import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;

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
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.embroideryfilm.EmbroideryFilmModelLocator;

import saoi.orderestimationinbox.OrderEstimationInboxModelLocator;
import saoi.orderestimationinbox.components.OrderEstimationInbox;



[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:OrderEstimationInboxModelLocator =  OrderEstimationInboxModelLocator(__genModel.activeModelLocator);
private var __service:ServiceLocator = __genModel.services;
private var __generatePackageSlip:IResponder;
private var resultFromUps:XML ;
private var  __genrateUpsLabel:IResponder;
public  var fileRefDown:FileReference = new FileReference();

[Embed("com/generic/assets/btn_view_artwork.png")]
private const viewArtworkButtonIcon:Class;
[Embed("com/generic/assets/btn_download_artwork.png")]
private const donloadArtworkButtonIcon:Class;


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
	
	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["receive_stitch_estimation_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["receive_stitch_estimation_flag"] = 'N';
	}  	
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["stitch_count"] == '')
			{
				retValue = -1;
				Alert.show("Enter Stitches count for the artwork.");
				break
			}						
		}	
	}
	return retValue;
}

private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	hb.setStyle("horizonalGap",10);
	
	var btnViewArtwork:Button        			= new Button();
	btnViewArtwork.label						= "VIEW ARTWORK";
	btnViewArtwork.height						= 20;
	//btnViewArtwork.setStyle("icon",viewArtworkButtonIcon);
	btnViewArtwork.styleName					= "promoButton";
	btnViewArtwork.addEventListener(MouseEvent.CLICK,viewClickHandler);
	
	var btnDownloadArtwork:Button        		= new Button();
	btnDownloadArtwork.label					= "DOWNLOAD ARTWORK";
	btnDownloadArtwork.height					= 20;
	//btnDownloadArtwork.setStyle("icon",donloadArtworkButtonIcon);
	btnDownloadArtwork.styleName				= "promoButton";
	btnDownloadArtwork.addEventListener(MouseEvent.CLICK,downloadFileClickHandler);
	
	var space:Spacer	 = new Spacer();
	space.width			 = 200;
	
	hb.addChild(space);
	hb.addChild(btnViewArtwork);
	hb.addChild(btnDownloadArtwork);
	
	OrderEstimationInbox(this.parentDocument).bcp.addChildAt(hb,7);
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
