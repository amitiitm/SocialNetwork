package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.AddEditEvent;
	import com.generic.events.DetailAddEditEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Container;
	
	public class PreSaveRowCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(__genModel.isLockScreen)
			{
				Alert.show('In Progrss ! please try again');
				return;
			}
			else
			{
				var detailAddEditContainer:Container = __genModel.activeModelLocator.detailEditObj.detailEditContainer
				detailAddEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.PRE_SAVE_ROW_EVENT));
			}
		}
	}
}
