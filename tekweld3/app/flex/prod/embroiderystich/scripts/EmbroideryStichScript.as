import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import prod.embroiderystich.EmbroideryStichController;
import prod.embroiderystich.EmbroideryStichModelLocator;
import prod.embroiderystich.EmbroideryStichServices;
import prod.embroiderystich.InboxDrilldownEmbroideryStich;
import prod.embroiderystich.components.EmbroideryStichAddEdit;

import valueObjects.ModeVO;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:EmbroideryStichModelLocator = new EmbroideryStichModelLocator();

public function handleEmbroideryStichAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new EmbroideryStichController();
	__genModel.services 			= 	new EmbroideryStichServices();
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

	__localModel.addEditObj.addEditContainer 	= new EmbroideryStichAddEdit();
    __localModel.listObj.listGrid 				= listControlComponent.dgList;
    
     __localModel.listObj.isdrilldownrow		= 'Y';
      __localModel.listObj.isfixedurl			= 'Y';
     __localModel.listObj.drilldown_component_code	= 'prod/productionorder/components/ProductionOrder.swf';
    __localModel.listObj.idrilldown				= new InboxDrilldownEmbroideryStich();
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
	
	this.bcp.btnSave.toolTip	= "Send To Pick Job";
}
