package org.wuikit.wui
{
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import org.wuikit.wui.frame.IFrameStyle;
	import org.wuikit.wui.layout.ILayout;

	public interface IWidget  extends IInteractive
	{
		function setGeometry(x:Number,y:Number,w:Number,h:Number):void
		
		function set geometry(val:Rectangle):void
		function get geometry():Rectangle
	
		function set layout(val:ILayout):void;
		function get layout():ILayout;
		
		function get frameStyle():IFrameStyle
		function set frameStyle(val:IFrameStyle):void
			
		function set minSize(val:WSize):void
		function get minSize():WSize
	
		function set maxSize(val:WSize):void
		function get maxSize():WSize
		
		function set stretch(val:WSize):void
		function get stretch():WSize
			
		function set hPolicy(val:String):void;
		function get hPolicy():String;
		
		function set vPolicy(val :String):void;
		function get vPolicy():String;
		
		function open():IEventDispatcher
		function close():IEventDispatcher
			
		function sizeHint():WSize;
	}
}