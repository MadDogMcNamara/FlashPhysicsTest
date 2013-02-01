package Physics 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	public class PMath 
	{
		
		public function PMath() 
		{
			
		}
		
		public static function addVector(v1:Point, v2:Point):Point
		{
			var r:Point = Physics.Physics.mPointPool.getObject() as Point;
			r.x = v1.x + v2.x;
			r.y = v1.y + v2.y;
			return r;
		}
		
		public static function addVectorIP(v1:Point, v2:Point):void
		{
			v1.x = v2.x + v1.x;
			v1.y = v2.y + v1.y;
		}
		
		public static function scaleVector( v1:Point, s:Number):Point
		{
			var r:Point = Physics.Physics.mPointPool.getObject() as Point;
			r.x = v1.x * s;
			r.y =  v1.y * s;
			return r;
		}
		
		
		public static function scaleVectorIP( v1:Point, s:Number ):Point
		{
			v1.x = v1.x * s;
			v1.y = v1.y * s;
			return v1;
		}
		
		
		public static function scaleToVector(v:Point, s:Number):Point
		{
			var v1:Point = Physics.Physics.mPointPool.getObject() as Point;
			v1.x = v.x;
			v1.y = v.y;
			v1.normalize(s);			
			return v1;
		}
		
		public static function scaleToVectorIP(v1:Point, s:Number):Point
		{
			v1.normalize(s);			
			return v1;
		}
		
		public static function getMagnitudeVector( v1:Point):Number
		{
			return Math.sqrt( ( v1.x * v1.x + v1.y * v1.y ) );
		}
		
		public static function normalizeVectorIP( v1:Point ):void
		{
			v1.normalize(1);
		}
		
		public static function normalizeVector(v1:Point):Point
		{
			var v:Point = Physics.Physics.mPointPool.getObject() as Point;
			v.x = v1.x;
			v.y = v1.y;
			v.normalize(1);
			return v;
		}
		
		public static function dotVector(v1:Point, v2:Point):Number
		{
			return v1.x * v2.x + v1.y * v2.y;
		}
		
		// projects v1 onto v2
		public static function projectVector( v1:Point, v2:Point ):Point
		{
			var a:Point = normalizeVector(v2);
			scaleVectorIP(a, dotVector(v1, a) );
			return a;			
		}
		
		public static function subtractVector( v1:Point, v2:Point ): Point
		{
			
			var r:Point = Physics.Physics.mPointPool.getObject() as Point;
			r.x = v1.x - v2.x;
			r.y = v1.y - v2.y;
			return r;
		}
		
		
	}

}