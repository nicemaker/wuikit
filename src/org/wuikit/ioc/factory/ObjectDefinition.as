package org.wuikit.ioc.factory
{
	import flash.utils.Dictionary;

	public class ObjectDefinition
	{
		public var id:String;
		public var lazy:Boolean;
		public var static:Boolean;
		public var singleton:Boolean;
		public var prototype:Boolean;
		public var className:String;
		public var props:Dictionary;
		public var init:FunctionCall;
		public var constructor:FunctionCall;
		public var inherit:String;
		public var instance:*;
		
		public function ObjectDefinition()
		{
		}
		
		public function clone():*{
			var def:ObjectDefinition = new ObjectDefinition;
			def.id = id;
			def.lazy = lazy;
			def.static = static;
			def.singleton = singleton;
			def.props = props;
			def.prototype = prototype;
			def.init = init;
			def.constructor = constructor;
			def.inherit = inherit;
			return def;
		}
	}
}