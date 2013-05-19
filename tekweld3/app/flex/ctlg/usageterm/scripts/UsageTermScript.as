import business.events.InitializeDataEntryWithNoListEvent;
import com.generic.events.GenModuleEvent;
import ctlg.usageterm.UsageTermController;
import ctlg.usageterm.UsageTermModelLocator;
import ctlg.usageterm.UsageTermServices;
import ctlg.usageterm.components.UsageTermAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:UsageTermModelLocator = new UsageTermModelLocator();

public function handleUsageTermAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new UsageTermController();
	__genModel.services = new UsageTermServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new UsageTermAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
