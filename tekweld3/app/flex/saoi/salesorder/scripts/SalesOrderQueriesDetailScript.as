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
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.salesorder.SalesOrderModelLocator;

private var __sendToCustomer:IResponder;
private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:SalesOrderModelLocator = (SalesOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
public  var fileRef:FileReference = new FileReference();
public  var fileRefDown:FileReference = new FileReference();
private var urlObj:URL	=	new URL();

private var __service:ServiceLocator = __genModel.services;


override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	
}
override protected function resetObjectEventHandler():void
{

}
protected override function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	return 0;
}