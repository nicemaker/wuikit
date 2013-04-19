package org.wuikit.wui
{
	public class WPadding
	{
		public var left:Number;
		public var right:Number;
		public var top:Number;
		public var bottom:Number;
		
		public function WPadding(l:Number,r:Number,t:Number,b:Number)
		{
			left = l;
			right = r;
			top = t;
			bottom = b;
		}
		
		public function sumX():Number{
			return left+right;
		}
		
		public function sumY():Number{
			return  top + bottom;
		}
		
	}
}