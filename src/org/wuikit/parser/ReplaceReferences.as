package org.wuikit.parser
{
	import org.wuikit.common.IDict;
	import org.wuikit.common.IParser;
	
	public class ReplaceReferences implements IParser
	{
		public var dict:IDict;
		public var source:String;
		
		public function ReplaceReferences(dict:IDict)
		{
			this.dict = dict;
			this.source = source;
		}
		
		public function parse(value:Object):*
		{	
			source=value.toString();
			if(!source) return null;
			
			var regExp:RegExp = /(@{([\w\d\-_\$]+)})/gi;
			var match:Array;
			var val:String;
			while(match=regExp.exec(source) ){
				if( (val=dict.getVal(match[1]) ) )
				source = source.replace( match[1],val);
			}
				
			return source;
		}
	}
}