import business.events.*;

import com.generic.components.PrintInboxRecordsDetail;
import com.generic.events.GenModuleEvent;
import com.generic.genclass.ShortCut;

import flash.events.Event;
import flash.events.KeyboardEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Container;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;

[Bindable]
public var isRecordViewOnly:Boolean;

[Bindable]
public var isPrintMultipalRecords:Boolean	=	false;

private var preSaveEvent:PreSaveEvent;
private var saveRecordEvent:SaveRecordEvent;	
private var addEditEvent:AddEditEvent;		
private var queryEvent:QueryEvent;		
private var sortEvent:SortEvent;		
private var listEvent:business.events.ListEvent;		
private var layoutEvent:LayoutEvent;		
private var printEvent:PrintEvent;		
private var exportEvent:ExportEvent;		
private var configureColumnEvent:ConfigureColumnEvent;			
private var addEvent:AddEvent;			
private var notesEvent:NotesEvent;			
private var attachmentsEvent:AttachmentsEvent;
private var firstRecordEvent:FirstRecordEvent;			
private var previousRecordEvent:PreviousRecordEvent;		
private var nextRecordEvent:NextRecordEvent;			
private var lastRecordEvent:LastRecordEvent;			
private var refreshEvent:RefreshEvent;		
private var recordStatusEvent:RecordStatusEvent;
private var cancelEvent:CancelEvent;		
private var closeAddEditView:CloseAddEditViewEvent;
private var preSaveCustomEvent:PreSaveCustomEvent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function set isViewVisible(aBoolean:Boolean):void
{
	if(!aBoolean)
	{
		hbView.visible	=	false;
		hbView.height	=	0;
		hbView.width	=	0;			
	}

}
public function btnListClickHandler():void
{
   	listEvent = new business.events.ListEvent();
	listEvent.dispatch();
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

public function btnAddClickHandler():void
{
	addEvent = new AddEvent();
	addEvent.dispatch();
	
	//btnEditClickHandler() // Vivek 14 Jan 2010
}			

public function btnPrintClickHandler():void
{
	if(isPrintMultipalRecords)
	{
		var objPrintDetail:PrintInboxRecordsDetail	=	PrintInboxRecordsDetail(PopUpManager.createPopUp(this,PrintInboxRecordsDetail,true));		
		objPrintDetail.sourceButton		=	'PRINT';
	}
	else
	{
		printEvent = new PrintEvent();
		printEvent.dispatch();		
	}
}			

public function btnSaveClickHandler():void
{

	if(isPrintMultipalRecords)
	{
		var inboxXML:XML = __genModel.activeModelLocator.addEditObj.addEditContainer.inbox.selectedRows;
		if(inboxXML.children().length() > 0)
		{
			var objPrintDetail:PrintInboxRecordsDetail	=	PrintInboxRecordsDetail(PopUpManager.createPopUp(this,PrintInboxRecordsDetail,true));		
			objPrintDetail.sourceButton		=	'SAVE';
			objPrintDetail.setValues(inboxXML);
		}
		else
		{
			Alert.show("No row selected...!")
		}
	}
	else
	{
		preSaveEvent = new PreSaveEvent();
		preSaveEvent.dispatch();
	}
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

private function exportGridEventHandler():void
{
	exportEvent = new ExportEvent();
	exportEvent.dispatch();
}

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

private function btnCancelClickHandler():void
{
	cancelEvent = new CancelEvent();
	cancelEvent.dispatch();
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
	this.dispatchEvent(new Event('resetFilterInboxEvent'));
}
private function btnFilterClickHandler():void
{
	this.dispatchEvent(new Event('filterInboxEvent'));
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
	__genModel.activeModelLocator.viewObj.selectedView = XML((event.target).selectedItem);
	__genModel.activeModelLocator.viewObj.selectedView[0]["default_yn"] = "Y"
	__genModel.activeModelLocator.viewObj.selectedView[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 04 Jul 2010.

	var saveViewEvent:SaveViewEvent = new SaveViewEvent(__genModel.activeModelLocator.viewObj.selectedView);
	saveViewEvent.dispatch();

	var populateListEvent:PopulateListEvent = new PopulateListEvent(__genModel.activeModelLocator.viewObj.selectedView);
	populateListEvent.dispatch();
}


/* since tree false private function initPopUPBtn():void
{
	var menu:Menu = new Menu();
	
	menu.dataProvider = myMenuData.menuitem;
	menu.labelField	= "@label";
	menu.addEventListener(MenuEvent.ITEM_CLICK , popUPItemClickHandler)
	btnPopUp.popUp = menu;
} */

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
		default: Alert.show('item clicked' + String(event.item.@name).toLowerCase());     
	}	
}

/*[Bindable]*/
public function set customBar(aContainer:Container):void
{
	hbCustom1.addChild(aContainer)
	hbCustom1.visible = true
	hbCustom1.width = aContainer.width + 6
}
public function shortcutKeyHandler(event:GenModuleEvent):void
{
	var char:String = String.fromCharCode(KeyboardEvent(event.keyBoardEvent).charCode).toUpperCase();
	var keyCode:int 			= 	KeyboardEvent(event.keyBoardEvent).keyCode;
	var isShiftKey:Boolean	=	KeyboardEvent(event.keyBoardEvent).shiftKey;
	
	if(ShortCut.isQuery(event.keyBoardEvent,btnQuery))// 81 //ctrl + q query
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
	else if(ShortCut.isSave(event.keyBoardEvent,btnSave))
	{
		btnSave.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isReset(event.keyBoardEvent,btnCancel))
	{
		btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
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