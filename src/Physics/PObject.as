package Physics 
{
	import flash.display.ColorCorrectionSupport;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	public class PObject  
	{
		protected var mPhysics:Physics;
		protected var mAccel:Point;
		protected var mVel:Point;
		protected var mPos:Point;
		protected var mOutOfBounds:int;
		protected var mMass:Number;
		public var mQTNode:QTNode;
		private var mTimeMoved:Number;
		
		public function get physics():Physics { return mPhysics; }
		public function get pos():Point { return mPos; }
		public function get vel():Point { return mVel; }
		public function get mass():Number { return mMass; }
		
		
		
		public function PObject(accel:Point, vel:Point, pos:Point, physics:Physics, mass:Number=1) 
		{
			mPhysics = physics;
			mOutOfBounds = -1;
			mAccel = Physics.Physics.mPointPool.getObject() as Point;
			mAccel.x = accel.x;
			mAccel.y = accel.y;
			
			mVel = Physics.Physics.mPointPool.getObject() as Point;
			mVel.x = vel.x;
			mVel.y = vel.y;
			
			mPos = Physics.Physics.mPointPool.getObject() as Point;
			mPos.x = pos.x;
			mPos.y = pos.y;
			this.mMass = mass;
			mTimeMoved = 0;
		}
		
		
		public function move(aTime:Number):void
		{
			var temp:Point = PMath.scaleVector( vel, aTime );
			PMath.addVectorIP(mPos, temp);
			
			Physics.Physics.mPointPool.returnObject(temp);
			
			mOutOfBounds = isOutOfBounds();
			handleOutOfBounds(aTime);
			
			this.mQTNode.tree.updateObject(this);
		}
		
		public function accelerate( aTime:Number):void
		{				
			var temp:Point = PMath.scaleVector(mAccel, aTime);
			PMath.addVectorIP(mVel,  temp );
			
			Physics.Physics.mPointPool.returnObject(temp);
		}
		
		
		
		// -1 if not out of bounds
		// otherwise returns 0,1,2
		//                   3, ,4
		//                   5,6,7
		public function isOutOfBounds():int {
			return -1;
		}
		
		public function handleOutOfBounds(frameTime:Number):void
		{
			if ( mOutOfBounds == -1 )
			{
				return;
			}
			// object doesn't get to accel this frame
			return;
		}
		
		public function moveBy(v:Point):void
		{
			PMath.addVectorIP(mPos, v);
		}
		
		public function isCollidingWith(p:PObject):Boolean
		{
			return false;
		}
		
		public static function getDistance(p1:PObject, p2:PObject):Number
		{
			return PMath.getMagnitudeVector( p1.pos.subtract(p2.pos) );
		}
		
		public function isInQTNode(n:QTNode):Boolean
		{
			return false;
		}
		
		public function handleContact(p:PObject):void
		{
			return;
		}
		
		
	}

}