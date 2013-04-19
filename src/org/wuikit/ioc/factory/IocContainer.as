package org.wuikit.ioc.factory
{
	import org.wuikit.common.IObjectFactory;
	
	public class IocContainer implements IObjectFactory
	{
		
		public var contextList:Array;
		
		
		public function IocContainer()
		{
		}
		
		public function init( ...args ):*{
			contextList = [];
		}
		
		public function getObject(key:Object, ...args):*
		{
			return null;
		}
		
		public function addContext( context:IocContext ):IocContext{
			if( contextList.indexOf( context ) == -1){
				contextList.push( context );
			}
			return context
		}
		
		public function getContext(id:String):IocContext{
			var i:int = contextList.length;
			var c:IocContext;
			while(i--){
				if(contextList[i].id == id){
					c = contextList[i];
				}
			}
			return c;
		}
		
		public function removeContext( context:IocContext ):IocContext{
			var i:int = contextList.indexOf( context )
			if( i == -1)
				return null
			return contextList.splice(i,1)[0];
		}
			
		public function dispose():*{
			contextList = null;
			return this;
		}
	}
}