import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.dsaoi.netsalesregister.DrilldownDsaoiNetSalesRegisterReport;
import rept.dsaoi.netsalesregister.NetSalesRegisterController;
import rept.dsaoi.netsalesregister.NetSalesRegisterModelLocator;
import rept.dsaoi.netsalesregister.NetSalesRegisterServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:NetSalesRegisterModelLocator = new NetSalesRegisterModelLocator();

public function handleNetSalesRegisterActive(event:GenModuleEvent):void
{
	__genModel.controller			= new NetSalesRegisterController();
	__genModel.services 			= new NetSalesRegisterServices();
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
	__localModel.reportObj.idrilldown = new DrilldownDsaoiNetSalesRegisterReport();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
