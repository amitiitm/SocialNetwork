import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import saoi.pickorder.PickOrderController;
import saoi.pickorder.PickOrderModelLocator;
import saoi.pickorder.PickOrderServices;
import saoi.pickorder.components.PickOrderAddEdit;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PickOrderModelLocator = new PickOrderModelLocator();

public function handlePickOrderAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new PickOrderController();
	__genModel.services 			= 	new PickOrderServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new PickOrderAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
 //	__localModel.listObj.isdrilldownrow		=	"Y";
	//__localModel.listObj.variabledrilldown	= 	"N";
	
	//__localModel.listObj.drilldown_component_code = "saoi/salesorder/components/SalesOrder.swf"	
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	this.bcp.btnSave.visible	= false;
	this.bcp.btnSave.includeInLayout = false;
	this.bcp.btnPrint.visible	= false;
	this.bcp.btnPrint.includeInLayout = false;
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
