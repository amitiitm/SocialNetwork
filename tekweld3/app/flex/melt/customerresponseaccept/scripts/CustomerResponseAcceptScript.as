import business.events.InitializeEditableListEvent;
import com.generic.events.GenModuleEvent;
import melt.customerresponseaccept.CustomerResponseAcceptController;
import melt.customerresponseaccept.CustomerResponseAcceptModelLocator;
import melt.customerresponseaccept.CustomerResponseAcceptServices;
import melt.customerresponseaccept.components.CustomerResponseAcceptAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:CustomerResponseAcceptModelLocator = new CustomerResponseAcceptModelLocator();

public function handleCustomerResponseAcceptAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new CustomerResponseAcceptController();
	__genModel.services 			= 	new CustomerResponseAcceptServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= 1314;
	
	//__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new CustomerResponseAcceptAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
