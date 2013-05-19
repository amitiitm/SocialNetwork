import business.events.AddEditEvent;
import business.events.GetRecordEvent;
import business.events.InitializeDataEntryEvent;
import business.events.InitializeViewEvent;
import business.events.PopulateListEvent;
import business.events.ViewOnlyRecordEvent;

import com.generic.events.GenModuleEvent;
import com.generic.events.ListControlEvent;

import flash.events.Event;

import model.GenModelLocator;

import mx.controls.Alert;

import valueObjects.ModeVO;

[Bindable]
public var _view:XML;


[Bindable]
public var isSortOrderSelectionVisible:Boolean;

[Bindable]
public var isRecordViewOnly:Boolean;

[Bindable]
public var isAddPermission:String	=	"Y";

[Bindable]
public var isImportVisible:Boolean	=	false;

[Bindable]
public var downloadedRootNode:String = "rows";

[Bindable]
public var sampleURL:String = "";

[Bindable]
public var isModifyPermission:String	=	"Y";
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
public var recordInfo:XML

[Bindable]
public var isCopyRecord:Boolean	=	false;

protected var initializeEvent:InitializeDataEntryEvent;
protected var populateListEvent:PopulateListEvent
protected var initializeViewEvent:InitializeViewEvent
private var getRecordEvent:GetRecordEvent;
private var addEditEvent:AddEditEvent;
private var viewOnlyRecordEvent:ViewOnlyRecordEvent;//new
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

protected function handleModuleActive(event:GenModuleEvent):void {}
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
	initializeViewEvent	=	new InitializeViewEvent()
	initializeViewEvent.dispatch();
		
	populateListEvent = new PopulateListEvent(drillCriteria); 
	populateListEvent.dispatch();		
} 
private function handleResetFilterEvent(event:Event):void
{
	listControlComponent.resetFilter();
}
private function handleFilterEvent(event:Event):void
{
	listControlComponent.filter();
}
private function genModuleShortcutKeyHandler(event:GenModuleEvent):void
{
	if( __genModel.activeModelLocator.documentObj.selectedMode == ModeVO.LIST_MODE)
	{
		bcpList.shortcutKeyHandler(event);	
	}
	else if( __genModel.activeModelLocator.documentObj.selectedMode == ModeVO.EDIT_MODE)
	{
		bcpDataEntry.shortcutKeyHandler(event);	
	}
	else if( __genModel.activeModelLocator.documentObj.selectedMode == ModeVO.IMPORT_MODE)
	{
		bcpDataEntryImport.shortcutKeyHandler(event);	
	}

	
}
public function set mode(mode:int):void
{
	switch(mode)
	{
		case  ModeVO.EDIT_MODE :		vsButtonControlPanel.selectedIndex	=	1;
										vsViews.selectedIndex				=	1;
										//vbTree.visible						=	false;
		                        		break;
		                        		
		case  ModeVO.LIST_MODE :		
										vsButtonControlPanel.selectedIndex	=	0;
										vsViews.selectedIndex				=	0;
										//vbTree.visible						=	true;
		                       		 	break;
	
		case  ModeVO.VIEW_ONLY_WITH_TREE_MODE :
		
										vsButtonControlPanel.selectedIndex	=	0;
										vsViews.selectedIndex				=	1;
										//vbTree.visible						=	true;
		                       		 	break;
		                        			     	
		case  ModeVO.VIEW_ONLY_MODE :	
										vsButtonControlPanel.selectedIndex	=	1;
										vsViews.selectedIndex				=	1;
										//vbTree.visible						=	false;
		                       			break;
                   		                        		                         
		case  ModeVO.IMPORT_MODE:	
										vsButtonControlPanel.selectedIndex	=	2;
										vsViews.selectedIndex				=	2;
										//vbTree.visible						=	false;
										bcpDataEntryImport.reset();
	                       				break;
	}	
}
public function set view(aXML:XML):void
{
	bcpList.view = aXML;
	
	//cbView.dataProvider = aXML.children();
}
public function set defaultView(aXML:XML):void
{
	bcpList.defaultView = aXML;
	
	//cbView.selectedItem	= aXML;
}
private function listItemClickHandler(event:ListControlEvent):void
{
	/* this service is now calling from AddEditCommand
	 getRecordEvent = new GetRecordEvent(int(__genModel.activeModelLocator.listObj.selectedRow.id.toString()),null,false);
	getRecordEvent.dispatch();	 */
}
private function listItemdoubleClickHandler(event:ListControlEvent):void
{
	//previously it was used to open view only mode with tree now it is being used to open in edit mode in getRecordCommnad.
	 getRecordEvent = new GetRecordEvent(int(__genModel.activeModelLocator.listObj.selectedRow.id.toString()),null,true);
	getRecordEvent.dispatch(); 
	
	
	/*16 march 2011 this event is moved to GetRecordCommand since we want to call this event after calling RETRIEVE_RECORD_END_EVENT 
	viewOnlyRecordEvent	=	new ViewOnlyRecordEvent();
	viewOnlyRecordEvent.dispatch(); */
}
