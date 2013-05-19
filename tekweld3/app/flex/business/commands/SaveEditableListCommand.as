package business.commands
{
	import business.delegates.SaveEditableListDelegate;
	import business.events.PopulateListEvent;
	import business.events.RecordStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class SaveEditableListCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			var inboxXML:XML = __genModel.activeModelLocator.addEditObj.addEditContainer.inbox.selectedRows;

			if(inboxXML.children().length() > 0)
			{
				if(__genModel.activeModelLocator.documentObj.modify_permission	==	'Y')
				{
					CursorManager.setBusyCursor();
					Application.application.enabled	= false;
					var callbacks:Responder = new Responder(saveEditableListResultHandler, faultHandler);
					var delegate:SaveEditableListDelegate = new SaveEditableListDelegate(callbacks);
					delegate.save(inboxXML);
					
				}
				else
				{
					Alert.show('You donot have modify permission.');
					return;
				}
				
			}
			else
			{
				Alert.show("No row selected...!")
			}
		}

		private function saveEditableListResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
			
			var resultXml:XML;
			var message:String = '';

			resultXml = (XML)(event.result.toString());
			//Alert.show(resultXml.toXMLString());
			if(resultXml.name() == "errors")
			{
				if(resultXml.children().length() > 0) 
				{
					var message:String = '';
					
					for(var i:uint = 0; i < resultXml.children().length(); i++) 
					{
						message += resultXml.children()[i] + "\n";
					}
					Alert.show(message);
				} 
			}
			else
			{
				if(resultXml.children().length() > 0)
				{
					message = '';
					
					for(var i:uint = 0; i < resultXml.children().length(); i++)
					{
						message += resultXml.children()[i] + "\n";
					}
					
					//Alert.show(message);
				}
				
				__genModel.activeModelLocator.viewObj.selectedView[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 20 May 2010.
				
				var populateListEvent:PopulateListEvent = new PopulateListEvent(__genModel.activeModelLocator.viewObj.selectedView);
				populateListEvent.dispatch();
				
				var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("SAVE")
				recordStatusEvent.dispatch()
			}
			
			
		}

		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(SaveEditableListCommand + " : " + event.fault.toString());
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
		}
	}
}
