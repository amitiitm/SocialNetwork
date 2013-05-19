// ActionScript file
import business.events.*;

import com.generic.events.GenModuleEvent;
import com.generic.genclass.ShortCut;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.DateFormatter;


[Bindable]
public var isRecordViewOnly:Boolean;
[Bindable]
public var isAddPermission:String	=	"Y";
private var _recordUpdateInfo:String;
[Bindable]
public var isCopyRecord:Boolean	=	false;


private var preSaveEvent:PreSaveEvent;
private var saveRecordEvent:SaveRecordEvent;	
private var printEvent:PrintEvent;		
private var addEvent:AddEvent;			
private var notesEvent:NotesEvent;			
private var attachmentsEvent:AttachmentsEvent;
private var cancelEvent:CancelEvent;		
private var closeAddEditView:CloseAddEditViewEvent;
private var copyRecordEvent:CopyRecordEvent;
private var firstRecordEvent:FirstRecordEvent;			
private var previousRecordEvent:PreviousRecordEvent;		
private var nextRecordEvent:NextRecordEvent;			
private var lastRecordEvent:LastRecordEvent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();


public function set recordInfo(aXML:XML):void
{
	if(aXML	==	XML(undefined)	||   aXML	==	null)
	{
		recordUpdateInfo	=	'';
	}
	else
	{
		//+  aXML.children()[0].child('updated_by').toString() + ' , '
		recordUpdateInfo	=	'Last Updated : '  + getFormattedDate(aXML.children()[0].child('updated_at').toString()) + ' , '+ aXML.children()[0].child('updated_by_code').toString() 
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
public function btnAddClickHandler():void
{
	addEvent = new AddEvent();
	addEvent.dispatch();
	
	//btnEditClickHandler() // Vivek 14 Jan 2010
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


public function btnPrintClickHandler():void
{
	printEvent = new PrintEvent();
	printEvent.dispatch();
}			
public function btnPrintInExcelClickHandler():void
{
	printEvent = new PrintEvent("Y")
	printEvent.dispatch();
}
public function btnSaveClickHandler():void
{
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
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
private function btnCopyClickHandler():void
{
	if(__genModel.activeModelLocator.addEditObj.record	!=	null)
	{
		copyRecordEvent	=	new CopyRecordEvent();
		copyRecordEvent.dispatch();
	}
	else
	{
		Alert.show('Nothing to copy.');
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


/*********************************************************************************************************/
public function shortcutKeyHandler(event:GenModuleEvent):void
{
	var char:String = String.fromCharCode(KeyboardEvent(event.keyBoardEvent).charCode).toUpperCase();
	
	var keyCode:int 			= 	KeyboardEvent(event.keyBoardEvent).keyCode;
	var isShiftKey:Boolean		=	KeyboardEvent(event.keyBoardEvent).shiftKey;
	
	if(ShortCut.isADD(event.keyBoardEvent,btnAdd)) //73 ctrl + i    add
	{
		btnAdd.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isSave(event.keyBoardEvent,btnSave))// //ctrl + s save
	{
		btnSave.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isCopyRecord(event.keyBoardEvent,btnCopy))// //ctrl + shift + c   copy
	{
		btnCopy.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isListMode(event.keyBoardEvent,btnCloseAddEditView))// //ctrl + L List
	{
		btnCloseAddEditView.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isNote(event.keyBoardEvent,btnNote))// //ctrl + N notes
	{
		btnNote.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isAttachment(event.keyBoardEvent,btnAttachment))// //ctrl + H  attachments
	{
		btnAttachment.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
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
	else if(ShortCut.isReset(event.keyBoardEvent,btnCancel))// //ctrl + D 
	{
		btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}									
}