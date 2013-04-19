package org.wuikit.global
{
	public function getService( id:String,...args ):*{
		return __APP.getServiceRegister().getVal(id) ;
	}
		
}