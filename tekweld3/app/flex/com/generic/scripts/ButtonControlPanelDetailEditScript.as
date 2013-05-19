import business.events.CancelRowEvent;
import business.events.CopyRowEvent;
import business.events.FirstRowEvent;
import business.events.InsertRowEvent;
import business.events.LastRowEvent;
import business.events.NextRowEvent;
import business.events.PreSaveRowEvent;
import business.events.PreviousRowEvent;

import com.generic.genclass.ShortCut;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.DateFormatter;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance()
private var _rowUpdateInfo:String;

public function btnAddClickHandler():void
{
	var insertRowEvent:InsertRowEvent = new InsertRowEvent();
	insertRowEvent.dispatch();
}			

public function btnSaveClickHandler():void
{
	var preSaveRowEvent:PreSaveRowEvent = new PreSaveRowEvent();
	preSaveRowEvent.dispatch();
}		

public function btnCancelClickHandler():void
{
	var cancelRowEvent:CancelRowEvent = new CancelRowEvent();
	cancelRowEvent.dispatch();
}		

public function btnFirstClickHandler():void
{
	var firstRowEvent:FirstRowEvent = new FirstRowEvent();
	firstRowEvent.dispatch();
}			

public function btnPreviousClickHandler():void
{
	var previousRowEvent:PreviousRowEvent = new PreviousRowEvent();
	previousRowEvent.dispatch();
}			

public function btnNextClickHandler():void
{
	var nextRowEvent:NextRowEvent = new NextRowEvent();
	nextRowEvent.dispatch();
}			

public function btnLastClickHandler():void
{
	var lastRowEvent:LastRowEvent = new LastRowEvent();
	lastRowEvent.dispatch();
}		
public function set rowInfo(aXML:XML):void
{
	if(aXML	==	XML(undefined)	||   aXML	==	null || aXML.child('id').toString()	==	'' || int(aXML.child('id').toString())	==	0)
	{
		rowUpdateInfo	=	'';
	}
	else
	{
		rowUpdateInfo	=	'Last Updated : '  + getFormattedDate(aXML.child('updated_at').toString()) + ' , '+ aXML.child('updated_by_code').toString()
		 
	}
	
}	
[Bindable]
public function set rowUpdateInfo(aString:String):void
{
	_rowUpdateInfo	=	aString;
}
public function get rowUpdateInfo():String
{
	return _rowUpdateInfo;
}
private function btnCopyClickHandler():void
{
	if(__genModel.activeModelLocator.detailEditObj.selectedRow	!=	null)
	{
		var copyRowEvent:CopyRowEvent	=	new CopyRowEvent();
		copyRowEvent.dispatch();
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
public function shortcutKeyHandler(event:KeyboardEvent):void
{
	var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
	var keyCode:int 		= 	event.keyCode;
	var isShiftKey:Boolean	=	event.shiftKey;
	
	if(ShortCut.isSave(event,btnSave))
	{
		btnSave.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isReset(event,btnCancel))
	{
		btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isADD(event,btnAdd))
	{
		btnAdd.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isCopyRecord(event,btnCopyRow))
	{
		btnCopyRow.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isFirst(event,btnFirst)) // ctrl + <    first
	{
		btnFirst.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isPrevious(event,btnPrevious)) //109  //ctrl + '-'   prvious
	{
		btnPrevious.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isNext(event,btnNext)) //107  ctrl + '+'  next
	{
		btnNext.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isLast(event,btnLast)) //ctrl + >       last
	{
		btnLast.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
}