import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import melt.stoppayment.StopPaymentController;
import melt.stoppayment.StopPaymentModelLocator;
import melt.stoppayment.StopPaymentServices;
import melt.stoppayment.components.StopPaymentAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:StopPaymentModelLocator = new StopPaymentModelLocator();

public function handleStopPaymentAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new StopPaymentController();
	__genModel.services 			= 	new StopPaymentServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new StopPaymentAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
