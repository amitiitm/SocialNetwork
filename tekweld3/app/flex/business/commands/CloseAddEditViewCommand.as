package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import valueObjects.ModeVO;
		
	public class CloseAddEditViewCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			__genModel.activeModelLocator.documentObj.selectedMode	=	ModeVO.LIST_MODE;
			__genModel.activeModelLocator.addEditObj.isCopy	=	false;
			__genModel.activeModelLocator.addEditObj.copiedRecord	=	null;
		}
	}
}
