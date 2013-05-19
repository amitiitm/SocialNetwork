import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.saoi.orderregister.DrilldownSalesOrderRegisterReport;
import rept.saoi.orderregister.OrderRegisterController;
import rept.saoi.orderregister.OrderRegisterModelLocator;
import rept.saoi.orderregister.OrderRegisterServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:OrderRegisterModelLocator = new OrderRegisterModelLocator();

public function handleOrderRegisterActive(event:GenModuleEvent):void
{
	__genModel.controller			= new OrderRegisterController();
	__genModel.services 			= new OrderRegisterServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID			= __genModel.applicationObject.selectedMenuItem.@document_id;
    __localModel.documentObj.create_permission 	= "N";
    __localModel.documentObj.modify_permission 	= "N";
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
    __localModel.documentObj.upload_permission 	= "N";

	__localModel.reportObj.customReportDataGrid = this.customReportComponent;
	__localModel.reportObj.idrilldown	=	new DrilldownSalesOrderRegisterReport();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
	__localModel.reportObj.customReportDataGrid.headerWordWrap = true;
	//__localModel.reportObj.customReportDataGrid.sortItemRenderer = null;
}
