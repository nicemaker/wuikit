package org.wuikit.common
{
	import org.wuikit.common.IClear;
	import org.wuikit.common.IDispose;
	
	import flash.display.DisplayObject;
	
	public interface IDataRenderer extends IDispose,IClear
	{
		function renderData(data:Object,w:Number,h:Number):DisplayObject;
		function isValidDataType( data : Object ):Boolean;
		function display():DisplayObject;
		
	}
}