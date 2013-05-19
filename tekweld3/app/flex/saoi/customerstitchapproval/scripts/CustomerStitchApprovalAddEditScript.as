import business.events.GetInformationEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flashx.textLayout.elements.BreakElement;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.customerstitchapproval.CustomerStitchApprovalModelLocator;
import saoi.customerstitchapproval.components.RejectWindow;
import saoi.muduleclasses.event.MissingInfoEvent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:CustomerStitchApprovalModelLocator =  CustomerStitchApprovalModelLocator(__genModel.activeModelLocator);
private var __service:ServiceLocator = __genModel.services;
private var __refreshList:IResponder;

private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var colName:String;
	var rowIndex:int;
	colName = event.object.id
	rowIndex = event.currentTarget.editBarRowPosition;

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["customer_stitch_approval_flag"] = 'Y';
		if(event.object.id == 'customer_stitch_approval_flag')
		{
			if(event.newValues["customer_stitch_approval_flag"] == 'Y')
			{
				inbox.focusedRow["customer_stitch_reject_flag"] = "N";
			}
			else
			{
				inbox.focusedRow["customer_stitch_reject_flag"] = "Y";
				inbox.focusedRow["customer_stitch_approval_flag"] = "N";
			} 
		}
		else if(event.object.id == 'customer_stitch_reject_flag')
		{
			if(event.newValues["customer_stitch_reject_flag"] == 'Y')
			{
				inbox.focusedRow["customer_stitch_approval_flag"] = "N";
			}
			else
			{
				inbox.focusedRow["customer_stitch_approval_flag"] = "Y";
				inbox.focusedRow["customer_stitch_reject_flag"] = "N";
			} 
		}
		else if(event.object.id == 'select_yn')
		{
			inbox.focusedRow["customer_stitch_reject_flag"] = "N";
		}
		
	}
	else
	{
		inbox.focusedRow["customer_stitch_approval_flag"] = "";
		inbox.focusedRow["customer_stitch_reject_flag"] = "";
	}

}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	var count:int = -1;
	count   = inbox.selectedRows.copy().length();

	if(count==1)
	{
		var index:int = -1;
		for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
		{
			if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
			{
				index  = i;
				break;
			}	
		}
		if(index>=0)
		{
			var reject_flag:String  = inbox.dgDtl.dataProvider[index]["customer_stitch_reject_flag"].toString();
			if(reject_flag=='Y')
			{
				openRejectWindow();
				retValue =-1;
			}
			else
			{
				retValue= 0;
			}
		}
	}
	else
	{
		retValue  = -1;
		Alert.show("Please Select One record");
	}
	
	
	return retValue;
}
private function openRejectWindow():void
{
	var rejectWindow:RejectWindow 			= RejectWindow(PopUpManager.createPopUp(this,RejectWindow,true));
	rejectWindow.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoEventListner);
	rejectWindow.x							= ((Application.application.width/2)-(rejectWindow.width/2));
	rejectWindow.y							= ((Application.application.height/2)-(rejectWindow.height/2));
	rejectWindow.xml 						= new XML(inbox.selectedRows.copy());
}
public function  missingInfoEventListner(event:MissingInfoEvent):void
{
	var xml:XML   				= XML(event.xml);
	if(xml.children().length()>0)
	{
		if(xml.result.toString()=='SUCCESS')
		{
			refreshHandler();
		}
	}
	else
	{
		
	}
	
	
}
public function dataService(service:HTTPService):HTTPService
{
	var urlObj:URL				=	new URL();
	service.url					=	urlObj.getURL(service.url);
	service.resultFormat 		= "e4x";					
	service.method 				= "POST";
	service.useProxy			= false;
	service.contentType			="application/xml";
	service.requestTimeout	 	= 1800
	
	return service;
}
private function refreshHandler():void
{
	CursorManager.setBusyCursor();
	
	var refresh:HTTPService = dataService(__service.getHTTPService("getList"));
	__refreshList = new mx.rpc.Responder(refreshResultHandler,refreshFaultHandler);
	var token:AsyncToken = refresh.send(__localModel.viewObj.selectedView);
	token.addResponder(__refreshList);	
}


private function refreshResultHandler(event:ResultEvent):void
{
	var resultXML:XML;
	var utilityObj:Utility	=	new Utility();
	resultXML 				= 	utilityObj.getDecodedXML((XML)(event.result));
	__localModel.listObj.rows = new XML(resultXML);   	
	__localModel.listObj.filteredList = new XML(resultXML);
	
	CursorManager.removeBusyCursor();
}
public function refreshFaultHandler(event:FaultEvent):void
{
	Alert.show("Refreshorder"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
}
