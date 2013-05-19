import business.events.InitializeEditableListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import prod.embroiderystich.EmbroideryStichController;
import prod.embroiderystich.EmbroideryStichModelLocator;
import prod.embroiderystich.EmbroideryStichServices;
import prod.embroiderystich.InboxDrilldownEmbroideryStich;
import prod.embroiderystich.components.EmbroideryStichAddEdit;
import prod.pickjob.InboxDrilldownPickJob;
import prod.pickjob.PickJobController;
import prod.pickjob.PickJobModelLocator;
import prod.pickjob.PickJobServices;
import prod.pickjob.components.PickJobAddEdit;

import valueObjects.ModeVO;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PickJobModelLocator = new PickJobModelLocator();

public function handlePickJobAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new PickJobController();
	__genModel.services 			= 	new PickJobServices();
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

	__localModel.addEditObj.addEditContainer 	= new PickJobAddEdit();
    __localModel.listObj.listGrid 				= listControlComponent.dgList;
    
     __localModel.listObj.isdrilldownrow			= 'Y';
     __localModel.listObj.isfixedurl				= 'Y';
     __localModel.listObj.drilldown_component_code	= 'prod/productionorder/components/ProductionOrder.swf'
     __localModel.listObj.idrilldown				= new InboxDrilldownPickJob();
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
