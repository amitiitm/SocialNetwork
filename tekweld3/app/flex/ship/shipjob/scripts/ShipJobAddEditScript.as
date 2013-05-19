import business.events.GetInformationEvent;
import business.events.PreSaveEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.DataEntry;
import com.generic.customcomponents.GenButton;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.AddEditEvent;
import com.generic.events.DetailAddEditEvent;
import com.generic.events.DetailEvent;
import com.generic.events.GenTextInputEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.utils.Timer;
import flash.utils.setTimeout;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.Spacer;
import mx.controls.TextInput;
import mx.core.Application;
import mx.events.ListEvent;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.muduleclasses.CommonArtworkXml;
import saoi.muduleclasses.GenNotesAttachmentIcon;
import saoi.muduleclasses.event.MissingInfoEvent;

import ship.shipjob.ShipJobModelLocator;
import ship.shipjob.components.PopUpViewer;
import ship.shipjob.components.ShipJob;

public  var fileRef:FileReference = new FileReference();
public  var fileRefDown:FileReference = new FileReference();

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
[Bindable]
private var __localModel:ShipJobModelLocator = (ShipJobModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var image_name:String;

[Bindable]
private var main_image_name:String;

[Bindable]
private var reorderEnable:Boolean = true;
[Bindable]
private var optionEnable:Boolean = true;
private var selectUniqueArtworkVersionIndex:int=0;
public var refreshTimer:Timer  = new Timer(__genModel.screenRefreshTimeInterval);
public var remainTimer:Timer  = new Timer(1000);
private var __refreshList:IResponder;
private var __service:ServiceLocator = __genModel.services;
private var __responderPrintJob:IResponder;
[Bindable]
public var remainingTime:int=(__genModel.screenRefreshTimeInterval)/1000;
private var shipping_detail:GetInformationEvent;

private var optionXmlAfterSave:XML;

private var saveXml:XML;
private var screenName:String = '';
private var isMissingInfoSave:Boolean	=	false;
private var missingInfoWindow:PopUpViewer;
private var preSaveEvent:PreSaveEvent;
[Embed("com/generic/assets/ups_logo.jpg")]
private const upsshippingButtonIcon:Class;
[Embed("com/generic/assets/fedex_logo.jpg")]
private const fedexshippingButtonIcon:Class;
[Bindable]
private var btnShipMethodClass:Class;
private var  __genrateUpsLabel:IResponder;
private var  __responder:IResponder;
private var resultFromUps:XML ;
private var __generatePackageSlip:IResponder;
private var __generateTruckingSlip:IResponder;
private var hbox:HBox   								= new HBox();
private var btnUpsLabel:Button        				= new Button();
private var btnPrintpackageSlip:Button        		= new Button();
private var btnPrintTruckingSlip:Button        		= new Button();


[Embed("com/generic/assets/btn_print_shipping_label.png")]
private const printUpsLabelButtonIcon:Class;
[Embed("com/generic/assets/btn_print_package_slip.png")]
private const printPackageSlipButtonIcon:Class;
[Embed("com/generic/assets/btn_print_trucking.png")]
private const printTruckingButtonIcon:Class;
private var packageChangeFlag:Boolean  = false;
private var commonartworkXml:CommonArtworkXml   			= new CommonArtworkXml();
private var sourceScreen:String= '';
public function setMainImage(resultXml:XML):void
{

	if(resultXml.image_thumnail!='')
	main_image_name = resultXml.image_thumnail;
	else
	main_image_name = '';
	
}
							

private function init():void
{
	addOptionBar(__genModel.objectFromDrilldown);
	screenName = __genModel.tabMain.selectedChild.label;
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	var refreshLabel:Label  = new Label();
	refreshLabel.name		= "refreshLabel";
	refreshLabel.text		= "refresh within "+remainingTime.toString()+" sec.";
	refreshLabel.height     = 20;
	refreshLabel.setStyle("color","#356DCC");
	refreshLabel.setStyle("fontSize",11);
	refreshLabel.setStyle("fontWeight","bold");
	
	ShipJob(this.parentDocument).bcpList.addChild(refreshLabel);
	refreshTimer.addEventListener(TimerEvent.TIMER,refreshTimerPickHandler);
	remainTimer.addEventListener(TimerEvent.TIMER,remainTimerPickHandler);
	refreshTimer.start();
	remainTimer.start();
	

}

private function refreshTimerPickHandler(event:TimerEvent):void
{
	var tabpage:TabPage =  new TabPage();
	var index:int = tabpage.searchTabPage(screenName);
	if(index>0)
	{
		refreshPickHandler();
		remainingTime = (__genModel.screenRefreshTimeInterval)/1000;
	}
	else
	{
		refreshTimer.stop();
		remainTimer.stop();
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
	service.showBusyCursor		= true;	
	
	return service;
}


private function refreshPickHandler():void
{
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
	Alert.show("Shipjob"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}

private function remainTimerPickHandler(event:TimerEvent):void
{
	Label(ShipJob(this.parentDocument).bcpList.getChildByName("refreshLabel")).text =	"refresh within "+remainingTime.toString()+" sec."; ;
	remainingTime = remainingTime - 1;	
}

private function setShipAmountEnablity():void
{
	if(dcShipping_code.dataValue == 'TRUCKING')
	{
		tiAmount.enabled			= true;
	}
	else
	{
		tiAmount.enabled			= false;
	}
}
//--------------------------------------------------------------------------------
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	packageChangeFlag    			= false;
	
	if(cbBillingTransportationTo.dataValue=='Shipper (TEKWELD)')
	{
		btnRecalculateAmount.enabled  = true;
	}
	else
	{
		btnRecalculateAmount.enabled  = false;
	}
	if(dcShipping_code.dataValue=='TRUCKING')
	{
		dtlFreight.enabled			  = true;
	}
	else
	{
		dtlFreight.enabled			  = false;
	}
	
	setShipAmountEnablity();
	var recordXml:XML		= event.recordXml;
	saveXml					= event.recordXml.copy();
		
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
	
	if(__genModel.objectFromDrilldown.children().length()>0)
	{
		sourceScreen	 = __genModel.objectFromDrilldown.row[0].toString();
	}
	setVisiblityOfOptionsBar(__genModel.objectFromDrilldown)
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{	
	__localModel.trans_no	= '';
	__localModel.artwork_dept_email	= '';
}

private function isShipQtyMatchWithPackagesQty(ship_qty_param:String,packagesXml:XML):int
{	
	var ship_qty:Number					= Number(ship_qty_param);
	var total_package_qty:Number 		= 0;
	
	var return_value:int	= 0;
	for(var i:int = 0 ; i < packagesXml.children().length(); i++)
	{
		total_package_qty = total_package_qty + Number(packagesXml.children()[i]['pcs_per_carton'].toString());
	}
	
	if(total_package_qty>ship_qty)
	{
		return_value  	= -1;
	}
	else if(total_package_qty<ship_qty)
	{
		return_value  	= 1;
	}
	else
	{
		return_value	= 0;
	}
	
	return return_value;
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	
	var returnValue:int    = 0;
	/*if(isShipQtyMatchWithPackagesQty(tiQty.dataValue,dtlPackage.dgDtl.rows.copy())!=0)
	{
		Alert.show("Ship qty mis-match with total Pcs/Carton");
		return -1;
	}*/
	if(dcShipping_code.dataValue!='TRUCKING' && packageChangeFlag && cbBillingTransportationTo.dataValue=='Shipper (TEKWELD)')
	{
		Alert.show("Please Recalculate Ship Amount");
		return  -1;
	}
	return returnValue;
}

private function addOptionBar(xml:XML):void
{
	hbox.setStyle("horizontalGap",10);
	btnUpsLabel.label						= "PRINT SHIPPING LABEL";
	btnUpsLabel.height     					= 20;
	//btnUpsLabel.setStyle("icon",printUpsLabelButtonIcon);
	btnUpsLabel.styleName					= "promoButton";
	btnUpsLabel.addEventListener(MouseEvent.CLICK,genrateUpsLabelClickHandler);
	
	btnPrintpackageSlip.label					= "PRINT PACKAGE SLIP";
	btnPrintpackageSlip.height					= 20;
	btnPrintpackageSlip.styleName				= "promoButton";
	//btnPrintpackageSlip.setStyle("icon",printPackageSlipButtonIcon);
	btnPrintpackageSlip.addEventListener(MouseEvent.CLICK,PrintPackageSlipClickHandler);
	
	btnPrintTruckingSlip.label					= "PRINT TRUCKING";
	btnPrintTruckingSlip.height					= 20;
	//btnPrintTruckingSlip.setStyle("icon",printTruckingButtonIcon);
	btnPrintTruckingSlip.styleName				= "promoButton";
	btnPrintTruckingSlip.addEventListener(MouseEvent.CLICK,PrintTruckingSlipClickHandler);
	
	if(hbox.getChildren().length<=0)
	{
		hbox.addChild(btnPrintpackageSlip);
		hbox.addChild(btnUpsLabel);
		hbox.addChild(btnPrintTruckingSlip);
		
		ShipJob(this.parentDocument).bcpDataEntry.addChildAt(hbox,4);
	}
}
private function setVisiblityOfOptionsBar(xml:XML):void
{
	/*if(xml.children().length()>0)
	{*/
		//var sourceScreen:String	 = xml.row[0].toString();
		if(sourceScreen.toUpperCase()=='SHIPPING INBOX')
		{
			if(dcShipping_code.dataValue.toUpperCase()=='TRUCKING')
			{
				btnUpsLabel.visible = false;
				btnUpsLabel.includeInLayout= false;
				
				btnPrintTruckingSlip.visible = true;
				btnPrintTruckingSlip.includeInLayout= true;
			}
			else
			{
				btnUpsLabel.visible = true;
				btnUpsLabel.includeInLayout= true;
				
				btnPrintTruckingSlip.visible = false;
				btnPrintTruckingSlip.includeInLayout= false;
			}
			
		}
		else if(sourceScreen.toUpperCase()=='PACKAGE JOB')
		{
			btnUpsLabel.visible = false;
			btnUpsLabel.includeInLayout= false;
			
			btnPrintTruckingSlip.visible  = false;
			btnPrintTruckingSlip.includeInLayout =  false;
		}
		else
		{
			btnUpsLabel.visible = false;
			btnUpsLabel.includeInLayout= false;
			
			btnPrintTruckingSlip.visible = false;
			btnPrintTruckingSlip.includeInLayout= false;
		}
	
	__genModel.objectFromDrilldown = new XML(<rows></rows>);
}

private function PrintTruckingSlipClickHandler(event:MouseEvent):void
{
	if(__localModel.addEditObj.record != null && !__genModel.activeModelLocator.addEditObj.editStatus)
	{
		var shipping_id:Number = Number(__localModel.addEditObj.record.children()[0].id.toString());
		if(shipping_id>0)
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
		Alert.show("Please Save Record Before Printing");
	}
}

private function PrintPackageSlipClickHandler(event:MouseEvent):void
{
	if(__localModel.addEditObj.record != null && !__genModel.activeModelLocator.addEditObj.editStatus)
	{
		var shipping_id:Number = Number(__localModel.addEditObj.record.children()[0].id.toString());
		if(shipping_id>0)
		{
			Application.application.enabled = false;
			CursorManager.setBusyCursor();
			
			
			var generatePackageSlip:HTTPService 	= dataService(__service.getHTTPService("genratePackageSlip"));
			__generatePackageSlip 					= new mx.rpc.Responder(generatePackageSlipResultHandler,generatePackageSlipHandler);
			var token:AsyncToken 					= generatePackageSlip.send(new XML(<params>
																							<id>{shipping_id}</id>
																						</params>));
			token.addResponder(__generatePackageSlip);
		}
		
	}
	else
	{
		Alert.show("Please Save Record Before Printing");
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
private function genrateUpsLabelClickHandler(event:MouseEvent):void
{
	if(__localModel.addEditObj.record != null && !__genModel.activeModelLocator.addEditObj.editStatus)
	{
		var shipping_id:Number = Number(__localModel.addEditObj.record.children()[0].id.toString());
		if(shipping_id>0)
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;
			
			var printjob:HTTPService 	= dataService(__service.getHTTPService("genrateUpsLabel"));
			__genrateUpsLabel 			= new mx.rpc.Responder(genrateUpsLabelResultHandler,genrateUpsLabelHandler);
			var token:AsyncToken 		= printjob.send(new XML(	<params>
																		<id>{shipping_id}</id>
																	</params>));
			token.addResponder(__genrateUpsLabel);
		}
		else
		{
			Alert.show("Please Save Record Before Printing");
		}
	}
	else
	{
		Alert.show("Please Save Record Before Printing UPS Label");
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
		openFile(resultFromUps);
	}
}

private function openFile(resultFromUps:XML):void
{
	var url:String 			= __genModel.path.ups_label  + resultFromUps.children()[0].toString()
	var request:URLRequest 	= new URLRequest(url);
	navigateToURL(request,'_self');
}
public function genrateUpsLabelHandler(event:FaultEvent):void
{
	Alert.show("Genrate package Slip"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
		
}
private function getShipDate():String
{
	if(dfShip_date.dataValue!='')
	{
		return dfShip_date.dataValue;
	}
	else
	{
		return dfEstimaedShip_date.dataValue;
	}
}
private function getInhandDate():Object
{
	if(dfShip_date.dataValue!='')
	{
		return dfInhand_date;
	}
	else
	{
		return dfEstimaedShip_date;
	}
}
private function getPackageXml():XML
{
	var column1Price:Number	 = 0.00;
	column1Price			 = Number(saveXml.children()[0].column1.toString());
	
	var tempXml:XML			= dtlPackage.dgDtl.rows.copy();
	for(var i:int=0;i<tempXml.children().length();i++)
	{
		tempXml.children()[i].insured_charge  = numericFormatter.format(Number(tempXml.children()[i].pcs_per_carton.toString())* column1Price);
	}
	return tempXml;
}
private function recalculateAmount():void
{
	var shipping_id:Number = Number(__localModel.addEditObj.record.children()[0].id.toString());
	if(shipping_id>0)
	{
		Application.application.enabled = false;
		
		var tempXml:XML			= new XML(<params>
																	<zip_code>{tiShip_zip.dataValue}</zip_code>
																	<country>{tiShip_country.dataValue}</country>
																	<shipping_code>{dcShipping_code.dataValue}</shipping_code>
																	<state>{tiShip_state.dataValue}</state>
																	<packagexml>{getPackageXml()}</packagexml>
																	<estimated_ship_date>{getShipDate()}</estimated_ship_date>
																	<catalog_item_id>{__localModel.addEditObj.record.children()[0].catalog_item_id.toString()}</catalog_item_id>
																	<company_id>{__genModel.user.id}</company_id>
																  </params>);
		
		var recalculateAmount:HTTPService 	= dataService(__service.getHTTPService("recalculateShipAmount"));
		__responder 					    = new mx.rpc.Responder(recalculateShipAmountResultHandler,recalculateShipAmountFaultHandler);
		var token:AsyncToken 				= recalculateAmount.send(tempXml);
		token.addResponder(__responder);
	}
	else
	{
		Alert.show("Please Save Record Before Printing");
	}

}
private function recalculateShipAmountResultHandler(event:ResultEvent):void
{
	Application.application.enabled = true;
	var resultXml:XML				 = XML(event.result);
	if(resultXml.name() == "errors")
	{
		if(resultXml.children().length() > 0) 
		{
			var message:String = '';
			
			for(var i:uint = 0; i < resultXml.children().length(); i++) 
			{
				message += resultXml.children()[i] + "\n";
			}
			Alert.show(message);
		} 
	}
	else
	{
		for(var j:int=0;j<resultXml.children().length();j++)
		{
			var xmllist:XMLList	= XMLList(resultXml.children()[j]).copy();
			if(xmllist.child('service_code').toString() ==	tiShipMethodCode.dataValue)
			{
				tiAmount.dataValue 			 = xmllist.price.toString();
			}
		}
		packageChangeFlag    = false;
	}
	
}

public function recalculateShipAmountFaultHandler(event:FaultEvent):void
{
	Alert.show("Recalculate Ship Amount"+event.fault.faultDetail);
	
	Application.application.enabled = true;
	
}
private function addPackageHandler(event:DetailEvent):void
{
	packageChangeFlag    = true;
}
private function removePackageHandler(event:DetailEvent):void
{
	packageChangeFlag    = true;
}