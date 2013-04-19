package org.wuikit.ioc.factory
{
	
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.wuikit.common.IDict;
	import org.wuikit.common.IObjectFactory;
	import org.wuikit.common.IParser;
	import org.wuikit.ioc.factory.parser.DefaultParser;
	
	public class IocContext extends EventDispatcher implements IObjectFactory
	{
		protected var configLoader:URLLoader;
		protected var namespaceHandler:Dictionary;
		
		public function IocContext(parent:IocContext = null)
		{
			this.parent = parent;
			definitions = new Dictionary;
			namespaceHandler = new Dictionary;
		}
	
		
		
	public function parseConfiguration( config:String ):void{
			var xml:XML = new XML(config);
			var def:ObjectDefinition;
			for each(var node:XML in xml.objects[0].children() ){
				def = parseNode( node );
				if(def.id) definitions[ def.id ] = def;
				if(!def.lazy && !def.static) def.instance = getInstanceForDefinition(def);
			}
		}
		
		public function addDefinition(def:ObjectDefinition):ObjectDefinition{
			if(def.id) definitions[ def.id ] = def;
			if(!def.lazy && !def.static) def.instance = getInstanceForDefinition(def);
			return def;
		}
		
		public function parseNode(xml:XML):ObjectDefinition{
			var ns:String = xml.namespace();
			var handler:DefaultParser = namespaceHandler[ns] || new DefaultParser;
			var def:ObjectDefinition = handler.parseNode( xml,this );
			return  def;
		}
	
		public function getObject(key:Object, ...args):*
		{
			var def:ObjectDefinition;
			return ( def=getDefinition( key ) ) ? getInstanceForDefinition( def ) : null;
		}
		
		protected function getDefinition( key:Object, ...arg):ObjectDefinition{
			if(!definitions.hasOwnProperty( key ) ) return null;
			return  definitions[key];
		}
		
		protected function getInstanceForDefinition( def:ObjectDefinition ):*{
			if(!def) return null;
			
			var inst:Object;
			if(def.instance)
				inst = def.instance;
			else if(def.inherit)
				def = resolveInherit(def);
			if(def.className){
				var cl:Class=getDefinitionByName( def.className) as Class;
				if(def.static)
					return cl;
				if(def.constructor && def.constructor.name)
					inst = Function(cl[def.constructor.name]).apply( this,def.constructor.args )
				else
					inst = new ClassFactory().getObject( def.className, def.constructor ? def.constructor.args : null ) ;
			}
			else inst = {};
			if(def.props){
				for(var prop:String in def.props){
					if(inst.hasOwnProperty( prop ) ){
						inst[prop] = resolveProp( def.props[ prop ] );	
					}
				}
			}
			if(def.init && def.init.name)
				inst[def.init.name].apply( this,def.init.args )
			return inst;
		}
		
		protected function resolveProp(prop:*):Object{
			if(prop is ObjectRef )
				return resolveRef(prop);
			else if(prop is ObjectDefinition)
				return getInstanceForDefinition(prop);
			else if( prop is Array )
				return iterateArray(prop) 
			return prop
		}
		
		protected function iterateArray(val:Array):Array{
			val = [].concat(val);
			var i:int=val.length;
			while(i--){
				val[i] = resolveProp( val[i] )
			}
			return val;
		}
		
		protected function resolveRef(ref:ObjectRef):*{
			if(ref.uri.search('@{') == 0 )
				return dict.getVal(ref.uri)
			
			var path:Array = ref.uri.split('.');
			var o:Object;
			if( ( o = getObject( path[0] ) ) && path.length>1 ){
				var i :int = 1;
				for( i;i< path.length;i++ ){
					o = o[ path[i] ];
				}
			}
			return o
		}
		
		public function hasDefinition(key:*):Boolean{
			return definitions.hasOwnProperty('key');
		}
		
		protected function resolveInherit(def:ObjectDefinition):ObjectDefinition
		{
			if(!def.inherit) return def;
			
			var prot:ObjectDefinition
			if( (prot = getDefinition( def.inherit) ) ){
				if(prot.inherit && hasDefinition( prot.inherit) )
					prot = resolveInherit( prot );
				def = mergeDefinitions( def,prot )
			} 
			return def;
		}
		
		protected function mergeDefinitions(a:ObjectDefinition,b:ObjectDefinition):ObjectDefinition{
				a = a.clone();
				if(! b) return a;
				if(! a.constructor)
					a.constructor = b.constructor;
				if(! a.init)
					a.init = b.init;
				if(! a.className)
					a.className = b.className;
				if(!a.props && b.props)
					a.props = b.props;
				else{
					for(var prop:String in b.props){
						if( a.hasOwnProperty( prop ) )
							continue;
						a.props[prop] = b.props[ prop ]
					}
				}
				return a;
		}
		
		private var parent_:IocContext;
		public function set parent(context:IocContext):void{
			parent_  = parent;
		}
		
		public function get parent():IocContext{
			return parent_;
		}
		
		
		private var definitions_:Dictionary;
		public function get definitions():Dictionary{
			return definitions_ 
		}
		
		public function set definitions(value:Dictionary):void{
			definitions_ = value;
		}
		
		private var dict_:IDict;
		public function get dict():IDict{
			return dict_ 
		}
		
		public function set dict(value:IDict):void{
			dict_ = value;
		}
		
		public function addNamespaceHandler( uri:String,handler:IParser ):void{
			namespaceHandler[uri] = handler;
		}
		
		
	}
}