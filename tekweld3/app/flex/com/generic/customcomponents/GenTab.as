package com.generic.customcomponents 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.tabBarClasses.Tab;
	import mx.core.UIComponent;
	import mx.events.ItemClickEvent;
	
	import valueObjects.ModeVO;
	
	[Style(name="closeButtonStyleName", type="String", inherit="no")]
	public class GenTab extends Tab
	{
		public static const CLOSE_TAB_EVENT:String = "closeTab";
		public static const CLOSE_ALWAYS:String = "close_always";
		public static const CLOSE_SELECTED:String = "close_selected";
		public static const CLOSE_ROLLOVER:String = "close_rollover";
		public static const CLOSE_NEVER:String = "close_never";
		
		private var _rolledOver:Boolean = false;
		private var closeButton:Button;
		private var indicator:DisplayObject;

		public function GenTab():void 
		{
			super();
			this.mouseChildren = true;
		}
		
		private var _closePolicy:String;
		public function get closePolicy():String
	    {
			return _closePolicy;
		}
		
		public function set closePolicy(value:String):void 
		{
			this._closePolicy = value;
			this.invalidateDisplayList();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			closeButton = new Button();
			closeButton.width = 16;
			closeButton.height = 16;
			closeButton.name = "CloseButton"
			closeButton.styleName = "CloseButton";
			
			closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler, false, 0, true);
			closeButton.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown); // VD 22 Oct 
			// closeButton.styleName = getStyle("closeButtonStyleName");
			
			var indicatorClass:Class = getStyle("indicatorClass") as Class;

			if(indicatorClass) 
			{
				indicator = new indicatorClass() as DisplayObject;
			}
			else 
			{
				indicator = new UIComponent();
			}
			
			addChild(indicator);
			addChild(closeButton);
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			setChildIndex(closeButton, numChildren - 2);
			setChildIndex(indicator, numChildren - 1);
			closeButton.visible = false;
			indicator.visible = false;
			
		    if(_closePolicy == GenTab.CLOSE_SELECTED) 
		    {
				if(selected) 
				{
					closeButton.visible = true;
					closeButton.enabled = true;
				}
			}
			else 
			{
				if(!_rolledOver) 
				{
					if(_closePolicy == GenTab.CLOSE_ALWAYS)
					{
						closeButton.visible = true;
						closeButton.enabled = false;
					}
					else if(_closePolicy == GenTab.CLOSE_ROLLOVER) 
					{
						closeButton.visible = false;
						closeButton.enabled = false;
					}
				}
				else 
				{
					if(_closePolicy != GenTab.CLOSE_NEVER) 
					{
						closeButton.visible = true;
						closeButton.enabled = true;
					}
				}
			}
			
			if(closeButton.visible) 
			{
				// VD 22 Oct 2010
				if(this.width - this.textField.width <= 25)
				{
					this.textField.width -= closeButton.width;
				}
				
				this.textField.truncateToFit();
		     	closeButton.x = unscaledWidth-closeButton.width - 4;
				closeButton.y = 4;
			}
		}

		override protected function rollOverHandler(event:MouseEvent):void
		{
			_rolledOver = true;
			super.rollOverHandler(event);	
		}
		
		override protected function rollOutHandler(event:MouseEvent):void
		{
			_rolledOver = false;
			super.rollOutHandler(event);	
		}

		private function closeClickHandler(event:MouseEvent):void 
		{
			dispatchEvent(new Event(CLOSE_TAB_EVENT));
			event.stopImmediatePropagation();
		}
		
		// VD 22 Oct 2010			
		private function handleMouseDown(event:MouseEvent):void
		{
			event.stopPropagation();
			event.preventDefault();
			
			if (event.target is Button && event.target.name == "CloseButton")
			{
				var __genModel:GenModelLocator = GenModelLocator.getInstance();
				var closeFlag:Boolean=false;

				if(__genModel.activeModelLocator.hasOwnProperty('addEditObj'))
				{
					if(!(__genModel.activeModelLocator.addEditObj.recordStatus == "MODIFY" && __genModel.activeModelLocator.documentObj.selectedMode == ModeVO.EDIT_MODE))
					{
						closeFlag = true;
					}
				}	
				else
				{
					closeFlag = true;
				}

				if(closeFlag)
				{
					var closeEvent:ItemClickEvent = new ItemClickEvent("TAB_CLOSE_CLICK", true, true);
					closeEvent.index = parent.getChildIndex(this)

					closeButton.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);

					//removeEventListener("creationComplete", handleCreationComplete);

					dispatchEvent(closeEvent);
				}
				else
				{
					Alert.show("Please save/cancel current record !")			
				}
			}
		}
	}
}