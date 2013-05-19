package business.commands
{
	import business.events.CancelImportEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import valueObjects.ModeVO;
	
	public class ImportRecordsCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
				__genModel.activeModelLocator.documentObj.selectedMode	=	ModeVO.IMPORT_MODE;
		}
	}
	
}


