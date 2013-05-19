package business.commands
{
	import business.events.AddEvent;
	import business.events.GetGenDataGridFormatEvent;
	import business.events.GetGenListDataEvent;
	import business.events.GetRecordEvent;
	import business.events.InitializeQuickDataEntryEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	
	import flash.utils.getQualifiedClassName;
	
	import model.GenModelLocator;
	
	import mx.rpc.IResponder;
	
	import valueObjects.AddEditVO;
	
	public class InitializeQuickDataEntryCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditObj:AddEditVO;
		private var getRecordEvent:GetRecordEvent;
		private var callbacks:IResponder;
		private var selectedRow:XML = null;
		
		public function execute(event:CairngormEvent):void
		{
			var genObj:GenObject = new GenObject();
			var genValidator:GenValidator = new GenValidator();
					
			var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
			var getGenListDataEvent:GetGenListDataEvent;
			
			if(__genModel.activeModelLocator.listObj.selectedRow != null) //means need to edit row
			{
				selectedRow	=	XML(__genModel.activeModelLocator.listObj.selectedRow).copy();
			}
			callbacks = (event as InitializeQuickDataEntryEvent).callbacks;
			
			//this  __addEditObj  belongs to the master screen which is now opened to add new items
			__addEditObj 									=		 __genModel.activeModelLocator.addEditObj;
			__addEditObj.genObjects	 						= 		genObj.getGenObjects(__addEditObj.addEditContainer);
			__addEditObj.validators 						= 		genValidator.applyValidation(__addEditObj.genObjects)
			__addEditObj.tableName 							= 		__addEditObj.genObjects[0].tableName
			
			
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
			
			var addEvent:AddEvent	=			new AddEvent();
			addEvent.dispatch();
			
			if(selectedRow != null) //means need to edit row
			{
				 getRecordEvent = new GetRecordEvent(int(selectedRow.id.toString()),null,false);
				 getRecordEvent.dispatch(); 
			}
		}
	}
}

