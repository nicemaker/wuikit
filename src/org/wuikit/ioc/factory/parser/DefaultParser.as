package org.wuikit.ioc.factory.parser
{
	import flash.utils.Dictionary;
	
	import mx.events.ChildExistenceChangedEvent;
	
	import org.wuikit.ioc.factory.FunctionCall;
	import org.wuikit.ioc.factory.IocContext;
	import org.wuikit.ioc.factory.ObjectDefinition;
	import org.wuikit.ioc.factory.ObjectRef;

	public class DefaultParser
	{
		
		private var ctxt:IocContext;
		
		public function DefaultParser()
		{
		}
		
		public function parseNode(xml:XML,context:IocContext):*{
			ctxt = context;
			return resolveNode(xml);
		}
		
		
		protected function resolveNode(node:XML,def:ObjectDefinition = null):*{
			switch(node.localName()){
				case 'def':
					return resolveDef(node);
				break;
				case 'prop':
					return resolveKeyValue(node)
				break;
				case 'properties':
					return resolveProperties(node);
				break
				case 'init':
					return resolveFunctionCall(node,'init');
				break;
				case 'construct':
					return resolveFunctionCall(node);
				break;
				case "boolean":
				case "int":
				case "number":
				case "string":
				case "array":
				case "ref":
					return transformType( node.toString(),node.localName())
				break;
				default:
					return ctxt.parseNode( node );
			}
			return null;
		}
		
		
		protected function resolveDef(xml:XML):ObjectDefinition{
			var def:ObjectDefinition = new ObjectDefinition;
			
			def.id = xml.@id;
			def.className =  xml['@class']||null;
			def.static = xml['@static'] == 'true' || false;
			if(def.static)
				return def;
			
			def.inherit = xml['@inherit']||null;
			def.lazy = xml.hasOwnProperty( '@lazy' ) && xml.@lazy == 'false' ? false : true; 
			def.prototype = xml.hasOwnProperty( '@prototype' ) && xml.@prototype == 'true' ? true : false;
			if(xml.hasOwnProperty('init'))
				def.init = resolveNode(xml.init[0]);
			if(xml.hasOwnProperty('construct'))
				def.constructor = resolveNode(xml.construct[0]);
			if(xml.hasOwnProperty('properties'))
				def.props = resolveNode(xml.properties[0]);
			
			return def
			
		}
		protected function resolveFunctionCall(xml:XML,defaultCall:String=null):FunctionCall{
			var f:FunctionCall = new FunctionCall;
			f.name = xml.hasOwnProperty('@call') ? xml.@call : defaultCall;
			for each(var node:XML in xml.children() ){
				if(!f.args) f.args = [];
				f.args.push( resolveNode( node ) )
			}
			return f;
		}
		
		protected function resolveProperties(xml:XML):Dictionary{
			
			var result:Dictionary = new Dictionary;
			var list:XMLList = xml.children();

			for each( var node:XML in list )
				result[node.@key.toString()] = resolveNode( node);
			
			return result;
		}
		
		
		protected function resolveKeyValue( node:XML ):*{
			if(!node) return null;
			if( node.hasOwnProperty('@val') )
				return transformType( node.@val.toString(),node.@type);
			else if( node.hasOwnProperty('@ref') )
				return new ObjectRef( node.@ref );
			else if(node.hasOwnProperty('@type'))
				return transformType( node,node.@type );
			else
				return resolveNode(  node.children()[0] );
			
			return null
				
				
			}
		
		protected function transformType(val:String,type:String):*{
			if(!type) type = getTypeFor(val);
			if(val.search('@{') == 0 )
				val = ctxt.dict.getVal( val)
			switch(type){
				case "boolean":
					return val == 'true' || val == '1';
				break;
				case "int":
					return parseInt(val);
					break;
				case "number":
					return parseFloat(val);
				break;
				case "string":
					return val;
					break;
				case "array":
					var a:Array = [];
					for each(var child:XML in XML(val).children())
						a.push(resolveNode( child ));
					return a;
				break;
				case "ref":
					return new ObjectRef( val );
				break;
				default:
					if(val == 'true' || val == 'false') return val == 'true' ? true : false;
					
					
			}
			return val;
		}
	
		protected function getTypeFor(val:String):String{
			var regEx:RegExp;
			var match:Array;
			if( ( match = val.match( /[0xaA-Ff0-9]+/ ) ) ){
				if(match[0].toString().length == val.length)
					return 'int';
			}
			if( (  match = val.match( /[\d\.]+/ )  ) ){
				if(match[0].toString().length == val.length)
					return 'number';
			}
			if(val == 'true' || val == 'false')
				return 'bool'
			
			return ''
		}
	}
}