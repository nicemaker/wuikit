package org.wuikit.parser
{
	import org.wuikit.common.IParser;
	
	import flash.text.StyleSheet;
	
	public class CSSToStyleSheet implements IParser
	{
		public function CSSToStyleSheet()
		{
		}
		
		public function parse(value:Object):*
		{
			var s:StyleSheet = new StyleSheet()
			s.parseCSS( value.toString() )
			return s;
		}
	}
}