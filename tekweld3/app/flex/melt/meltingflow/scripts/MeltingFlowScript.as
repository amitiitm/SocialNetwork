import business.events.InitializeDataEntryWithNoListEvent;
import com.generic.events.GenModuleEvent;
import melt.meltingflow.MeltingFlowController;
import melt.meltingflow.MeltingFlowModelLocator;
import melt.meltingflow.MeltingFlowServices;
import model.GenModelLocator;
import mx.events.FlexEvent;

protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
protected var __localModel:MeltingFlowModelLocator = new MeltingFlowModelLocator();

public function handleOtherParametersAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new MeltingFlowController();
	__genModel.services = new MeltingFlowServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission = 'Y';

	__localModel.addEditObj.addEditContainer = new MeltingFlowAddEdit();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryWithNoListEvent();
	initializeEvent.dispatch();
}
