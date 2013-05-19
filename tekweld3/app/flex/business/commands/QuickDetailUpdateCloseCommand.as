package business.commands
{
	import business.events.RowStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenModuleLoader;
	import com.generic.events.GenModuleLoaderEvent;
	
	import model.GenModelLocator;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import valueObjects.AddEditVO;
	
	public class QuickDetailUpdateCloseCommand implements ICommand
	{
		private var __addEditObj:AddEditVO;
		private var __genModel:GenModelLocator;
		
		public function execute(event:CairngormEvent):void
		{
			__genModel = GenModelLocator.getInstance();
			__addEditObj = __genModel.activeModelLocator.addEditObj;
			
			if(__addEditObj.recordStatus	==	'MODIFY')
			{
				Alert.show("Do you want to discard changes ?", "",
           		 	Alert.YES | Alert.NO, __addEditObj.addEditContainer,
            		discardChangeEvent, null, Alert.YES);
			}
			else
			{
				__genModel.lookupObj.isQuickAddActive	=	false;
				PopUpManager.removePopUp(TitleWindow(__addEditObj.addEditContainer.parentDocument));
				__genModel.activeModelLocator.addEditObj.setNull();
			
				(GenModuleLoader)(__genModel.tabMain.selectedChild).dispatchEvent(new GenModuleLoaderEvent("genModuleLoaderActive"))
				
				if(__genModel.lookupObj.isRecordAdded)
				{
					__genModel.lookupObj.isRecordAdded	=	false;
					var rowStatusEvent:RowStatusEvent	=	new RowStatusEvent('MODIFY')
					rowStatusEvent.dispatch()
				}
			}
		}

		private function discardChangeEvent(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				__genModel.lookupObj.isQuickAddActive	=	false;
				PopUpManager.removePopUp(TitleWindow(__addEditObj.addEditContainer.parentDocument));
				__genModel.activeModelLocator.addEditObj.setNull();
				
				(GenModuleLoader)(__genModel.tabMain.selectedChild).dispatchEvent(new GenModuleLoaderEvent("genModuleLoaderActive"))
				
				if(__genModel.lookupObj.isRecordAdded)
				{
					__genModel.lookupObj.isRecordAdded	=	false;
					
					var rowStatusEvent:RowStatusEvent	=	new RowStatusEvent('MODIFY')
					rowStatusEvent.dispatch()
				}
			}
			else
			{
			}
		}
	}
}


