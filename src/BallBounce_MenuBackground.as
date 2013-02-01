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
	
	import flash.display.GradientType;
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	public class BallBounce_MenuBackground extends Game
	{
		private var ballimage:Sprite;
		
		
		public static var gravity:Point = new Point(0, .0007);
		
		public static var ballSize:Number = 8;
		
		
		public function BallBounce_MenuBackground (width:Number, height:Number, stage:Stage) 
		{
			super(width, height, stage);
			mBackground = new Sprite();
			var matrix:Matrix = new Matrix;
			var min:Number = Math.min(width, height);
			matrix.createGradientBox(min, min, 0, ( width - min ) / 2 , (height - min ) / 2)
			mBackground.graphics.beginGradientFill(GradientType.RADIAL, [0x00008B, 0x000000], [1, 1], [0, 255], matrix, "pad", "linearrgb");
			mBackground.graphics.drawRect( 0, 0, width, height );
			
			
			
			
			
			ballimage =new Sprite();
			ballimage.graphics.lineStyle(.1, 0xFFFFFF);
			ballimage.graphics.drawCircle(0, 0, 10);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			
			//mRenderableObjects.push( new Statistics(mPhysics, this) );
			
			addBall(new Point(20, 30), new Point(0, 0) );
			
		}
		
		public function mouseDown(e:MouseEvent):void
		{
			
		}
		
		
		public override function render():void
		{
			super.render();
			return;
		}
		
		public function addBall( pos:Point, vel:Point ):void
		{
			var p1:Ball = new Ball(gravity, vel, pos, mPhysics, ballSize);
			mPhysics.addObject(p1);
			
			ballimage =new Sprite();
			ballimage.graphics.lineStyle(.1, 0xFFFFFF);
			ballimage.graphics.drawCircle(0, 0, p1.radius);
			
			var p1r:RenderableObject = new RenderableObject(ballimage, p1);
			mRenderableObjects.push(p1r);
		}
		
	}

}