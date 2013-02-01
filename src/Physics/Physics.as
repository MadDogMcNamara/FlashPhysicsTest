package Physics 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import Utility.Pool;
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	public class Physics 
	{
		private var mHeight:Number;
		private var mWidth:Number; 
		public var mNumContacts:int;
		public var mNumObjects:int;
		
		public  var mQTree:QTree;
		
		private static var mContactSearchDepth:int = 2;
		public function get height():int{return mHeight}
		public function get width():int { return mWidth }
		
		protected var mContanctList:Vector.<ContactPoint>;
		
		private var mObjectList:Vector.<PObject>;
		
		public static var mContactPool:Pool;
		public static var mPointPool:Pool;
		
		public function Physics(width:Number, height:Number) 
		{
			mContactPool = new Pool( ContactPoint, 1000 );
			mPointPool = new Pool( Point, 2000 );
			mQTree = new QTree(width, height );
			
			mNumObjects = 0;
			mHeight = height;
			mWidth = width;
			mObjectList = new Vector.<PObject>();
			mContanctList = new Vector.<ContactPoint>();
		}
		
		// update a number of millis
		public function update(aTime:Number):void {
			for (var i:int = 0; i < mObjectList.length; i++)
			{
				//aTime = 100;
				mObjectList[i].move(aTime );
			}
			
			mContanctList.length = 0; // todo this throws away already made and precious contact points :(
			
			
		
			var lPotentiallyDirtyObjects:Dictionary = new Dictionary();
			for each ( var p:PObject in mObjectList )
			{
				lPotentiallyDirtyObjects[p] = p;
			}
			
			for ( var lDepth:int = 0; lDepth < mContactSearchDepth; lDepth++ )
			{
				for ( var key:Object in lPotentiallyDirtyObjects)
				{
					var k:PObject = key as PObject;
					for each ( var j:PObject in mQTree.getAllCollisionCandidates(k) )
					{
						if ( k.isCollidingWith( j ) )
						{
							addContactPoint(mContanctList, k, j );
						}
					}
				}
				
				mContanctList.sort( ContactPoint.compare );
				
				lPotentiallyDirtyObjects = new Dictionary();
				
				for (i = 0; i < mContanctList.length; i++)
				{
					mContanctList[i].resolve();
					var p1:PObject = mContanctList[i].p1;
					var p2:PObject = mContanctList[i].p2;
					lPotentiallyDirtyObjects[p1]=p1;
					lPotentiallyDirtyObjects[p2] = p2;
					
					mContactPool.returnObject( mContanctList[i] );
				}
				mNumContacts = mContanctList.length;
				mContanctList.length = 0;
				
				
				
			}
			
			
			for (var i:int = 0; i < mObjectList.length; i++)
			{
				mObjectList[i].accelerate(aTime );
			}
		}
		
		public function addObject(aObj:PObject ):void
		{
			this.mObjectList.push(aObj);
			this.mQTree.addObject(aObj);
			
			this.mNumObjects = mObjectList.length;
		}
		
		
		private function addContactPoint( list:Vector.<ContactPoint> ,  p1:PObject,  p2:PObject ):void
		{
			// check that there is actually a collision here
			if ( p1.isCollidingWith(p2) )
			{
				var cp:ContactPoint = mContactPool.getObject() as ContactPoint;
				cp.init(p1, p2);
				list.push(cp);				
			}
		}
		
		
		
	}

}