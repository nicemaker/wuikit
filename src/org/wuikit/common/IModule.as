package org.wuikit.common
{
	public interface IModule extends IInit,IDispose
	{
		function start():void
		function pause():void
		function resume():void
		function finish():void
		
	}
}