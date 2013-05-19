import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.core.ClassFactory;
import mx.events.FlexEvent;

import rept.prod.plansheet.DrilldownPlanSheet;
import rept.prod.plansheet.PlanSheetController;
import rept.prod.plansheet.PlanSheetModelLocator;
import rept.prod.plansheet.PlanSheetServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:PlanSheetModelLocator = new PlanSheetModelLocator();

public function handlePlanSheetActive(event:GenModuleEvent):void
{
	__genModel.controller			= new PlanSheetController();
	__genModel.services 			= new PlanSheetServices();
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
	__localModel.reportObj.idrilldown			=	new DrilldownPlanSheet();
	
	__localModel.reportObj.customReportDataGrid.headerWordWrap = true;
	__localModel.reportObj.customReportDataGrid.sortableColumns = false;
	__localModel.reportObj.customReportDataGrid.sortItemRenderer= null;
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}