package org.wuikit.log
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	import org.wuikit.wui.Widget;

	public class Logger extends Sprite implements ILog
	{
		
		public var textField:TextField;
		public var flashTrace:Boolean;
		
		
		public function Logger(flashTrace:Boolean=false)
		{
			this.flashTrace
			textField = new TextField;
			textField.defaultTextFormat = new TextFormat('Arial',10,0x00ff00);
			
			textField.multiline = true;
			textField.selectable = true;
			addChild(textField);
			addEventListener( Event.ADDED_TO_STAGE,onAdded );
			visible = false;
		}
		
		protected function onAdded(e:Event):void{
			removeEventListener( Event.ADDED_TO_STAGE,onAdded );
			stage.addEventListener(Event.RESIZE,onResize);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKey);
			onResize();
		}
		
		protected function onKey(e:KeyboardEvent):void{
			if(e.shiftKey && e.keyCode == Keyboard.BACKSPACE)
				visible = !visible;
		}
		
		protected function onResize(e:Event=null):void{
			resizeTo(stage.stageWidth,stage.stageHeight)
		}
		
		
		protected function resizeTo(w:Number,h:Number):void{
			textField.width = w - 20;
			textField.height = h - 20;
			textField.x = 10;
			textField.y = 10;
			
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(0,.8);
			g.drawRect(0,0,w,h);
			g.endFill();
		}
		
		private var count:Number=0;
		public function log(  ...args ):*{
			count++;
			var l:int=args.length;
			for(var i:int=0;i<l;i++)
				textField.appendText( (args[i] == null ? 'null' : args[i].toString() ) + (i==args.length-1 ? '' : ' ') );
			textField.appendText('\n');
			
			textField.scrollV =  textField.getLineIndexOfChar( textField.length - 1 ) ;
			
			if(flashTrace)
				trace.apply( null,args);
		}
							 
							 
	}
}