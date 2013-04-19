package org.wuikit.task
{
	import flash.utils.Dictionary;
	
	import org.wuikit.common.ICommand;
	import org.wuikit.common.IDict;
	import org.wuikit.global.log;
	import org.wuikit.resource.ResourceDict;
	
	public class TaskGroup extends Task implements ITaskGroup
	{
		
		public var sequential:Boolean;
		
		
		protected var running:Array;
		protected var isPausing:Boolean;
		protected var total:int;
		
		public function TaskGroup(id:String=null,tasks:Array=null,stack:IDict=null,sequential:Boolean=false,priority:int=0,message:Object=null)
		{
			super(null,null,id,priority);
			push.apply(this,tasks);
			setStack(stack || new ResourceDict );
			this.sequential = sequential;
			
		}
		
		public function push(...args):*
		{
			var l:int = args.length;
			if(!tasks) tasks = args;
			else tasks = tasks.concat(args);
			
			return this;
		}
		
		public function pushStart(...args):*{
			if(!tasks) tasks = args;
			else
				tasks = args.concat( tasks )
			
			return this
		}
		
		override public function run(...args):*{
			runNext();
		}
		
		override public function pause():void
		{
			isPausing = true;
			var l:int = running.length;
			if(running)
				running.forEach( function(item:*, index:int, array:Array):void{ item.pause() } );
		}
		
		override public function resume():void
		{
			isPausing = false;
			if(running) 
				running.forEach( function(item:*, index:int, array:Array):void{ item.resume() } );				
			else
				runNext();
		}
		
		private var i:int=0;
		protected function runNext():void
		{
			if(!tasks || tasks.length == 0){
				dispatchState( COMPLETE, stack);
				return;
			}
			
			tasks.sortOn('priority',Array.DESCENDING|Array.NUMERIC);
			
			if(isPausing || (running && running.length == max) ) 
				return;
			
			if(!running)
				running = [];
			
			var task:ITask = tasks.shift();
			task.addCallback( onSubtaskState );
			task.group = this;
			running.push(task);
			runTask( task )

			if(!sequential)
				runNext();
		}
		
		protected function onSubtaskState(task:ITask,type:int,val:*):void{
			if(type == ERROR){
				runNext();
			}
			else if(type==COMPLETE){
				running.splice( running.indexOf(task),1);
				runNext();
			}
		}
		
		protected function runTask(task:ITask):*{
			task.run();
		}
		
		
		override public function clear():*
		{
			super.clear();
			if(tasks )
				tasks.forEach( function(item:*, index:int, array:Array):void{ item.clear() } );
			if(running)	
				running.forEach( function(item:*, index:int, array:Array):void{ item.clear() } );
			total = 0;
			tasks = null;
			running = null;
			return this;
		}
		
		private var max_:int = 3;
		public function set max(val:int):void{
			max_ = val;
		}
		
		public function get max():int{
			return max_;
		}
		
		protected var stack:IDict;
		public function setStack(val:IDict):void 
		{
			stack = val;
		}
		
		public function getStack():IDict 
		{
			return stack;
		}
		
		protected var tasks:Array;
		public function setTasks(val:Array):void{
			tasks = val;
		}
		
		public function getTasks():Array{
			return tasks;
		}
		
		public function taskAt(i:int):*{
			if(!tasks || i>tasks.length && i<0)
				return null;
			return tasks[i];
		}
		
		public function indexOf(val:ITask):int{
			if(!tasks) return  -1;
			
			return tasks.indexOf( val );
			
		}
		
	}
}