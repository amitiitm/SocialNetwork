import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.saoi.creditinvoiceregister.CreditInvoiceRegisterController;
import rept.saoi.creditinvoiceregister.CreditInvoiceRegisterModelLocator;
import rept.saoi.creditinvoiceregister.CreditInvoiceRegisterServices;
import rept.saoi.creditinvoiceregister.DrilldownSalesCreditInvoiceRegisterReport;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:CreditInvoiceRegisterModelLocator = new CreditInvoiceRegisterModelLocator();

public function handleCreditInvoiceRegisterActive(event:GenModuleEvent):void
{
	__genModel.controller			= new CreditInvoiceRegisterController();
	__genModel.services 			= new CreditInvoiceRegisterServices();
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
	__localModel.reportObj.idrilldown = new DrilldownSalesCreditInvoiceRegisterReport;
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}