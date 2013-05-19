package business.commands
{
	import business.events.GetGenDataGridFormatEvent;
	import business.events.GetGenListDataEvent;
	import business.events.GetRecordEvent;
	import business.events.InitializeDataEntryWithNoListEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	import flash.utils.getQualifiedClassName;
	import model.GenModelLocator;
	import mx.rpc.IResponder;
	import valueObjects.AddEditVO;
	
	public class InitializeDataEntryWithNoListCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditObj:AddEditVO;
		private var callbacks:IResponder;
		private var getRecordEvent:GetRecordEvent;
		
		public function execute(event:CairngormEvent):void
		{
			var genObj:GenObject = new GenObject();
			var genValidator:GenValidator = new GenValidator();
			var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
			var getGenListDataEvent:GetGenListDataEvent;
			
			__addEditObj = __genModel.activeModelLocator.addEditObj;
			__addEditObj.genObjects = genObj.getGenObjects(__addEditObj.addEditContainer);
			__addEditObj.validators = genValidator.applyValidation(__addEditObj.genObjects)

			genObj.resetObjects(__addEditObj.genObjects);

			callbacks = (event as InitializeDataEntryWithNoListEvent).callbacks;

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

			__addEditObj.tableName = __addEditObj.genObjects[0].tableName
			
			getRecordEvent = new GetRecordEvent(0);
			getRecordEvent.dispatch();	
		}
	}
}