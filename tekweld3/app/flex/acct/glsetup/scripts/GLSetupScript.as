import business.events.InitializeDataEntryWithNoListEvent;
import com.generic.events.GenModuleEvent;
import acct.glsetup.GLSetupController;
import acct.glsetup.GLSetupModelLocator;
import acct.glsetup.GLSetupServices
import acct.glsetup.components.GLSetupAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:GLSetupModelLocator = new GLSetupModelLocator();

public function handleGLSetupAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new GLSetupController();
	__genModel.services = new GLSetupServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new GLSetupAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
