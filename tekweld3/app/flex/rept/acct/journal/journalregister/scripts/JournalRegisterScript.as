import business.events.InitializeCustomReportEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import rept.acct.journal.journalregister.JournalRegisterController;
import rept.acct.journal.journalregister.JournalRegisterModelLocator;
import rept.acct.journal.journalregister.JournalRegisterServices;
import rept.acct.journal.journalregister.DrilldownJournalRegister;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:JournalRegisterModelLocator = new JournalRegisterModelLocator();

public function handleJournalRegisterActive(event:GenModuleEvent):void
{
	__genModel.controller			= new JournalRegisterController();
	__genModel.services 			= new JournalRegisterServices();
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
	__localModel.reportObj.idrilldown  = new DrilldownJournalRegister();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
