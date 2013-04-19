package org.wuikit.common
{
	
	public interface IService extends IDispose, IInit
	{
		function register(client:*):*
		function remove( client:* ):*
		function isValidClient(client:*):Boolean
	}
}