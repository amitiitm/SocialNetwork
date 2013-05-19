// ActionScript file
import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.GenModuleEvent;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;

import dashboard.DashboardModelLocator;
import dashboard.DashboardServices;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DateField;
import mx.events.FlexEvent;
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
public var search_type:XML        		= new XML(<rows>
<row>
<label>Customer PO #</label>
<value>ext_ref_no</value>
</row>
<row>
<label>Order #</label>
<value>trans_no</value>
</row>
<row>
<label>Customer #</label>
<value>customer_code</value>
</row>
<row>
<label>Item #</label>
<value>catalog_item_code</value>
</row>
<row>
<label>Tracking #</label>
<value>tracking_no</value>
</row>
<row>
<label>Workflow Location</label>
<value>workflow_location</value>
</row>
<row>
<label>Logo</label>
<value>logo_name</value>
</row>
<row>
<label>Estimate #</label>
<value>estimate_no</value>
</row>	
	
</rows>);

[Bindable]
public var query__type_total:XML        = new XML();
[Bindable]
public var order_type_total:XML		    = new XML();
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
	dgRushOrderList.structure       = rushOrderListStr;
	dgTop10OrderbyAmount.structure  = top10OrderbyAmountListStr;
	dgGenericSearch.structure		= genericSearch;
	
	getOrderTypeTotalCount();
	getRushOrders();
	getTop10OrderByAmount();
}
private function getTop10OrderByAmount():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("listTop10Amount"));	
	__responderProductionType 		= new mx.rpc.Responder(getTop10OrderByAmountResultHandler,getTop10OrderByAmountFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responderProductionType);
}
private function getTop10OrderByAmountResultHandler(event:ResultEvent):void
{
	dgTop10OrderbyAmount.rows   	= XML(event.result); 
}
private function getTop10OrderByAmountFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getOrderTypeTotalCount():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("orderTypeCount"));	
	__responderProductionType 		= new mx.rpc.Responder(getOrderTypeTotalCountResultHandler,getOrderTypeTotalCountFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responderProductionType);
}
private function getOrderTypeTotalCountResultHandler(event:ResultEvent):void
{
	order_type_total  		   = XML(event.result); 
}
private function getOrderTypeTotalCountFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function getRushOrders():void
{
	var service:HTTPService 		= dataService(__service.getHTTPService("listRushOrder"));	
	__responderProductionType 		= new mx.rpc.Responder(getRushOrdersTotalCountResultHandler,getRushOrdersTotalCountFaultHandler);
	var token:AsyncToken 			= service.send(new XML());
	token.addResponder(__responderProductionType);
}
private function getRushOrdersTotalCountResultHandler(event:ResultEvent):void
{
	dgRushOrderList.rows   		   = XML(event.result); 
}
private function getRushOrdersTotalCountFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function findOrderBy(event:KeyboardEvent):void
{
	if(event.keyCode==Keyboard.ENTER)
	{
		goClickHandler();
	}
}
private function goClickHandler():void
{
	var search_value:String						= tiSearchValue.text;
	
	if(search_value!='')
	{
		var service:HTTPService 				= dataService(__service.getHTTPService("genericSearch"));	
		__responderProductionType 				= new mx.rpc.Responder(goClickResultHandler,goClickFaultHandler);
		var selected_search_type:String			= cbSearchType.selectedItem.value.toString();
		var tempXml:XML							= new XML(<params><search_type>{selected_search_type}</search_type><search_value>{search_value}</search_value></params>);
		var token:AsyncToken 					= service.send(new XML(tempXml));
		token.addResponder(__responderProductionType);
	}
	else
	{
		Alert.show("Enter search value.");
	}
	
}
private function goClickResultHandler(event:ResultEvent):void
{
	dgGenericSearch.rows	  		= XML(event.result); 
}
private function goClickFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
}
private function openOrderScreen():void
{
	var selectedXml:XML								=   XML(dgGenericSearch.selectedItem).copy();
	if(selectedXml.children().length()>0)
	{
		__genModel.drillObj.drillrow				=	XML(dgGenericSearch.selectedItem)
		var __localModel:DashboardModelLocator   	=   DashboardModelLocator(__genModel.activeModelLocator);
		
		if(__genModel.drillObj.drillrow.trans_type.toString()=='E')
		{
			__localModel.listObj.drilldown_component_code = "saoi/reorder/components/ReOrder.swf"	
		}
		else if(__genModel.drillObj.drillrow.trans_type.toString()=='S' || __genModel.drillObj.drillrow.trans_type.toString()=='F')
		{
			__localModel.listObj.drilldown_component_code = "saoi/salesorder/components/SalesOrder.swf"	
		}
		else if(__genModel.drillObj.drillrow.trans_type.toString()=='P')
		{
			__localModel.listObj.drilldown_component_code = "saoi/sampleorder/components/SampleOrder.swf"	
		}
		else if(__genModel.drillObj.drillrow.trans_type.toString()=='V')
		{
			__localModel.listObj.drilldown_component_code = "saoi/virtualorder/components/VirtualOrder.swf"	
		}
		var tabpage:TabPage	=	new TabPage();
		tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
	}
	else
	{
		
	}
	
}
private function btnRefreshClickHandler(event:Event):void
{
	if(GenButton(event.target).id.toString().toUpperCase()=='BTNORDERTYPEREFRESH')
	{
		getOrderTypeTotalCount();	
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNRUSHORDERTYPEREFRESH')
	{
		getRushOrders();
	}
	else if(GenButton(event.target).id.toString().toUpperCase()=='BTNTOP10ORDERBYAMOUNTREFRESH')
	{
		getTop10OrderByAmount();
	}
}

private function addRefreshButton(btnId:String):void
{
	var btn:GenButton  	= new GenButton();
	btn.id				= btnId;
	btn.setStyle('icon' , refreshButtonIcon);
	btn.addEventListener(MouseEvent.CLICK,btnRefreshClickHandler);
	if(btnId.toUpperCase()=='BTNORDERTYPEREFRESH')
	{
		btwOrderTypeCount.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNRUSHORDERTYPEREFRESH')
	{
		btwRushOrders.titleBarContainer.addChild(btn);	
	}
	else if(btnId.toUpperCase()=='BTNTOP10ORDERBYAMOUNTREFRESH')
	{
		btwTop10OrderByAmount.titleBarContainer.addChild(btn);
	}
}