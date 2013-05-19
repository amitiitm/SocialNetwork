// ActionScript file
import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.GenModuleEvent;
import com.generic.genclass.URL;

import dashboard.DashboardServices;

import flash.events.Event;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DateField;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

private var __responderStages:IResponder;
private var __responderProductionType:IResponder;
private var __responderTodayShip:IResponder;
private var __responderTomorrowShip:IResponder;
[Bindable]
public var order_stages_count:XML       = new XML();
[Bindable]
public var production_type_count:XML    = new XML();
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
	service.showBusyCursor		= true;	
	
	return service;
}

protected function module1_creationCompleteHandler(event:FlexEvent):void
{
	dgTodayShipMent.structure   	= todaysShipment;
	dgTomorrowShipMent.structure	= tomorrowShipment;
	
	getOrderStageCount();
	getProductionTypeCount();
	
	getTodayShipment();
	getTomorrowShipment();
}

private function getProductionTypeCount():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("productionType"));
	__responderProductionType 		= new mx.rpc.Responder(getProductionTypeCountResultHandler,getProductionTypeCountFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responderProductionType);
}
private function getProductionTypeCountResultHandler(event:ResultEvent):void
{
	production_type_count  = XML(event.result); 
}
private function getProductionTypeCountFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getOrderStageCount():void
{
	var service:HTTPService 	= dataService(__service.getHTTPService("orderActivity"));
	__responderStages 			= new mx.rpc.Responder(stageResultHandler,stageFaultHandler);
	var token:AsyncToken 		= service.send(new XML());
	token.addResponder(__responderStages);
}
private function stageResultHandler(event:ResultEvent):void
{
	order_stages_count  = XML(event.result); 
}
private function stageFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getTodayShipment():void
{
	var service:HTTPService 	= dataService(__service.getHTTPService("todaysShipment"));
	__responderTodayShip 		= new mx.rpc.Responder(todayShipmentResultHandler,todayShipmentFaultHandler);
	var token:AsyncToken 		= service.send(new XML());
	token.addResponder(__responderTodayShip);
}
private function todayShipmentResultHandler(event:ResultEvent):void
{
	var result:XML  			  	 = XML(event.result); 
	dgTodayShipMent.rows  	 		 = result;
}
private function todayShipmentFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getTomorrowShipment():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("tomorrowShipment"));
	__responderTomorrowShip 		= new mx.rpc.Responder(tomorrowShipmentResultHandler,tomorrowShipmentFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responderTomorrowShip);
}
private function tomorrowShipmentResultHandler(event:ResultEvent):void
{
	var result:XML  			  	 = XML(event.result); 
	dgTomorrowShipMent.rows  		 = result;
}
private function tomorrowShipmentFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function btnRefreshClickHandler(event:Event):void
{
	if(GenButton(event.target).id.toString().toUpperCase()=='BTNORDERSTAGEREFRESH')
	{
		getOrderStageCount();	
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNPRODUCTIONTYPEREFRESH')
	{
		getProductionTypeCount();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNTODAYSSHIPMENTREFRESH')
	{
		getTodayShipment();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNTOMORROWSHIPMENTREFRESH')
	{
		getTomorrowShipment();
	}
}
private function addRefreshButton(btnId:String):void
{
	var btn:GenButton  	= new GenButton();
	btn.id				= btnId;
	btn.setStyle('icon' , refreshButtonIcon);
	btn.addEventListener(MouseEvent.CLICK,btnRefreshClickHandler);
	if(btnId.toUpperCase()=='BTNORDERSTAGEREFRESH')
	{
		btwOrderStageCount.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNPRODUCTIONTYPEREFRESH')
	{
		btwProductionType.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNTODAYSSHIPMENTREFRESH')
	{
		btwTodaysShipment.titleBarContainer.addChild(btn);
	}
	else if(btnId.toUpperCase()=='BTNTOMORROWSHIPMENTREFRESH')
	{
		btwTomorrowShipment.titleBarContainer.addChild(btn);
	}
	
	
}