import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.dsaoi.invoiceregister.DrilldownDsaoiInvoiceRegisterReport;
import rept.dsaoi.invoiceregister.InvoiceRegisterController;
import rept.dsaoi.invoiceregister.InvoiceRegisterModelLocator;
import rept.dsaoi.invoiceregister.InvoiceRegisterServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:InvoiceRegisterModelLocator = new InvoiceRegisterModelLocator();

public function handleInvoiceRegisterActive(event:GenModuleEvent):void
{
	__genModel.controller			= new InvoiceRegisterController();
	__genModel.services 			= new InvoiceRegisterServices();
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
	__localModel.reportObj.idrilldown = new DrilldownDsaoiInvoiceRegisterReport();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
