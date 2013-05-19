import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.URL;
import com.generic.customcomponents.GenButton;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Spacer;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.embroiderystich.EmbroideryStichModelLocator;
import prod.embroiderystich.components.EmbroideryStich;
import prod.embroiderystich.components.ThreadList;

import saoi.muduleclasses.PrintObject;
import saoi.muduleclasses.event.MissingInfoEvent;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:EmbroideryStichModelLocator =  EmbroideryStichModelLocator(__genModel.activeModelLocator);
public  var fileRefDown:FileReference = new FileReference();
private var __service:ServiceLocator = __genModel.services;
private var __listThread:IResponder;

[Embed("com/generic/assets/btn_view_digitized_file.png")]
private const viewDigitizedFileButtonIcon:Class;
[Embed("com/generic/assets/btn_download_digitized_file.png")]
private const downloadDigitizedFileButtonIcon:Class;
[Embed("com/generic/assets/btn_view_threads.png")]
private const viewThreadsButtonIcon:Class;
[Embed("com/generic/assets/btn_print_pick_slip.png")]
private const printpickslipButtonIcon:Class;

private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	hb.setStyle('horizontalGap' , 10);
	var sp:Spacer  = new Spacer();
	sp.width     =   2;
	
	var btnView:Button        				= new Button();
	btnView.label							= "VIEW DIGITIZED FILE";
	btnView.height							= 20;
	btnView.styleName						= "promoButton";
	//btnView.setStyle('icon' , viewDigitizedFileButtonIcon);
	btnView.addEventListener(MouseEvent.CLICK,viewClickHandler);
	
	var btnUpload:Button        			= new Button();
	btnUpload.height						= 20;
	btnUpload.label							= "DOWNLOAD DIGITIZED FILE";
	btnUpload.styleName						= "promoButton";
	//btnUpload.setStyle('icon' , downloadDigitizedFileButtonIcon);
	btnUpload.addEventListener(MouseEvent.CLICK,downloadFileClickHandler);
	
	var btnIndigo:Button        			= new Button();
	btnIndigo.label							= "VIEW THREADS";
	btnIndigo.height						= 20;
	btnIndigo.styleName						= "promoButton";
	//btnIndigo.setStyle('icon' , viewThreadsButtonIcon);
	btnIndigo.addEventListener(MouseEvent.CLICK,genrateIndigoClickHandler);
	
	var btnPrintPickSlip:Button        		= new Button();
	btnPrintPickSlip.height					= 20;
	btnPrintPickSlip.label					= "PRINT PICK SLIP";
	btnPrintPickSlip.styleName				= "promoButton";
	//btnPrintPickSlip.setStyle('icon' , printpickslipButtonIcon);
	btnPrintPickSlip.addEventListener(MouseEvent.CLICK,genratePickSlipHandler);
	

	
	var space:Spacer	 = new Spacer();
	space.width			 = 200;
	
	hb.addChild(space);
	hb.addChild(btnView);
	hb.addChild(btnUpload);
	hb.addChild(btnIndigo);
	
	EmbroideryStich(this.parentDocument).bcp.addChildAt(hb,7);
}
private function genratePickSlipHandler(event:MouseEvent):void
{
	new PrintObject().genratePickSlipHandler(inbox);
}

private function getFileName():String
{
	var returnValue:String  = '';
	if(inbox.selectedRows.children().length()>0)
	{
		returnValue		= inbox.selectedRows.children()[0].artwork_file_name.toString();
		return returnValue;
	}
	else
	{
		return returnValue;
	}
}
private function viewClickHandler(event:MouseEvent):void
{
	if(getFileName()=='')
	{
		Alert.show("Please Select Job");
	}
	else
	{
		var url:String  =	__genModel.path.attachment+getFileName();
		var _requestViewUrl:URLRequest = new URLRequest(url);
		navigateToURL(_requestViewUrl); 
	}
}
private function downloadFileClickHandler(event:MouseEvent):void
{
	if(getFileName()=='')
	{
		Alert.show("Please Select Job");
	}
	else
	{
		var urlObj:URL	=	new URL();
		var url:String  =	__genModel.path.attachment+getFileName();
		var _request:URLRequest = new URLRequest(url);             
		_request.method = URLRequestMethod.GET;
		fileRefDown.addEventListener(Event.OPEN,openHandler);
		fileRefDown.addEventListener(Event.COMPLETE,downloadCompletehandler);
		try
		{
			fileRefDown.download(_request);
		}
		catch (error:Error)
		{
			Alert.show("Unable to download file.");
		}
	}
}
private function openHandler(event:Event):void
{
	//Alert.show("downlaod start");
}

private function downloadCompletehandler(event:Event):void
{
	Alert.show("Download Complete");
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
private function genrateIndigoClickHandler(event:MouseEvent):void
{
	if(inbox.selectedRows.children().length()==1)
	{
		var threadList:ThreadList 			= ThreadList(PopUpManager.createPopUp(this,ThreadList,true));
		threadList.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoEventListner);
		threadList.x						= ((Application.application.width/2)-(threadList.width/2));
		threadList.y						= ((Application.application.height/2)-(threadList.height/2));
		threadList.xml 						= new XML(inbox.selectedRows.copy());
	}
	else
	{
		Alert.show("Please select One Job");
	}
	
}
public function  missingInfoEventListner(event:MissingInfoEvent):void
{
	
}
private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["stitch_flag"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["stitch_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["stitch_flag"] = 'N';
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