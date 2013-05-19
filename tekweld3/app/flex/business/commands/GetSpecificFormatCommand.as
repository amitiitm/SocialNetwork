package business.commands
{
	import business.delegates.GetSpecificDataDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class GetSpecificFormatCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var callbacksFormat:Responder 	=	new Responder(getSpecificFormatResultHandler, faultHandler);
			
			var specificFormatDelegate:GetSpecificDataDelegate = new  GetSpecificDataDelegate(callbacksFormat)
			specificFormatDelegate.getFormat(__genModel.activeModelLocator.documentObj.documentID.toString());
		}
		private function getSpecificFormatResultHandler(event:ResultEvent):void
		{
			__genModel.activeModelLocator.documentObj.printFormatXML = (XML)(event.result);
			
		}
		private function faultHandler(event:FaultEvent):void
	   {
	   		Alert.show('GetSpecificFormatCommand ' + event.fault.toString());
	   }

	}
}	