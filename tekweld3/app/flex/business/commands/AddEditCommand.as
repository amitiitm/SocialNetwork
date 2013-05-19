package business.commands
{
	import business.events.GetRecordEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import valueObjects.ModeVO;
	
	public class AddEditCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			/*since we have removed tree and view only with tree mode 
			var genObj:GenObject = new GenObject(); //new
				
			if(__genModel.activeModelLocator.listObj.selectedRow != null) //new
			{
				if(__genModel.activeModelLocator.addEditObj.record.children()[0]["update_flag"].toString() == 'V')//new
				{ 
					
					genObj.setRecordViewOnly(__genModel.activeModelLocator.addEditObj.genObjects);
				}
				else //new
				{
					genObj.setRecordEditable(__genModel.activeModelLocator.addEditObj.genObjects);
					
					//new 16 march 2011.
					__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new AddEditEvent(AddEditEvent.RETRIEVE_RECORD_END_EVENT, __genModel.activeModelLocator.addEditObj.record));
				}
				__genModel.activeModelLocator.documentObj.selectedMode	=	ModeVO.EDIT_MODE
			} */
			
			/*since we have removed tree and view only with tree mode */
			if(__genModel.activeModelLocator.listObj.selectedRow != null) 
			{
					var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__genModel.activeModelLocator.listObj.selectedRow.id.toString()),null,false);
					getRecordEvent.dispatch();	
				__genModel.activeModelLocator.documentObj.selectedMode	=	ModeVO.EDIT_MODE	
			}
			
		}
	}
}
