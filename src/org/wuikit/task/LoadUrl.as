package org.wuikit.task
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.wuikit.common.IParser;

	public class LoadUrl extends Task
	{
		
		public function LoadUrl(src:Object,parser:IParser=null,id:String=null, priority:int=0,info:Object=null)
		{
			super(src,parser,id, priority, info);
			this.loader = setupLoader();
		}
		
		
		override public function run(...args):*{
			if(!src)
				super.run();
			else
				loader.load(new URLRequest( src.toString() ) );
			return
		}
		
		protected function setupLoader():URLLoader{
			var l:URLLoader = new URLLoader;
			l.addEventListener( Event.COMPLETE,onLoaderComplete);
			l.addEventListener( ProgressEvent.PROGRESS,onLoaderProgress);
			l.addEventListener( IOErrorEvent.IO_ERROR,onLoaderIOError);
			l.addEventListener( IOErrorEvent.NETWORK_ERROR,onLoaderIOError);
		
			return l;
		}
		
		protected function disposeLoader():void{
			loader.removeEventListener( Event.COMPLETE,onLoaderComplete);
			loader.removeEventListener( ProgressEvent.PROGRESS,onLoaderProgress);
			loader.removeEventListener( IOErrorEvent.IO_ERROR,onLoaderIOError);
			loader.removeEventListener( IOErrorEvent.NETWORK_ERROR,onLoaderIOError);
		}
		
		protected function onLoaderProgress(e:ProgressEvent):void{
			dispatchState( PROGRESS, {total:e.bytesTotal,completed:e.bytesLoaded} );
		}
		
		protected function onLoaderIOError(e:IOErrorEvent):void{
			dispatchState(ERROR, new Error(e.text) );
		}
		
		protected function onLoaderComplete( e:Event ):void{
			dispatchState( COMPLETE, parser? parser.parse( e.target.data ) : e.target.data );
		}
		
		override public function skip():void{
			if(loader && loader.bytesLoaded > 0)
				loader.close();
			super.skip();		
		}
		
		private var loader_:URLLoader;
		protected function set loader(val:URLLoader):void 
		{
			loader_ = val;
		}
		
		protected function get loader():URLLoader{
			return loader_;
		}
		
		override public function clear():*{
			super.clear();
			disposeLoader();
			loader = null;
		}
		
		
	}
}