package org.wuikit.global
{
	import org.wuikit.common.IDict;

	public class __APP
	{
		
		private static var services_:IDict;
		private static var dicts_:IDict;
		private static var logCall_:Function;
		private static var main_:String;
		
		public function __APP()
		{
		}
		
		
		public static function setServiceRegister( value:IDict ):uint{
			if(services_)
				return 0
			
			services_ = value;
			
			return 1;
		}
		
		public static function getServiceRegister():IDict{
			return services_
		}
		
		public static function getDictRegister():IDict{
			return dicts_
		}
		
		public static function setDictRegister( value:IDict ):uint{
			if(dicts_)
				return 0;
			dicts_ = value;
			return 1;
		}
		
		public static function  setLogCall( f:Function ):uint{
			if(null != logCall_)
				return 0;
			logCall_ = f;
			return 1;
		}
		
		public static function getLogCall():Function{
			return logCall_;
		}
		
	}
}