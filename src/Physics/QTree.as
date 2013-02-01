package Physics 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class QTree 
	{
		public var root:QTNode;
		public var width:Number;
		public var height:Number;
		
		public static var sNumObjectsToBranchOn:int = 1;
		
		
		
		public function QTree(width:Number, height:Number) 
		{
			this.width = width;
			this.height = height;
			
		}
		
		public function addObject( p:PObject ):void
		{
			if ( root == null )
			{
				expandNode(null);
				root.addObject(p);
				
			}
			else
			{			
				addObjectRec( p, root );
			}
			
		}
		
		public function addObjectRec( p:PObject, n:QTNode ):Boolean
		{
			var lExpandedN:Boolean = false;
			if ( p.isInQTNode(n) || n.root )
			{
				if ( n.children.length == 0 )
				{
					if ( n.numObjects >= sNumObjectsToBranchOn )
					{
						lExpandedN = true;
						expandNode(n);
					}
					else
					{
						n.addObject(p);
						return true;
					}
				}
				
				for each ( var key:QTNode in n.children )
				{
					if ( addObjectRec(p, key ) )
					{
						return true;
					}
				}
				if ( lExpandedN )
				{
					contractNode(n);
				}
				
				n.addObject(p);
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		public function updateObject( p:PObject ):void
		{
			var n:QTNode = p.mQTNode;
			n.removeObject(p);
			// find the lowest node at or above its current one that it is in
			while ( ! p.isInQTNode( n ) )
			{
				n = n.parent;
			}
			
			// now go find the lowest node it'll fit in
			
			while ( n.children.length!=0 )
			{
				if ( p.isInQTNode(n.children[0] ) )
				{
					n = n.children[0];
				}
				else if ( p.isInQTNode(n.children[1] ) )
				{
					n = n.children[1];
				}
				else if ( p.isInQTNode(n.children[2] ) )
				{
					n = n.children[2];
				}
				else if ( p.isInQTNode(n.children[3] ) )
				{
					n = n.children[3];
				}
				else {
					break; // not in any of the children.
				}
			}
			
			if ( n.numObjects >= sNumObjectsToBranchOn )
			{
				var nodeExpanded:Boolean = false;
				if ( n.children.length == 0 )
				{
					nodeExpanded = true;
					expandNode(n);
				}
				var foundInChild:Boolean = false;
				for each ( var key:QTNode in n.children )
				{
					if ( p.isInQTNode(key ) )
					{
						n = key;
						foundInChild = true;
						break;
					}
				}
				
				if ( !foundInChild && nodeExpanded )
				{
					contractNode(n);
				}
				
			}
			
			n.addObject( p);
			
		}
		
		public function getAllCollisionCandidates(p:PObject ):Vector.<PObject>
		{
			var result:Vector.<PObject> = new Vector.<PObject>();
			
			var n:QTNode = p.mQTNode;
			while ( n != null )
			{
				for ( var key in n.objects )
				{
					if( key != p.mQTNode )
					{
						result.push(key);
					}
				}
				
				n = n.parent;
			}
			
			return result;
		}
		
		// change this to expand node
		public function expandNode( parent:QTNode ):void
		{
			var n:QTNode;
			if ( parent == null )
			{
				n = new QTNode( new Point(width / 2, height / 2 ), width, height, null, this);
				root = n;
				n.root = true;
			}
			else if ( parent.children.length == 0 ){
				var a:QTNode = new QTNode( new Point( parent.center.x - parent.width / 4, parent.center.y - parent.height / 4 ), parent.width / 2, parent.height / 2, parent, this );
				var b:QTNode = new QTNode( new Point( parent.center.x + parent.width / 4, parent.center.y - parent.height / 4 ), parent.width / 2, parent.height / 2, parent, this );
				var c:QTNode = new QTNode( new Point( parent.center.x - parent.width / 4, parent.center.y + parent.height / 4 ), parent.width / 2, parent.height / 2, parent, this );
				var d:QTNode = new QTNode( new Point( parent.center.x + parent.width / 4, parent.center.y + parent.height / 4 ), parent.width / 2, parent.height / 2, parent, this );
				parent.children.push(a);
				parent.children.push(b);
				parent.children.push(c);
				parent.children.push(d);
			}
			
		}
		
		public function contractNode( n:QTNode ):void
		{
			for each  ( var c:QTNode in n.children )
			{
				if ( c.numObjects > 0 || c.children.length > 0 )
				{
					throw new Error("can't contract a QTNode that has nonempty children");
					return;
				}			
				c.kill();

			}
			n.children = new Vector.<QTNode>();
			
			
		}
		
	}

}