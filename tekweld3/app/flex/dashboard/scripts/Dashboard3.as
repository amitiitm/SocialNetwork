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
private var __responderStages:IResponder;
private var __responderProductionType:IResponder;
private var __responderTodayShip:IResponder;
private var __responderTomorrowShip:IResponder;

[Bindable]
public var search_type:XML        		= new XML(<rows>
<row>
<label>Order #</label>
<value>trans_no</value>
</row>
<row>
<label>Customer #</label>
<value>customer_code</value>
</row>
<row>
<label>Customer PO #</label>
<value>ext_ref_no</value>
</row>
<row>
<label>Item #</label>
<value>catalog_item_code</value>
</row>
</rows>);

[Bindable]
public var artwork_query_total:String   = '';
[Bindable]
public var order_query_total:String		= '';
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
	dgTop10SellingItem.structure  	    = top10SellingItemListStr;
	dgListOutOfStockOrders.structure    = outOfStockOrderListStr;
	dgListOutOfStockItems.structure		= outOfStockItemListStr;
	dgArtworkQuery.structure			= artworkQueryListStr;
	dgOrderQuery.structure				= orderQueryListStr;
	
	getTop10SellingItem();
	getOutOfStockOrders();
	getOutOfStockItems();
	getOrderQuery();
	getArtworkQuery();
}
private function getTop10SellingItem():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("listTop10SellingItem"));	
	__responderProductionType 		= new mx.rpc.Responder(getTop10SellingItemResultHandler,getTop10SellingItemFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responderProductionType);
}
private function getTop10SellingItemResultHandler(event:ResultEvent):void
{
	dgTop10SellingItem.rows   	= XML(event.result); 
}
private function getTop10SellingItemFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}

private function btnRefreshClickHandler(event:Event):void
{
	if(GenButton(event.target).id.toString().toUpperCase()=='BTNTOP10SELLINGITEMREFRESH')
	{
		getTop10SellingItem();	
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNQUERYTYPECOUNTREFRESH')
	{
		getOrderQuery();
		getArtworkQuery();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNLISTOUTOFSTOCKORDERSREFRESH')
	{
		getOutOfStockOrders();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNLISTOUTOFSTOCKITEMREFRESH')
	{
		getOutOfStockItems();
	}
}
private function getOutOfStockOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("listOutOfStockOrder"));	
	__responderProductionType 		= new mx.rpc.Responder(getOutOfStockOrdersResultHandler,getOutOfStockOrdersFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responderProductionType);
}

private function getOutOfStockOrdersResultHandler(event:ResultEvent):void
{
	dgListOutOfStockOrders.rows   	= XML(event.result); 
}
private function getOutOfStockOrdersFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getOutOfStockItems():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("listOutOfStockItems"));	
	__responderProductionType 		= new mx.rpc.Responder(getOutOfStockItemsResultHandler,getOutOfStockItemsFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responderProductionType);
}

private function getOutOfStockItemsResultHandler(event:ResultEvent):void
{
	dgListOutOfStockItems.rows   	= XML(event.result); 
}
private function getOutOfStockItemsFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function addRefreshButton(btnId:String):void
{
	var btn:GenButton  	= new GenButton();
	btn.id				= btnId;
	btn.setStyle('icon' , refreshButtonIcon);
	btn.addEventListener(MouseEvent.CLICK,btnRefreshClickHandler);
	
	if(btnId.toUpperCase()=='BTNTOP10SELLINGITEMREFRESH')
	{
		btwTop10SellingItemRefresh.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNQUERYTYPECOUNTREFRESH')
	{
		btwQueryTypeCountRefresh.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNLISTOUTOFSTOCKORDERSREFRESH')
	{
		btwOutOfStockOrderRefresh.titleBarContainer.addChild(btn);
	}
	else if(btnId.toUpperCase()=='BTNLISTOUTOFSTOCKITEMREFRESH')
	{
		btwOutofStockItem.titleBarContainer.addChild(btn);
	}
}
private function getOrderQuery():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getOrderQuery"));	
	__responder 					= new mx.rpc.Responder(getOrderQueryResultHandler,getOrderQueryFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}

private function getOrderQueryResultHandler(event:ResultEvent):void
{
	dgOrderQuery.rows   	= XML(event.result);
	hbOrderQuery.label		= "Order Query"+" ("+dgOrderQuery.rows.children().length()+" )";
}
private function getOrderQueryFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getArtworkQuery():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("getArtworkQuery"));	
	__responder 					= new mx.rpc.Responder(getArtworkQueryResultHandler,getArtworkQueryFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responder);
}

private function getArtworkQueryResultHandler(event:ResultEvent):void
{
	dgArtworkQuery.rows   		= XML(event.result);
	hbArtworkQuery.label		= "Artwork Query"+" ("+dgArtworkQuery.rows.children().length()+" )";
}
private function getArtworkQueryFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
