package Physics 
{
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	
	 import flash.geom.Point;
	 
	public class Ball extends PObject
	{
		
		private var mRadius:Number;
		private var mDamp:Number = .8;
		public function get radius():Number { return mRadius };
		public var mContactDamp = .9;
		
		public function Ball(accel:Point, vel:Point, pos:Point, physics:Physics,radius:Number=10) 
		{
			super(accel, vel, pos, physics);
			mRadius = radius;
		}
		
		override public function isOutOfBounds():int 
		{
			if ( pos.y < mRadius )
			{
				if ( pos.x < mRadius )
				{
					return 0;
				}
				if ( pos.x > mPhysics.width - mRadius )
				{
					return 2;
				}
				return 1;
			}
			if ( pos.y > mPhysics.height - mRadius )
			{
				if ( pos.x < mRadius )
				{
					return 5;
				}
				if ( pos.x > mPhysics.width - mRadius )
				{
					return 7;
				}
				return 6;
			}
			
			if ( pos.x < mRadius )
			{
				return 3;
			}
			if ( pos.x > mPhysics.width - mRadius)
			{
				return 4;
			}
			return -1;
		}
		
		
	
		override public function handleOutOfBounds(frameTime:Number):void 
		{
			super.handleOutOfBounds(frameTime);
			var lXCollision:Boolean = false;
			var lYCollision:Boolean = false;
			//handle velocity
			switch(mOutOfBounds )
			{
				case 0:
					lXCollision = true;
					lYCollision = true;
					if ( mVel.x < 0 ) {
						mVel.x = -mVel.x;
					}
					if ( mVel.y < 0 )
					{
						mVel.y = -mVel.y;
					}
					break;
				case 1:
					lYCollision = true;
					if ( mVel.y < 0 )
					{
						mVel.y = -mVel.y;
					}
					break;
				case 2:
					lYCollision = true;
					lXCollision = true;
					if ( mVel.x > 0 ) {
						mVel.x = -mVel.x;
					}
					if ( mVel.y < 0 )
					{
						mVel.y = -mVel.y;
					}
					break;
				case 3:
					lXCollision = true;
					if ( mVel.x < 0 ) {
						mVel.x = -mVel.x;
					}
					break;
				case 4:
					lXCollision = true;
					if ( mVel.x > 0 ) {
						mVel.x = -mVel.x;
					}
					break;
				case 5:
					lXCollision = true;
					lYCollision = true;
					if ( mVel.x < 0 ) {
						mVel.x = -mVel.x;
					}
					if ( mVel.y > 0 )
					{
						mVel.y = -mVel.y;
					}
					break;
				case 6:
					lYCollision = true;
					if ( mVel.y > 0 )
					{
						mVel.y = -mVel.y;
					}
					break;
				case 7:
					lYCollision = true;
					lXCollision = true;
					if ( mVel.x > 0 ) {
						mVel.x = -mVel.x;
					}
					if ( mVel.y > 0 )
					{
						mVel.y = -mVel.y;
					}
					break;
			}
			
			if ( lXCollision )
			{
				mVel.x *= mDamp;
			}
			if (lYCollision)
			{
				mVel.y *= mDamp;
			}
			
			// handle x coord
			switch(mOutOfBounds)
			{
				case 0:
				case 3:
				case 5:
					mPos.x = mRadius;
					break;
				case 2:
				case 4:
				case 7:
					mPos.x = this.mPhysics.width - mRadius;
					break;
			}
			//handle y coord
			switch(mOutOfBounds)
			{
				case 0:
				case 1:
				case 2:
					mPos.y = mRadius;
					break;
				case 5:
				case 6:
				case 7: 
					mPos.y = mPhysics.height - mRadius;
					break;
			}
			
		}
		
		override public function isCollidingWith(p:PObject):Boolean 
		{
			var result:Boolean = false;
			if ( p == this)
			{
				return false;
			}
			if( ! ( p is Ball  ))
				return super.isCollidingWith(p);
			var b:Ball =  p as Ball;
			
			var diff:Point = PMath.subtractVector(pos, b.pos );
			
			if ( PMath.getMagnitudeVector( diff ) < this.radius + b.radius )
			{
				result = true;
			}
			
			Physics.Physics.mPointPool.returnObject(diff);
			return result;
		}
		override public function isInQTNode(n:QTNode):Boolean 
		{
			if ( n.dead )
			{
				return false;
			}
			
			if ( Math.abs( ( pos.x - n.center.x ) ) + radius <= n.width / 2 )
			{
				if ( Math.abs( ( pos.y - n.center.y ) ) + radius <= n.height / 2 )
				{
					return true;
				}
			}
			return false;
		}
		
		
		override public function handleContact(p:PObject):void
		{
			// p has gotta be a ball :/
			
			var b:Ball = p as Ball;
			
			if ( b == null )
			{
				throw Error("handle contact for a ball can only handle the contact if both objs are balls");
			}
			
			var diff:Point = PMath.subtractVector(b.pos, this.pos);
			
			var thisvp:Point = PMath.projectVector(this.vel, diff);
			var bvp:Point = PMath.projectVector(b.vel, diff);
			var thisvn:Point = PMath.subtractVector(this.vel, thisvp);
			var bvn:Point = PMath.subtractVector( b.vel, bvp);
			
			var thisvmag:Number = PMath.getMagnitudeVector( thisvp );
			if ( PMath.dotVector( thisvp, diff ) < 0 )
			{
				thisvmag = -thisvmag;
			}
			
			var bvmag:Number = PMath.getMagnitudeVector( bvp );
			
			if ( PMath.dotVector( bvp, diff) < 0 )
			{
				bvmag = -bvmag;
			}
			
			var vels:Point = Physics.Physics.mPointPool.getObject() as Point;
			vels.x = thisvmag;
			vels.y = bvmag;
			handle1DCollision( vels, this.mass, b.mass );
			
			
			thisvmag = vels.x;
			bvmag = vels.y;
			
			thisvmag *= mContactDamp;
			bvmag *= b.mContactDamp;
			
			
			diff.normalize(1);
			
			Physics.Physics.mPointPool.returnObject(this.mVel);
			Physics.Physics.mPointPool.returnObject(b.mVel);
			
			var temp:Point = PMath.scaleVector( diff, thisvmag );
			
			this.mVel = PMath.addVector( temp, thisvn );

			temp = PMath.scaleVector( diff, bvmag );
			b.mVel = PMath.addVector( temp , bvn );
			Physics.Physics.mPointPool.returnObject(temp);

			Physics.Physics.mPointPool.returnObject(diff);
			Physics.Physics.mPointPool.returnObject(thisvp);
			Physics.Physics.mPointPool.returnObject(bvn);
			Physics.Physics.mPointPool.returnObject(thisvn);
			Physics.Physics.mPointPool.returnObject(bvp);
			Physics.Physics.mPointPool.returnObject(vels);
		}
		
		public static function handle1DCollision( p:Point, m1:Number, m2:Number ):void
		{
			var v1:Number = ( p.x * ( m1 - m2 ) + 2 * m2 * p.y ) / ( m1 + m2 );
			p.y = ( p.y * ( m2 - m1 ) + 2 * m1 * p.x ) / ( m1 + m2 );
			p.x = v1;
		}
		
		
		
	}

}