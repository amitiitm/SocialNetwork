import business.events.DetailEditCloseEvent;
import business.events.GetInformationEvent;
import business.events.GetRecordEvent;
import business.events.PreSaveEvent;

import com.generic.components.DetailEdit;
import com.generic.events.DetailAddEditEvent;

import cust.quickcustomer.QuickCustomerMasterModelLocator;

import model.GenModelLocator;

import mx.containers.TitleWindow;
import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

import valueObjects.DetailEditVO;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:QuickCustomerMasterModelLocator = (QuickCustomerMasterModelLocator)(GenModelLocator.getInstance().activeModelLocator);
private var getInformationEvent:GetInformationEvent;
private var customer_id:String = '';
private var __detailEditObj:DetailEditVO = __genModel.activeModelLocator.detailEditObj;

private function creationComplete():void
{
	DetailEdit(this.parentDocument).bcp.btnSave.visible 		= false;
	DetailEdit(this.parentDocument).bcp.btnSave.includeInLayout = false;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	customer_id 				= __localModel.customer_id;
}
override protected function resetObjectEventHandler():void
{
	customer_id 				= __localModel.customer_id;
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
private function saveClickHandler():void
{
	if(customer_id!='' && tiCardNO.dataValue!='' && cbCard_type.dataValue!='' && tiExp_Year.dataValue!='' && tiExp_Month.dataValue!='')
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(paymentProfileDetailsHandler, null);
		getInformationEvent			=	new GetInformationEvent('create_customer_payment_profile', callbacks, customer_id,cbCard_type.dataValue,tiCardNO.dataValue,tiExp_Month.dataValue,tiExp_Year.dataValue);
		getInformationEvent.dispatch();
		
		Application.application.enabled  = false;
		CursorManager.setBusyCursor();
	}
	else
	{
		Alert.show("Enter payment information.");
	}
}

private function paymentProfileDetailsHandler(resultXml:XML):void
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
