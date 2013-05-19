import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.dpuoi.memoreturnregister.DrilldownDpuoiMemoReturnRegisterReport;
import rept.dpuoi.memoreturnregister.MemoReturnRegisterController;
import rept.dpuoi.memoreturnregister.MemoReturnRegisterModelLocator;
import rept.dpuoi.memoreturnregister.MemoReturnRegisterServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:MemoReturnRegisterModelLocator = new MemoReturnRegisterModelLocator();

public function handleMemoReturnRegisterActive(event:GenModuleEvent):void
{
	__genModel.controller			= new MemoReturnRegisterController();
	__genModel.services 			= new MemoReturnRegisterServices();
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
	__localModel.reportObj.idrilldown = new DrilldownDpuoiMemoReturnRegisterReport();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
