import business.events.DetailEditEvent;
import business.events.GetInformationEvent;
import business.events.PreSaveRowEvent;
import business.events.RecordStatusEvent;
import business.events.SaveRowEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.ButtonControlPanelDetailEdit;
import com.generic.components.Detail;
import com.generic.components.DetailAddEdit;
import com.generic.components.DetailEdit;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.DetailAddEditEvent;
import com.generic.genclass.URL;

import flash.events.DataEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.ValidationResultEvent;
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.validators.EmailValidator;

import saoi.muduleclasses.CommonArtworkXml;
import saoi.orderreceive.OrderReceiveModelLocator;
import saoi.orderreceive.components.OrderReceiveArtworkDetail;

import valueObjects.ModeVO;

[Bindable]
private var __localModel:OrderReceiveModelLocator 			= (OrderReceiveModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator 						= GenModelLocator.getInstance();

private var numericFormatter:NumberFormatter 				= new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
public  var fileRef:FileReference 							= new FileReference();
public  var fileRefDown:FileReference 						= new FileReference();
private var urlObj:URL										=	new URL();
private var urlartworkUploadUrl:String  					=	urlObj.getURL(__genModel.services.getHTTPService("artworkUploadUrl").url.toString());
private var _request:URLRequest 							= new URLRequest(urlartworkUploadUrl);
private var __service:ServiceLocator 						= __genModel.services;
private var commonartworkXml:CommonArtworkXml   			= new CommonArtworkXml(); 

private function init():void
{		
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
private function handleUploadArtwork():void
{
	try
	{
		fileRef.addEventListener(Event.SELECT,selectArtworkHandler);
		fileRef.addEventListener(Event.COMPLETE, handleComplete);
		fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,handleResponseCompleteData);
		fileRef.browse();
	}
	catch(error:Error)
	{
		Alert.show(error.message);
	}

}

public function selectArtworkHandler(event:Event):void
{
	btnUpload.enabled   = false;
	
	tiFileName.text = fileRef.name;
	  
	var _variables:URLVariables = new URLVariables();
	_variables.file_name 		= 	 fileRef.name.toString();
	
	_request.method 			= 	URLRequestMethod.POST;
	_request.data 				= 	_variables;	
	
	uploadFile(fileRef)
	 
	CursorManager.setBusyCursor();
	__genModel.isLockScreen  	= true;
	
}

public  function uploadFile(file:FileReference):void
{
    try
    {	
    	fileRef.upload(_request);
    }
    catch (error:Error)
    {
        Alert.show("unable to load Artwork"+error.message);
    }
	
}

public function handleComplete(event:Event):void
{
	CursorManager.removeBusyCursor();
	__genModel.isLockScreen  = false;
}
private function handleResponseCompleteData(event:DataEvent):void
{
	var result:String = event.data.toString();
	if(result=='Attachment Upload Successfull')
	{
		var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent('MODIFY');
		recordStatusEvent.dispatch();
 	}
	else
	{
		tiFileName.text = '';
		Alert.show(result);
	}
	btnUpload.enabled	= true
	//Alert.show(result);
}

private function downloadHandler():void
{

	if(tiFileName.text == '' || tiFileName.text==null)
	{
		Alert.show("Please Select Artwork");
	}
	else
	{
		var urlObj:URL	=	new URL();
		var url:String  =	__genModel.path.attachment+tiFileName.text;
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
override protected function resetObjectEventHandler():void
{
	btnUpload.enabled 		= true;
	btnUpload.visible		= true;
	tiVersion.enabled		= true;
	tiComment.enabled		= true;
	
	btnDownload.visible		= false;
	btnViewArtwork.visible	= false;
}
override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	btnUpload.enabled  		= true;
	btnUpload.visible		= true;
	tiVersion.enabled		= false;
	tiComment.enabled		= false;
	
	btnDownload.visible		= true;
	btnViewArtwork.visible	= true;
}

private function viewArtworkHandler():void
{
	if(tiFileName.text == '' || tiFileName.text==null)
	{
		Alert.show("Please Select Artwork");
	}
	else
	{
		var url:String  =	__genModel.path.attachment+tiFileName.text;
		var _requestViewUrl:URLRequest = new URLRequest(url);
		navigateToURL(_requestViewUrl); 
	}
	
}