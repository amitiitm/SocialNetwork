import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.events.FlexEvent;

import rept.saoi.useractivity.DrilldownUserActivity;
import rept.saoi.useractivity.UserActivityController;
import rept.saoi.useractivity.UserActivityModelLocator;
import rept.saoi.useractivity.UserActivityServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:UserActivityModelLocator = new UserActivityModelLocator();

public function handleUserActivityActive(event:GenModuleEvent):void
{
	__genModel.controller			= new UserActivityController();
	__genModel.services 			= new UserActivityServices();
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
	__localModel.reportObj.idrilldown			=	new DrilldownUserActivity();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
	__localModel.reportObj.customReportDataGrid.headerWordWrap = true;
	__localModel.reportObj.customReportDataGrid.sortableColumns = false;
	__localModel.reportObj.customReportDataGrid.sortItemRenderer= null;
	

}
