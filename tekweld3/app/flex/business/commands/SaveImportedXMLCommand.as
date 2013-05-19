package business.commands
{
	import business.delegates.SaveImportedXMLDelegate;
	import business.events.RowStatusEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.events.DetailAddEditEvent;
	import com.generic.genclass.GenObject;
	
	import model.GenModelLocator;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.Container;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.DetailEditVO;
	
	public class SaveImportedXMLCommand implements ICommand
	{
		private var __detailEditObj:DetailEditVO;
		private var rowStatusEvent:RowStatusEvent;
		private var __genModel:GenModelLocator ;
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;
			
			__genModel	=	GenModelLocator.getInstance();
			__detailEditObj = __genModel.activeModelLocator.detailEditObj;				
			
			
			
			var responder:Responder 				= new Responder(saveResultHandler, faultHandler);
						
			
			__detailEditObj.saveImportedXML = new GenObject().generateRecordXML(__detailEditObj.genObjects)

			var tableName:String = __detailEditObj.tableName

			__detailEditObj.saveImportedXML[tableName]["company_id"]		=	 __genModel.user.default_company_id;
			__detailEditObj.saveImportedXML[tableName]["created_by"] 		=	 __genModel.user.userID;
			__detailEditObj.saveImportedXML[tableName]["updated_by"] 		=	 __genModel.user.userID;
			__detailEditObj.saveImportedXML[tableName]["lock_version"]	 	=	0;
			 	 
			if(__detailEditObj.saveImportedXML[tableName]["id"] == '')
			{
				__detailEditObj.saveImportedXML[tableName]["id"] = '';
			}
			
			// we have to add general info in all table rows;
			if(__detailEditObj.tablenames	!=	null)
			{
				var tempXMLList:XMLList	
				for(var i:int = 0 ; i < __detailEditObj.tablenames.length	;	i++)
				{
					tempXMLList	=	new XMLList(<row/>)
					tableName	=	__detailEditObj.tablenames[i].tablename;
					tempXMLList	=	__detailEditObj.saveImportedXML.descendants(tableName);
					if(tempXMLList.children().length()	>	0)
					{
						for(var j:int = 0 ; j < tempXMLList.length() ; j++)
						{
							tempXMLList[j]["id"]				=	''
							tempXMLList[j]["company_id"]		=	__genModel.user.default_company_id;
							tempXMLList[j]["created_by"]		=	__genModel.user.userID;
							tempXMLList[j]["updated_by"]		=	__genModel.user.userID;
							tempXMLList[j]["lock_version"]		=	0;
						}
					}
				}
			}
			
			if(__detailEditObj.isCallServiceOnSave)
			{
				var delegate:SaveImportedXMLDelegate 	= new SaveImportedXMLDelegate(responder);
				delegate.saveImportedXML(__detailEditObj.saveImportedXML);	
			}
			else
			{
				returnToWindow();
			}
			
		}
		private function returnToWindow():void
		{
			var _resultXml:XML	=	__detailEditObj.saveImportedXML;
			//notification to the detail level addedit component
			var detailAddEditContainer:Container = __genModel.activeModelLocator.detailEditObj.detailEditContainer
			detailAddEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.RETRIEVE_ROW_END_EVENT,_resultXml));

			rowStatusEvent = new	RowStatusEvent("SAVE")
			rowStatusEvent.dispatch();							
			
			__genModel.activeModelLocator.detailEditObj.isActive	=	false;
			PopUpManager.removePopUp(TitleWindow(__detailEditObj.detailEditContainer.parentDocument));
			__detailEditObj.setNull();
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
		}
		private function saveResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			var _resultXml:XML;

			_resultXml = (XML)(event.result.toString());
			
			if(_resultXml.name() == "errors")
			{
				if(_resultXml.children().length() > 0) 
				{
					var message:String = '';
			
					for(var i:uint = 0; i < _resultXml.children().length(); i++) 
					{
						message += _resultXml.children()[i] + "\n";
					}
					Alert.show(message);
				} 
			}
			else
			{
				__detailEditObj.saveImportedXML	=	(XML)(event.result);
				
				//notification to the detail level addedit component
				var detailAddEditContainer:Container = __genModel.activeModelLocator.detailEditObj.detailEditContainer
				detailAddEditContainer.dispatchEvent(new DetailAddEditEvent(DetailAddEditEvent.RETRIEVE_ROW_END_EVENT,_resultXml));

				//notification to the dataentry level addedit component. now we are notifying from import detail
				//Detail(__detailEditObj.genDataGrid.parentDocument).dispatchEvent(new DetailEvent(DetailEvent.DETAIL_SAVE_IMPORTED_XML_COMPLETE,null,null,null));
				
								
				rowStatusEvent = new	RowStatusEvent("SAVE")
				rowStatusEvent.dispatch();							
				
				__genModel.activeModelLocator.detailEditObj.isActive	=	false;
				PopUpManager.removePopUp(TitleWindow(__detailEditObj.detailEditContainer.parentDocument));
				__detailEditObj.setNull();

			}
		}
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			Alert.show(event.fault.toString());
		}		
	}
}
