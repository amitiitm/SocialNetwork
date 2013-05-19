import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import acct.custcreditinvoiceapply.CustomerCreditInvoiceApplyController;
import acct.custcreditinvoiceapply.CustomerCreditInvoiceApplyModelLocator;
import acct.custcreditinvoiceapply.CustomerCreditInvoiceApplyServices;
import acct.custcreditinvoiceapply.components.CustomerCreditInvoiceApplyAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;
import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:CustomerCreditInvoiceApplyModelLocator = new CustomerCreditInvoiceApplyModelLocator();

public function handleCustomerCreditInvoiceApplyAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new CustomerCreditInvoiceApplyController();
	__genModel.services   = new CustomerCreditInvoiceApplyServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.selectedMode		=	ModeVO.LIST_MODE;
    __localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission 	= 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new CustomerCreditInvoiceApplyAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
