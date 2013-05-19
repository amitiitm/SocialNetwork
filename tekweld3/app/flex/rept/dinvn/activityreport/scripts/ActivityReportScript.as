import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.dinvn.activityreport.ActivityReportController;
import rept.dinvn.activityreport.ActivityReportModelLocator;
import rept.dinvn.activityreport.ActivityReportServices;
import rept.dinvn.activityreport.DrilldownDinvnActivityRegisterReport;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:ActivityReportModelLocator = new ActivityReportModelLocator();

public function handleActivityReportActive(event:GenModuleEvent):void
{
	__genModel.controller			= new ActivityReportController();
	__genModel.services 			= new ActivityReportServices();
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
	__localModel.reportObj.idrilldown = new DrilldownDinvnActivityRegisterReport();
	
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
