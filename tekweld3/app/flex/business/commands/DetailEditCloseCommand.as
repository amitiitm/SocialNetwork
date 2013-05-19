package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import model.GenModelLocator;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import valueObjects.DetailEditVO;
	
	public class DetailEditCloseCommand implements ICommand
	{
		private var __detailEditObj:DetailEditVO;
		private var __genModel:GenModelLocator;
		
		public function execute(event:CairngormEvent):void
		{
			__genModel = GenModelLocator.getInstance();
			__detailEditObj = __genModel.activeModelLocator.detailEditObj;
			
			if(__detailEditObj.rowStatus	==	'MODIFY')
			{
				Alert.show("Do you want to discard changes ?", "",
           		 	Alert.YES | Alert.NO, __detailEditObj.detailEditContainer,
            		discardChangeEvent, null, Alert.YES);
			}
			else
			{
				__genModel.activeModelLocator.detailEditObj.isActive	=	false;
				PopUpManager.removePopUp(TitleWindow(__detailEditObj.detailEditContainer.parentDocument));
				__genModel.activeModelLocator.detailEditObj.setNull();
			}
		
		}
		private function discardChangeEvent(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				__genModel.activeModelLocator.detailEditObj.isActive	=	false;
				PopUpManager.removePopUp(TitleWindow(__detailEditObj.detailEditContainer.parentDocument));
				__genModel.activeModelLocator.detailEditObj.setNull();
			}
			else
			{
				
			}
		}
		
	}
}
