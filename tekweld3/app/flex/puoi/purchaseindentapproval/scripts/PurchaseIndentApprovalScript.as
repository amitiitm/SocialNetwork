import business.events.InitializeEditableListEvent;
import com.generic.events.GenModuleEvent;
import puoi.purchaseindentapproval.PurchaseIndentApprovalController
import puoi.purchaseindentapproval.PurchaseIndentApprovalModelLocator;
import puoi.purchaseindentapproval.PurchaseIndentApprovalServices;
import puoi.purchaseindentapproval.components.PurchaseIndentApprovalAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PurchaseIndentApprovalModelLocator = new PurchaseIndentApprovalModelLocator();

public function handlePurchaseIndentApprovalAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new PurchaseIndentApprovalController();
	__genModel.services 			= 	new PurchaseIndentApprovalServices();
	__genModel.activeModelLocator 	= __localModel;
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new PurchaseIndentApprovalAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
