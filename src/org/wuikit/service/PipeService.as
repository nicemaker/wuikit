package org.wuikit.service
{
	
	import flash.utils.Dictionary;

	public class PipeService
	{
		
		protected var ports:Dictionary;
		protected const $OWNER:String = '$OWNER';
		protected const $VALID:String = '$VALID';
		protected const $VAL:String = '$VAL';
		
		public function PipeService()
		{
			ports = new Dictionary;
		}
		
		public function send( port:uint, val:* ):*{
			if( !ports.hasOwnProperty(port)|| !isValid( val, port ) )
				return val;
			ports[port][$VAL] = val;
			var i:int =0;
			var l:int = ports[port].length;
			for(i;i<l;i++){
				sendToPipe( ports[port][i],val );
			}
			return val;
		}
		
		protected function isValid(val:Object,port:uint):Boolean{
			return !ports[port][$VALID] || (ports[port][$VALID] as Function).call(null,val)
		}
		
		protected function sendToPipe(p:Object,val:Object):*{
			if(p.t is Function)
				p.t.call(null,val)
			else if(p.p)
				p.t[p.p] = val;
			return 1;
		}
		
		public function register( port:int, ...args ):*{
			if(ports.hasOwnProperty(port)){
				var p:Object ;
				if( null != (p = getPipe.apply(null, args ) ) ){
					if( !ports[port].every( function(o:Object):Boolean{ return p.t != o.t }  ) )
						return 0;
					ports[port].push(p)
					sendToPipe( p, ports[port][$VAL] );
				return 1}
			}
			return  0;
		}
		
		protected function getPipe(...args):Object{
			if(args.length == 0) return null;
			var p:Object= new Object;
			p.t = args[0];
			p.p = args.length > 1 && args[1] is String? args[1] : null;
			return  p;
		}
		
		
		public function open( port:uint,owner:Object,validate:Function=null ):*{
			if(!ports.hasOwnProperty(port)){
				ports[port] = [];
				ports[port][$OWNER] = owner;
				ports[port][$VALID] = validate;
				return 1;
			}
			return 0;
		}
		
		public function close( port:*,owner:Object ):*{
			if( ports.hasOwnProperty(port) && ports[port][$OWNER] == owner){
				delete ports[port];
				return 1;
			}
			else return 0;
		}
		
	}
}