package org.wuikit.global
{
	public function registerDict( id:String,dict:Object ):*{
		__APP.getDictRegister()[id] = dict;
		return dict;
	}
		
}