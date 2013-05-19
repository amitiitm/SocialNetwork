import business.events.GetInformationEvent;
import business.events.PreSaveEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.DataEntry;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.utils.Timer;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.Label;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.DataGridEvent;
import mx.formatters.DateFormatter;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.muduleclasses.GenNotesAttachmentIcon;
import saoi.muduleclasses.event.MissingInfoEvent;
import saoi.sendmultipleartworktocustomer.SendMultipleArtworkToCustomerModelLocator;
import saoi.sendmultipleartworktocustomer.components.PopUpViewer;
import saoi.sendmultipleartworktocustomer.components.SendMultipleArtworkToCustomer;

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
[Bindable]
private var __localModel:SendMultipleArtworkToCustomerModelLocator = (SendMultipleArtworkToCustomerModelLocator)(GenModelLocator.getInstance().activeModelLocator);
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
[Bindable]
public var remainingTime:int=(__genModel.screenRefreshTimeInterval)/1000;
private var shipping_detail:GetInformationEvent;

private var optionXmlAfterSave:XML;

private var saveXml:XML;
private var screenName:String = '';
private var isMissingInfoSave:Boolean	=	false;
private var missingInfoWindow:PopUpViewer;
private var preSaveEvent:PreSaveEvent;

//private const str1:String = "Please acknowledge the artworks";
//private const str2:String = "Sample Text2";
//private const str3:String = "Sample Text3";
//private const str4:String = "Sample Text4";
//private const str5:String = "Sample Text5";
//private const str6:String = "Sample Text6";



private const str1:String = __genModel.masterData.child('artwork_send_proof').text1.value.toString();
private const str2:String = __genModel.masterData.child('artwork_send_proof').text2.value.toString();
private const str3:String = __genModel.masterData.child('artwork_send_proof').text3.value.toString();
private const str4:String = __genModel.masterData.child('artwork_send_proof').text4.value.toString();
private const str5:String = __genModel.masterData.child('artwork_send_proof').text5.value.toString();
private const str6:String = __genModel.masterData.child('artwork_send_proof').text6.value.toString();

public function setMainImage(resultXml:XML):void
{

	if(resultXml.image_thumnail!='')
	main_image_name = resultXml.image_thumnail;
	else
	main_image_name = '';
	
}

public function setMessage():void
{
	var tempStr:String='';
	
	if(cbCheckArtwork1.dataValue=='Y')
		tempStr=tempStr+str1+"\n";
	
	if(cbCheckArtwork2.dataValue=='Y')
		tempStr=tempStr+str2+"\n";
	
	if(cbCheckArtwork3.dataValue=='Y')
		tempStr=tempStr+str3+"\n";
	
	if(cbCheckArtwork4.dataValue=='Y')
		tempStr=tempStr+str4+"\n";
	
	if(cbCheckArtwork5.dataValue=='Y')
		tempStr=tempStr+str5+"\n";
	
	if(cbCheckArtwork6.dataValue=='Y')
		tempStr=tempStr+str6+"\n";
	
	tiComment.dataValue=tempStr;
}
							

private function init():void
{
	screenName = __genModel.tabMain.selectedChild.label;
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	__localModel.trans_date = dfTrans_date.text	
	getAccountPeriod();
	
	dtlItem.bcdp.visible			= false;
	dtlItem.bcdp.includeInLayout	= false;
	tnDetail.selectedIndex			= 1;
	
	dtlQueries.bcdp.visible			= false;
	dtlQueries.bcdp.includeInLayout	= false;
	
	var refreshLabel:Label  = new Label();
	refreshLabel.name		= "refreshLabel";
	refreshLabel.text		= "this screen will automatically refresh within "+remainingTime.toString()+" sec.";
	refreshLabel.height     = 20;
	refreshLabel.setStyle("color","#356DCC");
	refreshLabel.setStyle("fontSize",11);
	refreshLabel.setStyle("fontWeight","bold");
	
	SendMultipleArtworkToCustomer(this.parentDocument).bcpList.addChild(refreshLabel);
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
	Alert.show("ReviewArtwork"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
}

private function remainTimerPickHandler(event:TimerEvent):void
{
	Label(SendMultipleArtworkToCustomer(this.parentDocument).bcpList.getChildByName("refreshLabel")).text =	"refresh within "+remainingTime.toString()+" sec."; ;
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
	tiCustomerCode.dataValue		= dcCustomer_id.labelValue;
	__localModel.customer_id		= dcCustomer_id.dataValue;
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	var recordXml:XML		= event.recordXml;
	saveXml					= event.recordXml.copy();
	
	dcCustomer_id.enabled	=	false;
	if(tiMailTo.dataValue=='')
	{
		tiMailTo.dataValue		= recordXml.sales_order.artwork_dept_email.toString();
	}
	__localModel.customer_id= dcCustomer_id.dataValue;
	tiSubject.dataValue		= "TEKWELD Cust PO #"+ recordXml.sales_order.ext_ref_no.toString();
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
}
override protected function resetObjectEventHandler():void   //on add buttton press,
{

	getAccountPeriod();

	dcCustomer_id.enabled	=	true;
	
	__localModel.trans_date = dfTrans_date.text
	__localModel.trans_no	= '';
	__localModel.ext_ref_no	= '';
	__localModel.artwork_dept_email	= '';
	__localModel.customer_id			= dcCustomer_id.dataValue;
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
}


override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var returnValue:int    = 0;
	
	if(!isAnyArtworkSelected())
	{
		Alert.show("Please Select Atleast One Artwork");
		returnValue =  -1;
	}
	
	return returnValue;
}
private function isAnyArtworkSelected():Boolean
{
	var dgXml:XMLList  = dgArtwork.rows.(trans_flag='A');
	var returnValue:Boolean = false;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var select_yn:String  = dgXml.children()[i]['select_yn'].toString();
		if(select_yn.toUpperCase()=='Y')
		{
			returnValue = true;
			break;
		}
	}
	return returnValue;
}
private function selectRow():void
{		 
	
	if(dgArtwork.selectedRow.select_yn == 	 'Y')
	{
		dgArtwork.selectedRow.select_yn = 	 'N'
	}
	else
	{
		dgArtwork.selectedRow.select_yn = 	 'Y'
	}
	
	
	dgArtwork.dispatchEvent(new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT));
	
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();
}
private function getArtworkId():void
{
	var index:int  = getSelectedIndex();
	if(index>=0)
	{
		var artwork_id:String  = dgArtwork.rows.children()[index].id.toString();
		clickAttchmentPreview(artwork_id);	
	}
	else
	{
		Alert.show("Please Select one Artwork For Preview");
	}
}
private function getSelectedIndex():int
{
	var xml:XML	= dgArtwork.rows.copy();
	var count:int=0;
	var index:int=-1;
	for(var i:int=0;i<xml.children().length();i++ )
	{
		if(xml.children()[i].select_yn.toString()=='Y')
		{
			index  = i;
			++count;
		}
	}
	if(count==1)
	{
		return  index;
	}
	else
	{
		return -1;
	}
}
private function clickAttchmentPreview(artwork_id:String):void
{
	CursorManager.setBusyCursor();
	
	var callbacks:IResponder = new mx.rpc.Responder(getAttchmentPreviewMethodsHandler, null);
	
	getInformationEvent	=	new GetInformationEvent('preview_artwork_ack', callbacks,artwork_id);
	getInformationEvent.dispatch(); 
}
private function getAttchmentPreviewMethodsHandler(resultXml:XML):void
{
	CursorManager.removeBusyCursor();
	
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
		var url:String 				= __genModel.path.report_print  + resultXml["result"].toString()
		var request:URLRequest 		= new URLRequest(url);
		navigateToURL(request);
	}
	
}
private function setQueryDateLavelFunction():void
{
	while(true)
	{
		if(dtlQueries.dgDtl.columns.length>0)
		{
			DataGridColumn(dtlQueries.dgDtl.columns[2]).labelFunction = dateFunc;
			break;
		}
	}
	
}
private function dateFunc(item:Object, column:DataGridColumn):String
{
	var dateFormatter:DateFormatter = new DateFormatter();
	var date_format:String = GenModelLocator.getInstance().user.date_format.toLocaleUpperCase();
	
	if(date_format == null || date_format == "")
	{
		dateFormatter.formatString = 'MM/DD/YYYY H:NN:SS';
	}
	else
	{
		dateFormatter.formatString = 'MM/DD/YYYY H:NN:SS';
	}
	
	return dateFormatter.format(item[column.dataField].toString());
}
private function setActivityDateLavelFunction():void
{
	while(true)
	{
		if(dgActivityLines.columns.length>0)
		{
			DataGridColumn(dgActivityLines.columns[0]).labelFunction = dateFunc;
			break;
		}
	}
	
}
