import business.events.GetInformationEvent;
import business.events.PreSaveEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flash.events.TimerEvent;
import flash.utils.Timer;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.Label;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.artworkquery.ArtworkQueryModelLocator;
import saoi.assignedartwork.components.PopUpViewer;
import saoi.muduleclasses.MissingInfolViewer;
import saoi.muduleclasses.event.MissingInfoEvent;
import saoi.orderquery.OrderQueryModelLocator;
import saoi.orderquery.components.OrderQuery;

private var preSaveEvent:PreSaveEvent;
private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
[Bindable]
private var __localModel:OrderQueryModelLocator = (OrderQueryModelLocator)(GenModelLocator.getInstance().activeModelLocator);
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
private var shipping_detail:GetInformationEvent;
private var isMissingInfoSave:Boolean	=	false;
private var optionXmlAfterSave:XML;
private var missingInfoWindow:PopUpViewer;
private var saveXml:XML;
public var refreshTimer:Timer  = new Timer(__genModel.screenRefreshTimeInterval);
public var remainTimer:Timer  = new Timer(1000);
[Bindable]
public var remainingTime:int=(__genModel.screenRefreshTimeInterval)/1000;
private var screenName:String = ''
private var __service:ServiceLocator = __genModel.services;
private var __refreshList:IResponder;


								
private function init():void
{
	screenName 				= __genModel.tabMain.selectedChild.label;
	var refreshLabel:Label  = new Label();
	refreshLabel.name		= "refreshLabel";
	refreshLabel.text		= "refresh within "+remainingTime.toString()+" sec.";
	refreshLabel.height     = 20;
	refreshLabel.setStyle("color","#356DCC");
	refreshLabel.setStyle("fontSize",11);
	refreshLabel.setStyle("fontWeight","bold");
	
	OrderQuery(this.parentDocument).bcpList.addChild(refreshLabel);
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
private function remainTimerPickHandler(event:TimerEvent):void
{
	Label(OrderQuery(this.parentDocument).bcpList.getChildByName("refreshLabel")).text =	"refresh within "+remainingTime.toString()+" sec." ;
	remainingTime = remainingTime - 1;	
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
	Alert.show("RefreshOrderQuery"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
}
override protected function resetObjectEventHandler():void   //on add buttton press,
{
	
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{

}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	setAnswerFlag();
	var returnValue:int	= 0 ;
	
	return returnValue; 
}
private function setAnswerFlag():void
{
	if(tiAnswer.dataValue=='')
	{
		cbAnswerFlag.dataValue  = 'N';
	}
	else
	{
		cbAnswerFlag.dataValue  = 'Y';
	}
}
private function viewDetailOrder():void
{
	if(!__genModel.activeModelLocator.addEditObj.editStatus && tiTrans_no.dataValue!='')
	{
		
		__genModel.drillObj.drillrow							=	new XML(<rows><trans_no>{tiTrans_no.dataValue}</trans_no></rows>);
		
		if(cbOrder_type.dataValue=='E')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/reorder/components/ReOrder.swf";
		}
		else if(cbOrder_type.dataValue=='S'||cbOrder_type.dataValue=='F')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/salesorder/components/SalesOrder.swf";
		}
		else if(cbOrder_type.dataValue=='P')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/sampleorder/components/SampleOrder.swf";
		}
		else if(cbOrder_type.dataValue=='V')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/virtualorder/components/VirtualOrder.swf";
		}
		
		var tabpage:TabPage										=	new TabPage();
		tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
	}
	else
	{
		Alert.show("To view order in detail screen, save order and then click on order# link.");
	}
}