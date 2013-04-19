package org.wuikit.global
{
	import org.wuikit.common.IDict;

	public function getDict(id:String,...args):IDict{
		return __APP.getDictRegister().getVal( id ) ;
	}
}