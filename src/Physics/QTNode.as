package Physics 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class QTNode 
	{
		public var root:Boolean;
		public var center:Point;
		public var objects:Dictionary;
	
		public var numObjects:int;
		public var width:Number;
		public var height:Number;
		public var parent:QTNode;
		public var children:Vector.<QTNode>;
		public var tree:QTree;
		
		private var mDead:Boolean;
		public function get dead():Boolean { return mDead; }
		public function kill():void { mDead = true;}
		
		
		public function QTNode(center:Point, width:Number, height:Number, parent:QTNode, tree:QTree ) 
		{
			mDead = false;
			this.numObjects = 0;
			this.center = center;
			this.width = width;
			this.height = height;
			this.parent = parent;
			this.tree = tree;
			
			children = new Vector.<QTNode>();
			objects = new Dictionary();
			
			
			root = false;
			
		}
		
		
		public function addObject( p:PObject ):void
		{
			if ( objects[ p ] != null )
			{
				return;
			}
			numObjects++;
			objects[p] = p;
			p.mQTNode = this;
		}
		
		public function removeObject( p:PObject ):void
		{
			numObjects--;
			delete objects[p];
			p.mQTNode = null;
			if ( numObjects == 0 && !root )
			{
				var shouldKillParentsChildren:Boolean = true;
				for each (var n:QTNode in parent.children )
				{
					if ( n.children.length != 0 || n.numObjects > 0 )
					{
						shouldKillParentsChildren = false;
						break;
					}
					
				}
				if ( shouldKillParentsChildren )
				{
					tree.contractNode(parent);
				}
			}
		}
		
		
		
	}

}