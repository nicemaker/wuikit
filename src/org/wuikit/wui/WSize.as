package org.wuikit.wui
{
	public class WSize
	{
		
		public var x:Number=0;
		public var y:Number=0;
		
		public function WSize(x:Number=0,y:Number=0){
			this.x = x;
			this.y = y;
		}
		
		public function equals(val:WSize):Boolean{
			return val && (val.x == x && val.y == y);
		}
		
		public function clone():WSize{
			return new WSize(x,y);
		}
		
		public function limit( min:WSize,max:WSize):WSize{
			return new WSize( Math.min(max.x, Math.max(min.x,x) ), Math.min(max.y, Math.max(min.y,y) )  )
		}
		
	}
}