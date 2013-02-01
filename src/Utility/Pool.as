package Utility 
{
	import Physics.ContactPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class Pool 
	{
		protected var pool:Array;
		protected var count:int;
		protected var length:int;
		protected var type:Class;
		
		public function Pool(type:Class, len:int) 
		{
			this.type = type;
			length = len;
			count = 0;
			pool = new Array();
			for (var i:int; i < len; i++ )
			{
				pool[i] = new type();
			}
		}
		
		public function getObject():Object
		{
			if ( count == length )
			{
				pool[count] = new type();
				length ++;
			}
			return pool[count++];
			
		}
		
		public function returnObject( s:Object ):void {
			
			if ( count == 0 )
			{
				throw new Error("More objects returned from pool than taken");
				return;
			}
			
			pool[--count] = s;
			
		}
	}

}