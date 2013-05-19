package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.AddEditEvent;
	import com.generic.events.DetailAddEditEvent;
	
	import model.GenModelLocator;
	
	import mx.core.Container;
	
	public class PreSaveImportedXMLCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
				var detailAddEditContainer:Container = __genModel.activeModelLocator.detailEditObj.detailEditContainer
				detailAddEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.PRE_SAVE_IMPORTED_XML_EVENT));
			
		}
	}
}


