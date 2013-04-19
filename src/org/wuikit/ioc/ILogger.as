package org.wuikit.ioc
{
	import org.wuikit.common.IDispose;

	public interface ILogger extends IDispose
	{
		function log( ...args ):void;
	}
}