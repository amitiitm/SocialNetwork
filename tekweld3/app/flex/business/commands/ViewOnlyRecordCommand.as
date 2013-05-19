package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.GenObject;
	
	import model.GenModelLocator;
	
	import valueObjects.ModeVO;
		
	public class ViewOnlyRecordCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			 var genObj:GenObject = new GenObject();
			genObj.setRecordViewOnly(__genModel.activeModelLocator.addEditObj.genObjects);
			
			__genModel.activeModelLocator.documentObj.selectedMode	=	ModeVO.VIEW_ONLY_WITH_TREE_MODE
		}
	}
}
