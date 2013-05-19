import business.events.GetInformationEvent;
import business.events.GetRecordEvent;

import com.generic.events.AddEditEvent;

import cust.quickcustomer.QuickCustomerMasterModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
[Bindable]
private var __localModel:QuickCustomerMasterModelLocator = (QuickCustomerMasterModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private var getInformationEvent:GetInformationEvent;

private function init():void 
{
	__localModel.customer_id		= tiId.text;
	dtlPaymentProfile.bcdp.btnRemoveVisible  = false;
}

private function cbBacklistedClickHandler():void
{
	/*if(cbBlacklisted_flag.selected)
	{
		cbStop_ship.selected = true;
	}
	else
	{
		cbStop_ship.selected = false;
	}*/
}


override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	//dcParent_id.enabled	=	false;
	__localModel.customer_id		= tiId.text
	
	setCustomerProfileLinkVisible(event.recordXml);
	
	var billto_id:String			=	event.recordXml.children()[0].billto_id.toString()
	var customerLookupXml:XML		=	GenModelLocator.getInstance().lookupObj.customer.copy();
	var flag:Boolean=false;
	for(var i:int=0 ; i<customerLookupXml.children().length() ;i++)
	{
		if(customerLookupXml.children()[i].id.toString()	==	billto_id.toString())
		{
			flag	=	true;
			break;
		}
	}
	if(!flag)
	{
		var temp:XML	=	new XML(<customer>
										<id>{billto_id}</id>
										<code>{tiCode.text}</code>
										<name>{tiName.text}</name>
									</customer>)
									
									
		customerLookupXml.appendChild(temp);
		
		//dcParent_id.dataProvider	=		customerLookupXml.children();	
		//dcParent_id.dataValue		=		billto_id;				
	}
	
	//http://192.168.100.235:4005/setup/setup/create_customer_profile_code
	/*var customer_profile_code:String			=	event.recordXml.children()[0].customer_profile_code.toString();
	if(customer_profile_code =='' || customer_profile_code ==null)
	{
		var customer_profile:HTTPService 		= dataService(new HTTPService());
		var callbacks:IResponder 	= new mx.rpc.Responder(customeProfileCodeResultHandler,customeProfileCodeFaultHandler);
		var token:AsyncToken = customer_profile.send(new XML(<params>
													<customer_code>{tiCode.dataValue}</customer_code>
												</params>));
		token.addResponder(callbacks);
	}
	else
	{
		//customer already have profile code 
	}*/
	
}
public function dataService(service:HTTPService):HTTPService
{
	service.url					= 'http://192.168.100.235:4005/setup/setup/create_customer_profile_code';
	service.resultFormat 		= "e4x";					
	service.method 				= "POST";
	service.useProxy			= false;
	service.contentType			="application/xml";
	service.requestTimeout	 	= 1800
	
	return service;
}
private function customeProfileCodeResultHandler(event:ResultEvent):void
{
	Alert.show(event.result.toString());
}
private function customeProfileCodeFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.faultDetail.toString());
}

override protected function resetObjectEventHandler():void  
{
	//dcParent_id.enabled	=	true;
	__localModel.customer_id			= tiId.text;
	lblcustomer_profile_code.visible	= false;	
}
override protected function  preSaveEventHandler(event:AddEditEvent):int
{
	var returnValue:int = 0;
	
	if(isIndustryInfoFill())
	{
		returnValue = 0;
	}
	else
	{
		Alert.show("Enter one of the industry information.");
		tnDetail.selectedChild = vbIndustryInfo;
		return -1;
	}
	return returnValue;
}
private function isIndustryInfoFill():Boolean
{
	var returnValue:Boolean  = true;
	if(tiEin_no.dataValue=='' && tiPPAI.dataValue=='' && tiSAGE.dataValue=='' && tiDC.dataValue=='' && tiAffiliation.dataValue=='' && tiOrganisation.dataValue=='' && tiOther.dataValue=='')
	{
		returnValue  = false;
	}
	return returnValue;
}
private function createCustomerProfile():void
{
	var record:XML							= __localModel.addEditObj.record;
	
	if(record!=null && !__genModel.activeModelLocator.addEditObj.editStatus)
	{
		var customer_id:String										= __localModel.addEditObj.record.children()[0].id.toString();
		if(customer_id!='')
		{
			var callbacks:IResponder	=	new mx.rpc.Responder(createCustomerProfileHandler, null);
			getInformationEvent			=	new GetInformationEvent('create_customer_profile', callbacks, customer_id);
			getInformationEvent.dispatch();
			
			Application.application.enabled  = false;
			CursorManager.setBusyCursor();
		}
		else
		{
			Alert.show("Please Select Customer");
		}
		
	}
	else
	{
		Alert.show("Please Save or get Record");
	}
}
private function createCustomerProfileHandler(resultXml:XML):void
{
	var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__localModel.addEditObj.record.children()[0].id.toString()),null,false);
	getRecordEvent.dispatch();
	
	Alert.show(resultXml.toString());
	
	Application.application.enabled  = true;
	CursorManager.removeBusyCursor();
}
private function setCustomerProfileLinkVisible(xml:XML):void
{
	var customer_profile_code:String			=	xml.children()[0].customer_profile_code.toString();
	if(customer_profile_code=='' || customer_profile_code==null)
	{
		lblcustomer_profile_code.visible  = true;
	}
	else
	{
		lblcustomer_profile_code.visible  =  false;
	}
	
}
private function setBillingAddress():void
{
	__localModel.billing_address.address1 	= tiAddress1.dataValue;
	__localModel.billing_address.address2	= tiAddress2.dataValue;
	__localModel.billing_address.city		= tiCity.dataValue;
	__localModel.billing_address.state		= tiState.dataValue;
	__localModel.billing_address.zip		= tiZip.dataValue;
	__localModel.billing_address.country	= tiCountry.dataValue;
	__localModel.billing_address.phone1		= tiPhone1.dataValue;
	__localModel.billing_address.phone2		= tiPhone2.dataValue;
	__localModel.billing_address.fax		= tiFax1.dataValue;
}