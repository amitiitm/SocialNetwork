package business.commands
{
	import business.events.GetGenDataGridFormatEvent;
	import business.events.GetGenListDataEvent;
	import business.events.InitializeQuickDetailUpdateEvent;
	import business.events.RecordStatusEvent;
	import business.events.ViewOnlyRecordEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.AddEditEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	
	import flash.utils.getQualifiedClassName;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	
	import valueObjects.AddEditVO;
	
	public class InitializeQuickDetailUpdateCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditObj:AddEditVO;
		private var callbacks:IResponder;
		private var recordStatusEvent:RecordStatusEvent;
		private var isOpenViewOnlyMode:Boolean;
		private var viewOnlyRecordEvent:ViewOnlyRecordEvent;
		
		private var value:XML;
		
		public function execute(event:CairngormEvent):void
		{
			var genObj:GenObject = new GenObject();
			var genValidator:GenValidator = new GenValidator();
					
			var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
			var getGenListDataEvent:GetGenListDataEvent;
		
			value = __genModel.detailUpdateObj.value;
	
			callbacks = (event as InitializeQuickDetailUpdateEvent).callbacks;
			
			//this  __addEditObj  belongs to the master screen which is now opened to add new items
			__addEditObj 				=	__genModel.activeModelLocator.addEditObj;
			__addEditObj.genObjects	 	= 	genObj.getGenObjects(__addEditObj.addEditContainer);
			__addEditObj.validators 	= 	genValidator.applyValidation(__addEditObj.genObjects)
			__addEditObj.tableName 		= 	__addEditObj.genObjects[0].tableName
			
			for(var i:int = 0; i < __addEditObj.genObjects.length; i++)
			{
				if( getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.customcomponents::GenDataGrid"
					||	getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.components::Detail"
					|| 	getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.components::EditableDetail"
					|| 	getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.components::NewDetail"
				)
				{
					getGenDataGridFormatEvent = new GetGenDataGridFormatEvent(__addEditObj.genObjects[i]);
					getGenDataGridFormatEvent.dispatch();
				}
				else if(getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.customcomponents::GenList")
				{
					getGenListDataEvent = new GetGenListDataEvent(__addEditObj.genObjects[i]);
					getGenListDataEvent.dispatch();
				}
			}
			
			//	var addEvent:AddEvent = new AddEvent();
			//	addEvent.dispatch();
			setValue();
		}
		
		private function setValue():void
		{
			if(value.children().length() > 0)
			{
				var genObj:GenObject = new GenObject();
				var update_flag:String;
				var viewOnly:Boolean = false;
			
				__genModel.activeModelLocator.addEditObj.record = value;
				
				if(__genModel.activeModelLocator.hasOwnProperty('noteAttachObj'))
				{
					__genModel.activeModelLocator.noteAttachObj.recordId	= int(value.children()[0].id.toString())	
				}
					
				update_flag = __genModel.activeModelLocator.addEditObj.record.children()[0]["update_flag"].toString()

				if(update_flag.toLocaleUpperCase() == "V")
				{
					viewOnly = true;
					genObj.setRecordViewOnly(__genModel.activeModelLocator.addEditObj.genObjects);
					
				}
				else
				{
					genObj.setRecordEditable(__genModel.activeModelLocator.addEditObj.genObjects);
				}
				
				// VD 04 Oct 2011
				//__genModel.activeModelLocator.addEditObj.isRecordViewOnly = viewOnly
				
				recordStatusEvent = new	RecordStatusEvent("QUERY") 
				recordStatusEvent.dispatch()
				
				genObj.setRecord(__genModel.activeModelLocator.addEditObj.genObjects, __genModel.activeModelLocator.addEditObj.record);
				
				__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new AddEditEvent(AddEditEvent.RETRIEVE_RECORD_END_EVENT, __genModel.activeModelLocator.addEditObj.record));

				/*16 march 2011 this event is moved from dataentryscript  since we want to call this event after calling RETRIEVE_RECORD_END_EVENT*/
				if(isOpenViewOnlyMode)
				{
					viewOnlyRecordEvent	=	new ViewOnlyRecordEvent();
					viewOnlyRecordEvent.dispatch();
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
		}
	}
}
