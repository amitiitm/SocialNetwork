import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;

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

import saoi.muduleclasses.CommonMooduleFunctions;
import saoi.muduleclasses.MyCamera;

import ship.sampleshipping.SampleShippingModelLocator;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:SampleShippingModelLocator =  SampleShippingModelLocator(__genModel.activeModelLocator);
private var __service:ServiceLocator = __genModel.services;
private var __generatePackageSlip:IResponder;
private var resultFromUps:XML ;
private var  __genrateUpsLabel:IResponder;

[Embed("com/generic/assets/btn_take_picture.png")]
private const imageIcon:Class;
[Embed("com/generic/assets/btn_generate_package_slips.png")]
private const generatePackageSlipIcon:Class;
[Embed("com/generic/assets/btn_print_shipping_label.png")]
private const printUpsLabelIcon:Class;
[Embed("com/generic/assets/btn_print_trucking.png")]
private const printTruckingButtonIcon:Class;

private var hbox:HBox   								= new HBox();
private var btnUpsLabel:Button        				= new Button();
private var btnPrintTruckingSlip:Button        		= new Button();

private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var select:String = event.newValues.select_yn.toString();
	
	for(var i:int=0; i <inbox.dgDtl.rows.children().length();i++)
	{
		inbox.dgDtl.rows.children()[i].select_yn = 'N';
	}
	if(select.toUpperCase() == 'Y')
	{
		inbox.focusedRow["select_yn"] = 'Y';
	}
	
	setVisiblityOfOptionsBar();
		
	var colName:String;
	colName 							= event.object.id
 	//var oldValue:String 				= event.oldValues["shipping_flag"].toString();
	var oldValueshipQty:String 			= event.oldValues["ship_qty"].toString();
	var newdValueshipQty:String 		= event.newValues["ship_qty"].toString();
	var oldValuedamqagedQty:String 		= event.oldValues["damaged_qty"].toString();
	var newValuedamqagedQty:String 		= event.newValues["damaged_qty"].toString();

	/*if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["shipping_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["shipping_flag"] = 'N';
	}  	*/
	/*if(colName == "damaged_qty")
	{
		if(Number(newValuedamqagedQty)<1)
		{
			inbox.focusedRow["damaged_qty"] = oldValuedamqagedQty;
		}
		else if(Number(newValuedamqagedQty)>Number(newdValueshipQty))
		{
			inbox.focusedRow["damaged_qty"] = oldValuedamqagedQty;
		}
		else
		{
			
		}
		
	}*/
	
	
	/*if(colName == "ship_qty")
	{
		if(Number(newdValueshipQty)<1)
		{
			inbox.focusedRow["ship_qty"] = oldValueshipQty;
			Alert.show("ship qty can't be 0 or blank");
		}
		else
		{
			if(Number(newdValueshipQty)>Number(oldValueshipQty))
			{
				inbox.focusedRow["ship_qty"] = oldValueshipQty;
				Alert.show("ship qty can't be more than available quantity");
			}
			else if(Number(newValuedamqagedQty)>Number(newdValueshipQty))
			{
				inbox.focusedRow["ship_qty"] = oldValueshipQty;
			}
			else
			{
				
			}
		}
		
	}*/
	
	
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;

	return retValue;
}

private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	hb.setStyle("horizontalGap",10);
	
	var sp:Spacer  = new Spacer();
	sp.width     =   2;
	
	var btnIndigo:Button        		= new Button();
	//btnIndigo.setStyle("icon",generatePackageSlipIcon);
	btnIndigo.height					= 20;
	btnIndigo.label						= "GENERATE PACKAGE SLIP";
	btnIndigo.styleName					= "promoButton";
	btnIndigo.addEventListener(MouseEvent.CLICK,genratePackageSlipClickHandler);
	
	btnUpsLabel			       			= new Button();
	//btnUpsLabel.setStyle("icon",printUpsLabelIcon);
	btnUpsLabel.height					= 20;
	btnUpsLabel.name					= "UPS";
	btnUpsLabel.label					= "PRINT SHIPPING LABEL";
	btnUpsLabel.styleName				= "promoButton";
	btnUpsLabel.addEventListener(MouseEvent.CLICK,genrateUpsLabelClickHandler);
	
	btnPrintTruckingSlip.height			= 20;
	btnPrintTruckingSlip.label			= "PRINT TRUCKING";
	btnPrintTruckingSlip.styleName		= "promoButton";
	//btnPrintTruckingSlip.setStyle("icon",printTruckingButtonIcon);
	btnPrintTruckingSlip.addEventListener(MouseEvent.CLICK,PrintTruckingSlipClickHandler);
	
	
	
	var btnTakeButton:Button			= new Button();
	//btnTakeButton.setStyle("icon", imageIcon);
	btnTakeButton.height				=  20;
	//btnTakeButton.width					=  25;
	btnTakeButton.toolTip	  			=  "Take Picture";
	btnTakeButton.label					= "TAKE PICTURE";
	btnTakeButton.styleName				= "promoButton";
	btnTakeButton.addEventListener(MouseEvent.CLICK,takePicktureClickHandler);
	
	var space:Spacer	 = new Spacer();
	space.width			 = 200;
	
	hb.addChild(space);
	
	hb.addChild(btnIndigo);
	hb.addChild(btnTakeButton);
	hb.addChild(btnUpsLabel);
	//hb.addChild(btnPrintTruckingSlip);
	
	SampleShipping(this.parentDocument).bcp.addChildAt(hb,7);
}
private function setVisiblityOfOptionsBar():void
{
	if(inbox.selectedRows.children().length()==1)
	{
		var shipping_provider:String  = inbox.selectedRows.children()[0].shipping_code.toString();
		if(shipping_provider!='')
		{
			if(shipping_provider=='TRUCKING')
			{
				btnUpsLabel.name	 = "TRUCKING";
				btnUpsLabel.label	 = "TRUCKING";
				//btnUpsLabel.setStyle("icon",printTruckingButtonIcon);
			}
			else
			{
				btnUpsLabel.name	 = "UPS";
				btnUpsLabel.label	 = "PRINT SHIPPING LABEL";
				//btnUpsLabel.setStyle("icon",printUpsLabelIcon);
			}
		}
		else
		{
			btnUpsLabel.name	 = "UPS";
			btnUpsLabel.label	 = "PRINT SHIPPING LABEL";
			//btnUpsLabel.setStyle("icon",printUpsLabelIcon);
		}
	}
	else
	{
		btnUpsLabel.name	 = "UPS";
		btnUpsLabel.label	 = "PRINT SHIPPING LABEL";
		//btnUpsLabel.setStyle("icon",printUpsLabelIcon);
	}
}
private function PrintTruckingSlipClickHandler(event:MouseEvent):void
{
	if(inbox.selectedRows.children().length()==1)
	{
			var file_name:String 	= 'bill_of_lading_template.dot';
			var folderName:String 	= '/sampleformats/';
			var urlObj:URL			=	new URL();
			var url:String			=	urlObj.getURL(folderName + file_name) 
			
			var request:URLRequest 	= new URLRequest(url);
			navigateToURL(request);
	}
	else
	{
		Alert.show("Please Select One Record");
	}
}
private function takePicktureClickHandler(event:MouseEvent):void
{
	new CommonMooduleFunctions().captureImage(this,inbox.selectedRows.copy());
}
private function genrateUpsLabelClickHandler(event:MouseEvent):void
{
	if(inbox.selectedRows.children().length()==1)
	{
		if(event.target.name.toString()=="UPS")
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;
			
			var printjob:HTTPService 	= dataService(__service.getHTTPService("genrateUpsLabel"));
			__genrateUpsLabel 			= new mx.rpc.Responder(genrateUpsLabelResultHandler,genrateUpsLabelHandler);
			var token:AsyncToken 		= printjob.send(new XML(	<params>
																		<id>{inbox.selectedRows.children()[0].id.toString()}</id>
																	</params>));
			token.addResponder(__genrateUpsLabel);
		}
		else
		{
			var file_name:String 	= 'bill_of_lading_template.dot';
			var folderName:String 	= '/sampleformats/';
			var urlObj:URL			=	new URL();
			var url:String			=	urlObj.getURL(folderName + file_name) 
			
			var request:URLRequest 	= new URLRequest(url);
			navigateToURL(request);
		}
		
			
	}
	else
	{
		Alert.show("Please Select One Record");
	}
	
}
private function genrateUpsLabelResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	resultFromUps		= XML(event.result);
	
	if(resultFromUps.name() == "errors")
	{
		if(resultFromUps.children().length() > 0) 
		{
			var message:String = '';
			
			for(var i:uint = 0; i < resultFromUps.children().length(); i++) 
			{
				message += resultFromUps.children()[i] + "\n";
			}
			Alert.show(message);
		} 
	}
	else
	{
		openFile(0);
		/*for(var j:int=0;j<resultXml.children().length();j++)
		{
		/*var url:String 			= __genModel.path.ups_label  + resultXml.children()[j].toString()
		var request:URLRequest 	= new URLRequest(url);
		// setTimeout(openFile,4000,request);
		navigateToURL(request,'_blank');
		Alert.show("hi");
		
		}*/
	}
}

private function openFile(i:int):void
{
	if(i<resultFromUps.children().length())
	{
		var url:String 			= __genModel.path.ups_label  + resultFromUps.children()[i].toString()
		var request:URLRequest 	= new URLRequest(url);
		navigateToURL(request,'_self');
		callLater(callLater, [openFile, [i+1]]); 
		
	}
}
public function genrateUpsLabelHandler(event:FaultEvent):void
{
	Alert.show("Genrate package Slip"+event.fault.faultDetail);
	
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
private function genratePackageSlipClickHandler(event:MouseEvent):void
{
	/*if(inbox.selectedRows.children().length()==1)
	{
		Application.application.enabled = false;
		CursorManager.setBusyCursor();
		
		
			var generatePackageSlip:HTTPService 	= dataService(__service.getHTTPService("genratePackageSlip"));
			__generatePackageSlip 					= new mx.rpc.Responder(generatePackageSlipResultHandler,generatePackageSlipHandler);
			var token:AsyncToken 					= generatePackageSlip.send(new XML(<params>
																							<id>{inbox.selectedRows.children()[0].id.toString()}</id>
																						</params>));
			token.addResponder(__generatePackageSlip);
	}
	else
	{
		Alert.show("Please select one Record");
	}*/
	if(inbox.selectedRows.children().length()==1)
	{
		__genModel.drillObj.drillrow					=	XML(inbox.selectedRows.children()[0])
		__localModel.listObj.drilldown_component_code   =   "ship/shipjob/components/ShipJob.swf";
		
		var tabpage:TabPage	=	new TabPage();
		tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
	}
	else
	{
		Alert.show("Please Select One Record");
	}
	
}
private function generatePackageSlipResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
	var request:URLRequest = new URLRequest(url);
	
	navigateToURL(request);
}
public function generatePackageSlipHandler(event:FaultEvent):void
{
	Alert.show("Genrate package Slip"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}