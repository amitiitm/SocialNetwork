import business.events.GetInformationEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;
import com.generic.customcomponents.GenButton;

import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Spacer;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.shiptovendor.ShipToVendorModelLocator;
import prod.shiptovendor.components.PrintUpsLabel;
import prod.shiptovendor.components.ShipToVendor;

import saoi.muduleclasses.event.MissingInfoEvent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:ShipToVendorModelLocator =  ShipToVendorModelLocator(__genModel.activeModelLocator);
private var resultFromUps:XML ;
private var  __genrateUpsLabel:IResponder;
private var __service:ServiceLocator = __genModel.services;
private var __refreshList:IResponder;

[Embed("com/generic/assets/btn_generate_shipping_label.png")]
private const generateShippingLabelButtonIcon:Class;


private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	
	var sp:Spacer  = new Spacer();
	sp.width     =   2;
	
	var btnPrintUpsLabel:Button        			= new Button();
	btnPrintUpsLabel.height						= 20;
	btnPrintUpsLabel.label						= "GENERATE SHIPPING LABEL";
	//btnPrintUpsLabel.setStyle('icon' , generateShippingLabelButtonIcon);
	btnPrintUpsLabel.styleName					= "promoButton";
	btnPrintUpsLabel.addEventListener(MouseEvent.CLICK,genrateUpsLabelClickHandler);
	
	var space:Spacer	 = new Spacer();
	space.width			 = 200;
	
	hb.addChild(space);
	hb.addChild(btnPrintUpsLabel);
	
	ShipToVendor(this.parentDocument).bcp.addChildAt(hb,7);
}
private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var colName:String;
	var rowIndex:int;
	colName = event.object.id
	rowIndex = event.currentTarget.editBarRowPosition;
	
	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["ship_to_vendor_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["ship_to_vendor_flag"] = 'N';
	}
	
	if(colName == "vendor_code")
	{
		if(event.object.text != null && event.object.text != '')
		{
			inbox.focusedRow["vendor_id"]	 = event.object.dataValue;
			inbox.focusedRow["vendor_code"]	 = event.object.labelValue;
		}
		else
		{
			inbox.focusedRow["vendor_id"]	 = ''
			inbox.focusedRow["vendor_code"]	 = ''
		}
	}

}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["vendor_id"] == '')
			{
				retValue = -1;
				Alert.show("Please Enter Vendor");
				break
			}					
		}	
	}
	for(var j:int=0; j<inbox.dgDtl.dataProvider.length; j++)
	{
		if(inbox.dgDtl.dataProvider[j]["select_yn"] == "Y")
		{				
			if(inbox.dgDtl.dataProvider[j]["ref_po_no"] == '')
			{
				retValue = -1;
				Alert.show("Please Genrate PO # Before Ship To Vendor");
				break
			}	
		}	
	}
	
	return retValue;
}
private function isSameVendorSelected():Boolean
{
	var returnValue:Boolean	= true;
	
	var vendor:String	= inbox.selectedRows.children()[0].vendor_id.toString();
	if(vendor=='')
	{
		return  false;
	}
	for(var i:int=1;i<inbox.selectedRows.children().length();i++)
	{
		var vendor_id:String	= inbox.selectedRows.children()[i].vendor_id.toString();
		if(vendor.toUpperCase()!=vendor_id.toUpperCase())
		{
			returnValue	= false;
		}
	}
	return returnValue;
}
private function genrateUpsLabelClickHandler(event:MouseEvent):void
{
	
	if(inbox.selectedRows.children().length()>0)
	{
		if(isSameVendorSelected())
		{
			openPrintUpsLabelWindow();
		}
		else
		{
			Alert.show("Please select One Vendor");
		}
	}
	else
	{
		Alert.show("Please Select  Record");
	}
	
}
private function openPrintUpsLabelWindow():void
{
	var printUpsLabel:PrintUpsLabel 		= PrintUpsLabel(PopUpManager.createPopUp(this,PrintUpsLabel,true));
	printUpsLabel.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoEventListner);
	printUpsLabel.x							= ((Application.application.width/2)-(printUpsLabel.width/2));
	printUpsLabel.y							= ((Application.application.height/2)-(printUpsLabel.height/2));
	printUpsLabel.xml 						= new XML(inbox.selectedRows.copy());
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
private function refreshHandler():void
{
	CursorManager.setBusyCursor();
	Application.application.enabled  = false;
	
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
	Application.application.enabled = true;
}
public function refreshFaultHandler(event:FaultEvent):void
{
	Alert.show("Refreshorder"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
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