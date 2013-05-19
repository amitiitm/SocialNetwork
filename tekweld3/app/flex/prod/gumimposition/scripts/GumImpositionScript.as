import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import prod.gumimposition.GumImpositionController;
import prod.gumimposition.GumImpositionModelLocator;
import prod.gumimposition.GumImpositionServices;
import prod.gumimposition.InboxDrilldownGumImposition;
import prod.gumimposition.components.GumImpositionAddEdit;

import valueObjects.ModeVO;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:GumImpositionModelLocator = new GumImpositionModelLocator();

public function handleGumImpositionAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new GumImpositionController();
	__genModel.services 			= 	new GumImpositionServices();
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

	__localModel.addEditObj.addEditContainer 	= new GumImpositionAddEdit();
    __localModel.listObj.listGrid 				= listControlComponent.dgList;
    
     __localModel.listObj.isdrilldownrow		= 'Y';
      __localModel.listObj.isfixedurl			= 'Y';
     __localModel.listObj.drilldown_component_code	= 'prod/indigojob/components/IndigoJob.swf'
    __localModel.listObj.idrilldown				= new InboxDrilldownGumImposition();
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
	
	
	this.bcp.btnSave.toolTip	= "Send To Print";
	this.bcp.btnSave.visible			= false;
	this.bcp.btnSave.includeInLayout	= false;
}
