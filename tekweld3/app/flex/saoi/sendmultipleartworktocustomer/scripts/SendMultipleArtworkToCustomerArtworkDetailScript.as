
import business.events.GetInformationEvent;
import business.events.GetRecordEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.Responder;
import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.AddEdit;
import com.generic.events.AddEditEvent;
import com.generic.genclass.URL;

import flash.events.DataEvent;
import flash.events.Event;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.validators.EmailValidator;

import saoi.reviewartwork.ReviewArtworkModelLocator;


private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:ReviewArtworkModelLocator = (ReviewArtworkModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __sendToCustomer:IResponder;
private var numericFormatter:NumberFormatter = new NumberFormatter();
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
public  var fileRef:FileReference = new FileReference();
public  var fileRefDown:FileReference = new FileReference();
private var urlObj:URL	=	new URL();
private var urlartworkUploadUrl:String  =	urlObj.getURL(__genModel.services.getHTTPService("artworkUploadUrl").url.toString());
private var _request:URLRequest = new URLRequest(urlartworkUploadUrl);
private var __service:ServiceLocator = __genModel.services;
private var emailValidator:EmailValidator	= new EmailValidator();
private var callbacks:IResponder 			= new mx.rpc.Responder(retrieveHandler, null);

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
	tiFileName.text = fileRef.name;
	  
	var _variables:URLVariables = new URLVariables();
	_variables.file_name 		= 	 fileRef.name.toString();
	
	_request.method 			= 	URLRequestMethod.POST;
	_request.data 				= 	_variables;	
	
	uploadFile(fileRef)
	 
	CursorManager.setBusyCursor();
	__genModel.isLockScreen  = true;
	
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
		btnUpload.enabled = false;
	}
	else
	{
		tiFileName.text = '';
		Alert.show(result);
	}
	//Alert.show(event.data.toString());
}

private function sendtoCustomerHandler():void
{
	if(tiMailTo.text!='' && tiMailTo.text!=null)
	{
		emailValidator.required	= false;
		emailValidator.addEventListener(ValidationResultEvent.VALID,validEmail);
		emailValidator.addEventListener(ValidationResultEvent.INVALID,validEmail);
		emailValidator.source	= tiMailTo;
		emailValidator.property	= "text";
		emailValidator.trigger	= btnSendToCustomer;
		emailValidator.validate();
		
	}
	else
	{
		Alert.show("Please fill Email To");
	}
	
	
}
private function validEmail(event:ValidationResultEvent):void
{
	if(event.type	== ValidationResultEvent.VALID)
	{
		
		if(__localModel.trans_no=='' || __localModel.trans_no==null)
		{
			Alert.show("Please select record");
		}
		else
		{
			if(tiFileName.text == '' || tiFileName.text==null)
			{
				Alert.show("Please Select Artwork");
			}
			else
			{
				Alert.show("Are you sure to send artwork to customer ?","Send To Customer",Alert.YES | Alert.NO,this,alertListener,null,Alert.YES)
			}
			
		}
		
	}
	else
	{
		focusManager.setFocus(tiMailTo);
		Alert.show("Invalid email. Please Correct.");
	}
	
	
	
}
private function alertListener(event:CloseEvent):void
{
	switch (event.detail)
	{
		case Alert.YES:
			var xml:XML = new XML(	<params>
													<trans_no>{__localModel.trans_no}</trans_no>
													<artwork_name>{tiFileName.text}</artwork_name>
													<customer_email>{tiMailTo.text}</customer_email>
													</params>);
			
			var sendtoCustomer:HTTPService = dataService(__service.getHTTPService("sendToCustomer"));
			__sendToCustomer = new mx.rpc.Responder(sendtoCustomerResultHandler,sendtoCustomerFaultHandler);
			var token:AsyncToken = sendtoCustomer.send(xml);
			token.addResponder(__sendToCustomer);
			break;
		case Alert.NO:
			
			break;
	}
}
private function retrieveHandler(xml:XML):void
{
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent('MODIFY');
	recordStatusEvent.dispatch();
}
private function sendtoCustomerResultHandler(event:ResultEvent):void
{
	var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__genModel.activeModelLocator.listObj.selectedRow.id.toString()),callbacks,false);
	getRecordEvent.dispatch();
	Alert.show(event.result.toString());
}
private function sendtoCustomerFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.faultDetail.toString());
}

private function downloadHandler():void
{
	if(tiFileName.text == '' || tiFileName.text==null)
	{
		Alert.show("Please Select Artwork");
	}
	else
	{
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
	tiMailTo.text			= __localModel.artwork_dept_email;
	tiSubject.text			= "TEKWELD Cust PO #"+__localModel.ext_ref_no;
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