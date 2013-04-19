package org.wuikit.task.config
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	
	import org.wuikit.common.IDict;
	import org.wuikit.task.ITask;
	import org.wuikit.task.LoadImage;
	import org.wuikit.task.TaskGroup;
	
	public class LoadFonts extends TaskGroup
	{
		public var css:String;
		public function LoadFonts( css:String,id:String=null,priority:int=0, message:Object=null)
		{
			this.css = css;
			super(id, tasks, stack, sequential, priority, message);
		}
		
		override public function run(...args):*{
			

			var context:LoaderContext = new LoaderContext;
			context.applicationDomain = ApplicationDomain.currentDomain;

			var fontFace:Object;
			var fontFaceExp:RegExp = /@font-face\s+?{[^}]+}/gi;
			var match:Array;
			while( match=fontFaceExp.exec( css ) ){
				fontFace = {};
				var keyValueExp:RegExp = /([a-z0-9\-]+)\s*:\s*([^;]+)/gi;
				var keyValue:Array;
				var url:String;
				var id:String;
				while( keyValue = keyValueExp.exec( match[0] ) ){
					fontFace[normalizeName( keyValue[1] ) ] = keyValue[2];
				}
				if(fontFace.hasOwnProperty('src')){
					url = fontFace.src.toString().match( /(?<=\(\'|\")[^\'\"\)]+/gi )[0];
					id = fontFace.hasOwnProperty('font_class') ? fontFace.font_class : null;
					push( new LoadImage( src.toString(),null,id,context ) );
				}
			}
			return super.run();
		}
		
		
		override protected function onSubtaskState(task:ITask, type:int, val:*):void{
			if(type==COMPLETE)
				if(task.id)//=font class
					Font.registerFont( getDefinitionByName( task.id ) as Class );
			super.onSubtaskState(task,type,val);
		}
		
		protected function normalizeName( value:String):String{
			return value.replace('-','_');
		}
		
		
	}
}