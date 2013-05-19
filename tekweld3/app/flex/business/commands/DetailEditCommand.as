package business.commands
{
	import business.events.InitializeDetailEditEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.DetailEdit;
	
	import model.GenModelLocator;
	
	import mx.core.Application;
	import mx.core.Container;
	import mx.managers.PopUpManager;
	
	public class DetailEditCommand implements ICommand
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
			var detailEdit:DetailEdit;

			detailEdit = DetailEdit(PopUpManager.createPopUp(__addEditContainer, DetailEdit, true));
			detailEdit.vbAddEdit.addChild(__genModel.activeModelLocator.detailEditObj.detailEditContainer);
			//detailEdit.x = detailEdit.x + detailEdit.width / 2
			//detailEdit.y = detailEdit.y + detailEdit.height / 4
			
			detailEdit.x = ((Application.application.width/2)-(__genModel.activeModelLocator.detailEditObj.detailEditContainer.width/2)-15);
			detailEdit.y = ((Application.application.height/2)-(__genModel.activeModelLocator.detailEditObj.detailEditContainer.height/2)-15);
				
				
			detailEdit.title	=	__genModel.activeModelLocator.detailEditObj.title;
			
		}
	}
}	