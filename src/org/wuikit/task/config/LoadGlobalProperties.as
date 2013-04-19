package org.wuikit.task.config
{
	import flash.text.Font;
	import flash.text.StyleSheet;
	
	import org.wuikit.common.IDict;
	import org.wuikit.global.cnst.$LANG;
	import org.wuikit.global.cnst.$PROP;
	import org.wuikit.global.cnst.$RB;
	import org.wuikit.global.getDict;
	import org.wuikit.global.log;
	import org.wuikit.parser.PropertiesParser;
	import org.wuikit.resource.ResourceDict;
	import org.wuikit.task.ITask;
	import org.wuikit.task.LoadImage;
	import org.wuikit.task.LoadUrl;
	import org.wuikit.task.TaskGroup;
	
	public class LoadGlobalProperties extends TaskGroup
	{
		
		public var props:IDict;
		
		public function LoadGlobalProperties(src:String, priority:int=100, message:Object=null)
		{
			super('Global Properties',null,new ResourceDict, true, priority, message);
			props = getDict( $PROP );
			push( new LoadUrl(src.toString(),new PropertiesParser( props ), '.prop', priority,"Loading .prop file: " + src) );
		}
		
		override protected function onSubtaskState(task:ITask, type:int, val:*):void{
			if(type==COMPLETE){
				switch (task.id){
					case '.prop':
						props = val as IDict;
						if(props.getVal( 'include' ) )
							push( new LoadUrl( props.getVal( 'include' ),new PropertiesParser( props ), 'include' ) );
						else
							pushResources();
						break;
					case 'include':
						pushResources();
						break;
					case 'lang':
						break;
					case 'css':
						getDict( $RB ).setVal( 'css',val);
						var ss:StyleSheet = new StyleSheet();
						ss.parseCSS( val.toString() )
						getDict( $RB ).setVal( 'styleSheet', ss); 
						push( new LoadFonts( val.toString(),'fonts',0,'Loading Fonts' ) );
						
						break;
					case 'fonts':
						var fonts:Array = Font.enumerateFonts();
						fonts.forEach( 
							function(font:Font,...args):void{ log( 'Registered font: ', font.fontName )}
						)
						break;
					default:
						if(task.info && task.info.hasOwnProperty('type') )
							getDict( $RB ).setVal( task.id, val);
						break;
				}
			}
			super.onSubtaskState(task,type,val);
		}
		
		protected function pushResources():void{
			if(props.getVal( 'lang' ) )
				push( new LoadUrl( props.getVal( 'lang' ),new PropertiesParser( getDict( $LANG ) ), 'lang' ) );
			if(props.getVal( 'css' ) )
				push( new LoadUrl( props.getVal( 'css' ),null, 'css' ) );
			for( var prop:String in props){
				if(props[prop].toString().search('src:') == 0)
					push(new LoadUrl(props[prop].toString().replace('src:',''),null,prop,0,{type:'rb'}));
				if(props[prop].toString().search('img:') == 0)
					push(new LoadImage(props[prop].toString().replace('img:',''),null,prop,null,0,{type:'rb'}));
			}
		}
	}

}