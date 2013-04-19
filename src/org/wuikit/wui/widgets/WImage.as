package org.wuikit.wui.widgets
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mx.states.OverrideBase;
	
	import org.wuikit.task.ITask;
	import org.wuikit.task.LoadImage;
	import org.wuikit.task.Task;
	import org.wuikit.wui.WPadding;
	import org.wuikit.wui.WSize;
	import org.wuikit.wui.Widget;

	public class WImage extends Widget
	{
		
		public static const LETTER_BOX:String = 'letterBox';
		public static const FORCE:String = 'force';
		public static const RATIO:String = 'ratio';
		
		protected var contentSize:Rectangle = new Rectangle(0,0,0,0);
		protected var contentContainer:Sprite;
		
		public function WImage()
		{
			super();
			contentContainer = new Sprite;
			addChild(contentContainer);
						
		}
		
		
		
		protected function onLoadState(task:ITask,type:int,val:*):void{
			if(type == Task.COMPLETE)
				content = val;
		}
		
		public var src_:String='';
		public function set src(val:String):void 
		{
			if(src_==val) return;
			src_=val;
			new LoadImage(src,null,src).addCallback( onLoadState ).run();
		}
		
		override public function validate():void{
			refreshImage();
			super.validate();
		}
		
		public function refreshImage():void{
			if(!content) return;
			if(content is Bitmap)
				(content as Bitmap).smoothing = smoothing;
				
				
		}
		
		override protected function resizeTo(w:Number, h:Number):void{
			if(!content) return;
			w=w - padding.sumX();
			h=h - padding.sumY();
			var geoRatio:Number = w/h;
			var ratio:Number = contentSize.width/contentSize.height;
			contentContainer.scrollRect=null;
			switch(resizeMode){
				case LETTER_BOX:
					contentContainer.scrollRect = new Rectangle(0,0,w,h);
					content.width = geoRatio>ratio ? w : h*ratio;
					content.height = geoRatio>ratio ? w/ratio : h;
					contentContainer.x = .5*( geometry.width - w );
					contentContainer.y = .5*( geometry.height - h );
					break;
				case FORCE:
					content.width = w;
					content.height = h;
					contentContainer.x = .5*( geometry.width - w );
					contentContainer.y = .5*( geometry.height - h );
					break;
				case RATIO:
						content.width = geoRatio>ratio ?  h * ratio : w;
						content.height =geoRatio>ratio ?  h : w/ratio;
						contentContainer.x = .5*( geometry.width - contentContainer.width );
						contentContainer.y = .5*( geometry.height - contentContainer.height);
					break;
			}
			
		}
		
		public function get src():String 
		{
			return src_;
		}
		
		private var content_:DisplayObject;
		public function set content(val:DisplayObject):void{
			if(content_==val) return;
			if(content_) contentContainer.removeChild( content_ );
			if(val){
				content_ = val;
				contentSize = content.getBounds( content );
				contentContainer.addChild( content );
			}
			invalidate();
		}
		
		public function get content():DisplayObject{
			return content_;
		}
		
		private var smoothing_:Boolean=true;
		public function set smoothing(val:Boolean):void 
		{
			smoothing_ = val;
			invalidate();
		}
		
		public function get smoothing():Boolean{
			return smoothing_;
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
		
		override public function sizeHint():WSize{
			return new WSize( contentSize.width - padding.sumX(),contentSize.height-padding.sumY());
		}
		
		private var padding_:WPadding = new WPadding(0,0,0,0);
		public function set padding(val:WPadding):void 
		{
			padding_ = val;
			invalidate();
		}
		
		public function get padding():WPadding 
		{
			
			return padding_;
		}
		
	}
}