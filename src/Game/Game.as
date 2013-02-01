package Game 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import Physics.Physics;
	import Physics.PObject;
	
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	public class Game 
	{
		public var mFPS:int;
		public var stage:Stage;
		public static var Renderer:BitmapData;
		public var bitmap:Bitmap;
		protected var mPhysics:Physics;		
		protected var mFrameTime:Number;		
		protected var prevFrame:Number;		
		protected var mFirstRun:Boolean;
		protected var mRenderableObjects:Vector.<RenderableObject>
		protected var mBackground:Sprite;
		
		protected var mKeysPressed:Dictionary;
		
		public function Game(width:Number, height:Number, stage:Stage, background = null ) 
		{
			
			
			mKeysPressed = new Dictionary();
			this.stage = stage;
			mFirstRun = true;
			Renderer = new BitmapData(width, height, false, 0xFFFFFF);
			
			if ( background == null )
			{
				mBackground = new Sprite();
				mBackground.graphics.beginFill( 0x000000, 1 );
				mBackground.graphics.drawRect(0, 0, Renderer.width, Renderer.height);
			}
			else {
				mBackground = background;
			}
			
			bitmap = new Bitmap(Renderer);
			
			mPhysics = new Physics(width, height);
			mRenderableObjects = new Vector.<RenderableObject>();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			
			
		}
		
		public function run(e:Event):void {
			if ( mFirstRun )
			{
				prevFrame = getTimer();
				mFirstRun = false;
				return;
			}
			
			mFrameTime = (getTimer() - prevFrame);	
			mFPS = 1000 / mFrameTime;
			prevFrame = getTimer();
			
			mPhysics.update(mFrameTime);
			
			this.prepareToRender();
			this.render();
			this.doneRendering();
			

		}
		
		private function prepareToRender():void
		{
			Renderer.lock();			
		}
		private function doneRendering():void
		{
			Renderer.unlock();
		}
		public function render():void {
			Renderer.draw(mBackground);
			
			for (var i:int = 0; i < mRenderableObjects.length; i++)
			{
				mRenderableObjects[i].render();
			}
			
		}
		
		public function keyDown( e:KeyboardEvent ):void
		{
			mKeysPressed[e.keyCode] = e.keyCode;
			trace(e.keyCode);
		}
		public function keyUp( e:KeyboardEvent ):void
		{
			if ( mKeysPressed[e.keyCode] != null )
			{
				delete mKeysPressed[e.keyCode];
			}
		}
		
		public function isCharPressed( s:String ):Boolean
		{
			return mKeysPressed[s.charCodeAt(0)] != null;
		}
		
		public function destroy():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
	}

}

/*
package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
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
	 
	public class BallBounce extends Game
	{
		private var isMouseDown:Boolean;
		
		private var mouseDownLocation:Point;
		private var mouseLocation:Point;
		private var ballimage:Sprite;
		
		
		public static var gravity:Point = new Point(0, .0000);
		
		
		public function BallBounce (width:Number, height:Number, stage:Stage) 
		{
			super(width, height, stage);
			
			ballimage =new Sprite();
			ballimage.graphics.lineStyle(.1, 0xFFFFFF);
			
			
			
			
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
				addBall(mouseDownLocation.clone() , PMath.scaleVector(new Point(mouseDownLocation.x - mouseLocation.x, mouseDownLocation.y - mouseLocation.y), 1 / stage.width ));
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
			return;
			var s:Vector.<QTNode> = new Vector.<QTNode>();
			s.push(mPhysics.mQTree.root );
			
			var oldcolline:Sprite = new Sprite();
			oldcolline.graphics.lineStyle(.1, 0xFFFF00);
			for each (var p:RenderableObject in mRenderableObjects )
			{
				break;
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
			{
				break;
				if ( p.model.mQTNode == null )
				{
					continue;
				}
				ballline.graphics.moveTo(p.model.pos.x, p.model.pos.y);
				
				ballline.graphics.lineTo(p.model.mQTNode.center.x, p.model.mQTNode.center.y);
				
				
				for each (var q:PObject in mPhysics.mQTree.getAllCollisionCandidates(p.model) )
				{
					break;
					colline.graphics.moveTo(q.pos.x, q.pos.y);
					colline.graphics.lineTo(p.model.pos.x, p.model.pos.y);
				}
			}
			Renderer.draw(colline);
			Renderer.draw(ballline);
			
			
		}
		
		public function addBall( pos:Point, vel:Point ):void
		{
			var p1:Ball = new Ball(gravity, vel, pos, mPhysics, 8);
			mPhysics.addObject(p1);
			
			ballimage.graphics.lineStyle(.1, 0xFFFFFF);
			ballimage.graphics.drawCircle(0, 0, p1.radius);
			
			var p1r:RenderableObject = new RenderableObject(ballimage, p1);
			mRenderableObjects.push(p1r);
		}
		
	}

}
*/