package business.commands
{
	import business.delegates.GetRecordDelegate;
	import business.events.GetRecordEvent;
	import business.events.RecordStatusEvent;
	import business.events.ViewOnlyRecordEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.AddEditEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.Utility;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.ModeVO;

	public class GetRecordCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var recordStatusEvent:RecordStatusEvent;
		private var isOpenViewOnlyMode:Boolean;
		private var viewOnlyRecordEvent:ViewOnlyRecordEvent;//new
		private var __viewHandler:IResponder;
		
		public function execute(event:CairngormEvent):void
		{
			var callbacks:Responder = new Responder(getRecordResultHandler, faultHandler);
			var delegate:GetRecordDelegate = new GetRecordDelegate(callbacks);
			var recordId:int 	= 	(event as GetRecordEvent).recordId;
			isOpenViewOnlyMode	=	(event as GetRecordEvent).isOpenViewOnlyMode;
			__viewHandler 					= 	(event as GetRecordEvent).callbacks;
			var params:XML   =  new XML(<params>
											<id>{recordId}</id>
											<userId>{__genModel.user.userID.toString()}</userId>
											<loginType>{__genModel.user.login_type.toString()}</loginType>		
										</params>)
			
			// VD 20100724 Later we will change below logic,
			if(__genModel.services.getHTTPService("getRecord").url.toString()!= "")
			{
				CursorManager.setBusyCursor();
				Application.application.enabled = false;

				delegate.getRecord(params);	
			}
		}
		
		private function getRecordResultHandler(event:ResultEvent):void
		{
			var resultXML:XML;
			var utilityObj:Utility	=	new Utility();
			resultXML 				= 		utilityObj.getDecodedXML((XML)(event.result));
		
			if(resultXML.children().length() > 0)
			{
				var genObj:GenObject = new GenObject();
				var update_flag:String;
				var viewOnly:Boolean = false;
			
				__genModel.activeModelLocator.addEditObj.record = resultXML;
				
				if(__genModel.activeModelLocator.hasOwnProperty('noteAttachObj'))
				{
					__genModel.activeModelLocator.noteAttachObj.recordId	= int(resultXML.children()[0].id.toString())	
				}
					
				update_flag = __genModel.activeModelLocator.addEditObj.record.children()[0]["update_flag"].toString()

				if(update_flag.toLocaleUpperCase() == "V")
				{
					viewOnly = true;
					/* to remove tree and view only with tree mode 
					genObj.setRecordViewOnly(__genModel.activeModelLocator.addEditObj.genObjects); */
					
				}
				else
				{	
					genObj.setRecordEditable(__genModel.activeModelLocator.addEditObj.genObjects);
				}
				
				__genModel.activeModelLocator.addEditObj.isRecordViewOnly = viewOnly
				
				recordStatusEvent = new	RecordStatusEvent("QUERY") //16 feb 2010 this must be before setRecord and retrieve event
				recordStatusEvent.dispatch()
				
				genObj.setRecord(__genModel.activeModelLocator.addEditObj.genObjects, __genModel.activeModelLocator.addEditObj.record);
				
				__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new AddEditEvent(AddEditEvent.RETRIEVE_RECORD_END_EVENT, __genModel.activeModelLocator.addEditObj.record));
				
				//to remove tree and view only with tree mode---------------------------------------------------
				if(update_flag.toLocaleUpperCase() == "V")
				{
					genObj.setRecordViewOnly(__genModel.activeModelLocator.addEditObj.genObjects);
					
				}
				
				/*16 march 2011 this event is moved from dataentryscript  since we want to call this event after calling RETRIEVE_RECORD_END_EVENT*/
				if(isOpenViewOnlyMode)//it will true when user double click on list
				{
					__genModel.activeModelLocator.documentObj.selectedMode	=	ModeVO.EDIT_MODE;//since we have reomved viewonly eith tree mode
					
					/* since we have reomved viewonly eith tree mode
					 viewOnlyRecordEvent	=	new ViewOnlyRecordEvent();
					viewOnlyRecordEvent.dispatch(); */
				}
				
			}
			else
			{
				Alert.show('This record has been modified please query again');
				
				recordStatusEvent = new RecordStatusEvent("NEW");
				recordStatusEvent.dispatch();	

				new GenObject().resetObjects(__genModel.activeModelLocator.addEditObj.genObjects);

				__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new AddEditEvent(AddEditEvent.RESET_OBJECT_EVENT));
				
			}
			if(__viewHandler!=null)
			{
				__viewHandler.result(XML(event.result));
			}
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
		}
		
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			
			Alert.show(event.fault.toString());	
		}
	}
}
