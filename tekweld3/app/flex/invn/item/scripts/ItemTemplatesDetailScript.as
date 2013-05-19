import business.events.RecordStatusEvent;

import com.generic.events.DetailAddEditEvent;
import com.generic.genclass.URL;

import flash.events.DataEvent;
import flash.events.Event;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.CursorManager;

import saoi.muduleclasses.CommonArtworkXml;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private var columnArray:ArrayCollection = new ArrayCollection();
private var columnIndex:int=0;
private var commonartworkXml:CommonArtworkXml   			= new CommonArtworkXml(); 
public  var fileRefDown:FileReference = new FileReference();
public  var fileRefView:FileReference = new FileReference();
public  var fileRefUpload:FileReference = new FileReference();
private var urlObj:URL	=	new URL();
private var urlTemplateUploadUrl:String  	=	urlObj.getURL(__genModel.services.getHTTPService("templateUploadUrl").url.toString());
private var _request:URLRequest 			= 	new URLRequest(urlTemplateUploadUrl);


override protected function resetObjectEventHandler():void
{
	btnUpload.enabled 		= true;
	btnUpload.visible		= true;
	tiComment.enabled		= true;
	
	btnDownload.visible		= false;
	btnViewArtwork.visible	= false;
	
}
override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	btnUpload.enabled  		= false;
	btnUpload.visible		= false;
	tiComment.enabled		= false;
	
	btnDownload.visible		= true;
	btnViewArtwork.visible	= true;
	
}

private function handleUploadArtwork():void
{
	if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly)
	{
		try
		{
			fileRefUpload.addEventListener(Event.SELECT,selectArtworkHandler);
			fileRefUpload.addEventListener(Event.COMPLETE, handleComplete);
			fileRefUpload.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,handleResponseCompleteData);
			fileRefUpload.browse();
		}
		catch(error:Error)
		{
			Alert.show(error.message);
		}
	}
}

public function selectArtworkHandler(event:Event):void
{
	btnUpload.enabled   = false;
	
	tiFileName.text = fileRefUpload.name;
	
	var _variables:URLVariables = new URLVariables();
	_variables.file_name 		= 	 fileRefUpload.name.toString();
	
	_request.method 			= 	URLRequestMethod.POST;
	_request.data 				= 	_variables;	
	
	uploadFile(fileRefUpload)
	
	CursorManager.setBusyCursor();
	__genModel.isLockScreen  = true;
}

public  function uploadFile(file:FileReference):void
{
	try
	{	
		fileRefUpload.upload(_request);
	}
	catch (error:Error)
	{
		Alert.show("unable to load Artwork"+error.message);
	}
	
}

public function handleComplete(event:Event):void
{
	CursorManager.removeBusyCursor();
	__genModel.isLockScreen   = false;
}
private function handleResponseCompleteData(event:DataEvent):void
{
	var result:String = event.data.toString();
	if(result=='Attachment Upload Successfull')
	{
		
		var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent('MODIFY');
		recordStatusEvent.dispatch();
		btnUpload.enabled = false;
	}
	else
	{
		tiFileName.text = '';
		Alert.show(result);
	}
	//Alert.show(result);
}

private function downloadHandler():void
{
	if(tiFileName.text == '' || tiFileName.text==null)
	{
		Alert.show("Please Select Template");
	}
	else
	{
		var urlObj:URL	=	new URL();
		
		var url:String  =	__genModel.path.template_path+tiFileName.text;
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
private function viewArtworkHandler():void
{
	if(tiFileName.text == '' || tiFileName.text==null)
	{
		Alert.show("Please Select Template");
	}
	else
	{
		var url:String  				=	__genModel.path.template_path+tiFileName.dataValue;
		var _requestViewUrl:URLRequest 	= new URLRequest(url);
		navigateToURL(_requestViewUrl); 
	}
}