import business.events.InitializeEditableListEvent;
import com.generic.events.GenModuleEvent;
import melt.customerresponsereject.CustomerResponseRejectController;
import melt.customerresponsereject.CustomerResponseRejectModelLocator;
import melt.customerresponsereject.CustomerResponseRejectServices;
import melt.customerresponsereject.components.CustomerResponseRejectAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:CustomerResponseRejectModelLocator = new CustomerResponseRejectModelLocator();

public function handleCustomerResponseRejectAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new CustomerResponseRejectController();
	__genModel.services 			= 	new CustomerResponseRejectServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= 1315;
	
	//__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new CustomerResponseRejectAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
