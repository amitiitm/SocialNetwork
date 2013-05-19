package business.commands
{
	import business.events.RecordStatusEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.GenComponentEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	import model.GenModelLocator;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import valueObjects.AddEditVO;
	
	public class QuickDetailUpdateSaveRecordCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditObj:AddEditVO= GenModelLocator.getInstance().activeModelLocator.addEditObj;
		private var genObj:GenObject = new GenObject();
		private var genValidator:GenValidator = new GenValidator();
		private var recordStatusEvent:RecordStatusEvent;		
 				
 		public function execute(event:CairngormEvent):void
		{
			if(genValidator.runCustomValidator(__addEditObj.validators) >= 0)
			{
				if(saveRecord() >= 0)
				{
					postSaveRecord()
				}
			}
		}
	
		protected function postSaveRecord():void {}
		
		protected function saveRecord():int
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;

			__addEditObj.record = new GenObject().generateRecordXML(__addEditObj.genObjects)

			var tableName:String = __addEditObj.tableName

			__addEditObj.record[tableName]["company_id"] = __genModel.user.default_company_id;
			__addEditObj.record[tableName]["created_by"] = __genModel.user.userID;
			__addEditObj.record[tableName]["updated_by"] = __genModel.user.userID;
			__addEditObj.record[tableName]["updated_by_code"] = __genModel.user.user_cd.toString()

			if(__addEditObj.record[tableName]["id"] == '')
			{
			  //	__addEditObj.record[tableName]["id"] = '0';
			}
			
			__genModel.lookupObj.isRecordAdded		=	true;
			
			__genModel.detailUpdateObj.gencomponent.dispatchEvent(new GenComponentEvent(GenComponentEvent.VALUE_UPDATE_EVENT, __addEditObj.record))

			recordStatusEvent = new	RecordStatusEvent("SAVE") //16 feb 2010 this must be before setRecord and retrieve event
			recordStatusEvent.dispatch()
	
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;

			return 0;
		}
	}
}

