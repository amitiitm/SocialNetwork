import business.events.RefreshEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.AddEditEvent;
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

import saoi.makecancelorder.MakeCancelOrderModelLocator;
import saoi.makecancelorder.components.MakeCancelOrder;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:MakeCancelOrderModelLocator  =  MakeCancelOrderModelLocator(__genModel.activeModelLocator);
private var __responderPick:IResponder;
private var __refreshList:IResponder;
private var refreshEvent:RefreshEvent;		
private var __service:ServiceLocator = __genModel.services;
private var drillIndex:int;
private var drillXml:XML	=	 new XML(		<rows>
													<row>MakeCacelOrder</row>
												</rows>);
[Bindable]
private var screenName:String = '';

private function init():void
{
}
private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var select:String = event.newValues.select_yn.toString();
	
	if(select.toUpperCase() == 'Y')
	{
		inbox.focusedRow["ordercancelstatus_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["ordercancelstatus_flag"] = 'N';
	}
		
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["cancel_order_reason"] == '')
			{
				retValue = -1;
				Alert.show("Please Enter Reason For Cancellation");
				break
			}						
		}	
	}
	return retValue;
}
