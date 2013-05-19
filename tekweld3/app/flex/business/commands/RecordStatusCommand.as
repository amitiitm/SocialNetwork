package business.commands
{
	import business.events.RecordStatusEvent;
	import business.events.RowStatusEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import model.GenModelLocator;

	public class RecordStatusCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var status:String;
		private var rowStatusEvent:RowStatusEvent;
		public function execute(event:CairngormEvent):void
		{
			status = (event as RecordStatusEvent).status;

			//Jitu 132010 for handling row status on component value change
			if(__genModel.activeModelLocator.hasOwnProperty('detailEditObj'))
			{
				if(__genModel.activeModelLocator.detailEditObj.isActive == true)
				{
					if(status	==	'MODIFY')
					{
						changeRecordStatus();
					}
					rowStatusEvent = new RowStatusEvent(status);
					rowStatusEvent.dispatch();	
				}
				else
				{ 
					changeRecordStatus();
				}  
			}
			else
			{  
				changeRecordStatus();
			}  
		}
		private function changeRecordStatus():void
		{
			__genModel.activeModelLocator.addEditObj.recordStatus = status;
			
			if(status == "MODIFY")
			{
				__genModel.activeModelLocator.addEditObj.editStatus = true;
			}
			else
			{
				__genModel.activeModelLocator.addEditObj.editStatus = false;
			}
		}
	}
}
