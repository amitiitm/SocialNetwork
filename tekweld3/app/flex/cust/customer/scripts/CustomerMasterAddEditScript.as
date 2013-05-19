import business.events.GetInformationEvent;
import business.events.GetRecordEvent;

import com.generic.events.AddEditEvent;

import cust.customer.CustomerMasterModelLocator;
import cust.customer.components.CustomerPaymentProfile;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.muduleclasses.CommonArtworkXml;
import saoi.muduleclasses.GenericExportService;
import saoi.muduleclasses.event.MissingInfoEvent;

private var commonartworkXml:CommonArtworkXml   			= new CommonArtworkXml();
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
[Bindable]
private var __localModel:CustomerMasterModelLocator = (CustomerMasterModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private var getInformationEvent:GetInformationEvent;

private function init():void 
{
	__localModel.customer_id		= tiId.text
	__localModel.customer_code		= tiCode.dataValue;	
		
	//dtlPaymentProfile.bcdp.btnRemoveVisible  = false;	
}

private function cbBacklistedClickHandler():void
{
	if(cbBlacklisted_flag.selected)
	{
		cbStop_ship.selected = true;
	}
	else
	{
		cbStop_ship.selected = false;
	}
}


override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	__localModel.customer_id		= tiId.text
	__localModel.customer_code		= tiCode.dataValue;	
	//dcParent_id.enabled	=	false;
	
	setCustomerProfileLinkVisible(event.recordXml);
	cbBillingChangeHandler();
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
													<customer_email>{tiAccounts.dataValue}</customer_email>
												</params>));
		token.addResponder(callbacks);
	}
	else
	{
		//customer already have profile code 
	}*/
	setBillingAddress();
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
	Alert.show(event.fault.faultDetail);
}

override protected function resetObjectEventHandler():void  
{
	__localModel.customer_id			= tiId.text
	__localModel.customer_code		    = tiCode.dataValue;	
		
	lblcustomer_profile_code.visible	= false;	
	//dcParent_id.enabled	=	true;
	setBillingAddress();
}
override protected function  preSaveEventHandler(event:AddEditEvent):int
{
	var returnValue:int = 0;
	/*if(dtlShipping.dgDtl.rows.children().length() <= 0)
	{
		var xml:XML			=	new XML(<shipping/>)
		
		xml.id				=	''
		xml.company_id		=	__genModel.user.default_company_id
		xml.updated_by		=	__genModel.user.userID
		xml.created_by		=	__genModel.user.userID
        xml.lock_version	=	0
        
 	
        xml.serial_no		=	'101'
        xml.trans_flag		=	'A'
        xml.code			=	tiCode.text + ' - Main';
        xml.name			=	tiCode.text + ' - Main';
        //xml.contact1		=	tiContact1.text
        xml.address1		=	tiAddress1.text
        xml.address2		=	tiAddress2.text
        xml.city			=	tiCity.text
        xml.state			=	tiState.text
        xml.zip				=	tiZip.text
        xml.country			=	tiCountry.text
        xml.phone1			=	tiPhone1.text
        xml.fax1			=	tiFax1.text
        	
		dtlShipping.dgDtl.rows.appendChild(xml);
	}*/
	if(isOnlyOneFinalDefaultContact())
	{
		returnValue = 0;
	}
	else
	{
		Alert.show("There should be atleast one default contact for the customer.");
		tnDetail.selectedChild 	= vbCustomerContacts;
		return -1;
	}
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
private function isOnlyOneFinalDefaultContact():Boolean
{
	var dgXml:XMLList  = dtlCustomerContacts.dgDtl.rows.(trans_flag='A');
	var returnValue:Boolean = false;
	var counter:int = 0;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var artwotkflag:String  = dgXml.children()[i]['default_contact_flag'].toString();
		if(artwotkflag.toUpperCase()=='Y')
		{
			counter = counter+1; 
		}
	}
	if(counter==1 ||dgXml.children().length()==0)
	{
		returnValue = true;
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
private function openCustomerPaymentProfilePopup():void
{
	var record:XML							= __localModel.addEditObj.record;
	
	if(record!=null)
	{
		var customer_id:String										= __localModel.addEditObj.record.children()[0].id.toString();
		
		if(customer_id!='')
		{
			var paymentProfilePopUp:CustomerPaymentProfile 				= CustomerPaymentProfile(PopUpManager.createPopUp(this,CustomerPaymentProfile,true));
			paymentProfilePopUp.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,saveProfileResultHandler);
			paymentProfilePopUp.x										= ((Application.application.width/2)-(paymentProfilePopUp.width/2));
			paymentProfilePopUp.y										= ((Application.application.height/2)-(paymentProfilePopUp.height/2));
			paymentProfilePopUp.orderDetail 							= new XML(	<order_detail>
																							<customer_id>{customer_id}</customer_id>
																					</order_detail>);
		}
		else
		{
			Alert.show("Please save or get record");
		}
		
	}
	else
	{
		Alert.show("Please save or get record");
	}
	
	
}
private function saveProfileResultHandler(event:MissingInfoEvent):void
{

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
private function getselectedPaymentProfile():String
{
	var returnValue:String  = '';
	var length:int	= dtlPaymentProfile.dgDtl.deletedRows.children().length();
	if(length>0)
	{
		returnValue	= dtlPaymentProfile.dgDtl.deletedRows.children()[length-1].customer_payment_profile_code.toString();
	}
	
	return returnValue;
}
private function removePaymentProfile():void
{
	if(tiId.dataValue!='' && getselectedPaymentProfile()!='')
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(paymentProfileDeleteDetailsHandler, null);
		getInformationEvent			=	new GetInformationEvent('delete_customer_payment_profile', callbacks, tiId.dataValue,getselectedPaymentProfile());
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
	
	var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__localModel.addEditObj.record.children()[0].id.toString()),null,false);
	getRecordEvent.dispatch();
}

private function cbBillingChangeHandler():void
{
	if(cbBillingTransportationTo.dataValue == 'Third Party')
	{
		tithird_party_account_number.enabled   = true; 
	}
	else
	{
		tithird_party_account_number.dataValue = '';
		tithird_party_account_number.enabled   = false;
	}
}
private function csPriceExport():void
{
	var genericExportService:GenericExportService   = new GenericExportService();
	genericExportService.exportData('/sale/customer/convert_xls_customer_specific_price',__localModel.addEditObj.record.copy());
}