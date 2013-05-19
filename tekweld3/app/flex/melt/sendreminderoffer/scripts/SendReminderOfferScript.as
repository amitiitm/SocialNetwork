import business.events.InitializeEditableListEvent;
import com.generic.events.GenModuleEvent;
import melt.sendreminderoffer.SendReminderOfferController;
import melt.sendreminderoffer.SendReminderOfferModelLocator;
import melt.sendreminderoffer.SendReminderOfferServices;
import melt.sendreminderoffer.components.SendReminderOfferAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:SendReminderOfferModelLocator = new SendReminderOfferModelLocator();

public function handleSendReminderOfferAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new SendReminderOfferController();
	__genModel.services 			= 	new SendReminderOfferServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id;
	__localModel.documentObj.create_permission 	= __genModel.applicationObject.selectedMenuItem.@create_permission;
	__localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission;
	__localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
	__localModel.documentObj.upload_permission 	= 'Y';

	__localModel.addEditObj.addEditContainer = new SendReminderOfferAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeEditableListEvent();
	initializeEvent.dispatch();
}
