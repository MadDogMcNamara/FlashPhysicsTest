package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Game.Game;
	
	/**
	 * ...
	 * @author Ryan McNamara
	 */
	public class Main extends Sprite 
	{
		
		public var mGame:Game;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			mGame = new PhysicsTest(stage.stageWidth, stage.stageHeight, stage);
			
			addChild(mGame.bitmap);
			
			stage.addEventListener(Event.ENTER_FRAME, mGame.run);
			
		}
		
		
		
	}
	
}