package org.wuikit.wui.widgets
{
	import org.wuikit.wui.Widget;
	import org.wuikit.wui.frame.SimpleFrame;
	
	public class WSpacer extends Widget
	{
		public function WSpacer()
		{
			super();
			mouseChildren=false;
			mouseEnabled=false;
			frameStyle=new SimpleFrame(0,0,0,0,0);
		}
		
	}
}