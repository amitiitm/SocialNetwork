import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

//import rept.acct.gl.generalledgerdetail.DrillDownGeneralLedgerDetail;
import rept.acct.gl.generalledgerdetail.GeneralLedgerDetailController;
import rept.acct.gl.generalledgerdetail.GeneralLedgerDetailModelLocator;
import rept.acct.gl.generalledgerdetail.GeneralLedgerDetailServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:GeneralLedgerDetailModelLocator = new GeneralLedgerDetailModelLocator();

public function handleGeneralLedgerDetailActive(event:GenModuleEvent):void
{
	__genModel.controller			= new GeneralLedgerDetailController();
	__genModel.services 			= new GeneralLedgerDetailServices();
	__genModel.activeModelLocator 	= __localModel;
	
	//must required in drill target
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID			= __genModel.applicationObject.selectedMenuItem.@document_id;
    __localModel.documentObj.create_permission 	= "N";
    __localModel.documentObj.modify_permission 	= "N";
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
    __localModel.documentObj.upload_permission 	= "N";

	this.bcpReportView.btnConfigureColumn.enabled = false
	
	__localModel.reportObj.customReportDataGrid = this.customReportComponent;
	//__localModel.reportObj.idrilldown = new DrillDownGenera();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
