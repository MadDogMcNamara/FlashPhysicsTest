package Game 
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import Physics.PObject;
	import Game.Game;
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	public class RenderableObject 
	{
		
		protected var image_sprite:Sprite;
		protected var height:Number = 0;
		protected var width:Number = 0;
		
		
		public var model:PObject;
		
		public function RenderableObject(sprite:Sprite, model:PObject) 
		{
			image_sprite = sprite;
			this.model = model;
		}
		
		public function render():void
		{
			var matrix:Matrix = new Matrix();
			matrix.translate(model.pos.x, model.pos.y);
			
			
			Game.Game.Renderer.draw(image_sprite, matrix);
		}
		
		
	}

}