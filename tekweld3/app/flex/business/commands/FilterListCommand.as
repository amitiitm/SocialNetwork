package business.commands
{
	import business.events.FilterListEvent;
	import business.events.GetRecordEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import valueObjects.ListVO;
	
	public class FilterListCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __listObj:ListVO;
		private var getRecordEvent:GetRecordEvent;

		public function execute(event:CairngormEvent):void
		{
			__listObj = __genModel.activeModelLocator.listObj;

			var ary:Array = (event as FilterListEvent).ary

			if(ary.length > 0)
			{
				generateFilterXML(ary);
			}
			else
			{
				__listObj.filteredList = new XML(XML(__listObj.rows).copy())
			}
			
			// Vivek Dubey 10 Feb 2010
			if(__listObj.filteredList.length() > 0)
			{
				__listObj.selectedRow = __listObj.filteredList.children()[0]
				__listObj.listGrid.selectedIndex = 0
				__listObj.listGrid.scrollToIndex(0);
				
				if(__genModel.activeModelLocator.hasOwnProperty('noteAttachObj'))
				{
					__genModel.activeModelLocator.noteAttachObj.recordId	=	int(__listObj.filteredList.children()[0].id.toString())	
				}
				
						
				if(__listObj.selectedRow != null)
				{
					getRecordEvent = new GetRecordEvent(int(__listObj.selectedRow.id.toString()));
					getRecordEvent.dispatch();
				}
			}
			else
			{
				// new ,since on after filtering list nothing is get selected
				if(__genModel.activeModelLocator.hasOwnProperty('noteAttachObj'))
				{
					__genModel.activeModelLocator.noteAttachObj.recordId		=	0;
				}
				
				__listObj.selectedRow = null
				__listObj.listGrid.selectedIndex = -1
			}
			// End Vivek
		}
		
		private function generateFilterXML(ary:Array):void
		{
			var filteredXML:XML = new XML("<" + __listObj.rows.localName().toString() + "/>");
			var filteredXMLList:XMLList = new XMLList(XMLList(__listObj.rows.children()).copy());
		
			for(var i:int=0; i<ary.length; i++)
			{
				filteredXMLList = filteredXMLList.(elements(ary[i].name) == ary[i].value)
			}
		
			filteredXML.appendChild(filteredXMLList)
			
			__listObj.filteredList = filteredXML;
		}	
	}
}
