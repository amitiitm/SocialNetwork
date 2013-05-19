import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import prod.directproduction.DirectProductionController;
import prod.directproduction.DirectProductionModelLocator;
import prod.directproduction.DirectProductionServices;
import prod.directproduction.InboxDrilldownDirectProduction;
import prod.directproduction.components.DirectProductionAddEdit;

import valueObjects.ModeVO;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:DirectProductionModelLocator = new DirectProductionModelLocator();

public function handleDirectProductionAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new DirectProductionController();
	__genModel.services 			= 	new DirectProductionServices();
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

	__localModel.addEditObj.addEditContainer = new DirectProductionAddEdit();
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
     __localModel.listObj.isdrilldownrow	= 'Y';
      __localModel.listObj.isfixedurl			= 'Y';
     __localModel.listObj.drilldown_component_code	= 'prod/productionorder/components/ProductionOrder.swf'
    __localModel.listObj.idrilldown		= new InboxDrilldownDirectProduction();
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
	
	this.bcp.btnSave.toolTip = 'Production Done';
}
