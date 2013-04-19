package org.wuikit.task
{
	import org.wuikit.common.ICommand;
	import org.wuikit.common.IDict;

	public interface ITaskGroup extends ITask
	{
		function push( ...args ):*;
		function pushStart( ...args ):*;
		
		function taskAt(i:int):*
		function getTasks():Array;
		function setTasks(val:Array):void;
		function indexOf(task:ITask):int;
		function setStack(val:IDict):void
		function getStack():IDict;
		
	}
}