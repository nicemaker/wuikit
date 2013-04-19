package org.wuikit.global
{

	public function log(...args):*{
		if(__APP.getLogCall() != null)
			__APP.getLogCall().apply(null,args);
		else
			trace.apply(null,args);
	}
	
}