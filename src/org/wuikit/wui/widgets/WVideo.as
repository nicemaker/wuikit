package org.wuikit.wui.widgets
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.states.OverrideBase;
	
	import org.wuikit.global.log;
	import org.wuikit.wui.WPadding;
	import org.wuikit.wui.WSize;
	import org.wuikit.wui.Widget;
	import org.wuikit.wui.frame.SimpleFrame;
	
	public class WVideo extends Widget
	{
		public static const LETTER_BOX:String = 'letterBox';
		public static const FORCE:String = 'force';
		public static const RATIO:String = 'ratio';
		
		protected var stream_:NetStream;
		protected var connection:NetConnection;
		protected var video:Video;
		protected var videoSize:WSize = new WSize(0,0);
		
		public function WVideo()
		{
			super();
			frameStyle=new SimpleFrame(0xff);
			video = new Video;
			connection = new NetConnection;
			connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			connection.client = this;
			connection.connect( null );
			addChild(video);
		}
		
		public function isPause():Boolean{
			return paused_;
		}
		
		private var paused_:Boolean;
		public function pause():void{
			paused_ = true;
			if(stream_)
				stream_.pause();
		}
		
		public function resume():void{
			paused_ = false;
			if(stream_)
				stream_.resume();
		}
		
		public function attachCamera( val:Camera ):void{
			video.attachCamera( val );
			videoSize.x = val.width;
			videoSize.y = val.height;
			invalidMeasure();
		}
		
		
		public function connect(command:String,...args):void{
			connection.connect.apply( [command].concat(args) );
			
		}
		
		public function grabScreen():BitmapData{
			var sx:Number = video.scaleX * (videoSize.x/video.width);
			var sy:Number = video.scaleY * (videoSize.y/video.height);
			var bmp:BitmapData = new BitmapData(videoSize.x,videoSize.y);
			var m:Matrix = new Matrix;
			m.scale(  sx,sy);
			bmp.draw(video,m);
			return bmp;
		}
		
		private function connectStream():void{
			stream_ = new NetStream( connection );
			stream_.bufferTime = bufferTime;
			stream_.client = this;
			stream_.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			stream_.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			video.attachNetStream(stream_);
		}
		
		public function get stream():NetStream 
		{
			
			return stream_;
		}
		
		private function onNetStatus(e:NetStatusEvent):void {
			log(e.info.code)
			
			switch (e.info.code) {
				case "NetStream.Buffer.Full":
					if(videoSize.x == 0) // first full video info
					{
						videoSize.x = video.videoWidth;
						videoSize.y = video.videoHeight;
						invalidMeasure();
					}
				break;
				case "NetStream.Play.Start":
					
					break;
				case "NetConnection.Connect.Success":
					connectStream();
					break;
			}
			dispatchEvent(e);
		}
		
		private var metaData_:Object;
		public function get metaData():Object 
		{
			return metaData_;
		}

		public function onMetaData(val:Object):void{
			metaData_ = val;
			dispatchEvent( new Event( 'onMetaData' ) );
		}
		
		public function onPlayStatus(...args):void{
			
		}
		
		
		private function onSecurityError(e:SecurityErrorEvent):void {
			log( e.text );
			dispatchEvent( e );
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void {
			log( e.text );
			dispatchEvent( e );
		}

		public function play(...args):void{
			stream_.play.apply(this,args);
		}
		
		override protected function resizeTo(w:Number, h:Number):void{
			if(!video) return;
		
			w=w - padding.sumX();
			h=h - padding.sumY();
			var geoRatio:Number = w/h;
			var ratio:Number = sourceRatio();
			scrollRect = null;
			switch(resizeMode){
				case LETTER_BOX:
					this.scrollRect = new Rectangle(0,0,geometry.width,geometry.height);
						video.width = geoRatio>ratio ? w:h*ratio;
						video.height = geoRatio>ratio ? w/ratio:h;
					break;
				case FORCE:
					video.width = w;
					video.height = h;
					break;
				case RATIO:
						video.width = geoRatio>ratio ? h * ratio : w;
						video.height = geoRatio>ratio ? h : w/ratio;
					break;
			}
			video.x = .5*(w-video.width) + padding.left;
			video.y = .5*(h-video.height) + padding.top;
		}
		
		public function set smoothing(val:Boolean):void 
		{
			video.smoothing = val;
		}
		
		public function get smoothing():Boolean{
			return video.smoothing;
		}
		
		private var resizeMode_:String='ratio';
		public function set resizeMode(val:String):void 
		{
			if(val == resizeMode)
				return;
			resizeMode_ = val;
			invalidate()
		}
		
		public function get resizeMode():String 
		{
			
			return resizeMode_;
		}
		
		public function get time():Number 
		{
			return stream_ ? stream_.time : 0;
		}
		
		public function sourceRatio():Number{
			return videoSize.x/videoSize.y;
		}	
		
		private var padding_:WPadding = new WPadding(0,0,0,0);
		public function set padding(val:WPadding):void 
		{
			padding_ = val;
			invalidate();
		}
		
		private var bufferTime_:Number = 3;
		public function set bufferTime(val:Number):void 
		{
			bufferTime_ = val;
			if(stream_)
				stream_.bufferTime = val;
		}
		
		public function get bufferTime():Number 
		{
			return bufferTime_;
		}
		
		public function get bytesTotal():Number 
		{
			return stream ? stream_.bytesTotal : 0;
		}
		
		public function get bytesLoaded():Number 
		{
			return stream ? stream_.bytesLoaded : 0;
		}
		
		
		public function get padding():WPadding 
		{
			
			return padding_;
		}
		
		
		override public function sizeHint():WSize{
			return new WSize( videoSize.x+padding.sumX(),videoSize.y+padding.sumY());
		}
		
	}
}