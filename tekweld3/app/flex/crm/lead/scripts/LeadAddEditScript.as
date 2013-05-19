import crm.otheraddress.components.*;
import model.GenModelLocator;
import business.events.GetRecordEvent;
import com.generic.events.AddEditEvent;

import mx.controls.Alert;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.core.Application
import mx.managers.CursorManager;

private var getRecordEvent:GetRecordEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance() 

private function init():void
{
	dfLast_followed_date.dataValue = ""
	dfNext_followed_date.dataValue = ""
}

/*private function btnConvertToAcctClickHandler():void
{
	if(tiAccount_number.text != '')
	{
		Alert.show('Account Already Created.');
		return;
	}
	
	if(!__genModel.activeModelLocator.addEditObj.editStatus &&  tiId.text != '')
	{
		var xml:XML = new XML(	<params>
										<id>{tiId.dataValue}</id>	
								</params>)
	
		var service:HTTPService = GenModelLocator.getInstance().services.getHTTPService("save_account");
	
		setDataService(service);
	
		service.addEventListener(ResultEvent.RESULT, saveOrderResultHandler)													
		service.addEventListener(FaultEvent.FAULT, faultHandler)
	
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		
		service.send(xml);
	}	
	else
	{
		Alert.show('Please Save Record And then Try.');
	}
}

private function setDataService(service:HTTPService):void
{
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";
}
private function saveOrderResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
		var _resultXml:XML;
	_resultXml = (XML)(event.result.toString());

	if(_resultXml.name() == "errors")
	{
		if(_resultXml.children().length() > 0) 
		{
			var message:String = '';
	
			for(var i:uint = 0; i < _resultXml.children().length(); i++) 
			{
				message += _resultXml.children()[i] + "\n";
			}
			Alert.show(message);
		} 
	}
	else
	{
		getRecordEvent = new GetRecordEvent(int(tiId.dataValue));
		getRecordEvent.dispatch();	
	}	

}
private function faultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}*/

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiLead_number.enabled = false;
}

override protected function resetObjectEventHandler():void
{
	tiLead_number.enabled = true;
	dfLast_followed_date.dataValue = ""
	dfNext_followed_date.dataValue = ""
}