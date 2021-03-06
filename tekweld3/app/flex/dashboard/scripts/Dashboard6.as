// ActionScript file
import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.GenModuleEvent;
import com.generic.genclass.URL;

import dashboard.DashboardModelLocator;
import dashboard.DashboardServices;

import flash.events.Event;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.DateField;
import mx.events.FlexEvent;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

private var __responder:IResponder;

[Bindable]
private var __genModel:GenModelLocator  = GenModelLocator.getInstance();
private var __service:ServiceLocator    = new DashboardServices();

[Embed("com/generic/assets/refresh.png")]
private const refreshButtonIcon:Class;

public function dataService(service:HTTPService):HTTPService
{
	var urlObj:URL				=	new URL();
	service.url					=	urlObj.getURL(service.url);
	service.resultFormat 		= "e4x";					
	service.method 				= "POST";
	service.useProxy			= false;
	service.contentType			="application/xml";
	service.requestTimeout	 	= 1800
	service.showBusyCursor		= true	
	return service;
}

protected function module1_creationCompleteHandler(event:FlexEvent):void
{
	dgEmbroideryStitchNotApprovedOrderRefresh.structure  	    		= embroideryStitchNotApprovedOrder;
	dgEmbroiderySendToDigitizedOrderRefresh.structure    				= embroiderySendToDigitizedOrderListStr;
	dgFilmInboxRefresh.structure										= filmInboxListStr;
	dgDirectPrintInboxOrdersRefresh.structure							= directPrintInboxOrdersListStr;
	
	getEmbroideryStitchNotApprovedOrders();
	getEmbroiderySendToDigitizedOrders();
	getFilmInboxOrders();
	getDirectPrintInboxOrders();
}
private function getEmbroideryStitchNotApprovedOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getEmbroideryStitchNotApprovedOrders"));	
	__responder 					= new mx.rpc.Responder(getEmbroideryStitchNotApprovedOrdersResultHandler,getEmbroideryStitchNotApprovedOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}
private function getEmbroideryStitchNotApprovedOrdersResultHandler(event:ResultEvent):void
{
	dgEmbroideryStitchNotApprovedOrderRefresh.rows = XML(event.result); 
}
private function getEmbroideryStitchNotApprovedOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getEmbroiderySendToDigitizedOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getEmbroiderySendToDigitizedOrders"));	
	__responder 					= new mx.rpc.Responder(getEmbroiderySendToDigitizedOrdersResultHandler,getEmbroiderySendToDigitizedOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}
private function getEmbroiderySendToDigitizedOrdersResultHandler(event:ResultEvent):void
{
	dgEmbroiderySendToDigitizedOrderRefresh.rows	 = XML(event.result);
}
private function getEmbroiderySendToDigitizedOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}

private function getFilmInboxOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getFilmInboxOrders"));	
	__responder 					= new mx.rpc.Responder(getFilmInboxOrdersResultHandler,getFilmInboxOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}

private function getFilmInboxOrdersResultHandler(event:ResultEvent):void
{
	dgFilmInboxRefresh.rows   	= XML(event.result); 
}
private function getFilmInboxOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getDirectPrintInboxOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getDirectPrintInboxOrders"));	
	__responder 					= new mx.rpc.Responder(getDirectPrintInboxOrdersResultHandler,getDirectPrintInboxOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}

private function getDirectPrintInboxOrdersResultHandler(event:ResultEvent):void
{
	dgDirectPrintInboxOrdersRefresh.rows				= XML(event.result);
}
private function getDirectPrintInboxOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function addRefreshButton(btnId:String):void
{
	var btn:GenButton  	= new GenButton();
	btn.id				= btnId;
	btn.setStyle('icon' , refreshButtonIcon);
	btn.addEventListener(MouseEvent.CLICK,btnRefreshClickHandler);
	
	if(btnId.toUpperCase()=='BTNEMBROIDERYSTITCHNOTAPPROVEDORDERREFRESH')
	{
		btwEmbroideryStitchNotApprovedOrderRefresh.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNEMBROIDERYSENDTODIGITIZEDORDERREFRESH')
	{
		btwEmbroiderySendToDigitizedOrderRefresh.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNFILMINBOXREFRESH')
	{
		btwFilmInboxRefresh.titleBarContainer.addChild(btn);
	}
	else if(btnId.toUpperCase()=='BTNDIRECTPRINTINBOXORDERSREFRESH')
	{
		btwDirectPrintInboxOrdersRefresh.titleBarContainer.addChild(btn);
	}
}
private function btnRefreshClickHandler(event:Event):void
{
	if(GenButton(event.target).id.toString().toUpperCase()=='BTNEMBROIDERYSTITCHNOTAPPROVEDORDERREFRESH')
	{
		getEmbroideryStitchNotApprovedOrders();	
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNEMBROIDERYSENDTODIGITIZEDORDERREFRESH')
	{
		getEmbroiderySendToDigitizedOrders();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNFILMINBOXREFRESH')
	{
		getFilmInboxOrders();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNDIRECTPRINTINBOXORDERSREFRESH')
	{
		getDirectPrintInboxOrders();
	}
}