import acct.vendcreditinvoiceapply.VendorCreditInvoiceApplyController;
import acct.vendcreditinvoiceapply.VendorCreditInvoiceApplyModelLocator;
import acct.vendcreditinvoiceapply.VendorCreditInvoiceApplyServices;
import acct.vendcreditinvoiceapply.components.VendorCreditInvoiceApplyAddEdit;
import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:VendorCreditInvoiceApplyModelLocator = new VendorCreditInvoiceApplyModelLocator();

public function handleVendorCreditInvoiceApplyAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new VendorCreditInvoiceApplyController();
	__genModel.services   = new VendorCreditInvoiceApplyServices();
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
 
	__localModel.addEditObj.addEditContainer = new VendorCreditInvoiceApplyAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
