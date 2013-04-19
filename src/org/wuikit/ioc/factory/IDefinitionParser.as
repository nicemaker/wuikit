package org.wuikit.ioc.factory
{
	public interface IDefinitionParser
	{
		function parseDefinition(xml:XML,context:IocContext):ObjectDefinition
	}
		
}