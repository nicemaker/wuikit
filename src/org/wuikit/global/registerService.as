package org.wuikit.global
{
	public function registerService( id:String,service:* ):*{
		__APP.getServiceRegister()[id] = service;
		return service;
	}
		
}