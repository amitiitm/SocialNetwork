package business.commands
{
	import business.events.DetailEditCloseEvent;
	import business.events.RowStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.Detail;
	import com.generic.events.DetailEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	import valueObjects.DetailEditVO;
	
	public class SaveRowCommand implements ICommand
	{
		private var __detailEditObj:DetailEditVO;
		private var rowStatusEvent:RowStatusEvent;
		private var __genModel:GenModelLocator ;
		
		public function execute(event:CairngormEvent):void
		{
			var genObj:GenObject =	new GenObject();
			var genValidator:GenValidator = new GenValidator();
		
			__genModel	=	GenModelLocator.getInstance();
			__detailEditObj = __genModel.activeModelLocator.detailEditObj;
						
			if(genValidator.runCustomValidator(__detailEditObj.validators) >= 0)
			{
				
			 	 var tempXml:XML = genObj.generateRecordXML(__detailEditObj.genObjects);
				 var tempRow:XML	= XML(tempXml.children()[0])
			
				tempRow.company_id		 = __genModel.user.default_company_id;
			
				if(tempRow[0]["id"] == '')
				{
					tempRow.created_by		 = __genModel.user.userID;
				}
				else
				{
					tempRow.updated_by	 	 = __genModel.user.userID;
				}
				
				tempRow.updated_by_code = __genModel.user.user_cd.toString();
			
				var __rows:XML = new XML(__genModel.activeModelLocator.detailEditObj.genDataGrid.rows)

				
				if(__detailEditObj.selectedRow != null)
				{
					__detailEditObj.selectedRow.setChildren(tempRow.children());
				} 
				else
				{
					tempRow[0]["serial_no"] = getNextSerial_no()
					__genModel.activeModelLocator.detailEditObj.detailEditContainer.tiSerial_no.text = tempRow[0]["serial_no"] 
					
					__rows.appendChild(tempRow);

					__genModel.activeModelLocator.detailEditObj.genDataGrid.rows = __rows;
					__genModel.activeModelLocator.detailEditObj.genDataGrid.selectedIndex = (__genModel.activeModelLocator.detailEditObj.genDataGrid.rows.children().length() - 1);
					__genModel.activeModelLocator.detailEditObj.selectedRow = XML(__genModel.activeModelLocator.detailEditObj.genDataGrid.rows.children()[__genModel.activeModelLocator.detailEditObj.genDataGrid.selectedIndex]) 
				}
				
				Detail(__detailEditObj.genDataGrid.parentDocument)
				Detail(__detailEditObj.genDataGrid.parentDocument).dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE,null,null,null));
				rowStatusEvent = new	RowStatusEvent("SAVE")
				rowStatusEvent.dispatch()
					
				var detailEditCloseEvent:DetailEditCloseEvent	=	new DetailEditCloseEvent();
				detailEditCloseEvent.dispatch();	
			}
		}
		
		private function getNextSerial_no():String
		{
			var serial_no:int;
			var maxSerial_no:int;
			var rows:XML = __genModel.activeModelLocator.detailEditObj.genDataGrid.rows;

			if(rows.children().length() > 0)
			{
				for(var i:int=0; i < rows.children().length(); i++)
				{	
					maxSerial_no = parseInt(rows.children()[i]["serial_no"], 0)
	
					if(i == (rows.children().length() - 1))
					{
						serial_no = maxSerial_no
					}
	
					if(serial_no < maxSerial_no)
					{
						serial_no = maxSerial_no
					}
				}
			}
			
			if(serial_no.toString() == '' || serial_no.toString() == null || serial_no.toString() == "0")
			{
				serial_no = 100;
			}

			serial_no = serial_no + 1;

			return serial_no.toString();
		}
	}
}
