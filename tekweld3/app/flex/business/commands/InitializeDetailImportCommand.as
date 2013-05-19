package business.commands
{
	import business.events.InsertRowEvent;
	import business.events.RowStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.DetailAddEditEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	
	import model.GenModelLocator;
	
	import mx.core.Container;
	
	import valueObjects.DetailEditVO;
	
	public class InitializeDetailImportCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __detailEditObj:DetailEditVO;
		private var rowStatusEvent:RowStatusEvent;
		
		public function execute(event:CairngormEvent):void
		{
			var genObj:GenObject = new GenObject();
			var genValidator:GenValidator = new GenValidator();
			var insertRowEvent:InsertRowEvent;

			__detailEditObj = __genModel.activeModelLocator.detailEditObj;
			__detailEditObj.genObjects = genObj.getGenObjects(__detailEditObj.detailEditContainer);
			__detailEditObj.validators = genValidator.applyValidation(__detailEditObj.genObjects)
			__detailEditObj.tableName = __detailEditObj.genObjects[0].tableName
			
			__detailEditObj.isActive = true
			
		}
	}
}

