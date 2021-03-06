import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.orderestimationinbox.InboxDrilldownOrderEstimationInbox;
import saoi.orderestimationinbox.OrderEstimationInboxController;
import saoi.orderestimationinbox.OrderEstimationInboxModelLocator;
import saoi.orderestimationinbox.OrderEstimationInboxServices;
import saoi.orderestimationinbox.components.OrderEstimationInbox;
import saoi.orderestimationinbox.components.OrderEstimationInboxAddEdit;

import valueObjects.ModeVO;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:OrderEstimationInboxModelLocator = new OrderEstimationInboxModelLocator();

public function handleOrderEstimationInboxAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new OrderEstimationInboxController();
	__genModel.services 			= 	new OrderEstimationInboxServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.selectedMode		=	ModeVO.LIST_MODE;
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer 	= new OrderEstimationInboxAddEdit();
    __localModel.listObj.listGrid 				= listControlComponent.dgList;
    
     __localModel.listObj.isdrilldownrow		= 'Y';
     // __localModel.listObj.isfixedurl			= 'Y';
    // __localModel.listObj.drilldown_component_code	= 'ship/shipjob/components/ShipJob.swf'
    __localModel.listObj.idrilldown				= new InboxDrilldownOrderEstimationInbox();
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
