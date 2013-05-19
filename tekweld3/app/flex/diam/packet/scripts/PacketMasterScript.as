import business.events.InitializeDataEntryEvent;
import com.generic.events.GenModuleEvent;
import diam.packet.PacketMasterController;
import diam.packet.PacketMasterModelLocator;
import diam.packet.PacketMasterServices;
import diam.packet.components.PacketMasterAddEdit;
import model.GenModelLocator;
import mx.events.FlexEvent;
import business.events.InitializeImportEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:PacketMasterModelLocator = new PacketMasterModelLocator();

public function handlePacketMasterAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new PacketMasterController();
	__genModel.services   = new PacketMasterServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
 
	__localModel.addEditObj.addEditContainer = new PacketMasterAddEdit()
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
     __localModel.importObj.container = new PacketMasterImport()
	vbImport.addChild(__localModel.importObj.container);
    
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
	
	var initializeImportEvent:InitializeImportEvent
	initializeImportEvent	=	new InitializeImportEvent();
	initializeImportEvent.dispatch(); 

}
