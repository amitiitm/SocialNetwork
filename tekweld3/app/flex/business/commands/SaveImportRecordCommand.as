package business.commands
{
	import business.delegates.SaveRecordDelegate;
	import business.events.RecordStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.ImportEvent;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.ImportVO;
	
	public class SaveImportRecordCommand implements ICommand
	{
		private var __genModel:GenModelLocator 	 =  GenModelLocator.getInstance();
		private var __importObj:ImportVO;
		
		private var recordStatusEvent:RecordStatusEvent		
 				
 		public function execute(event:CairngormEvent):void
		{
			saveRecord();
		}
	
		private function saveRecord():int
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;
			
			__importObj				=	__genModel.activeModelLocator.importObj;
			var responder:Responder = new Responder(saveResultHandler, faultHandler);
			var delegate:SaveRecordDelegate = new SaveRecordDelegate(responder);
			
			if(__importObj.records != null && __importObj.records.children().length() > 0)
			{
				// we have to add general info in all table rows;
				if(__importObj.tablenames	!=	null)
				{
					var tempXMLList:XMLList	;
					var tableName:String;
					
					for(var i:int = 0 ; i < __importObj.tablenames.length	;	i++)
					{
						tempXMLList	=	new XMLList(<row/>)
						tableName	=	__importObj.tablenames[i].tablename;
						tempXMLList	=	__importObj.records.descendants(tableName);
						if(tempXMLList.children().length()	>	0)
						{
							for(var j:int = 0 ; j < tempXMLList.length() ; j++)
							{
								tempXMLList[j]["id"]				=	''//'0'
								tempXMLList[j]["company_id"]		=	__genModel.user.default_company_id;
								tempXMLList[j]["created_by"]		=	__genModel.user.userID;
								tempXMLList[j]["updated_by"]		=	__genModel.user.userID;
								tempXMLList[j]["lock_version"]		=	0;
							}
						}
					}
				}

				
				delegate.saveRecords(__importObj.records);	
			}
			else
			{
				Alert.show('please code for generating save xml in your import component script use __importObj.records');
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
			}
			return 0;
		}

		private function saveResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			__importObj.records = null
			
			var _resultXml:XML;

			_resultXml = (XML)(event.result.toString());
			
		
			if(_resultXml.name() == "errors")
			{
				if(_resultXml.children().length() > 0) 
				{
					var message:String = '';
			
					for(var i:uint = 0; i < _resultXml.children().length(); i++) 
					{
						message += _resultXml.children()[i] + "\n";
					}
					Alert.show(message);
				} 
			}
			else if(_resultXml.name() == "errors_log")
			{
				var url:String = _resultXml.child("log_filename").toString()
				var request:URLRequest = new URLRequest(url);

				navigateToURL(request);
				
			}
			else if(_resultXml.name() == "success_log")
			{
				recordStatusEvent = new	RecordStatusEvent("SAVE") //16 feb 2010 this must be before setRecord and retrieve event
				recordStatusEvent.dispatch()
				
				var url:String = _resultXml.child("log_filename").toString()
				var request:URLRequest = new URLRequest(url);

				navigateToURL(request);
				
			}

			else
			{				
				recordStatusEvent = new	RecordStatusEvent("SAVE") //16 feb 2010 this must be before setRecord and retrieve event
				recordStatusEvent.dispatch()

				__importObj.container.dispatchEvent(new ImportEvent(ImportEvent.RETRIEVE_RECORD_END_EVENT,_resultXml)); 

			}
		}

		private function faultHandler(event:FaultEvent):void
		{
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			__importObj.records = null
			Alert.show(event.fault.toString());
		}
	}
}


