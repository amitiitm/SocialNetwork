package business.commands
{
	import business.delegates.LayoutDelegate;
	import business.events.PopulateListEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.LayoutVO;
	import valueObjects.ViewVO;

	
	public class InitializeLayoutCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __viewObj:ViewVO;
		private var __layoutObj:LayoutVO;

		
		public function execute(event:CairngormEvent):void
		{
			__viewObj 		= __genModel.activeModelLocator.viewObj;
			__layoutObj		= __genModel.activeModelLocator.layoutObj;
						
			var callbacksLayout:Responder 				= 	new Responder(layoutResultHandler, faultHandler);
			var delegate:LayoutDelegate					= 	new LayoutDelegate();
			
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;
			
			delegate.getLayouts(__genModel.user.userID, __genModel.activeModelLocator.documentObj.documentID , callbacksLayout);
		}
		private function layoutResultHandler(event:ResultEvent):void
		{
			var isFoundDefault:Boolean = false;
			
			//__genModel.activeModelLocator.layoutObj.layout = __genModel.activeModelLocator.layoutObj.getLayout()

			__genModel.activeModelLocator.layoutObj.layout = (XML)(event.result);
			
			if(__genModel.activeModelLocator.layoutObj.layout.children().length() > 0)
			{
				
				for(var i:int=0; i<__genModel.activeModelLocator.layoutObj.layout.children().length(); i++)
				{
					if(__genModel.activeModelLocator.layoutObj.layout.children()[i].child("default_yn").toString()	==	'Y')
					{
						__genModel.activeModelLocator.layoutObj.selectedLayout = XML(__genModel.activeModelLocator.layoutObj.layout.children()[i]);  
						__genModel.activeModelLocator.layoutObj.listFormat = XML(XML(__genModel.activeModelLocator.layoutObj.selectedLayout).child('report_layout_columns'));  	
						isFoundDefault = true;
						break;
					}
				}

				if(!isFoundDefault)
				{
					__genModel.activeModelLocator.layoutObj.selectedLayout = __genModel.activeModelLocator.layoutObj.layout.children()[0];
					__genModel.activeModelLocator.layoutObj.listFormat = XML(XML(__genModel.activeModelLocator.layoutObj.selectedLayout).child('report_layout_columns'));
				}
				__genModel.activeModelLocator.reportObj.isdrilldownrow				=	__genModel.activeModelLocator.layoutObj.layout.children()[0].child('isdrilldownrow').toString()
				__genModel.activeModelLocator.reportObj.isfixedurl					=	__genModel.activeModelLocator.layoutObj.layout.children()[0].child('isfixedurl').toString()
				__genModel.activeModelLocator.reportObj.drilldown_component_code	=	__genModel.activeModelLocator.layoutObj.layout.children()[0].child('drilldown_component_code').toString()

			}
			
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			var xml:XML
			if(__genModel.triggerSource	== 'MENU')
			{
				/*comment as we donot want data for report on opening. 
				xml = __viewObj.criteria	
				xml[0]["user_id"] = __genModel.user.userID;
				xml[0]["document_id"] = __genModel.activeModelLocator.documentObj.documentID;
				xml[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 20 May 2010.
				
				var populateListEvent:PopulateListEvent = new PopulateListEvent(xml); 
				populateListEvent.dispatch(); */
			}
			else if(__genModel.triggerSource	== 'DRILLDOWN')
			{
				
				xml	=	__genModel.drillObj.getDrillDownCriteria(__genModel.applicationObject.selectedMenuItem.@component_cd,__genModel.user.default_company_id,__genModel.user.userID,__genModel.activeModelLocator.documentObj.documentID);
			
				var populateListEvent:PopulateListEvent = new PopulateListEvent(xml); 
				populateListEvent.dispatch();
			}		
			
		}			
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			Alert.show('initialize layout command' + event.fault.toString());
		}
	}
}
