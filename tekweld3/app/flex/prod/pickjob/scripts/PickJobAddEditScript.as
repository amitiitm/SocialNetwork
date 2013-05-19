import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;

import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Spacer;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.pickjob.PickJobModelLocator;
import prod.pickjob.components.PickJob;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:PickJobModelLocator =  PickJobModelLocator(__genModel.activeModelLocator);
private var __service:ServiceLocator = __genModel.services;
private var __printPickSlip:IResponder;

private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	
	var sp:Spacer  = new Spacer();
	sp.width     =   2;
	
	var btnPrintPickSlip:Button        				= new Button();
	btnPrintPickSlip.label							= "PRINT PICK SLIP";
	btnPrintPickSlip.styleName						= "promoButton";
	btnPrintPickSlip.addEventListener(MouseEvent.CLICK,genratePickSlipHandler);
	
	hb.addChild(btnPrintPickSlip);
	
	PickJob(this.parentDocument).bcp.addChildAt(hb,7);
}

public function dataService(service:HTTPService):HTTPService
{
	var urlObj:URL				=	new URL();
	service.url					=	urlObj.getURL(service.url);
	service.resultFormat 		= 	"e4x";					
	service.method 				= 	"POST";
	service.useProxy			= 	false;
	service.contentType			=	"application/xml";
	service.requestTimeout	 	= 	1800
	
	return service;
}

private function genratePickSlipHandler(event:MouseEvent):void
{
	var index:int=-1;
	for(var i:int=0;i<inbox.dgDtl.rows.children().length();i++)
	{
		if(inbox.dgDtl.rows.children()[i].select_yn== 'Y')
		{
			index= i;
			break;
		}
	}

	if(index>=0)
	{
			var orderId:Number = Number(inbox.dgDtl.rows.children()[index].id.toString());
			if(orderId>0)
			{
				CursorManager.setBusyCursor();
				Application.application.enabled = false;
				
				var printPickSlip:HTTPService = dataService(__service.getHTTPService("printPickSlip"));
				__printPickSlip = new mx.rpc.Responder(printPickSlipResultHandler,printPickSlipFaultHandler);
				var token:AsyncToken = printPickSlip.send(new XML(<params>
																<id>{orderId}</id>
															</params>));
				token.addResponder(__printPickSlip);
			}
			else
			{
				Alert.show("Please Save or Retrieve recoed");
			}
	}
	else
	{
		Alert.show("Please Select Record");
	}	
	
}
private function printPickSlipResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
	var request:URLRequest = new URLRequest(url);
	
	navigateToURL(request);
}
public function printPickSlipFaultHandler(event:FaultEvent):void
{
	Alert.show("printPickSlip#"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
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
	var oldValue:String = event.oldValues["pick_flag"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["pick_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["pick_flag"] = 'N';
	}
	
	
	
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	/* for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["indigo_code"] == '')
			{
				retValue = -1;
				Alert.show("Please Enter INDIGO #");
				break
			}						
		}	
	} */

	return retValue;
}