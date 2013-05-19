import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.events.FlexEvent;

import rept.saoi.incompletestatus.DrilldownIncompleteStatus;
import rept.saoi.incompletestatus.IncompleteStatusController;
import rept.saoi.incompletestatus.IncompleteStatusModelLocator;
import rept.saoi.incompletestatus.IncompleteStatusServices;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:IncompleteStatusModelLocator = new IncompleteStatusModelLocator();

public function handleIncompleteStatusActive(event:GenModuleEvent):void
{
	__genModel.controller			= new IncompleteStatusController();
	__genModel.services 			= new IncompleteStatusServices();
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
	__localModel.reportObj.idrilldown			=	new DrilldownIncompleteStatus();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
	__localModel.reportObj.customReportDataGrid.headerWordWrap = true;
	__localModel.reportObj.customReportDataGrid.sortableColumns = false;
	__localModel.reportObj.customReportDataGrid.sortItemRenderer= null;
	

}
