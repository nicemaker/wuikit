package org.wuikit.wui
{
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import org.wuikit.global.log;

		public class StageValidator extends EventDispatcher 
		{
			
	
			protected var nextHash:Array = [];
			protected var busy:Boolean;
			protected var timeout:int;
			protected var stage:Stage;
			
			
			protected static var instance:StageValidator;
			
			public function Validator():void{
				
				
			}
			
			public function setStage(stage:Stage):void{
					this.stage = stage;
					stage.addEventListener(Event.RENDER,startCycle);
			}
			
			public static function getInstance():StageValidator{
				if(!instance) instance = new StageValidator();
				return instance;
			}
			
			public function push( target:Object, ... args ):void{
				if( nextHash.indexOf( target) == -1 )
					nextHash.push( target );
				if(!busy){
					if(stage)
						stage.invalidate();
					else
						timeout = setTimeout( startCycle,10 );
				}
			}
			
			protected function startCycle(e:Event=null):void{
				//var t:int = getTimer();
				busy=true;
				validateHash(nextHash);
				busy=false;
				//log(this,'Validated in',getTimer() - t,'ms' );
			}
			
			protected function validateHash(list:Array):void{
				while(list.length > 0){
					(list.shift() as Function).apply(null);
				}
									
			}
			
			
		}
}