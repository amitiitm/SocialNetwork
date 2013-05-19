import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.dsaoi.openmemoreport.DrilldownDsaoiOpenMemoRegisterReport;
import rept.dsaoi.openmemoreport.OpenMemoReportController;
import rept.dsaoi.openmemoreport.OpenMemoReportModelLocator;
import rept.dsaoi.openmemoreport.OpenMemoReportServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:OpenMemoReportModelLocator = new OpenMemoReportModelLocator();

public function handleOpenMemoReportActive(event:GenModuleEvent):void
{
	__genModel.controller			= new OpenMemoReportController();
	__genModel.services 			= new OpenMemoReportServices();
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
	__localModel.reportObj.idrilldown = new DrilldownDsaoiOpenMemoRegisterReport();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
