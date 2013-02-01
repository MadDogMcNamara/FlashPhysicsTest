package Physics 
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	public class ContactPoint extends Object
	{
		public var p1:PObject;
		public var p2:PObject;
		
		public function ContactPoint() 
		{
			var i:int = 0;
			i++;
		}
		public function init(p1:PObject, p2:PObject):void {
			this.p1 = p1;
			this.p2 = p2;
		}
		
		public function resolve():void {
			// collisions only implemented for balls at this time
			var b1:Ball;
			var b2:Ball;
			if ( p1 is Ball && p2 is Ball )
			{
				b1 =  p1 as Ball;
				b2 =  p2 as Ball;
			}
			else
			{
				return;
			}
			if ( !p1.isCollidingWith(p2) )
			{
				return;
			}
			
			
			// diff is the vector from 1 to 2
			var diff:Point = PMath.subtractVector(p2.pos, p1.pos);
			diff.normalize( -PMath.getMagnitudeVector(diff) + b1.radius + b2.radius );
			
			var distance:Number = PMath.getMagnitudeVector(diff);
			
			var distance1:Number = b1.mass / ( p1.mass + p2.mass ) * distance;
			var distance2:Number = b2.mass / ( p1.mass + p2.mass ) * distance;
			
			var toMove:Point = PMath.scaleToVector(diff, -distance1 );
			b1.moveBy(toMove );
			Physics.Physics.mPointPool.returnObject(toMove);
			
			toMove = PMath.scaleToVector(diff, distance2 );
			b2.moveBy( toMove );
			Physics.Physics.mPointPool.returnObject(toMove);
			
			b1.move(0);
			b2.move(0);
			
			Physics.Physics.mPointPool.returnObject(diff);

			
			
			b1.handleContact( b2 );
						
		}
		
		public static function compare( p2:ContactPoint, p1:ContactPoint ):Number
		{
			return PMath.getMagnitudeVector( p1.p1.pos.subtract(p1.p2.pos) ) - PMath.getMagnitudeVector( p2.p1.pos.subtract(p2.p2.pos) ) ;
		}
		
	}

}