package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import Game.Game;
	import Game.RenderableObject;
	import Game.Statistics;
	import Physics.PObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Physics.PMath;
	import Physics.Ball;
	import Physics.QTNode;
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	public class PhysicsTest extends Game
	{
		private var isMouseDown:Boolean;
		
		private var mouseDownLocation:Point;
		private var mouseLocation:Point;
		private var ballimage:Sprite;
		
		public static var radius:Number = 8;
		
		public static var gravity:Point = new Point(0, .0002);
		
		
		public function PhysicsTest (width:Number, height:Number, stage:Stage) 
		{
			super(width, height, stage);
			
			ballimage =new Sprite();
			ballimage.graphics.lineStyle(.2, 0xFF0000);
			ballimage.graphics.drawCircle(0, 0, radius);
			ballimage.graphics.beginFill(0xFFFFFF, 1);
			ballimage.graphics.drawCircle(0, 0, radius);
			
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
			mouseLocation = new Point(0, 0) ;
			mouseDownLocation = new Point(0, 0) ;
			isMouseDown = false;
			
			mRenderableObjects.push( new Statistics(mPhysics, this) );
			
		}
		
		public function mouseDown(e:MouseEvent):void
		{
			isMouseDown = e.buttonDown;
			mouseDownLocation.x = e.stageX
			mouseDownLocation.y = e.stageY;
			
		}
		public function mouseUp(e:MouseEvent):void
		{
			if ( isMouseDown )
			{
				var  num:int = 1;
				if ( isCharPressed("M") )
				{
					num = 20;
				}
				for (var i:int = 0; i < num; i++ )
				{
					addBall(mouseDownLocation.clone() , PMath.scaleVector(new Point(( Math.random() + .5 )*(mouseDownLocation.x - mouseLocation.x), ( Math.random() + .5 )*(mouseDownLocation.y - mouseLocation.y)), 1 / stage.width ));			
				}

			}
			isMouseDown = e.buttonDown;
		}
		
		
		
		public function mouseMove(e:MouseEvent):void
		{
			mouseLocation.x = e.stageX;
			mouseLocation.y = e.stageY;
		}
		
		public override function render():void
		{
			super.render();
			if ( isMouseDown )
			{
				var image:Sprite = new Sprite();
				image.graphics.lineStyle(.1, 0xFFFFFF);
				image.graphics.moveTo(mouseLocation.x, mouseLocation.y);
				image.graphics.lineTo(mouseDownLocation.x, mouseDownLocation.y);
				
				Renderer.draw(image);
				
				
			}
			var s:Vector.<QTNode> = new Vector.<QTNode>();
			s.push(mPhysics.mQTree.root );
			
			var oldcolline:Sprite = new Sprite();
			oldcolline.graphics.lineStyle(.1, 0xFFFF00);
			for each (var p:RenderableObject in mRenderableObjects )
			{break;
				if ( p.model.mQTNode == null )
				{
					continue;
				}
				for each (var x:RenderableObject in mRenderableObjects )
				{
					if ( x.model.mQTNode != null && p.model.mQTNode != null )
					{
						oldcolline.graphics.moveTo(x.model.pos.x, x.model.pos.y);
						oldcolline.graphics.lineTo(p.model.pos.x, p.model.pos.y);
					}
				}
			}
			
			Renderer.draw(oldcolline);
			
			
			var nodeline:Sprite = new Sprite();
			var colline:Sprite = new Sprite();
			nodeline.graphics.lineStyle(.1, 0x00FFFF);
			colline.graphics.lineStyle(.1, 0xDC143C);
			while ( s.length != 0 )
			{
				var n:QTNode = s.pop();
				if ( n == null )
				{
					continue;
				}
				nodeline.graphics.drawRect(n.center.x - n.width / 2, n.center.y - n.height / 2, n.width, n.height );
				
				for each ( var a:QTNode in n.children )
				{
					s.push(a);
				}
			}
			Renderer.draw(nodeline);

			var ballline:Sprite = new Sprite();
			
			ballline.graphics.lineStyle(.1, 0x32CD32);
			
			for each (var p:RenderableObject in mRenderableObjects )
			{break;
				if ( p.model.mQTNode == null )
				{
					continue;
				}
				ballline.graphics.moveTo(p.model.pos.x, p.model.pos.y);
				
				ballline.graphics.lineTo(p.model.mQTNode.center.x, p.model.mQTNode.center.y);
				
				
				for each (var q:PObject in mPhysics.mQTree.getAllCollisionCandidates(p.model) )
				{
					colline.graphics.moveTo(q.pos.x, q.pos.y);
					colline.graphics.lineTo(p.model.pos.x, p.model.pos.y);
				}
			}
			Renderer.draw(colline);
			//Renderer.draw(ballline);
			
			
			return;
		}
		
		public function addBall( pos:Point, vel:Point ):void
		{
			var p1:Ball = new Ball(gravity, vel, pos, mPhysics, radius);
			mPhysics.addObject(p1);
			
			var p1r:RenderableObject = new RenderableObject(ballimage, p1);
			mRenderableObjects.push(p1r);
		}
		
	}

}