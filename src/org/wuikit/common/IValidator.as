package org.wuikit.common
{
	import org.wuikit.common.IRefresh;
	
	import flash.utils.setTimeout;
	
	public interface IValidator
	{
		function validate( o:Object, ... args ) : void;
	}
}