package dashboard.customcomponent
{
	import flash.display.DisplayObject;
	
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.core.IUIComponent;
	import mx.core.mx_internal;

	use namespace mx_internal;

	public class BetterTitleWindow extends TitleWindow {
		public  var titleBarContainer:TitleBar;

		public function BetterTitleWindow() {
			super();
		}

		override public function createComponentsFromDescriptors(recurse:Boolean = true):void {
			super.createComponentsFromDescriptors(recurse);
			var n:int = numChildren;
			var child:IUIComponent;
			var oldChildDocument:Object;

			for(var i:int = 0; i < n; i++) {
				child = getChildAt(i)as IUIComponent;
				if (child is TitleBar) {
					
					oldChildDocument = child.document;
					
					if (contentPane) {
						contentPane.removeChild(DisplayObject(child));
					} else {
						removeChild(DisplayObject(child));
					}

					child.document = oldChildDocument;

					titleBarContainer = child as TitleBar;

					break;
				}
			}
		}
		
		override protected function createChildren():void{
			super.createChildren();
			
			if(titleBarContainer) titleBar.addChild(titleBarContainer);
			
		}

		override protected function layoutChrome(w:Number, h:Number):void{
			super.layoutChrome(w, h);
			
			if(titleBarContainer){
				var titleWidth:Number = titleTextField.getUITextFormat().measureText(titleTextField.text).width;
				var barWidth:Number = titleBar.width - (titleWidth + titleTextField.x + 1);
				if(_showCloseButton) barWidth -= (titleBar.width - closeButton.x);
				titleBarContainer.move(titleTextField.x + titleWidth + 1, 0);
				titleBarContainer.setActualSize(barWidth, titleBar.height);
			}
		}


	}
}