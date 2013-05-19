import business.events.DrillDownEvent;
import business.events.InitializeCustomReportEvent;
import business.events.InitializeViewEvent;
import business.events.PopulateListEvent;

import com.generic.events.CustomReportEvent;
import com.generic.events.GenModuleEvent;

import flash.utils.setTimeout;

import model.GenModelLocator;

import mx.rpc.IResponder;

[Bindable]
public var _view:XML;

[Bindable]
public var filteredReport:XML;

[Bindable]
public var reportFormat:XML;

[Bindable]
public var changeInLayout:XML;

[Bindable]
public var sortableColumns:Boolean	=	true;

[Bindable]
public var isPrintInSpecificFormat:Boolean	=	false;
[Bindable]
public var isRecordPrint:Boolean	=	false;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

protected var initializeEvent:InitializeCustomReportEvent;
protected var populateListEvent:PopulateListEvent
protected var initializeViewEvent:InitializeViewEvent
protected function handleModuleActive(event:GenModuleEvent):void {}
protected function structureCompleteEventHandler(event:CustomReportEvent):void{}

protected function handleDrillDown():void
{
	if(__genModel.triggerSource	==	'DRILLDOWN' 
		&& reportFormat != XML(undefined) 
		&& reportFormat != null 
		&& reportFormat.children().length() > 0)//means not first time called
	{
		var drillCriteria:XML	=	__genModel.drillObj.getDrillDownCriteria(__genModel.applicationObject.selectedMenuItem.@component_cd,__genModel.user.default_company_id,__genModel.user.userID,__genModel.activeModelLocator.documentObj.documentID);
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
private function genModuleShortcutKeyHandler(event:GenModuleEvent):void
{
	bcpReportView.shortcutKeyHandler(event);
}
private function expandTreeEventHandler():void
{
	customReportComponent.expandAllTreeNodes();
}
private function collapsTreeEventHandler():void
{
	customReportComponent.collapsAllTreeNodes()
}
public function set view(aXML:XML):void
{
	bcpReportView.view	=	aXML;
}

public function set defaultView(aXML:XML):void
{
	bcpReportView.defaultView	=	aXML;
}

public function set layouts(aXML:XML):void
{
	bcpReportView.layout	=	aXML;
}

public function set defaultLayout(aXML:XML):void
{
	bcpReportView.defaultLayout	=	aXML;
}

private function itemClickCustomReportHandler(event:CustomReportEvent):void {}

private function itemDoubleClickCustomReportHandler(event:CustomReportEvent):void
{
	if(customReportComponent.colname.toUpperCase()	!=	'GROUP_COLUMN')
	{
		if(customReportComponent.arrDrilldownColumns.length > 0 || __genModel.activeModelLocator.reportObj.isdrilldownrow == "Y")
		{
			if(XML(customReportComponent.selectedItem).children().length()>0)
			{
				__genModel.drillObj.drillrow		=	XML(customReportComponent.selectedItem)
				__genModel.drillObj.drillcolumn		=	customReportComponent.colname.toString()
				var callback:IResponder				=	new mx.rpc.Responder(columnDrillEventHandler,null);
				var drillDownEvent:DrillDownEvent	=	new DrillDownEvent(callback);
				drillDownEvent.dispatch();	
			}
		} 
	}
}

private function columnDrillEventHandler(obj:Object):void {}
