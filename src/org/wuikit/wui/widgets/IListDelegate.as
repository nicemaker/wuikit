package org.wuikit.wui.widgets
{

	public interface IListDelegate
	{
		function getItemRendererInListAt( list:IListView,i:int ):*
		function uiStateChangeInListAt( list:IListView,i:int ):void
	}
}