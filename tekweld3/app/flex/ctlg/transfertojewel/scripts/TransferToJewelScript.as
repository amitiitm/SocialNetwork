import business.events.InitializeEditableListEvent;
import com.generic.events.GenModuleEvent;
import ctlg.transfertojewel.TransferToJewelController;
import ctlg.transfertojewel.TransferToJewelModelLocator;
import ctlg.transfertojewel.TransferToJewelServices;
import ctlg.transfertojewel.components.TransferToJewelAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:TransferToJewelModelLocator = new TransferToJewelModelLocator();

public function handleTransferToJewelAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new TransferToJewelController();
	__genModel.services 			= 	new TransferToJewelServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new TransferToJewelAddEdit();
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
       __localModel.listObj.isdrilldownrow	=	"Y"
    __localModel.listObj.drilldown_component_code	=	"ctlg/catalogorder/components/CatalogOrder.swf"
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
