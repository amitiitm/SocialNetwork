import business.events.InboxDrillDownEvent;
import business.events.RefreshEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.InboxEvent;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Label;
import mx.controls.Spacer;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.pickartwork.PickArtworkModelLocator;
import saoi.pickartwork.components.PickArtwork;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:PickArtworkModelLocator  =  PickArtworkModelLocator(__genModel.activeModelLocator);
private var __responderPick:IResponder;
private var __refreshList:IResponder;
private var refreshEvent:RefreshEvent;		
private var __service:ServiceLocator = __genModel.services;
private var drillIndex:int;
public var refreshTimer:Timer  = new Timer(__genModel.screenRefreshTimeInterval);
public var remainTimer:Timer  = new Timer(1000);
[Bindable]
public var remainingTime:int=(__genModel.screenRefreshTimeInterval)/1000;

[Embed("com/generic/assets/btn_pick.png")]
private const pickArtworkButtonIcon:Class;

private function init():void
{
	var hb:HBox    = new HBox();
	hb.setStyle('horizontalGap' , 10);
	
	var space:Spacer	 = new Spacer();
	space.width			 = 200;
	
	var btn:Button = new Button();
	btn.label	   = "PICK";
	btn.styleName  = "promoButton";
	//btn.setStyle("icon",pickArtworkButtonIcon);
	btn.height 	   = 20;
	btn.addEventListener(MouseEvent.CLICK,pickOrderHandler);
	
	hb.addChild(space);
	hb.addChild(btn);
	
	
	
	var refreshLabel:Label  = new Label();
	refreshLabel.name		= "refreshLabel";
	refreshLabel.text		= "refresh within "+remainingTime.toString()+" sec.";
	refreshLabel.height     = 20;
	refreshLabel.setStyle("color","#356DCC");
	refreshLabel.setStyle("fontSize",11);
	refreshLabel.setStyle("fontWeight","bold");
	
	PickArtwork(this.parentDocument).bcp.addChildAt(hb,7);
	PickArtwork(this.parentDocument).bcp.addChild(refreshLabel);
	refreshTimer.addEventListener(TimerEvent.TIMER,refreshTimerPickHandler);
	remainTimer.addEventListener(TimerEvent.TIMER,remainTimerPickHandler);
	refreshTimer.start();
	remainTimer.start();
}
private function refreshTimerPickHandler(event:TimerEvent):void
{
	var tabpage:TabPage =  new TabPage();
	var index:int = tabpage.searchTabPage("Pick Artwork");
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
	Label(PickArtwork(this.parentDocument).bcp.getChildByName("refreshLabel")).text =	"refresh within "+remainingTime.toString()+" sec."; ;
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


private function pickOrderHandler(event:MouseEvent):void
{
	var index:int=-1;
	for(var i:int=0;i<inbox.dgDtl.rows.children().length();i++)
	{
		if(inbox.dgDtl.rows.children()[i].select_yn== 'Y')
		{
			
			index= i;
			drillIndex = i;
			break;
		}
	}
	
	if(index>=0)
	{
		var orderId:Number = Number(inbox.dgDtl.rows.children()[index].id.toString());
		var pick:HTTPService = dataService(__service.getHTTPService("pickArtwork"));
		__responderPick = new mx.rpc.Responder(pickResultHandler,pickFaultHandler);
		var token:AsyncToken = pick.send(new XML(<params>
												<id>{orderId}</id>
												<artworkassignedtouser_id>{__genModel.user.userID}</artworkassignedtouser_id>
												<artworkassignedtouser_code>{__genModel.user.user_cd}</artworkassignedtouser_code>
												</params>));
		token.addResponder(__responderPick);	
	
		CursorManager.setBusyCursor();
		Application.application.enabled = false;
	}
	else
	{
		Alert.show("Please Select Record");
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

public function pickResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var  resultXml:XML   = XML(event.result);
	
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
		__genModel.drillObj.drillrow					=	XML(inbox.dgDtl.rows.children()[drillIndex])
		var callback:IResponder							=	new mx.rpc.Responder(callbackDrillEventHandler,null);
		__localModel.listObj.drilldown_component_code 	= "saoi/assignedartwork/components/AssignedArtwork.swf"	
		var drillDownEvent:InboxDrillDownEvent			=	new InboxDrillDownEvent(callback);
		drillDownEvent.dispatch();	
		refreshPickHandler();
	}
}
private function callbackDrillEventHandler():void
{
	var refresh:HTTPService = dataService(__service.getHTTPService("getList"));
	__refreshList = new mx.rpc.Responder(refreshResultHandler,refreshFaultHandler);
	var token:AsyncToken = refresh.send(__localModel.viewObj.selectedView);
	token.addResponder(__refreshList);	
		
	CursorManager.setBusyCursor();
	Application.application.enabled = false;
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
	var utilityObj:Utility				=	new Utility();
	resultXML 							= 	utilityObj.getDecodedXML((XML)(event.result));
	
	__localModel.listObj.rows 			= new XML(resultXML);   	
	__localModel.listObj.filteredList 	= new XML(resultXML);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
public function refreshFaultHandler(event:FaultEvent):void
{
	Alert.show("Refreshorder"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
public function pickFaultHandler(event:FaultEvent):void
{
	Alert.show("PickOrder"+event.fault.faultDetail.toString());
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
