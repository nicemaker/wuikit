package org.wuikit.common
{
	public interface IDataObject
	{
		function set data( data : Object ):void
		function get data():*
		function isValidDataType( data:Object ):Boolean;
	}
}