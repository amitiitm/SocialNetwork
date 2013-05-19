import business.events.InitializeDataEntryWithNoListEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import stup.applicationsetting.ApplicationSettingController;
import stup.applicationsetting.ApplicationSettingModelLocator;
import stup.applicationsetting.ApplicationSettingServices;
import stup.applicationsetting.components.ApplicationSettingAddEdit;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:ApplicationSettingModelLocator = new ApplicationSettingModelLocator();

public function handleApplicationSettingAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new ApplicationSettingController();
	__genModel.services = new ApplicationSettingServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
	
	__localModel.addEditObj.addEditContainer = new ApplicationSettingAddEdit()
   

	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
