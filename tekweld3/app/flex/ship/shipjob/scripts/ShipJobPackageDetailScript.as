import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
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

import ship.shipjob.ShipJobModelLocator;

private var __sendToCustomer:IResponder;
private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:ShipJobModelLocator = (ShipJobModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
public  var fileRef:FileReference = new FileReference();
public  var fileRefDown:FileReference = new FileReference();
private var urlObj:URL	=	new URL();
private var urlartworkUploadUrl:String  =	urlObj.getURL(__genModel.services.getHTTPService("artworkUploadUrl").url.toString());
private var _request:URLRequest = new URLRequest(urlartworkUploadUrl);
private var __service:ServiceLocator = __genModel.services;
private var emailValidator:EmailValidator	= new EmailValidator();

protected override function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	if(Number(tiCarton_weight.dataValue)<=0 || Number(tiPcs_carton.dataValue)<=0)
	{
		Alert.show("carton Weight or Pcs per should be greater than zero");
		return -1;
	}
	else
	{
		tiCartonSize.dataValue  = tiCartonLength.dataValue + 'x'+ tiCartonWidth.dataValue + 'x'+ tiCartonHeight.dataValue;
		return 0;
	}
	
}