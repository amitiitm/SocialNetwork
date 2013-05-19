import acct.bounceandvoidcheck.BounceAndVoidCheckController;
import acct.bounceandvoidcheck.BounceAndVoidCheckModelLocator;
import acct.bounceandvoidcheck.BounceAndVoidCheckServices;
import acct.bounceandvoidcheck.components.BounceAndVoidCheckAddEdit;
import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:BounceAndVoidCheckModelLocator = new BounceAndVoidCheckModelLocator();

public function handleBounceAndVoidCheckAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new BounceAndVoidCheckController();
	__genModel.services = new BounceAndVoidCheckServices();
	__genModel.activeModelLocator = __localModel;
	
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new BounceAndVoidCheckAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
      
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
