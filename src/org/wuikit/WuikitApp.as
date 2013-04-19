package org.wuikit
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import org.wuikit.common.IDict;
	import org.wuikit.global.__APP;
	import org.wuikit.global.cnst.$LANG;
	import org.wuikit.global.cnst.$PROP;
	import org.wuikit.global.cnst.$RB;
	import org.wuikit.global.getDict;
	import org.wuikit.log.ILog;
	import org.wuikit.log.Logger;
	import org.wuikit.resource.ResourceDict;
	import org.wuikit.task.ITask;
	import org.wuikit.task.Task;
	import org.wuikit.task.TaskGroup;
	import org.wuikit.task.config.LoadGlobalProperties;
	import org.wuikit.wui.StageValidator;
	import org.wuikit.wui.UiManager;
	import org.wuikit.wui.Widget;

	public class WuikitApp extends Sprite
	{
		
		public function WuikitApp()
		{
			if(stage){
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align= StageAlign.TOP_LEFT;
			}
			setup();
		}
		
		protected function setup():*{
			logger = new Logger;
			__APP.setDictRegister( setupDictRegister() );
			__APP.setServiceRegister( setupServiceRegister() );
			setupUiManager();
			return 1;
		}
		
		
		protected function startView():void{
		}
		
		protected function onBootTaskState( task:ITask,type:int,val:Object):void{
			if(type == Task.COMPLETE)
				startView();
		} 
	
		
		
		protected function boot( propUrl:String = null,locale:String = null, tasks:Array=null ):*{
			getDict($PROP).setVal('locale',locale)
				
			var bootTask:TaskGroup = new TaskGroup('boot',null,new ResourceDict,true);
			if(propUrl)
				bootTask.push( new LoadGlobalProperties(propUrl,100,'Loading Properties' ) );
			if(tasks)
				bootTask.push.apply( tasks );
			
			bootTask.addCallback(onBootTaskState).run();
			return bootTask;
		}
		
		
		
		protected function setupUiManager():*{
			new UiManager(stage);
			StageValidator.getInstance().setStage(stage);
		}
		
		protected function setupDictRegister():IDict{
			var reg:IDict = new ResourceDict;
			reg.setVal( $PROP , new ResourceDict);
			reg.setVal( $LANG , new ResourceDict);
			reg.setVal($RB , new ResourceDict);
			return reg;	
		}
		
		
		protected function setupServiceRegister():IDict{
			return new ResourceDict;	
		}
				
		protected function showToolTipFor(ui:Widget):void{
			if(toolTipWidget)
				toolTipWidget.data = ui;
		}
		
		private var toolTipWidget_:Widget;
		public function set toolTipWidget( val:Widget ):void{
			toolTipWidget = val;
		}
		
		public function get toolTipWidget():Widget{
			return toolTipWidget_;
		}
		
		private var logger_:ILog;
		public function set logger(val:ILog):void 
		{
			if(logger_ && logger is DisplayObject)
				removeChild(logger_ as DisplayObject)
				
			logger_ = val;
			if(logger_){
				if(logger_ is DisplayObject)
					addChild(logger_ as DisplayObject);
				__APP.setLogCall( val.log );
			}
			else
				__APP.setLogCall(null);
			
		}
		
		public function get logger():ILog{
			return logger_;
		}
		
		
		protected function get flashVars():Object{
			return loaderInfo.parameters;
		}
		
	}
}