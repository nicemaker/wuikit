package org.wuikit.task
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.wuikit.common.IParser;

	public class LoadImage extends Task
	{
		
		
		public function LoadImage(srcOrByteArray:Object,parser:IParser=null,id:String=null,context:LoaderContext=null, priority:int=0,message:Object=null)
		{
			super(srcOrByteArray,parser,id, priority,message);
			this.context = context;
			this.loader = setupLoader();
		}
		
		override public function run(...args):*{
			if(!src)
				super.run();
			else if(src is ByteArray){
				loader.loadBytes( src as ByteArray )
			}
			else{
				loader.load(new URLRequest( src.toString() ),context);
			}
			return this
		}
		
		override public function skip():void{
			if(loader && loader.loaderInfo.bytesLoaded > 0){
				loader.close();
			}
			super.skip();		
		}
		
		
		protected function setupLoader():Loader{
			var l:Loader = new Loader;
			l.contentLoaderInfo.addEventListener( Event.COMPLETE,onLoaderComplete);
			l.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS,onLoaderProgress);
			l.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR,onLoaderIOError);
			l.contentLoaderInfo.addEventListener( IOErrorEvent.NETWORK_ERROR,onLoaderIOError);
			return l;
		}
		
		protected function onLoaderProgress(e:ProgressEvent):void{
			dispatchState(PROGRESS,{total:e.bytesTotal,completed:e.bytesLoaded});
		}
		
		protected function onLoaderIOError(e:IOErrorEvent):void{
			dispatchState(ERROR,new Error(e.text) );
		}
		
		protected function onLoaderComplete( e:Event ):void{
			dispatchState(COMPLETE,parser?parser.parse( e.target.content ) : e.target.content) 
		}
		
		protected function disposeLoader():void{
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE,onLoaderComplete);
			loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS,onLoaderProgress);
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR,onLoaderIOError);
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.NETWORK_ERROR,onLoaderIOError);
		}
		
		private var loader_:Loader;
		protected function set loader(val:Loader):void 
		{
			loader_ = val;
		}
		
		protected function get loader():Loader{
			return loader_;
		}
		
		private var context_:LoaderContext;
		public function set context(val:LoaderContext):void 
		{
			context_ = val;
		}
		
		public function get context():LoaderContext{
			return context_;
		}
		
		override public function clear():*{
			super.clear();
			disposeLoader();
			context = null;
			loader = null;
		}
		
	}
}