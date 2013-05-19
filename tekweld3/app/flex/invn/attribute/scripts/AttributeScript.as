import business.events.InitializeDataEntryEvent;
import business.events.InitializeImportEvent;
import com.generic.events.GenModuleEvent;
import invn.attribute.AttributeController;
import invn.attribute.AttributeModelLocator;
import invn.attribute.AttributeServices;
import invn.attribute.components.AttributeAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:AttributeModelLocator = new AttributeModelLocator();

public function handleAttributeAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new AttributeController();
	__genModel.services = new AttributeServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new AttributeAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
    __localModel.importObj.container = new AttributeImport()
	vbImport.addChild(__localModel.importObj.container);
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch();
}
