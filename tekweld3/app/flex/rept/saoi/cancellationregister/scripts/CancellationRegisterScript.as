import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.saoi.cancellationregister.CancellationRegisterController;
import rept.saoi.cancellationregister.CancellationRegisterModelLocator;
import rept.saoi.cancellationregister.CancellationRegisterServices;
import rept.saoi.cancellationregister.DrilldownSalesCancellationRegisterReport;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:CancellationRegisterModelLocator = new CancellationRegisterModelLocator();

public function handleCancellationRegisterActive(event:GenModuleEvent):void
{
	__genModel.controller			= new CancellationRegisterController();
	__genModel.services 			= new CancellationRegisterServices();
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
	__localModel.reportObj.idrilldown = new DrilldownSalesCancellationRegisterReport;
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
