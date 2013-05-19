package business.commands
{
	import business.delegates.SaveRecordDelegate;
	import business.events.RecordStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.AddEditEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.AddEditVO;

	public class SaveRecordDataEntryWithNoListCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditObj:AddEditVO = GenModelLocator.getInstance().activeModelLocator.addEditObj;
		private var genObj:GenObject = new GenObject();
		private var genValidator:GenValidator = new GenValidator();
		private var recordStatusEvent:RecordStatusEvent;

 		public function execute(event:CairngormEvent):void
		{
			if(genValidator.runCustomValidator(__addEditObj.validators) >= 0)
			{
				saveRecord()
			}			
		}

		protected function saveRecord():int
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;

			var responder:Responder = new Responder(saveResultHandler, faultHandler);
			var delegate:SaveRecordDelegate = new SaveRecordDelegate(responder);

			__addEditObj.record = new GenObject().generateRecordXML(__addEditObj.genObjects)

			var tableName:String = __addEditObj.tableName

			
			if(__addEditObj.record[tableName]["id"] == '')
			{
				if(__genModel.activeModelLocator.documentObj.create_permission	==	'Y')
				{
				   //	__addEditObj.record[tableName]["id"] = '0';
					__addEditObj.record[tableName]["created_by"] = __genModel.user.userID;	
				}
				else
				{
					CursorManager.removeBusyCursor();
					Application.application.enabled	=	true;
					Alert.show('You donot have create permission.');
					return	1;
				}
				
			}
			else
			{
				if(__genModel.activeModelLocator.documentObj.modify_permission	==	'Y')
				{
					__addEditObj.record[tableName]["updated_by"] = __genModel.user.userID;
				}
				else
				{
					CursorManager.removeBusyCursor();
					Application.application.enabled	=	true;
					Alert.show('You donot have modify permission.');
					return	1;
				}
				
			}
			


			__addEditObj.record[tableName]["company_id"] = __genModel.user.default_company_id;
			delegate.saveRecords(__addEditObj.record);

			return 0;
		}

		private function saveResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			var _resultXml:XML;

			_resultXml = (XML)(event.result.toString());

			//Alert.show("After Save : " + __addEditObj.record.toXMLString())
		
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
			else
			{
				var obj:GenObject = new GenObject();

				__addEditObj.record = (XML)(event.result);

				var update_flag:String;
				var viewOnly:Boolean;
							
				update_flag = __addEditObj.record.children()[0]["update_flag"].toString()

				if(__genModel.activeModelLocator.hasOwnProperty('noteAttachObj'))
				{
					__genModel.activeModelLocator.noteAttachObj.recordId = int((XML)(event.result).children()[0].id.toString())
				}

				if(update_flag.toLocaleUpperCase() == "V")
				{
					viewOnly = true
				}

				__genModel.activeModelLocator.addEditObj.isRecordViewOnly = viewOnly
				
				recordStatusEvent = new	RecordStatusEvent("SAVE")
				recordStatusEvent.dispatch()
				
				obj.setRecord(__addEditObj.genObjects, __addEditObj.record);
				__addEditObj.addEditContainer.dispatchEvent(new AddEditEvent(AddEditEvent.RETRIEVE_RECORD_END_EVENT,__addEditObj.record)); 
			}
		}

		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			Alert.show(event.fault.toString());
		}
	}
}
