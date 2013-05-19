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
[Bindable]
private var top10Customers:XML;

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
	dgArtworkNotApproved.structure  	    = artworkNotApprovedListStr;
	dgArtworkNotReceived.structure    		= artworkNotReceivedListStr;
	dgPaymentHoldOrder.structure			= paymentHoldOrderListStr;
	//dgTop10Customers.structure				= top10CustomersListStr;
	
	getArtworkNotReceivedOrders();
	getArtworkNotApprovedOrders();
	getPaymentHoldOrders();
	getTop10Customers();
}
private function getArtworkNotReceivedOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getArtworkNotReceivedOrders"));	
	__responder 					= new mx.rpc.Responder(getArtworkNotReceivedOrdersResultHandler,getArtworkNotReceivedOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}
private function getArtworkNotReceivedOrdersResultHandler(event:ResultEvent):void
{
	dgArtworkNotReceived.rows   	= XML(event.result); 
}
private function getArtworkNotReceivedOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getArtworkNotApprovedOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getArtworkNotApprovedOrders"));	
	__responder 					= new mx.rpc.Responder(getArtworkNotApprovedOrdersResultHandler,getArtworkNotApprovedOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}
private function getArtworkNotApprovedOrdersResultHandler(event:ResultEvent):void
{
	dgArtworkNotApproved.rows	 = XML(event.result);
}
private function getArtworkNotApprovedOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}

private function getPaymentHoldOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getPaymentHoldOrders"));	
	__responder 					= new mx.rpc.Responder(getPaymentHoldOrdersResultHandler,getPaymentHoldOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}

private function getPaymentHoldOrdersResultHandler(event:ResultEvent):void
{
	dgPaymentHoldOrder.rows   	= XML(event.result); 
}
private function getPaymentHoldOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getTop10Customers():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getTop10Customers"));	
	__responder 					= new mx.rpc.Responder(getTop10CustomersResultHandler,getTop10CustomersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}

private function getTop10CustomersResultHandler(event:ResultEvent):void
{
	//dgTop10Customers.rows   	= XML(event.result);
	top10Customers				= XML(event.result);
}
private function getTop10CustomersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function addRefreshButton(btnId:String):void
{
	var btn:GenButton  	= new GenButton();
	btn.id				= btnId;
	btn.setStyle('icon' , refreshButtonIcon);
	btn.addEventListener(MouseEvent.CLICK,btnRefreshClickHandler);
	
	if(btnId.toUpperCase()=='BTNPAYMENTHOLDORDERREFRESH')
	{
		btwPaymentHoldOrderRefresh.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNARTWORKNOTRECEIVEDREFRESH')
	{
		btwArtworkNotReceivedRefresh.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNARTWORKNOTAPPROVEDREFRESH')
	{
		btwArtworkNotApprovedRefresh.titleBarContainer.addChild(btn);
	}
	else if(btnId.toUpperCase()=='BTNTOP10CUSTOMERS')
	{
		btwTop10Customers.titleBarContainer.addChild(btn);
	}
}
private function btnRefreshClickHandler(event:Event):void
{
	if(GenButton(event.target).id.toString().toUpperCase()=='BTNPAYMENTHOLDORDERREFRESH')
	{
		getPaymentHoldOrders();	
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNARTWORKNOTRECEIVEDREFRESH')
	{
		getArtworkNotReceivedOrders();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNARTWORKNOTAPPROVEDREFRESH')
	{
		getArtworkNotApprovedOrders();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNTOP10CUSTOMERS')
	{
		getTop10Customers();
	}
}