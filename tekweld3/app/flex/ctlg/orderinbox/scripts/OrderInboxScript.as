import business.events.InitializeEditableListEvent;
import com.generic.events.GenModuleEvent;
import ctlg.orderinbox.OrderInboxController;
import ctlg.orderinbox.OrderInboxModelLocator;
import ctlg.orderinbox.OrderInboxServices;
import ctlg.orderinbox.components.OrderInboxAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:OrderInboxModelLocator = new OrderInboxModelLocator();

public function handleOrderInboxAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new OrderInboxController();
	__genModel.services 			= 	new OrderInboxServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new OrderInboxAddEdit();
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
       __localModel.listObj.isdrilldownrow	=	"Y"
    __localModel.listObj.drilldown_component_code	=	"ctlg/catalogorder/components/CatalogOrder.swf"
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
