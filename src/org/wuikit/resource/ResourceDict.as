package org.wuikit.resource
{
	
	import org.wuikit.common.IDict;
	
	
	public dynamic class ResourceDict implements IDict
	{
		
		public var id:String;
		
		public function ResourceDict()
		{
			super();
		}
				
		public function getVal(key:Object, ...args):*
		{
			if(key == null || key == 'undefined' || key == '') return null; 
			if(key.search(/@\{/) == 0){
				var r:*;
				key = key.toString().replace( /\@\{/,'' ).replace("}",'');
				r = traverseResources( key.toString() );
				return  r ? r.valueOf().valueOf() : null;
			}
		
			return hasOwnProperty( key ) ? this[key] : null ;
		}
		
		public function setVal(key:Object,val:*,...args):*{
			this[key] = val;
			return val;
		}
		
		protected function traverseResources(key:String):Object{
			var target:*=this;
			var next:*;
			var objectDivider:RegExp = /[^\:]+/g;
			while(next = objectDivider.exec(key)){
				target = target[next[0]];
				if(!target) return null;
			}
			return target == this ? null : target;
		}
	}
}