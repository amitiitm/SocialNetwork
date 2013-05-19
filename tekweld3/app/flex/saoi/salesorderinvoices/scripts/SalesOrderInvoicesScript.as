import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.salesorderinvoices.InboxDrilldownSalesOrderInvoices;
import saoi.salesorderinvoices.SalesOrderInvoicesController;
import saoi.salesorderinvoices.SalesOrderInvoicesModelLocator;
import saoi.salesorderinvoices.SalesOrderInvoicesServices;
import saoi.salesorderinvoices.components.SalesOrderInvoicesAddEdit;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:SalesOrderInvoicesModelLocator = new SalesOrderInvoicesModelLocator();

public function handleSalesOrderInvoicesAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new SalesOrderInvoicesController();
	__genModel.services 			= 	new SalesOrderInvoicesServices();
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
	__localModel.listObj.isObjectFromDrillDown	= 'Y';
	
	__localModel.listObj.idrilldown				= new InboxDrilldownSalesOrderInvoices();
	__localModel.addEditObj.addEditContainer 	= new SalesOrderInvoicesAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
 
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	this.bcp.btnPrint.visible	= false;
	this.bcp.btnPrint.includeInLayout = false;
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
