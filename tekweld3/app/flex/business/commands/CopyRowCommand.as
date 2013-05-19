package business.commands
{
	import business.events.RecordStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class CopyRowCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		private var recordStatusEvent:RecordStatusEvent;		
		
		public function execute(event:CairngormEvent):void
		{
			__genModel.activeModelLocator.detailEditObj.isCopy		=	true;
			__genModel.activeModelLocator.detailEditObj.copiedRow	=	XML(__genModel.activeModelLocator.detailEditObj.selectedRow).copy()
			var tempXMLList:XMLList		=	XML(__genModel.activeModelLocator.detailEditObj.copiedRow)..id
			
			for(var i:int= 0 ; i< tempXMLList.length() ; i++)
			{
				tempXMLList[i]	=	'';
			}
		}
	}
}

