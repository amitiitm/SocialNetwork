import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.dsaoi.memoregister.DrilldownDsaoiMemoRegisterReport;
import rept.dsaoi.memoregister.MemoRegisterController;
import rept.dsaoi.memoregister.MemoRegisterModelLocator;
import rept.dsaoi.memoregister.MemoRegisterServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:MemoRegisterModelLocator = new MemoRegisterModelLocator();

public function handleMemoRegisterActive(event:GenModuleEvent):void
{
	__genModel.controller			= new MemoRegisterController();
	__genModel.services 			= new MemoRegisterServices();
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
	__localModel.reportObj.idrilldown = new DrilldownDsaoiMemoRegisterReport();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
