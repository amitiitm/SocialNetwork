import business.events.*;

import com.generic.components.PrintListRecordsDetail;
import com.generic.events.GenModuleEvent;
import com.generic.genclass.ShortCut;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.Menu;
import mx.events.MenuEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;

import valueObjects.ModeVO;

[Bindable]
public var isRecordViewOnly:Boolean;

[Bindable]
public var isAddPermission:String	=	"Y";

[Bindable]
public var isModifyPermission:String	=	"Y";
	
[Bindable]
public var isImportVisible:Boolean		=	false;

[Bindable]
public var isPrintMultipalRecords:Boolean	=	false;

[Bindable]
private var _totalRows:String;

private var _recordUpdateInfo:String;

	
private var addEditEvent:AddEditEvent;	
private var importRecordsEvent:ImportRecordsEvent;	
private var queryEvent:QueryEvent;		
private var sortEvent:SortEvent;		
private var layoutEvent:LayoutEvent;		
private var printEvent:PrintEvent;		
/* private var exportEvent:ExportEvent;	 */	
private var configureColumnEvent:ConfigureColumnEvent;			
private var addEvent:AddEvent;			
private var notesEvent:NotesEvent;			
private var attachmentsEvent:AttachmentsEvent;
private var firstRecordEvent:FirstRecordEvent;			
private var previousRecordEvent:PreviousRecordEvent;		
private var nextRecordEvent:NextRecordEvent;			
private var lastRecordEvent:LastRecordEvent;			
private var refreshEvent:RefreshEvent;		
private var listEvent:business.events.ListEvent;

private var closeAddEditView:CloseAddEditViewEvent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
public function set totalRows(totalRow:int):void
{
	
   if(totalRow == int(undefined))
   {
   	  _totalRows = 'Total Rows : ' + '0';
   }
   else
   {
		_totalRows = 'Total Rows : ' + totalRow;
   }	
}
public function set recordInfo(aXML:XML):void
{
	if(aXML	==	XML(undefined)	||   aXML	==	null)
	{
		recordUpdateInfo	=	'';
	}
	else
	{
		//+  aXML.children()[0].child('updated_by').toString() + ' , '
		recordUpdateInfo	=	'Last Updated : '  + getFormattedDate(aXML.children()[0].child('updated_at').toString()) + ' , '+ aXML.children()[0].child('updated_by_code').toString() ;
	}
	
}
[Bindable]
public function set recordUpdateInfo(aString:String):void
{
	_recordUpdateInfo	=	aString;
}
public function get recordUpdateInfo():String
{
	return _recordUpdateInfo;
}
public function btnEditClickHandler():void
{
   	addEditEvent = new AddEditEvent();
	addEditEvent.dispatch();
}

public function btnLayoutClickHandler():void
{
   	layoutEvent	= new LayoutEvent();
	layoutEvent.dispatch();
}
public function btnListClickHandler():void
{
   	listEvent = new business.events.ListEvent();
	listEvent.dispatch();
}
public function btnAddClickHandler():void
{
	addEvent = new AddEvent();
	addEvent.dispatch();	
}			
public function btnImportClickHandler():void
{
	importRecordsEvent	=	new ImportRecordsEvent();
	importRecordsEvent.dispatch();
}
public function btnPrintClickHandler():void
{
	if(isPrintMultipalRecords)
	{
		var objPrintDetail:PrintListRecordsDetail	=	PrintListRecordsDetail(PopUpManager.createPopUp(this,PrintListRecordsDetail,true));		
	}
	else
	{
		printEvent = new PrintEvent();
		printEvent.dispatch();		
	}
}			
public function btnPrintInExcelClickHandler():void
{
	printEvent = new PrintEvent("Y")
	printEvent.dispatch();
}
public function btnFirstClickHandler():void
{
	firstRecordEvent = new FirstRecordEvent();
	firstRecordEvent.dispatch();
}			

public function btnPreviousClickHandler():void
{
	previousRecordEvent = new PreviousRecordEvent();
	previousRecordEvent.dispatch();
}			

public function btnNextClickHandler():void
{
	nextRecordEvent	= new NextRecordEvent()
	nextRecordEvent.dispatch();
}			

public function btnLastClickHandler():void
{
	lastRecordEvent	= new LastRecordEvent();
	lastRecordEvent.dispatch();
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

/* private function exportGridEventHandler():void
{
	exportEvent = new ExportEvent();
	exportEvent.dispatch();
} */

public function btnQueryClickHandler():void
{
	queryEvent = new QueryEvent();
	queryEvent.dispatch();
	
	btnListClickHandler() // Vivek 14 Jan 2010
}			

public function btnSortClickHandler():void
{
	sortEvent = new SortEvent();
	sortEvent.dispatch();
}			

private function btnCloseAddEditViewClickHandler():void
{
	closeAddEditView = new CloseAddEditViewEvent();
	closeAddEditView.dispatch();
}
private  function btnConfigureColumnClickHandler():void
{
	configureColumnEvent = new ConfigureColumnEvent();
	configureColumnEvent.dispatch();
}
private function btnResetFilterClickHandler():void
{
	this.dispatchEvent(new Event('resetFilterEvent'));
}
private function btnFilterClickHandler():void
{
	this.dispatchEvent(new Event('filterEvent'));
}
public function set view(aXML:XML):void
{
	cbView.dataProvider = aXML.children();
}

public function set defaultView(aXML:XML):void
{
	cbView.selectedItem	= aXML;
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

private function initPopUPBtn():void
{
	var menu:Menu = new Menu();
	
	menu.dataProvider = myMenuData.menuitem;
	menu.labelField	= "@label";
	menu.addEventListener(MenuEvent.ITEM_CLICK , popUPItemClickHandler)
	btnPopUp.popUp = menu;
}

private function popUPItemClickHandler(event:MenuEvent):void
{
	switch(String(event.item.@name).toLowerCase())
	{
		case "configurecolumns":
			 btnConfigureColumnClickHandler();
		     break;
		case "layout":
			 btnLayoutClickHandler();
		     break;
		case "showsort":
			  btnSortClickHandler();
		      break;
		case "landscape":
			  __genModel.activeModelLocator.listObj.print_orientation	=	"L"
		     break;
		case "portrait":
	 		 __genModel.activeModelLocator.listObj.print_orientation	=	"P"
    		 break;     
		default: Alert.show('item clicked' + String(event.item.@name).toLowerCase());     
	}	
}
private function getFormattedDate(value:String):String
{
	var dateFormatter:DateFormatter = new DateFormatter();
	dateFormatter.formatString = getDateFormat();
	return dateFormatter.format(value);
}
private function getDateFormat():String
{
	var date_format:String = __genModel.user.date_format.toLocaleUpperCase();
	
	if(date_format == null || date_format == "")
	{
		date_format = 'MM/DD/YYYY';
	}
	
	return date_format;
}
public function shortcutKeyHandler(event:GenModuleEvent):void
{
	var char:String = String.fromCharCode(KeyboardEvent(event.keyBoardEvent).charCode).toUpperCase();
	
	var keyCode:int 			= 	KeyboardEvent(event.keyBoardEvent).keyCode;
	var isShiftKey:Boolean		=	KeyboardEvent(event.keyBoardEvent).shiftKey;
	
	
	if(ShortCut.isQuery(event.keyBoardEvent,btnQuery))// 81 //ctrl + q query
	{
		btnQuery.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isADD(event.keyBoardEvent,btnAdd))
	{
		btnAdd.dispatchEvent(new MouseEvent(MouseEvent.CLICK))	
	}
	else if(ShortCut.isEdit(event.keyBoardEvent,btnEdit)) //69 ctrl + e    edit
	{
		btnEdit.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isImport(event.keyBoardEvent,btnImport)) //  && btnImport.visible 77 ctrl + m   import
	{
		btnImport.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isFirst(event.keyBoardEvent,btnFirst)) // ctrl + <    first
	{
		btnFirst.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isPrevious(event.keyBoardEvent,btnPrevious)) //109  //ctrl + '-'   prvious
	{
		btnPrevious.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isNext(event.keyBoardEvent,btnNext)) //107  ctrl + '+'  next
	{
		btnNext.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isLast(event.keyBoardEvent,btnLast)) //ctrl + >       last
	{
		btnLast.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isPrint(event.keyBoardEvent,btnPrint)) //ctrl + P
	{
		btnPrint.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isReferesh(event.keyBoardEvent,btnRefresh)) // ctrl + R
	{
		btnRefresh.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isResetFilter(event.keyBoardEvent,btnResetFilter)) ////ctrl + shift + T
	{
		btnResetFilter.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isFilter(event.keyBoardEvent,btnFilter)) // ctrl + T
	{
		btnFilter.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	
}