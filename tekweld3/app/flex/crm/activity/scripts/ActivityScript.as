import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import crm.activity.ActivityController;
import crm.activity.ActivityModelLocator;
import crm.activity.ActivityServices;
import crm.activity.components.ActivityAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:ActivityModelLocator = new ActivityModelLocator();

public function handleActivityAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new ActivityController();
	__genModel.services   = new ActivityServices();
	__genModel.activeModelLocator = __localModel;
	//	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new ActivityAddEdit()
	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}

