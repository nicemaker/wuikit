package org.wuikit.task
{
	
	import flash.display.Stage;
	
	import org.wuikit.common.IClear;
	import org.wuikit.common.ICommand;
	import org.wuikit.common.IParser;
	import org.wuikit.global.log;

	public class Task implements ITask
	{
		public static const ERROR:int = 1;
		public static const PROGRESS:int=2;
		public static const COMPLETE:int = 3;
		
		public function Task(src:Object=null,parser:IParser=null,id:String=null,priority:int=0,info:Object=null)
		{
			this.src = src;
			this.parser = parser;
			this.id = id;
			this.priority = priority;
			this.info = info;
		}
		
		
		private var info_:Object;
		public function get info():Object
		{
			return info_;
		}
		
		public function set info(val:Object):void
		{
			info_ = val;
		}
		
		
		private var id_:String;
		public function get id():String
		{
			return id_;
		}
		
		public function set id(val:String):void
		{
			id_ = val;
		}
		
		
		public function run(...args):*
		{
			dispatchState(COMPLETE,parser? parser.parse(src) : src);
		}
				
		public function undo(...args):*
		{
			return null
		}
		
		public function skip():void
		{
			clear();
		}
		
		public function clear():*{
			group = null;
		}
		
		public function pause():void{
			
		}
		
		public function resume():void{
			
		}
		
		private var priority_:int;
		public function set priority(val:int):void 
		{
			priority_ = val;
		}
		
		public function get priority():int{
			return priority_
		}
		
		protected function fromStack( uri:String ):*{
			if(!group) return null;
			return group.getStack().getVal( uri );
		}
		
		protected function pushTask(...args):void{
			if(group)
				group.push.apply(null,args);
		}
		

		private var group_:ITaskGroup;
		public function set group(val:ITaskGroup):void 
		{
			group_ = val;
		}
		
		public function get group():ITaskGroup 
		{
			
			return group_;
		}
		
		private var parser_:IParser;
		public function set parser(val:IParser):void 
		{
			parser_=val;
		}
		
		public function get parser():IParser{
			return parser_
		}
		
		public function dispatchState( type:int, val:Object ):ITask{
			logState(type,val);
			if(!callbacks_) return this;
			var l:int = callbacks_.length;
			for(var i:int;i<l;i++){
				(callbacks_[i] as Function).call( null,this, type, val );
			}
			return this;
		}
		
		protected function logState(state:int,val:*):void{
			if(state ==ERROR){
				var err:Error = val;
				var debug:Boolean;
				log( this,"'"+id+"'",'State:',state,"," + val.getStackTrace());
				debug = err.getStackTrace().search(/:[0-9]+]$/m) > -1;
				if(debug)
					throw err 
			}
			else if(state == COMPLETE)
				log( this,"'"+id+"'",",",'State:',state);
		}
		
		protected var callbacks_:Array;
		public function addCallback(f_with_task_type_value:Function):ITask{
			var f:* = f_with_task_type_value;
			if(!callbacks_) callbacks_ = [];
			if(callbacks_.indexOf( f ) == -1)
				callbacks_.push( f );
			return this;
		}
		
		
		private var src_:Object;		
		public function set src(val:Object):void
		{
			src_ = val;
		}
		
		public function get src():Object
		{
			return src_;
		}
		
	}
}