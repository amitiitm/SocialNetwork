import acct.vendpaymentapply.VendorPaymentApplyController;
import acct.vendpaymentapply.VendorPaymentApplyModelLocator;
import acct.vendpaymentapply.VendorPaymentApplyServices;
import acct.vendpaymentapply.components.VendorPaymentApplyAddEdit;
import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:VendorPaymentApplyModelLocator = new VendorPaymentApplyModelLocator();

public function handleVendorPaymentApplyAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new VendorPaymentApplyController();
	__genModel.services = new VendorPaymentApplyServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.selectedMode		=	ModeVO.LIST_MODE;
    __localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission  = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission  = 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new VendorPaymentApplyAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;

	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
