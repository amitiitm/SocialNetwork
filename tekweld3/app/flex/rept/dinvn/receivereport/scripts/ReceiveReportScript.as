import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.dinvn.receivereport.DrilldownDinvnReceiveRegisterReport;
import rept.dinvn.receivereport.ReceiveReportController;
import rept.dinvn.receivereport.ReceiveReportModelLocator;
import rept.dinvn.receivereport.ReceiveReportServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:ReceiveReportModelLocator = new ReceiveReportModelLocator();

public function handleReceiveReportActive(event:GenModuleEvent):void
{
	__genModel.controller			= new ReceiveReportController();
	__genModel.services 			= new ReceiveReportServices();
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
	__localModel.reportObj.idrilldown = new DrilldownDinvnReceiveRegisterReport();
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
