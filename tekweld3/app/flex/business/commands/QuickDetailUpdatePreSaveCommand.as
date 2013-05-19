package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.QuickDetailUpdateEvent;
	import model.GenModelLocator;
	import mx.core.Container;
	
	public class QuickDetailUpdatePreSaveCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			if(__genModel.activeModelLocator.addEditObj.recordStatus == "MODIFY")
			{
				var addEditContainer:Container = __genModel.activeModelLocator.addEditObj.addEditContainer
				addEditContainer.dispatchEvent(new QuickDetailUpdateEvent(QuickDetailUpdateEvent.QUICK_DETAIL_UPDATE_PRE_SAVE_EVENT));
			}
		}
	}
}
