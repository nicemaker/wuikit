package org.wuikit.task
{
	import org.wuikit.common.ICommand;
	import org.wuikit.common.IParser;

	public interface ITask extends ICommand
	{
		function set priority(val:int):void
		function get priority():int;
		function set group(val:ITaskGroup):void;
		function get group():ITaskGroup;
		function set info(val:Object):void;
		function get info():Object;
		function set src(val:Object):void;
		function get src():Object;
		function set parser(val:IParser):void;
		function get parser():IParser;
		function get id():String;
		function set id(val:String):void;
		
		function addCallback(f_with_task_type_value:Function):ITask;
		
	}
}