package business.commands
{
	import business.delegates.ViewDelegate;
	import business.events.QueryEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	//import com.generic.genclass.ICriteria;
	
	import flash.utils.getQualifiedSuperclassName;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.ModeVO;
	import valueObjects.ViewVO;
	
	public class InitializeViewCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __viewObj:ViewVO;
		
		public function execute(event:CairngormEvent):void
		{
			var callbacksViewFormat:Responder 	=	new Responder(viewFormatResultHandler, faultHandler);
			var callbacksView:Responder 		= 	new Responder(viewResultHandler, faultHandler);

			var viewDelegate:ViewDelegate = new ViewDelegate();
			__viewObj = __genModel.activeModelLocator.viewObj;
			
			viewDelegate.getViewFormat(callbacksViewFormat);
			//getViewFormat();
			
			if(__genModel.triggerSource	== 'MENU')
			{
				viewDelegate.getViews(__genModel.user.userID, __genModel.activeModelLocator.documentObj.documentID , callbacksView);	
			}
			else if(__genModel.triggerSource	== 'DRILLDOWN')
			{
				setDrillDownView();
			}	
			

		}
		/* private function getViewFormat():void
		{
			__genModel.activeModelLocator.viewObj.viewFormat = ICriteria(__genModel.activeModelLocator.iCriteria).getCriteria();
		} */
		private function viewFormatResultHandler(event:ResultEvent):void
		{
			__genModel.activeModelLocator.viewObj.viewFormat = (XML)(event.result);
			
		}
		private function viewResultHandler(event:ResultEvent):void
		{
			if(getQualifiedSuperclassName(__genModel.controller) == "business::DataEntryController" )
			{
				if( __genModel.activeModelLocator.documentObj.selectedMode == ModeVO.EDIT_MODE)
				{
					setViewForBlankList((XML)(event.result));	
				}
				else
				{
					setViewForData((XML)(event.result));
				}
				
			}
			else if(getQualifiedSuperclassName(__genModel.controller) == "business::CustomReportController" )
			{
				setViewForBlankList((XML)(event.result));	
			}
			else
			{
				setViewForData((XML)(event.result));
			}
		}
		private function setViewForBlankList(view:XML):void
		{
			if(view.children().length() > 0)
			{
				var childXML:XML = __viewObj.criteria.copy();

				childXML.default_yn = "N";
				childXML.company_id = __genModel.user.default_company_id;
				childXML.user_id = __genModel.user.userID;
				childXML.trans_flag = "A";
				childXML.criteria_type = "T"; //T for temp 
				childXML.name = "Select View";
				childXML.document_id = __genModel.activeModelLocator.documentObj.documentID;
				childXML.default_request = "N";

				view.prependChild(childXML);
				//view.appendChild();
				
				__genModel.activeModelLocator.viewObj.view	=	view;
				
				__genModel.activeModelLocator.viewObj.selectedView = childXML
			}
			else
			{
				var xml:XML = <criterias></criterias>;
				var childXML:XML = __viewObj.criteria.copy();

				childXML.default_yn = "Y";
				childXML.company_id = __genModel.user.default_company_id;
				childXML.user_id = __genModel.user.userID;
				childXML.trans_flag = "A";
				childXML.criteria_type = "U";
				childXML.name = "New Criteria";
				childXML.document_id = __genModel.activeModelLocator.documentObj.documentID;
				childXML.default_request = "N";

				xml.appendChild(childXML)
	
				__genModel.activeModelLocator.viewObj.view = xml;
				__genModel.activeModelLocator.viewObj.selectedView = childXML;
				
				/* var queryEvent:QueryEvent = new QueryEvent();
				queryEvent.dispatch(); */
			}
			
			
		}
		private function setViewForData(view:XML):void
		{
			var isFoundDefault:Boolean = false;
			__genModel.activeModelLocator.viewObj.view = view;
			
			if(__genModel.activeModelLocator.viewObj.view.children().length() > 0)
			{
				for(var i:int=0; i<__genModel.activeModelLocator.viewObj.view.children().length(); i++)
				{
					if(__genModel.activeModelLocator.viewObj.view.children()[i].child("default_yn").toString()	==	'Y')
					{
						__genModel.activeModelLocator.viewObj.selectedView = XML(__genModel.activeModelLocator.viewObj.view.children()[i]);  //will use to fill cricteria values ,to select default view and default levels

						isFoundDefault = true;
						break;
					}
				}

				if(!isFoundDefault)
				{
					__genModel.activeModelLocator.viewObj.selectedView = __genModel.activeModelLocator.viewObj.view.children()[0];
				}
			}
			else
			{
				var xml:XML = <criterias></criterias>;
				var childXML:XML = __viewObj.criteria.copy();

				childXML.default_yn = "Y";
				childXML.company_id = __genModel.user.default_company_id;
				childXML.user_id = __genModel.user.userID;
				childXML.trans_flag = "A";
				childXML.criteria_type = "U";
				childXML.name = "New Criteria";
				childXML.document_id = __genModel.activeModelLocator.documentObj.documentID;
				childXML.default_request = "N";

				xml.appendChild(childXML)
	
				__genModel.activeModelLocator.viewObj.view = xml;
				__genModel.activeModelLocator.viewObj.selectedView = childXML;
				
				var queryEvent:QueryEvent = new QueryEvent();
				queryEvent.dispatch();
			}
			
			
		}


		private function setDrillDownView():void
		{
			var drillView:XML		=	new XML(<criterias/>)
			
			
			var drillCriteria:XML	=	__genModel.drillObj.getDrillDownCriteria(__genModel.applicationObject.selectedMenuItem.@component_cd,__genModel.user.default_company_id,__genModel.user.userID,__genModel.activeModelLocator.documentObj.documentID);
			
			drillView.appendChild(drillCriteria);
			
		   __genModel.activeModelLocator.viewObj.view	=	drillView; 
		   __genModel.activeModelLocator.viewObj.selectedView = drillCriteria;
		}
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			Alert.show('initialize view command' + event.fault.toString());
		}
	}
}
