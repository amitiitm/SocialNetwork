import business.events.InitializeCustomReportEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import rept.ctlg.openaccountreceivablereport.OpenAccountReceivableReportController;
import rept.ctlg.openaccountreceivablereport.OpenAccountReceivableReportModelLocator;
import rept.ctlg.openaccountreceivablereport.OpenAccountReceivableReportServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:OpenAccountReceivableReportModelLocator = new OpenAccountReceivableReportModelLocator();

public function handleOpenAccountReceivableReportActive(event:GenModuleEvent):void
{
	__genModel.controller			= new OpenAccountReceivableReportController();
	__genModel.services 			= new OpenAccountReceivableReportServices();
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
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
