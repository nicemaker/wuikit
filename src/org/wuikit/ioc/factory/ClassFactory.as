package org.wuikit.ioc.factory
{
	
	import flash.utils.getDefinitionByName;
	
	import org.wuikit.common.IObjectFactory;
	
	public class ClassFactory implements IObjectFactory
	{
		public function ClassFactory()
		{
		}
		
		public function getObject(key:Object, ...args):*
		{
			if( !key )
				return null;
				
			args = args[0];
			
			if(key is String){
				try{ key = getDefinitionByName( key.toString() ) as Class }
				catch(err:Error){}
			}
			
			if(key is Class){
				var cl:Class = key as Class;
				var inst:Object;
				if(!args || args.length==0)
					inst = new cl( );
				else{
					switch(args.length){
						case 1:
							inst = new cl( args[0] );
						break;
						case 2:
							inst = new cl( args[0],args[1] );
						break;
						case 3:
							inst = new cl( args[0],args[1],args[2] );
						break;
						case 4:
							inst = new cl( args[0],args[1],args[2],args[3] );
						break;
						case 5:
							inst = new cl( args[0],args[1],args[2],args[3],args[4] );
						break;
						case 6:
							inst = new cl( args[0],args[1],args[2],args[3],args[4],args[5] );
						break;
						case 7:
							inst = new cl( args[0],args[1],args[2],args[3],args[4],args[5],args[6] );
							break;
						case 8:
							inst = new cl( args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7] );
							break;
						case 9:
							inst = new cl( args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8] );
							break;
						case 10:
							inst = new cl( args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9] );
							break;
					}
				}
				return inst
			}
			return null;
		}
	}
}