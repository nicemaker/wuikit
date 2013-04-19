package org.wuikit.common
{
	import flash.geom.Rectangle;
	
	public interface IRenderSize
	{
		function setRenderSize(w:Number,h:Number):void
		function getRenderSize():Rectangle;
	}
}