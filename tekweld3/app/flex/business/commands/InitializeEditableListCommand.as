package business.commands
{
	import business.delegates.InitializeEditableListDelegate;
	import business.events.InitializeEditableListEvent;
	import business.events.InitializeViewEvent;
	import business.events.PopulateListEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.SortLevel;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.ModeVO;
	import valueObjects.NoteAttachmentVO;
	import valueObjects.ViewVO;
	
	public class InitializeEditableListCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __viewObj:ViewVO;
		private var callbacks:IResponder;
		private var __noteAttachObj:NoteAttachmentVO;
		private var initializeViewEvent:InitializeViewEvent
		
		public function execute(event:CairngormEvent):void
		{
			__viewObj = __genModel.activeModelLocator.viewObj;
			
			callbacks = (event as InitializeEditableListEvent).callbacks;
			
			var callbacksListFormat:Responder = new Responder(listFormatResultHandler, faultHandler);
			var delegate:InitializeEditableListDelegate = new InitializeEditableListDelegate(callbacksListFormat);
			delegate.getListFormat();
			
			if(__genModel.activeModelLocator.hasOwnProperty('isViewVisible'))
			{
				if(__genModel.activeModelLocator.isViewVisible)
				{
					initializeViewEvent	=	new InitializeViewEvent()
					initializeViewEvent.dispatch();	
				}
			}
			else
			{
				initializeViewEvent	=	new InitializeViewEvent()
				initializeViewEvent.dispatch();	
			}
		}
		
		private function listFormatResultHandler(event:ResultEvent):void
		{
			var xml:XML
			if(__genModel.triggerSource	== 'MENU')
			{
				xml  = __viewObj.criteria	
				xml[0]["user_id"] = __genModel.user.userID;
				xml[0]["document_id"] = __genModel.activeModelLocator.documentObj.documentID;
				xml[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 20 May 2010.
			
			}
			else if(__genModel.triggerSource	== 'DRILLDOWN')
			{
				
				xml	=	__genModel.drillObj.getDrillDownCriteria(__genModel.applicationObject.selectedMenuItem.@component_cd,__genModel.user.default_company_id,__genModel.user.userID,__genModel.activeModelLocator.documentObj.documentID);
			}	

			var listFormat:XML;
			listFormat = (XML)(event.result);
			
			__genModel.activeModelLocator.listObj.listFormat = listFormat;
			__genModel.activeModelLocator.sortOrderSelectionObj.sortField = XML(new SortLevel().getSortFields(listFormat)).children();
			
			var populateListEvent:PopulateListEvent = new PopulateListEvent(xml); // 0 is for default view
			populateListEvent.dispatch();
			
			if(__genModel.activeModelLocator.hasOwnProperty('isViewVisible'))
			{
				if(!__genModel.activeModelLocator.isViewVisible)
				{
					__genModel.activeModelLocator.viewObj.selectedView 	=	xml;
				}
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