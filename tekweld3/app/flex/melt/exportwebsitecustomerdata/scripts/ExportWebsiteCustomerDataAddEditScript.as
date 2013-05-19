import com.adobe.cairngorm.business.ServiceLocator;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var __service:ServiceLocator = __genModel.services;
private var __responderExport:IResponder;


public function dataService(service:HTTPService):HTTPService
{
	service.resultFormat = "e4x";					
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";
	service.requestTimeout = 1800
	
	return service;
}
public function export():void
{
	var export:HTTPService = dataService(__service.getHTTPService("exportWebsiteCustomerData"));
	__responderExport = new mx.rpc.Responder(exportResultHandler,exportFaultHandler);
	var token:AsyncToken = export.send(new XML());
	token.addResponder(__responderExport);	
	
	CursorManager.setBusyCursor();
	Application.application.enabled = false;
}

public function exportResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var url:String = __genModel.path.report_export + XML(event.result)["result"].toString();
	var request:URLRequest = new URLRequest(url);
	navigateToURL(request,"_self"); 
	
}

public function exportFaultHandler(event:FaultEvent):void
{
	Alert.show("ExportCustomerData"+event.fault.faultDetail.toString());
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
