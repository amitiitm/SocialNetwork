// ActionScript file
import business.events.*;

import com.generic.events.GenModuleEvent;
import com.generic.genclass.ShortCut;

import flash.events.Event;
import flash.events.KeyboardEvent;

import model.GenModelLocator;


private var queryEvent:QueryEvent;		
private var layoutEvent:LayoutEvent;		
private var printReportEvent:PrintReportEvent;	
private var printRecordFromReportEvent:PrintRecordFromReportEvent	
private var printDataInSpecificFormatEvent:PrintDataInSpecificFormatEvent;
private var exportEvent:ExportEvent;		
private var configureColumnEvent:ConfigureColumnEvent;			
private var refreshEvent:RefreshEvent;
private var notesEvent:NotesEvent;			
private var attachmentsEvent:AttachmentsEvent;
[Bindable]
public var isPrintInSpecificFormat:Boolean	=	false;
[Bindable]
public var isRecordPrint:Boolean	=	false;			
[Bindable]			
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function btnPrintClickHandler():void
{
	printReportEvent = new PrintReportEvent();
	printReportEvent.dispatch();
}	
private function btnPrintRecordClickHandler():void
{
	printRecordFromReportEvent = new PrintRecordFromReportEvent();
	printRecordFromReportEvent.dispatch();
}	
private function btnPrintRecordInExcelClickHandler():void
{
	printRecordFromReportEvent = new PrintRecordFromReportEvent("Y");
	printRecordFromReportEvent.dispatch();
}	
private function btnPrintSpecificFormatClickHandler():void
{
	printDataInSpecificFormatEvent = new PrintDataInSpecificFormatEvent('REPORT');
	printDataInSpecificFormatEvent.dispatch();
}
public function btnRefreshClickHandler():void
{
	refreshEvent = new RefreshEvent();
	refreshEvent.dispatch();
} 		

public function btnNoteClickHandler():void
{
	notesEvent = new NotesEvent();
	notesEvent.dispatch();
} 		

public function btnAttachmentClickHandler():void
{
	attachmentsEvent = new AttachmentsEvent();
	attachmentsEvent.dispatch();
} 		

private function exportGridEventHandler():void
{
	exportEvent = new ExportEvent();
	exportEvent.dispatch();
}

public function btnQueryClickHandler():void
{
	queryEvent = new QueryEvent();
	queryEvent.dispatch();
}		
private  function btnConfigureColumnClickHandler():void
{
	configureColumnEvent = new ConfigureColumnEvent();
	configureColumnEvent.dispatch();
}
private function btnExpandTreeEventHandler():void
{
	dispatchEvent(new Event('expandTreeEvent'));
}
private function btnCollapsTreeClickHandler():void
{
	dispatchEvent(new Event('collapsTreeEvent'));
}
public function set view(aXML:XML):void
{
	cbView.dataProvider = aXML.children();
}

public function set defaultView(aXML:XML):void
{
	cbView.selectedItem	= aXML;
}
public function set layout(aXML:XML):void
{
	cbReportLayout.dataProvider = aXML.children();
}
public function set defaultLayout(aXML:XML):void
{
	cbReportLayout.selectedItem	= aXML;
}
public function cmbViewChangeHandler(event:Event):void
{
	if(XML((event.target).selectedItem).criteria_type.toString() != 'T')
	{
		__genModel.activeModelLocator.viewObj.selectedView = XML((event.target).selectedItem);
		__genModel.activeModelLocator.viewObj.selectedView[0]["default_yn"] = "Y"
		__genModel.activeModelLocator.viewObj.selectedView[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 04 Jul 2010.
	
		var saveViewEvent:SaveViewEvent = new SaveViewEvent(__genModel.activeModelLocator.viewObj.selectedView);
		saveViewEvent.dispatch();
	
		var populateListEvent:PopulateListEvent = new PopulateListEvent(__genModel.activeModelLocator.viewObj.selectedView);
		populateListEvent.dispatch();
			
	}
}
public function comboLayoutChangeHandler(event:Event):void
{
	__genModel.activeModelLocator.layoutObj.selectedLayout = XML((event.target).selectedItem);
	__genModel.activeModelLocator.layoutObj.listFormat = XML(XML(__genModel.activeModelLocator.layoutObj.selectedLayout).child('report_layout_columns'));
	__genModel.activeModelLocator.layoutObj.selectedLayout[0]["default_yn"] = "Y"

	__genModel.activeModelLocator.layoutObj.changeInLayout	=	new XML();
	
	var saveLayoutEvent:SaveLayoutEvent = new SaveLayoutEvent(__genModel.activeModelLocator.layoutObj.selectedLayout);
	saveLayoutEvent.dispatch();
}
public function shortcutKeyHandler(event:GenModuleEvent):void
{
	var char:String = String.fromCharCode(KeyboardEvent(event.keyBoardEvent).charCode).toUpperCase();
	var keyCode:int 			= 	KeyboardEvent(event.keyBoardEvent).keyCode;
	var isShiftKey:Boolean	=	KeyboardEvent(event.keyBoardEvent).shiftKey;
	
	if(ShortCut.isQuery(event.keyBoardEvent,btnQuery))
	{
		btnQuery.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isExport(event.keyBoardEvent,btnExport))
	{
		btnExport.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isPrint(event.keyBoardEvent,btnPrint))
	{
		btnPrint.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isReferesh(event.keyBoardEvent,btnRefresh))
	{
		btnRefresh.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isExpandAll(event.keyBoardEvent,btnExpandAllNodes))
	{
		btnExpandAllNodes.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}		
	else if(ShortCut.isCollapsAll(event.keyBoardEvent,btnCollapsAllNodes))
	{
		btnCollapsAllNodes.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}			
	else if(ShortCut.isConfigureColumn(event.keyBoardEvent,btnConfigureColumn))
	{
		btnConfigureColumn.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}				
}	
