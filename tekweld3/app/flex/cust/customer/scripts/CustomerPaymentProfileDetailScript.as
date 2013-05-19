import business.events.DetailEditCloseEvent;
import business.events.GetInformationEvent;
import business.events.GetRecordEvent;
import business.events.PreSaveEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.DetailEdit;
import com.generic.events.DetailAddEditEvent;
import com.generic.genclass.URL;

import cust.customer.CustomerMasterModelLocator;

import model.GenModelLocator;

import mx.containers.TitleWindow;
import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import valueObjects.DetailEditVO;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:CustomerMasterModelLocator = (CustomerMasterModelLocator)(GenModelLocator.getInstance().activeModelLocator);
private var xmlMissingInfo:XML = new XML();
private var getInformationEvent:GetInformationEvent;
private var customer_id:String = '';
private var __detailEditObj:DetailEditVO = __genModel.activeModelLocator.detailEditObj;
[Bindable]
private var isProfileSaved:Boolean    = false;
private var __service:ServiceLocator = __genModel.services;
private var __responder:IResponder;
private function setIsProfileSavedFlag():void
{
	if(tiCustomerPaymentProfileCode.dataValue=='')
	{
		isProfileSaved =  false;
	}
	else
	{
		isProfileSaved	= true;
	}
}


private function creationComplete():void
{
	DetailEdit(this.parentDocument).bcp.btnSave.visible 		= false;
	DetailEdit(this.parentDocument).bcp.btnSave.includeInLayout = false;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	customer_id 				= __localModel.customer_id;
	setIsProfileSavedFlag();
}
override protected function resetObjectEventHandler():void
{
	customer_id 				= __localModel.customer_id;
	setIsProfileSavedFlag();
}
private function deleteClickHandler():void
{
	if(customer_id!='' && tiCustomerPaymentProfileCode.dataValue!='')
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(paymentProfileDeleteDetailsHandler, null);
		getInformationEvent			=	new GetInformationEvent('delete_customer_payment_profile', callbacks, customer_id,tiCustomerPaymentProfileCode.dataValue);
		getInformationEvent.dispatch();
		
		Application.application.enabled  = false;
		CursorManager.setBusyCursor();
	}
	else
	{
		Alert.show("Select payment profile.");
	}
}
private function paymentProfileDeleteDetailsHandler(resultXml:XML):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled  = true;
	
	var result:XML		 = XML(resultXml);
	Alert.show(resultXml.toString());
	
	__genModel.activeModelLocator.detailEditObj.isActive	=	false;
	PopUpManager.removePopUp(TitleWindow(__detailEditObj.detailEditContainer.parentDocument));
	__genModel.activeModelLocator.detailEditObj.setNull();
	
	var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__localModel.addEditObj.record.children()[0].id.toString()),null,false);
	getRecordEvent.dispatch();
	
	
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
	service.showBusyCursor		= true;	
	
	return service;
}

public function saveResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var  resultXml:XML   = XML(event.result);
	
	if(resultXml.name() == "errors")
	{
		if(resultXml.children().length() > 0) 
		{
			var message:String = '';
			
			for(var i:uint = 0; i < resultXml.children().length(); i++) 
			{
				message += resultXml.children()[i] + "\n";
			}
			Alert.show(message);
		} 
	}
	else
	{
		var recordXml:XML		= resultXml.copy();
		var alert_msg:String	= recordXml.children()[0].message.toString();
		Alert.show(alert_msg);
		
		__genModel.activeModelLocator.detailEditObj.isActive	=	false;
		PopUpManager.removePopUp(TitleWindow(__detailEditObj.detailEditContainer.parentDocument));
		__genModel.activeModelLocator.detailEditObj.setNull();
		
		var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__localModel.addEditObj.record.children()[0].id.toString()),null,false);
		getRecordEvent.dispatch();
	}
}
public function saveFaultHandler(event:FaultEvent):void
{
	Alert.show("SavePaymentProfileOrder"+event.fault.faultDetail.toString());
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
private function saveClickHandler():void
{
	if(getAlertMessage()!='')
	{
		Alert.show(getAlertMessage());
	}
	else
	{
		var save:HTTPService 					= dataService(__service.getHTTPService("savePaymentProfile"));
		__responder 		 					= new mx.rpc.Responder(saveResultHandler,saveFaultHandler);
		var parentXml:XML	 					= new XML(<customer_payment_profiles></customer_payment_profiles>);
		var childXml:XML	 					= new XML(<customer_payment_profile></customer_payment_profile>);
		
		childXml.customer_id					= __localModel.customer_id;
		childXml.customer_code					= __localModel.customer_code;
		childXml.customer_payment_profile_code	= tiCustomerPaymentProfileCode.dataValue;
		childXml.card_type						= cbCard_type.dataValue;
		childXml.card_number					= tiCardNO.dataValue;
		childXml.expiration_month				= tiExp_Month.dataValue;	
		childXml.expiration_year				= tiExp_Year.dataValue;
		childXml.company						= tiCampany.dataValue;
		childXml.first_name						= tiFirstName.dataValue;
		childXml.last_name						= tiLastName.dataValue;
		childXml.address						= tiAddress1.dataValue;
		childXml.city							= tiCity.dataValue;
		childXml.state							= tiState.dataValue;
		childXml.zip							= tiZip.dataValue;
		childXml.country						= tiCountry.dataValue;
		childXml.phone							= tiPhone1.dataValue;
		childXml.fax							= tiFax1.dataValue;
		
		parentXml.appendChild(childXml);
		
		var token:AsyncToken = save.send(new XML(parentXml));
		token.addResponder(__responder);
	}
}
private function getAlertMessage():String
{
	var returnValue:String		= '';
	if(customer_id=='')
	{
		returnValue	= returnValue.concat("Please Save or Get Customer\n");
	}
	if(tiCardNO.dataValue =='')
	{
		returnValue	= returnValue.concat("Please Fill Credit Card No\n");
	}
	if(cbCard_type.dataValue =='')
	{
		returnValue	= returnValue.concat("Please Select Credit Card Type\n");
	}
	if(tiExp_Month.dataValue=='')
	{
		returnValue	= returnValue.concat("Please Fill  Credit Card Expiration Month\n");
	}
	if(tiExp_Year.dataValue =='')
	{
		returnValue	= returnValue.concat("Please Fill  Credit Card Expiration Year\n");
	}
	if(tiAddress1.dataValue =='')
	{
		returnValue	= returnValue.concat("Please Fill  Address\n");
	}
	if(tiCity.dataValue =='')
	{
		returnValue	= returnValue.concat("Please Fill  City\n");
	}
	if(tiState.dataValue =='')
	{
		returnValue	= returnValue.concat("Please Fill  State\n");
	}
	if(tiCountry.dataValue =='')
	{
		returnValue	= returnValue.concat("Please Fill  Country\n");
	}
	return returnValue;
		
}	
