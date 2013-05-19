import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import crm.opportunity.OpportunityController;
import crm.opportunity.OpportunityModelLocator;
import crm.opportunity.OpportunityServices;
import crm.opportunity.components.OpportunityAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:OpportunityModelLocator = new OpportunityModelLocator();

public function handleOpportunityAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new OpportunityController();
	__genModel.services   = new OpportunityServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new OpportunityAddEdit()
	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
