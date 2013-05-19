package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.FetchRecords;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.managers.PopUpManager;
	
	public class FetchRecordsCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditContainer:Container;
		
		public function execute(event:CairngormEvent):void
		{
			__addEditContainer = __genModel.activeModelLocator.addEditObj.addEditContainer
			openDetailEdit()
		}

		private function openDetailEdit():void
		{
			var fetchComponent:FetchRecords;
			
			fetchComponent = FetchRecords(PopUpManager.createPopUp(__addEditContainer, FetchRecords, true));
			fetchComponent.x = fetchComponent.x + fetchComponent.width / 6
			fetchComponent.y = fetchComponent.y + fetchComponent.height / 6
			fetchComponent.title	=	__genModel.activeModelLocator.detailEditObj.title;
			//__genModel.activeModelLocator.detailEditObj.detailEditContainer	=	fetchComponent;
		}
	}
}	



