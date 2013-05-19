import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import melt.calculateoffer.CalculateOfferController;
import melt.calculateoffer.CalculateOfferModelLocator;
import melt.calculateoffer.CalculateOfferServices;
import melt.calculateoffer.components.CalculateOfferAddEdit;
import melt.calculateoffer.components.CalculateOfferCustomButton;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:CalculateOfferModelLocator = new CalculateOfferModelLocator();

public function handleCalculateOfferAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new CalculateOfferController();
	__genModel.services 			= 	new CalculateOfferServices();
	__genModel.activeModelLocator 	= __localModel;
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new CalculateOfferAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	customBar = new CalculateOfferCustomButton();
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
