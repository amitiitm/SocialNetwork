package business.commands
{
	import business.events.RowStatusEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import model.GenModelLocator;
	import mx.controls.Alert;

	public class RowStatusCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var status:String;
		
		public function execute(event:CairngormEvent):void
		{
			status = (event as RowStatusEvent).status;

			__genModel.activeModelLocator.detailEditObj.rowStatus = status;
				
				if(status == "MODIFY")
				{
					__genModel.activeModelLocator.detailEditObj.editStatus = true;
				}
				else
				{
					__genModel.activeModelLocator.detailEditObj.editStatus = false;
				}
		}
	}
}
