import acct.paybills.PayBillController;
import acct.paybills.PayBillModelLocator;
import acct.paybills.PayBillServices;
import acct.paybills.components.PayBillAddEdit;
import business.events.InitializeDataEntryWithNoListEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PayBillModelLocator = new PayBillModelLocator();

public function handlePayBillAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new PayBillController();
	__genModel.services = new PayBillServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	this.bcp.btnSave.visible = false;
	__localModel.addEditObj.addEditContainer = new PayBillAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
