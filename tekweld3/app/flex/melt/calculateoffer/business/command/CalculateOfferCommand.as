package melt.calculateoffer.business.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import melt.calculateoffer.business.delegate.CalculateOfferDelegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class CalculateOfferCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			var inboxXML:XML = __genModel.activeModelLocator.addEditObj.addEditContainer.inbox.rows;

			if(inboxXML.children().length() > 0)
			{
				CursorManager.setBusyCursor();
				Application.application.enabled	= false;
				var callbacks:Responder = new Responder(calculateOfferResultHandler, faultHandler);
				var delegate:CalculateOfferDelegate = new CalculateOfferDelegate(callbacks);
				
				//Alert.show(inboxXML.toString());
				
				delegate.calculateOffer(inboxXML);
			}
			else
			{
				Alert.show("No row selected...!")
			}
		}

		private function calculateOfferResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
			
			var resultXml:XML;
			var message:String = '';

			resultXml = (XML)(event.result.toString());
			
			//Alert.show(resultXml.toString());
			
			if(resultXml.children().length() > 0)
			{
				message = '';

				for(var i:uint = 0; i < resultXml.children().length(); i++)
				{
					message += resultXml.children()[i] + "\n";
				}

			}
			
			__genModel.activeModelLocator.viewObj.selectedView[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 20 May 2010.
			
				__genModel.activeModelLocator.listObj.rows = resultXml;
				__genModel.activeModelLocator.listObj.filteredList = resultXml;
	
		}

		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(CalculateOfferCommand + " : " + event.fault.toString());
		}
	}
}
