package org.wuikit.parser
{
	import flash.utils.Dictionary;
	
	import org.wuikit.common.IParser;
	
	public class PropertiesParser implements IParser
	{
		
		public var dict:*;
		public function PropertiesParser(dict:*=null)
		{
			this.dict = dict ? dict : new Dictionary;
		}
		
		public function parse(value:Object):*
		{		
			var regEx:RegExp = /([\w\d\-_\$\.]+)=(.+)\n?/gim;
			var source:String=value.toString();
			var match:Array;
			var refParser:ReplaceReferences = new ReplaceReferences(dict);
			while( match = regEx.exec( source ) ){
				dict[match[1]] = refParser.parse(match[2]);
			}
			return dict;
		}
		
	}
}