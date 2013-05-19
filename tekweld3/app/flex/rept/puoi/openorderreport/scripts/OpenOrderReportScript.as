import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.puoi.openorderreport.DrilldownPurchaseOpenOrderRegisterReport;
import rept.puoi.openorderreport.OpenOrderReportController;
import rept.puoi.openorderreport.OpenOrderReportModelLocator;
import rept.puoi.openorderreport.OpenOrderReportServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:OpenOrderReportModelLocator = new OpenOrderReportModelLocator();

public function handleOpenOrderReportActive(event:GenModuleEvent):void
{
	__genModel.controller			= new OpenOrderReportController();
	__genModel.services 			= new OpenOrderReportServices();
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
	__localModel.reportObj.idrilldown = new DrilldownPurchaseOpenOrderRegisterReport();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
