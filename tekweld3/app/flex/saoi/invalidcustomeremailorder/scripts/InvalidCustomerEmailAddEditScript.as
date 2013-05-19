import business.events.RefreshEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.InboxEvent;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flash.events.TimerEvent;
import flash.utils.Timer;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.Label;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.invalidcustomeremailorder.InvalidCustomerEmailModelLocator;
import saoi.invalidcustomeremailorder.components.InvalidCustomerEmail;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:InvalidCustomerEmailModelLocator  =  InvalidCustomerEmailModelLocator(__genModel.activeModelLocator);
private var __responderPick:IResponder;
private var __refreshList:IResponder;
private var refreshEvent:RefreshEvent;		
private var __service:ServiceLocator = __genModel.services;
private var drillIndex:int;
private var drillXml:XML	=	 new XML(		<rows>
													<row>InvalidCustomerEmail</row>
												</rows>);
public var refreshTimer:Timer  = new Timer(__genModel.screenRefreshTimeInterval);
public var remainTimer:Timer  = new Timer(1000);
[Bindable]
public var remainingTime:int=(__genModel.screenRefreshTimeInterval)/1000;
private function init():void
{
	
	var refreshLabel:Label  = new Label();
	refreshLabel.name		= "refreshLabel";
	refreshLabel.text		= "this screen will automatically refresh within "+remainingTime.toString()+" sec.";
	refreshLabel.height     = 20;
	refreshLabel.setStyle("color","#356DCC");
	refreshLabel.setStyle("fontSize",11);
	refreshLabel.setStyle("fontWeight","bold");
	
	InvalidCustomerEmail(this.parentDocument).bcp.addChild(refreshLabel);
	refreshTimer.addEventListener(TimerEvent.TIMER,refreshTimerPickHandler);
	remainTimer.addEventListener(TimerEvent.TIMER,remainTimerPickHandler);
	refreshTimer.start();
	remainTimer.start();
}
private function refreshTimerPickHandler(event:TimerEvent):void
{
	var tabpage:TabPage =  new TabPage();
	var index:int = tabpage.searchTabPage("Qc Order");
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
private function remainTimerPickHandler(event:TimerEvent):void
{
	Label(InvalidCustomerEmail(this.parentDocument).bcp.getChildByName("refreshLabel")).text =	"this screen will automatically refresh within "+remainingTime.toString()+" sec."; ;
	remainingTime = remainingTime - 1;	
}
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
	var utilityObj:Utility				=	new Utility();
	resultXML 							= 	utilityObj.getDecodedXML((XML)(event.result));
	
	__localModel.listObj.rows 			= new XML(resultXML);   	
	__localModel.listObj.filteredList 	= new XML(resultXML);
	
	CursorManager.removeBusyCursor();
}
public function refreshFaultHandler(event:FaultEvent):void
{
	Alert.show("Refreshorder"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
}
public function pickFaultHandler(event:FaultEvent):void
{
	Alert.show("InvalidCustomerEmail"+event.fault.faultDetail.toString());
	
	CursorManager.removeBusyCursor();
}
