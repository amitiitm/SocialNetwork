package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.DetailEdit;
	import com.generic.components.DetailImport;
	
	import model.GenModelLocator;
	
	import mx.core.Container;
	import mx.managers.PopUpManager;
	
	public class DetailImportCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditContainer:Container;
		
		public function execute(event:CairngormEvent):void
		{
			__addEditContainer = __genModel.activeModelLocator.addEditObj.addEditContainer
			openDetailImport()
		}

		private function openDetailImport():void
		{
			var detailImport:DetailImport;

			detailImport 					= DetailImport(PopUpManager.createPopUp(__addEditContainer, DetailImport, true));
			detailImport.vbAddEdit.addChild(__genModel.activeModelLocator.detailEditObj.detailEditContainer);
			detailImport.x 					= detailImport.x + detailImport.width / 2
			detailImport.y					= detailImport.y + detailImport.height / 4
			detailImport.title				=	__genModel.activeModelLocator.detailEditObj.title;
			detailImport.uploadServiceID	=	__genModel.activeModelLocator.detailEditObj.uploadServiceID;
			detailImport.downloadedRootNode	=	__genModel.activeModelLocator.detailEditObj.downloadedRootNode;
			
		}
	}
}	
