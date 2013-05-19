package business.commands
{
	
	import business.events.CancelImportEvent;
	import business.events.GetGenDataGridFormatEvent;
	import business.events.GetGenListDataEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	
	import flash.utils.getQualifiedClassName;
	
	import model.GenModelLocator;
	
	import valueObjects.ImportVO;
	
	public class InitializeImportCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var genObj:GenObject = new GenObject();
			var genValidator:GenValidator = new GenValidator();
			var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
			var getGenListDataEvent:GetGenListDataEvent;
			var cancelImportEvent:CancelImportEvent;
			
			var __importObj:ImportVO	=	__genModel.activeModelLocator.importObj;
			
			 __importObj.genObjects = genObj.getGenObjects(__importObj.container);
			__importObj.validators 	= genValidator.applyValidation(__importObj.genObjects) 

			for(var i:int = 0; i < __importObj.genObjects.length; i++)
			{
				if( getQualifiedClassName(__importObj.genObjects[i]) == "com.generic.customcomponents::GenDataGrid"
					||	getQualifiedClassName(__importObj.genObjects[i]) == "com.generic.components::Detail"
					|| 	getQualifiedClassName(__importObj.genObjects[i]) == "com.generic.components::EditableDetail"
					|| 	getQualifiedClassName(__importObj.genObjects[i]) == "com.generic.components::NewDetail"
				  )
				{
					getGenDataGridFormatEvent = new GetGenDataGridFormatEvent(__importObj.genObjects[i]);
					getGenDataGridFormatEvent.dispatch();
				}
				else if(getQualifiedClassName(__importObj.genObjects[i]) == "com.generic.customcomponents::GenList")
				{
					getGenListDataEvent = new GetGenListDataEvent(__importObj.genObjects[i]);
					getGenListDataEvent.dispatch();
				}
			}
			//to reset
			cancelImportEvent	=	new CancelImportEvent();
			cancelImportEvent.dispatch();
			
			
		}
	}
}


