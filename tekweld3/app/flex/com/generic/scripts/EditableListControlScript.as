import business.events.AddEditEvent;
import business.events.GetRecordEvent;
import business.events.InitializeEditableListEvent;
import business.events.InitializeViewEvent;
import business.events.PopulateListEvent;
import business.events.ViewOnlyRecordEvent;

import com.generic.events.GenModuleEvent;
import com.generic.events.ListControlEvent;

import model.GenModelLocator;

import mx.core.Container;

[Bindable]
public var _view:XML;


[Bindable]
public var isSortOrderSelectionVisible:Boolean;

[Bindable]
public var isRecordViewOnly:Boolean;

//to set sortOrderSelection related variables
[Bindable]
public var sortField:XMLList;

[Bindable]
public var defaultLevelXml:XML; // to set default selected level for level comboboxes.

[Bindable]
public var treeXml:XML;   // to create filter tree

[Bindable]
public var filteredList:XML;

[Bindable]
public var listFormat:XML;

[Bindable]
public var isPrintMultipalRecords:Boolean	=	false;

[Bindable]
public var isViewVisible:Boolean	= true;

protected var initializeEvent:InitializeEditableListEvent;
protected var populateListEvent:PopulateListEvent;
protected var initializeViewEvent:InitializeViewEvent;
private var getRecordEvent:GetRecordEvent;
private var addEditEvent:AddEditEvent;
private var viewOnlyRecordEvent:ViewOnlyRecordEvent;//new
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

protected function handleModuleActive(event:GenModuleEvent):void {}

[Bindable]
public var customBar:Container;

protected function handleDrillDown():void
{
	if(__genModel.triggerSource	==	'DRILLDOWN' 
	&& listFormat != XML(undefined) 
	&& listFormat != null 
	&& listFormat.children().length() > 0)//means not first time called
	{
		var drillCriteria:XML
		drillCriteria	=	__genModel.drillObj.getDrillDownCriteria(__genModel.applicationObject.selectedMenuItem.@component_cd,__genModel.user.default_company_id,__genModel.user.userID,__genModel.activeModelLocator.documentObj.documentID);
		
		setTimeout(populateList,1000,drillCriteria)			
	} 
} 
private function populateList(drillCriteria:XML):void
{	
	/*if this is not workinig fine in the case when isViewVisible = false in local model locator 
	than use  __genModel.activeModelLocator.isViewVisible here and also check hasOwnProperty first*/
	if(isViewVisible)
	{
		initializeViewEvent	=	new InitializeViewEvent()
		initializeViewEvent.dispatch();		
	}
	
	populateListEvent = new PopulateListEvent(drillCriteria); 
	populateListEvent.dispatch();
}
private function genModuleShortcutKeyHandler(event:GenModuleEvent):void
{
	bcp.shortcutKeyHandler(event);
}
private function handleResetFilterEvent(event:Event):void
{
	__genModel.activeModelLocator.addEditObj.addEditContainer.inbox.resetFilter();
	
}
private function handleFilterEvent(event:Event):void
{
	__genModel.activeModelLocator.addEditObj.addEditContainer.inbox.filter();
}
public function set view(aXML:XML):void
{
	bcp.view = aXML;
	//cbView.dataProvider = aXML.children();
}

public function set defaultView(aXML:XML):void
{
	bcp.defaultView = aXML;
	
	//cbView.selectedItem	= aXML;
}

private function listItemClickHandler(event:ListControlEvent):void
{
	getRecordEvent = new GetRecordEvent(int(__genModel.activeModelLocator.listObj.selectedRow.id.toString()));
	getRecordEvent.dispatch();	
}

private function listItemdoubleClickHandler(event:ListControlEvent):void
{
	getRecordEvent = new GetRecordEvent(int(__genModel.activeModelLocator.listObj.selectedRow.id.toString()));
	getRecordEvent.dispatch();
	
	viewOnlyRecordEvent	=	new ViewOnlyRecordEvent();
	viewOnlyRecordEvent.dispatch();
}
