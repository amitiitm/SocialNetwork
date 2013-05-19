import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import prod.embroideryfilm.EmbroideryFilmController;
import prod.embroideryfilm.EmbroideryFilmModelLocator;
import prod.embroideryfilm.EmbroideryFilmServices;
import prod.embroideryfilm.InboxDrilldownEmbroideryFilm;
import prod.embroideryfilm.components.EmbroideryFilmAddEdit;

import ship.directshipping.DirectShippingController;
import ship.directshipping.DirectShippingModelLocator;
import ship.directshipping.DirectShippingServices;
import ship.directshipping.InboxDrilldownDirectShipping;
import ship.directshipping.components.DirectShippingAddEdit;

import valueObjects.ModeVO;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:DirectShippingModelLocator = new DirectShippingModelLocator();

public function handleDirectShippingAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new DirectShippingController();
	__genModel.services 			= 	new DirectShippingServices();
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

	__localModel.addEditObj.addEditContainer 	= new DirectShippingAddEdit();
    __localModel.listObj.listGrid 				= listControlComponent.dgList;
    
    __localModel.listObj.idrilldown				= new InboxDrilldownDirectShipping();
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
