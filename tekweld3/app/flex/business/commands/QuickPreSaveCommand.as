package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.QuickAddEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Container;
	
	public class QuickPreSaveCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(__genModel.isLockScreen)
			{
				Alert.show('In Progrss ! please try again');
				return;
				
			}
			else if(__genModel.activeModelLocator.addEditObj.recordStatus == "MODIFY")
			{
				var addEditContainer:Container = __genModel.activeModelLocator.addEditObj.addEditContainer
				addEditContainer.dispatchEvent(new QuickAddEvent(QuickAddEvent.QUICK_PRE_SAVE_EVENT));
			}
		}
	}
}

