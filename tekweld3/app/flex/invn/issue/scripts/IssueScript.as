import business.events.InitializeDataEntryEvent;

import com.generic.events.GenModuleEvent;

import invn.issue.IssueController;
import invn.issue.IssueModelLocator;
import invn.issue.IssueServices;
import invn.issue.components.IssueAddEdit;

import model.GenModelLocator;

import mx.events.FlexEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:IssueModelLocator = new IssueModelLocator();

public function handleIssueAcitve(event:GenModuleEvent):void
{
	__genModel.controller 			= 	new IssueController();
	__genModel.services 			= 	new IssueServices();
	__genModel.activeModelLocator 	= 	__localModel;
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID 			= __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission 		= __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission 		= __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission 		= __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission 		= 'Y' // Later we set thru column value

	__localModel.addEditObj.addEditContainer = new IssueAddEdit()
    __localModel.listObj.listGrid = listControlComponent.dgList;
    
	vbAddEdit.addChild(__localModel.addEditObj.addEditContainer);
	
	initializeEvent = new InitializeDataEntryEvent();
	initializeEvent.dispatch();
}
