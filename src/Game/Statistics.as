package Game 
{
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import Game.RenderableObject;
	import Physics.Physics;
	import Physics.PObject;
	/**
	 * ...
	 * @author ...
	 */
	public class Statistics extends RenderableObject
	{
		
		protected var text:TextField = new TextField();
		protected var mGame:Game;
		
		public function Statistics(aPhysics:Physics, aGame:Game)
		{
		
			super(new Sprite(), new PObject(new Point(0, 0), new Point(0, 0), new Point(0, 0), aPhysics ) );
			
			mGame = aGame;
			
			width = aPhysics.width;
			height = aPhysics.height;
			
			image_sprite.addChild(text);
		}
		
		override public function render():void 
		{
			image_sprite.graphics.beginFill(0x000000, 0);
			image_sprite.graphics.drawRect(0, 0, width, height);
			
			text.text = "Num Collisions: " + model.physics.mNumContacts + "\nNum objects: " + model.physics.mNumObjects + "\nFPS: " + mGame.mFPS;
			text.setTextFormat( new TextFormat("Arial", 20, 0xffffff ) );
		
			text.width = width;
			text.height = height;
			
			super.render();
		}
		
	}

}