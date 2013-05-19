import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import ship.sampleshipping.InboxDrilldownSampleShipping;
import ship.sampleshipping.SampleShippingController;
import ship.sampleshipping.SampleShippingModelLocator;
import ship.sampleshipping.SampleShippingServices;
import ship.sampleshipping.components.SampleShippingAddEdit;

import valueObjects.ModeVO;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:SampleShippingModelLocator = new SampleShippingModelLocator();

public function handleSampleShippingAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new SampleShippingController();
	__genModel.services 			= 	new SampleShippingServices();
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
	__localModel.listObj.isdrilldownrow			= 'Y';
	__localModel.listObj.isObjectFromDrillDown	= 'Y';
	__localModel.listObj.isfixedurl				= 'Y';
	__localModel.listObj.drilldown_component_code	= 'ship/shipjob/components/ShipJob.swf'

	__localModel.addEditObj.addEditContainer 	= new SampleShippingAddEdit();
    __localModel.listObj.listGrid 				= listControlComponent.dgList;
    
    __localModel.listObj.idrilldown				= new InboxDrilldownSampleShipping();
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
