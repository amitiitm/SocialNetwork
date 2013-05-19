import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.acct.gl.generalledgersummary.DrillRowGeneralLedgerSummary;
import rept.acct.gl.generalledgersummary.GeneralLedgerSummaryController;
import rept.acct.gl.generalledgersummary.GeneralLedgerSummaryModelLocator;
import rept.acct.gl.generalledgersummary.GeneralLedgerSummaryServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:GeneralLedgerSummaryModelLocator = new GeneralLedgerSummaryModelLocator();

public function handleGeneralLedgerSummaryActive(event:GenModuleEvent):void
{
	__genModel.controller				= new GeneralLedgerSummaryController();
	__genModel.services 				= new GeneralLedgerSummaryServices();
	__genModel.activeModelLocator 		= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID			= __genModel.applicationObject.selectedMenuItem.@document_id;
    __localModel.documentObj.create_permission 	= "N";
    __localModel.documentObj.modify_permission 	= "N";
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
    __localModel.documentObj.upload_permission 	= "N";

	__localModel.reportObj.customReportDataGrid = this.customReportComponent;
	
	//required in drill source for variable row or column level drill functionality
	__localModel.reportObj.idrilldown	=	new DrillRowGeneralLedgerSummary();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
