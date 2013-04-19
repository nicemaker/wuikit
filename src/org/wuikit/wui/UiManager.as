package org.wuikit.wui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class UiManager
	{
		//show Tooltip;
		//drag,remove,copy
	
		protected var dragGhost:Sprite;
		protected var stage:Stage;
		
		public function UiManager( stage:Stage )
		{
			this.stage = stage;
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouse );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouse );
			stage.addEventListener( MouseEvent.MOUSE_OVER, onMouse );
			stage.addEventListener( MouseEvent.MOUSE_OUT,onMouse );
		}
		
		
		private var active_:IInteractive;
		protected function onMouse(e:MouseEvent):void{
			var ui:IInteractive = e.target as IInteractive;
			var state:UiState = ui ? ui.getUiState() : null;
		
			if(active_ && ui!=active_){
				setUiState( active_, UiState.NORMAL  , false );
				active_ = null;
			}
			
			switch(e.type){
				case MouseEvent.MOUSE_OVER:
					if(ui) setUiState( ui,state.type,true );
				break;
				case MouseEvent.MOUSE_OUT:
					if(ui) setUiState( ui, state.type,false );
				break;
				case MouseEvent.MOUSE_DOWN:
					active_ = ui;
					if(ui) setUiState( ui, UiState.ACTIVE, true );
				break;
				case MouseEvent.MOUSE_UP:
					active_ = null;
					if(ui && ui.isSelectable){
						ui.selected = !ui.selected;
						setUiState( ui, ui.selected ? UiState.NORMAL : UiState.SELECTED  , false );
					}
					else if(ui)
						setUiState(ui, UiState.NORMAL,state.on );
				break;
			}
		}
		
		protected function setUiState(ui:IInteractive,type:int,on:Boolean):UiState{
			if(!ui || !ui.display().buttonMode) return null;
			ui.setUiState( type,on);
			
			if(type == UiState.ACTIVE && ui.dragable){
				if(!dragGhost){
					dragGhost = dragGhostFor( ui );
					stage.addChild(dragGhost)
					dragGhost.scaleX = dragGhost.scaleY = .5;
					dragGhost.x = stage.mouseX - .5*dragGhost.width;
					dragGhost.y = stage.mouseY - .5*dragGhost.height;
					dragGhost.visible = true;
					dragGhost.startDrag();
					dragGhost.cacheAsBitmap = true;
				}
			}
			else if(dragGhost){
				stage.removeChild( dragGhost );
				dragGhost = null;
			}
			return ui.getUiState();
		}
		
		public function dragGhostFor(ui:IInteractive):Sprite{
			dragGhost = new Sprite;
			dragGhost.mouseEnabled = false;
			var bmpData:BitmapData = new BitmapData(ui.display().width,ui.display().height,true);
			bmpData.draw( ui.display() );
			dragGhost.graphics.beginBitmapFill( bmpData );
			dragGhost.graphics.drawRect( 0,0,bmpData.width+1,bmpData.height+1);
			dragGhost.graphics.endFill();
			return dragGhost;
		}
		
		
	}
}