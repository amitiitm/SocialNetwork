import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.DataEntry;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.AddEditEvent;
import com.generic.events.GenTextInputEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;
import com.generic.customcomponents.GenButton;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.utils.Timer;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.core.Application;
import mx.events.ListEvent;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.productionorder.ProductionOrderModelLocator;
import prod.productionorder.components.ProductionOrder;

import saoi.muduleclasses.CommonMooduleFunctions;
import saoi.muduleclasses.GenNotesAttachmentIcon;
import saoi.muduleclasses.OptionsSetupChargeCalculation;
import saoi.muduleclasses.PrintObject;

public  var fileRef:FileReference = new FileReference();
public  var fileRefDown:FileReference = new FileReference();

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
[Bindable]
private var __localModel:ProductionOrderModelLocator = (ProductionOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
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
private var optionsSetupChargeCalculation:OptionsSetupChargeCalculation	= 	new OptionsSetupChargeCalculation();
private var resultXmlFromItem:XML = new XML();

[Embed("com/generic/assets/btn_print_pick_slip.png")]
private const printPickSlipButtonIcon:Class;
[Embed("com/generic/assets/btn_print_job.png")]
private const printJobButtonIcon:Class;

public function setMainImage(resultXml:XML):void
{

	if(resultXml.image_thumnail!='')
	main_image_name = resultXml.image_thumnail;
	else
	main_image_name = '';
	
}
							

private function init():void
{
	
	var btnPrintJobList:Button = new Button() ;	
	var btnPrintBarcodeDataEntry:Button 	= new Button() ;
	var btnPrintUPSLebelDataEntry:Button 	= new Button() ;
	
	
	btnPrintJobList.label	   					= "Print Job";
	btnPrintJobList.height 	   					= 20;
	btnPrintJobList.addEventListener(MouseEvent.CLICK,printJobOrderHandler);
	
	
	var btnPrintPickSlipDataEntry:GenButton        			= new GenButton();
	btnPrintPickSlipDataEntry.height							= 20;
	//btnPrintPickSlipDataEntry.label						= "Print Pick Slip";
	btnPrintPickSlipDataEntry.setStyle('icon' , printPickSlipButtonIcon);
	btnPrintPickSlipDataEntry.addEventListener(MouseEvent.CLICK,printPickSlipHandler);
	
	var btnPrintJobDataEntry:GenButton        		= new GenButton();
	btnPrintJobDataEntry.height						= 20;
	//btnPrintJobDataEntry.label					= "Print Job";
	btnPrintJobDataEntry.setStyle('icon' , printJobButtonIcon);
	btnPrintJobDataEntry.addEventListener(MouseEvent.CLICK,printJobOrderHandler);	
	
	
	btnPrintBarcodeDataEntry.label	   			= "Print PackageSlip";
	btnPrintBarcodeDataEntry.height 	   		= 20;
	btnPrintBarcodeDataEntry.addEventListener(MouseEvent.CLICK,printJobOrderHandler);
	
	btnPrintUPSLebelDataEntry.label	   			= "UPS Label";
	btnPrintUPSLebelDataEntry.height 	   		= 20;
	btnPrintUPSLebelDataEntry.addEventListener(MouseEvent.CLICK,printJobOrderHandler);
	
	ProductionOrder(this.parentDocument).bcpDataEntry.addChildAt(btnPrintJobDataEntry,4);
	ProductionOrder(this.parentDocument).bcpDataEntry.addChildAt(btnPrintPickSlipDataEntry,5);
	//ProductionOrder(this.parentDocument).bcpDataEntry.addChildAt(btnPrintBarcodeDataEntry,5);
	//ProductionOrder(this.parentDocument).bcpDataEntry.addChildAt(btnPrintUPSLebelDataEntry,6);
	
	//ProductionOrder(this.parentDocument).bcpList.addChildAt(btnPrintJobList,5);
	
	
	screenName = __genModel.tabMain.selectedChild.label;
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	__localModel.trans_date = dfTrans_date.text	
	getAccountPeriod();
	//setReorder();
	
	var refreshLabel:Label  = new Label();
	refreshLabel.name		= "refreshLabel";
	refreshLabel.text		= "this screen will automatically refresh within "+remainingTime.toString()+" sec.";
	refreshLabel.height     = 20;
	refreshLabel.setStyle("color","#356DCC");
	refreshLabel.setStyle("fontSize",11);
	refreshLabel.setStyle("fontWeight","bold");
	
	ProductionOrder(this.parentDocument).bcpList.addChild(refreshLabel);
	refreshTimer.addEventListener(TimerEvent.TIMER,refreshTimerPickHandler);
	remainTimer.addEventListener(TimerEvent.TIMER,remainTimerPickHandler);
	refreshTimer.start();
	remainTimer.start();

}
private function  printPickSlipHandler(event:MouseEvent):void
{
	new PrintObject().genratePickSlipHandler(new Object());
	
	
}
private function printPickSlipResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
	var request:URLRequest = new URLRequest(url);
	
	navigateToURL(request);
}
public function printPickSlipFaultHandler(event:FaultEvent):void
{
	Alert.show("printPickSlip#"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
private function  printJobOrderHandler(event:MouseEvent):void
{
	if(__localModel.addEditObj.record != null)
	{
		var orderId:Number = Number(__localModel.addEditObj.record.children()[0].id.toString());
		if(orderId>0)
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;
			
			var printjob:HTTPService = dataService(__service.getHTTPService("printJob"));
			__responderPrintJob = new mx.rpc.Responder(printJobResultHandler,printJobFaultHandler);
			var token:AsyncToken = printjob.send(new XML(<params>
															<id>{orderId}</id>
														</params>));
			token.addResponder(__responderPrintJob);
		}
		else
		{
			Alert.show("Please Save or Retrieve recoed");
		}
	}
	
		
}
private function printJobResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
	var request:URLRequest = new URLRequest(url);

	navigateToURL(request);
}
private function printJobFaultHandler(event:FaultEvent):void
{
	Alert.show("Print Job Sales Order" + " : " + event.fault.toString());
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
	var urlObj:URL	=	new URL();
	service.url		=	urlObj.getURL(service.url);
	service.resultFormat 		= "e4x";					
	service.method 				= "POST";
	service.useProxy			= false;
	service.contentType			="application/xml";
	service.requestTimeout	 	= 1800
	
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
	Alert.show("ArtworkApprovedCustomerManual"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}

private function remainTimerPickHandler(event:TimerEvent):void
{
	Label(ProductionOrder(this.parentDocument).bcpList.getChildByName("refreshLabel")).text =	"refresh within "+remainingTime.toString()+" sec."; ;
	remainingTime = remainingTime - 1;	
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	=	resultXml.child('code');
}

private function getCustomerDetails():void
{
	if(dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(customerDetailsHandler, null);
		
		getInformationEvent			=	new GetInformationEvent('customerdetail', callbacks, dcCustomer_id.dataValue, "I");
		getInformationEvent.dispatch();
		
		getCustomerShipping();
	}
}

private function getCustomerShipping():void
{
		var callbacksShipping:IResponder	=	new mx.rpc.Responder(customerShippingDetailsHandler, null);
		
		getInformationShippingEvent			=	new GetInformationEvent('customer_specific_shippings', callbacksShipping, dcCustomer_id.dataValue);
		getInformationShippingEvent.dispatch();  
}

private function customerDetailsHandler(resultXml:XML):void
{
	dcCustomer_id.dataValue		=	resultXml.children().child('id').toString();
	dcCustomer_id.labelValue	=	resultXml.children().child('code').toString();
	tiCustomer_code.dataValue	=	resultXml.children().child('code').toString();
	//setValue(resultXml);
}
private function customerShippingDetailsHandler(resultXml:XML):void
{
	//__localModel.customerShipping = resultXml;	
}


//--------------------------------------------------------------------------------
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML		= event.recordXml;
	saveXml					= event.recordXml.copy();
	
	if(recordXml.sales_order.trans_type.toString()!='E')
	{
		hbRef.visible = false;
		hbRef.includeInLayout = false;
	}
	else
	{
		hbRef.visible = true;
		hbRef.includeInLayout = true;
	}
	dcCustomer_id.enabled	=	false;
	
	var xml:XML  = XML(recordXml.sales_order.sales_order_lines);
	var xmlArtwork:XML  = XML(recordXml.sales_order.sales_order_artworks);
	
	setArtworkPoDetail(xmlArtwork.copy());
	for(var i:int=0;i<xml.children().length();i++)
	{
		var lineType:String = xml.children()[i].line_type.toString();
		var itemType:String = xml.children()[i].item_type.toString();
		
		if(lineType=='M')
		{
			setMainitem(xml.children()[i]);
		}
	}
	__localModel.artwork_dept_email	= recordXml.sales_order.artwork_dept_email.toString();
	__localModel.trans_no  = recordXml.sales_order.trans_no.toString();
	__localModel.trans_date = dfTrans_date.text
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
}
private function setMainitem(linesXml:XML):void
{
	dcItemId.dataValue 					= linesXml.catalog_item_id.toString();
	dcItemId.labelValue					= linesXml.catalog_item_code.toString();
	tiQty.dataValue 					= linesXml.item_qty.toString();
	taItemDescription.dataValue 		= linesXml.item_description.toString();
	tiType.dataValue 					= linesXml.item_type.toString();
	main_image_name 					= linesXml.image_thumnail.toString();
	tiPrice.dataValue					= linesXml.item_price.toString();
	tiMainId.dataValue					= linesXml.id.toString();
	tiMainLockVersion.dataValue			= linesXml.lock_version.toString();	 

	new CommonMooduleFunctions().setDisableOptions(vbMain,XML(saveXml.children()[0].sales_order_attributes_values).copy());
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{

	getAccountPeriod();

	dcCustomer_id.enabled	=	true;
	
	__localModel.trans_date = dfTrans_date.text
	__localModel.trans_no	= '';
	__localModel.artwork_dept_email	= '';
}

private function downloadHandler():void
{
	if(tiFileName.text == '' || tiFileName.text==null)
	{
		Alert.show("Please Select Artwork");
	}
	else
	{
		var urlObj:URL	=	new URL();
		var url:String  =	__genModel.path.attachment+tiFileName.text;
		var _request:URLRequest = new URLRequest(url);            
		_request.method = URLRequestMethod.GET;
		fileRefDown.addEventListener(Event.OPEN,openHandler);
		fileRefDown.addEventListener(Event.COMPLETE,downloadCompletehandler);
	  	try
	  	{
	  	 	fileRefDown.download(_request);
	  	}
	 	catch (error:Error)
		{
	    	Alert.show("Unable to download file.");
		}
	}
	
   
}

private function openHandler(event:Event):void
{
	//Alert.show("downlaod start");
}

private function downloadCompletehandler(event:Event):void
{
	Alert.show("Download Complete");
}
private function viewArtworkHandler():void
{
	if(tiFileName.text == '' || tiFileName.text==null)
	{
		Alert.show("Please Select Artwork");
	}
	else
	{
		var url:String  =	__genModel.path.attachment+tiFileName.text;
		var _requestViewUrl:URLRequest = new URLRequest(url);
		navigateToURL(_requestViewUrl); 
	}
	
}
private function setArtworkPoDetail(xml:XML):void
{	
	tiFileName.dataValue	 	= tiFileName.defaultValue;
	tiComment.dataValue			= tiComment.defaultValue;
	cbVersion.dataValue			= cbVersion.defaultValue;
	
	for(var i:int = 0 ; i < xml.children().length(); i++)
	{
		var final_artwork_flag:String  	= xml.children()[i]['final_artwork_flag'].toString();
		if(final_artwork_flag=='Y')
		{
			tiFileName.dataValue	 	= xml.children()[i].artwork_file_name.toString();
			tiComment.dataValue			= xml.children()[i].comment.toString();
			cbVersion.dataValue			= xml.children()[i].artwork_version.toString();
		}
	}
	
}
private function showItemDetail():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.openItemDetail(resultXmlFromItem,DataEntry(this.parentDocument));
}
