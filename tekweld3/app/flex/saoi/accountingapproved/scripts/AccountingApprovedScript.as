import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.accountingapproved.AccountingApprovedController;
import saoi.accountingapproved.AccountingApprovedDrilldown;
import saoi.accountingapproved.AccountingApprovedModelLocator;
import saoi.accountingapproved.AccountingApprovedServices;
import saoi.accountingapproved.components.AccountingApprovedAddEdit;
import saoi.accountingapproved.components.AccountingApprovedCustomButton;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:AccountingApprovedModelLocator = new AccountingApprovedModelLocator();

public function handleAccountingApprovedAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new AccountingApprovedController();
	__genModel.services 			= 	new AccountingApprovedServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.selectedMode		=	ModeVO.LIST_MODE;
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';
	__localModel.listObj.isdrilldownrow			= 'Y';
	//__localModel.listObj.isObjectFromDrillDown	= 'Y';
	
	__localModel.listObj.idrilldown				= new AccountingApprovedDrilldown();
	__localModel.addEditObj.addEditContainer 	= new AccountingApprovedAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
 
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	customBar			 = new AccountingApprovedCustomButton();
	this.bcp.btnPrint.visible	= false;
	this.bcp.btnPrint.includeInLayout = false;
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
