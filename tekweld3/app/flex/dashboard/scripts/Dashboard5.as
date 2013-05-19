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
	dgPreProductionNotApproved.structure  	    				= preProductionNotApprovedOrderListStr;
	dgEmbroideryArtworkNotReceived.structure    				= embroideryArtworkNotReceivedListStr;
	dgEmbroiderySendForEstimationRefresh.structure				= embroiderySendForEstimationListStr;
	dgEmbroideryWaitingForEstimationOrders.structure			= embroideryWaitingForEstimationOrdersListStr;
	
	getPreProductionNotApprovedOrders();
	getEmbroideryArtworkNotReceivedOrders();
	getEmbroiderySendForEstimationOrders();
	getEmbroideryWaitingForEstimationOrders();
}
private function getPreProductionNotApprovedOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getPreProductionNotApprovedOrders"));	
	__responder 					= new mx.rpc.Responder(getPreProductionNotApprovedOrdersResultHandler,getPreProductionNotApprovedOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}
private function getPreProductionNotApprovedOrdersResultHandler(event:ResultEvent):void
{
	dgPreProductionNotApproved.rows = XML(event.result); 
}
private function getPreProductionNotApprovedOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getEmbroideryArtworkNotReceivedOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getEmbroideryArtworkNotReceivedOrders"));	
	__responder 					= new mx.rpc.Responder(getEmbroideryArtworkNotReceivedOrdersResultHandler,getEmbroideryArtworkNotReceivedOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}
private function getEmbroideryArtworkNotReceivedOrdersResultHandler(event:ResultEvent):void
{
	dgEmbroideryArtworkNotReceived.rows	 = XML(event.result);
}
private function getEmbroideryArtworkNotReceivedOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}

private function getEmbroiderySendForEstimationOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getEmbroiderySendForEstimationOrders"));	
	__responder 					= new mx.rpc.Responder(getEmbroiderySendForEstimationOrdersResultHandler,getEmbroiderySendForEstimationOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}

private function getEmbroiderySendForEstimationOrdersResultHandler(event:ResultEvent):void
{
	dgEmbroiderySendForEstimationRefresh.rows   	= XML(event.result); 
}
private function getEmbroiderySendForEstimationOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getEmbroideryWaitingForEstimationOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getEmbroideryWaitingForEstimationOrders"));	
	__responder 					= new mx.rpc.Responder(getEmbroideryWaitingForEstimationOrdersResultHandler,getEmbroideryWaitingForEstimationOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}

private function getEmbroideryWaitingForEstimationOrdersResultHandler(event:ResultEvent):void
{
	dgEmbroideryWaitingForEstimationOrders.rows				= XML(event.result);
}
private function getEmbroideryWaitingForEstimationOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function addRefreshButton(btnId:String):void
{
	var btn:GenButton  	= new GenButton();
	btn.id				= btnId;
	btn.setStyle('icon' , refreshButtonIcon);
	btn.addEventListener(MouseEvent.CLICK,btnRefreshClickHandler);
	
	if(btnId.toUpperCase()=='BTNPREPRODUCTIONNOTAPPROVEDORDERREFRESH')
	{
		btwPreProductionNotApprovedOrderRefresh.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNEMBROIDERYARTWORKNOTRECEIVEDREFRESH')
	{
		btwEmbroideryArtworkNotReceivedRefresh.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNEMBROIDERYSENDFORESTIMATIONREFRESH')
	{
		btwEmbroiderySendForEstimationRefresh.titleBarContainer.addChild(btn);
	}
	else if(btnId.toUpperCase()=='BTNEMBROIDERYWAITINGFORESTIMATIONORDERS')
	{
		btwEmbroideryWaitingForEstimationOrders.titleBarContainer.addChild(btn);
	}
}
private function btnRefreshClickHandler(event:Event):void
{
	if(GenButton(event.target).id.toString().toUpperCase()=='BTNPREPRODUCTIONNOTAPPROVEDORDERREFRESH')
	{
		getPreProductionNotApprovedOrders();	
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNEMBROIDERYARTWORKNOTRECEIVEDREFRESH')
	{
		getEmbroideryArtworkNotReceivedOrders();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNEMBROIDERYSENDFORESTIMATIONREFRESH')
	{
		getEmbroiderySendForEstimationOrders();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNEMBROIDERYWAITINGFORESTIMATIONORDERS')
	{
		getEmbroideryWaitingForEstimationOrders();
	}
}