package business.commands
{
	import business.delegates.InitializeDataEntryDelegate;
	import business.events.AddEvent;
	import business.events.GetGenDataGridFormatEvent;
	import business.events.GetGenListDataEvent;
	import business.events.InitializeDataEntryEvent;
	import business.events.InitializeViewEvent;
	import business.events.PopulateListEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	import com.generic.genclass.SortLevel;
	
	import flash.utils.getQualifiedClassName;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.AddEditVO;
	import valueObjects.ModeVO;
	import valueObjects.NoteAttachmentVO;
	import valueObjects.ViewVO;
	
	public class InitializeDataEntryCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditObj:AddEditVO;
		private var __viewObj:ViewVO;
		private var callbacks:IResponder;
		private var __noteAttachObj:NoteAttachmentVO;
		private var initializeViewEvent:InitializeViewEvent
		
		public function execute(event:CairngormEvent):void
		{
			var addEvent:AddEvent;
			var genObj:GenObject = new GenObject();
			var genValidator:GenValidator = new GenValidator();
			var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
			var getGenListDataEvent:GetGenListDataEvent;

			// VD 08 Nov 2010 -- Code move to top
			callbacks = (event as InitializeDataEntryEvent).callbacks;
			
			var callbacksListFormat:Responder = new Responder(listFormatResultHandler, faultHandler);
			var delegate:InitializeDataEntryDelegate = new InitializeDataEntryDelegate(callbacksListFormat);
			
			delegate.getListFormat();
			
			initializeViewEvent	=	new InitializeViewEvent()
			initializeViewEvent.dispatch();
			// End 
			
			__addEditObj = __genModel.activeModelLocator.addEditObj;
			__viewObj = __genModel.activeModelLocator.viewObj;
			
			__addEditObj.genObjects = genObj.getGenObjects(__addEditObj.addEditContainer);
			__addEditObj.validators = genValidator.applyValidation(__addEditObj.genObjects) // VD 4 Nov, 2009
			__addEditObj.tableName = __addEditObj.genObjects[0].tableName
			
			if(__genModel.activeModelLocator.hasOwnProperty('noteAttachObj'))
			{
				__noteAttachObj				=	__genModel.activeModelLocator.noteAttachObj;
				__noteAttachObj.tableName		=	__addEditObj.genObjects[0].tableName
			}
			else
			{
				Alert.show('noteAttachObj is not defined for this screen');
			}
			

			for(var i:int = 0; i < __addEditObj.genObjects.length; i++)
			{
				if( getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.customcomponents::GenDataGrid"
					||	getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.components::Detail"
					|| 	getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.components::EditableDetail"
					|| 	getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.components::NewDetail"
				  )
				{
					getGenDataGridFormatEvent = new GetGenDataGridFormatEvent(__addEditObj.genObjects[i]);
					getGenDataGridFormatEvent.dispatch();
				}
				else if(getQualifiedClassName(__addEditObj.genObjects[i]) == "com.generic.customcomponents::GenList")
				{
					getGenListDataEvent = new GetGenListDataEvent(__addEditObj.genObjects[i]);
					getGenListDataEvent.dispatch();
				}
			}

			addEvent = new AddEvent(false)
			addEvent.dispatch();
		}
		
		
		private function listFormatResultHandler(event:ResultEvent):void
		{

			var listFormat:XML;
			listFormat = (XML)(event.result);
			
			__genModel.activeModelLocator.listObj.listFormat = listFormat;
			__genModel.activeModelLocator.sortOrderSelectionObj.sortField = XML(new SortLevel().getSortFields(listFormat)).children();

			var xml:XML
			if(__genModel.triggerSource	== 'MENU')
			{
				xml  = __viewObj.criteria	
				xml[0]["user_id"] = __genModel.user.userID;
				xml[0]["document_id"] = __genModel.activeModelLocator.documentObj.documentID;
				xml[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 20 May 2010.
				
				if( __genModel.activeModelLocator.documentObj.selectedMode == ModeVO.EDIT_MODE)
				{
					//__genModel.activeModelLocator.documentObj.selectedMode	=	ModeVO.EDIT_MODE;
				}
				else
				{
					var populateListEvent:PopulateListEvent = new PopulateListEvent(xml); // 0 is for default view
					populateListEvent.dispatch();
				}
				
			}
			else if(__genModel.triggerSource	== 'DRILLDOWN')
			{
				
				xml	=	__genModel.drillObj.getDrillDownCriteria(__genModel.applicationObject.selectedMenuItem.@component_cd,__genModel.user.default_company_id,__genModel.user.userID,__genModel.activeModelLocator.documentObj.documentID);

				var populateListEvent:PopulateListEvent = new PopulateListEvent(xml); // 0 is for default view
				populateListEvent.dispatch();
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