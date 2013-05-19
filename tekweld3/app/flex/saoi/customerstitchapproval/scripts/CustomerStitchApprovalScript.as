import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.customerstitchapproval.CustomerStitchApprovalController;
import saoi.customerstitchapproval.CustomerStitchApprovalModelLocator;
import saoi.customerstitchapproval.CustomerStitchApprovalServices;
import saoi.customerstitchapproval.InboxDrilldownCustomerStitchApproval;
import saoi.customerstitchapproval.components.CustomerStitchApprovalAddEdit;

import valueObjects.ModeVO;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:CustomerStitchApprovalModelLocator = new CustomerStitchApprovalModelLocator();

public function handleCustomerStitchApprovalAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new CustomerStitchApprovalController();
	__genModel.services 			= 	new CustomerStitchApprovalServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.selectedMode			=	ModeVO.LIST_MODE;
	__localModel.documentObj.documentID 			= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 		= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 		= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 		= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 		= 'Y';

	__localModel.addEditObj.addEditContainer 		= new CustomerStitchApprovalAddEdit();
    __localModel.listObj.listGrid 					= listControlComponent.dgList;
    
     __localModel.listObj.isdrilldownrow			= 'Y';
    __localModel.listObj.idrilldown					= new InboxDrilldownCustomerStitchApproval();
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
	
	this.bcp.btnSave.toolTip	= "Approve";
}
