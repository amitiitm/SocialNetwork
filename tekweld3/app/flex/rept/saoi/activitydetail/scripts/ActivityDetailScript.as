import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.events.FlexEvent;

import rept.saoi.activitydetail.ActivityDetailController;
import rept.saoi.activitydetail.ActivityDetailModelLocator;
import rept.saoi.activitydetail.ActivityDetailServices;
import rept.saoi.activitydetail.DrilldownActivityDetail;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:ActivityDetailModelLocator = new ActivityDetailModelLocator();

public function handleActivityDetailActive(event:GenModuleEvent):void
{
	__genModel.controller			= new ActivityDetailController();
	__genModel.services 			= new ActivityDetailServices();
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
	__localModel.reportObj.idrilldown			=	new DrilldownActivityDetail();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
	//__localModel.reportObj.customReportDataGrid.headerWordWrap = true;
	//__localModel.reportObj.customReportDataGrid.sortableColumns = false;
	//__localModel.reportObj.customReportDataGrid.sortItemRenderer= null;
	

}
