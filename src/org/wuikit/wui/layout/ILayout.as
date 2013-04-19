package org.wuikit.wui.layout
{
	import org.wuikit.wui.IWidget;
	import org.wuikit.wui.WSize;

	public interface ILayout
	{
		function apply(ui:IWidget):WSize
		function sizeHint():WSize;
	}
}