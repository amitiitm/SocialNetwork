package business.commands
{
	import business.delegates.GetLookupDataDelegate;
	import business.events.GetLookupDataEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.Utility;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class GetLookupDataCommand implements ICommand
	{
		private var lookupName:String;
		private var __viewHandler:IResponder;
		
		public function execute(event:CairngormEvent):void
		{
			var callbacks:Responder = new Responder(lookupDataResultHandler, faultHandler);
			var delegate:GetLookupDataDelegate = new GetLookupDataDelegate(callbacks);

			lookupName = (event as GetLookupDataEvent).lookupName;

			__viewHandler = (event as GetLookupDataEvent).callbacks;

			delegate.getLookupData(lookupName, GenModelLocator.getInstance().user.userID, GenModelLocator.getInstance().user.default_company_id);
		}

		private function lookupDataResultHandler(event:ResultEvent):void
		{
			var resultXML:XML;
			var utilityObj:Utility	=	new Utility();
			resultXML 				= 		utilityObj.getDecodedXML((XML)(event.result));
			
			GenModelLocator.getInstance().lookupObj.setData(lookupName, resultXML);

			if(__viewHandler != null)
			{
				__viewHandler.result(resultXML)
			}
		}

		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			Alert.show('fault'+lookupName + " : " + event.fault.toString());
		}
	}
}

