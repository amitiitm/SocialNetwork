import business.events.DetailEditEvent;
import business.events.DetailImportEvent;
import business.events.RecordStatusEvent;

import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.DetailEvent;

import flash.events.Event;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.events.DataGridEvent;
import mx.events.ListEvent;

import valueObjects.DetailEditVO;

private var recordStatusEvent:RecordStatusEvent;
public var recordStatusEnabled:Boolean = true;
public var DetailEditClass:Class;
public var DetailImportClass:Class;
private var detailEditEvent:DetailEditEvent;
private var detailImportEvent:DetailImportEvent;
private var _viewOnlyFlag:Boolean = false;
private var _initialEditableFlag:Boolean = true;
private var _structure:XML;


[Bindable]
public var deleteOnlyUnSavedRow:Boolean = false;

[Bindable]
public var updatableFlag:String = "false";

[Bindable]
public var checkBlankRowColumn:String = "";

[Bindable]
public var rootNode:String = "";

[Bindable]
public var formatServiceID:String = "";

[Bindable]
public var title:String = "";

[Bindable]
public var deletedRows:XML;

[Bindable]
public var uploadServiceID:String = "";

[Bindable]
public var downloadedRootNode:String = "";

[Bindable]
public var btnImportVisible:Boolean	=	false;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function set structure(aXML:XML):void
{
	_structure = aXML;
	dgDtl.editable  = true;
	dgDtl.structure = aXML;
}

public function get structure():XML
{
	return _structure;
}
public function set initialEditableFlag(aBoolean:Boolean):void //jeetu 21/01/2010 
{
 	_initialEditableFlag	=	true;
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}

public function set dataValue(aXML:XML):void //jeetu 21/01/2010 
{
 	dgDtl.rows	=	aXML;
}

public function get dataValue():XML
{
 	return dgDtl.rows;
}
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
public function set viewOnlyFlag(aBoolean:Boolean):void
{
 	if(initialEditableFlag)
 	{
	 	_viewOnlyFlag = aBoolean
 	}
}

public function get viewOnlyFlag():Boolean
{
 	return _viewOnlyFlag
}
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

private function itemClickHandler(event:ListEvent):void 
{
	dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ITEM_CLICK, null,event,null));
}

private function itemFocusOutHandler(event:DataGridEvent):void
{
	dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ITEM_FOCUS_OUT,event,null,null));
}

private function editRowHandler(event:Event):void
{
	__genModel.activeModelLocator.detailEditObj = new DetailEditVO();
	if(event.target.id.toString()=='dgDtl')
	{
		__genModel.activeModelLocator.detailEditObj.isDobleClickOnGrid = true;
	}
	else
	{
		__genModel.activeModelLocator.detailEditObj.isDobleClickOnGrid = false;
	}
	__genModel.activeModelLocator.detailEditObj.genDataGrid	=	dgDtl	;
	__genModel.activeModelLocator.detailEditObj.selectedRow	=	dgDtl.selectedRow;
	__genModel.activeModelLocator.detailEditObj.title		=	title;

	__genModel.activeModelLocator.detailEditObj.detailEditContainer = new  DetailEditClass();

	detailEditEvent = new DetailEditEvent();
	detailEditEvent.dispatch();

}	
private function importEventHandler(event:ButtonControlDetailEvent):void
{
	if(!viewOnlyFlag)
	{
		if(dgDtl.rows.children().length() <= 0)
		{
			__genModel.activeModelLocator.detailEditObj = new DetailEditVO();
		
			__genModel.activeModelLocator.detailEditObj.genDataGrid			=	dgDtl	;
			__genModel.activeModelLocator.detailEditObj.selectedRow			=	dgDtl.selectedRow;
			__genModel.activeModelLocator.detailEditObj.title				=	title;
			__genModel.activeModelLocator.detailEditObj.uploadServiceID		=	uploadServiceID;
			__genModel.activeModelLocator.detailEditObj.downloadedRootNode	=	downloadedRootNode;
			
			__genModel.activeModelLocator.detailEditObj.detailEditContainer = new  DetailImportClass();
	
			detailImportEvent = new DetailImportEvent();
			detailImportEvent.dispatch();
			
		}
		else
		{
			
		}
	}
}

private function removeRowHandler(event:ButtonControlDetailEvent):void
{
	deleteRow(dgDtl.selectedIndex);
}

// VD 14/03/2011
public function deleteRow(row:int):void
{
	if(!viewOnlyFlag)
	{
		if(row >= 0)
		{	
			var tempXml:XML;
			var dgDtlRow:XML = new XML(dgDtl.dataProvider[row]);
			var node:String = dgDtlRow.localName();
			var deleteChild:XML	=	new XML(dgDtlRow);
			
			if(deleteOnlyUnSavedRow && (Number(deleteChild.child('id').toString()) > 0))               // So 24 may 2012
			{
				return;
			}
			
			deleteChild.trans_flag = "D";
					
			if(Number(deleteChild.child('id').toString()) > 0)
			{
				XML(dgDtl.deletedRows).appendChild(deleteChild);
			} 
					
			delete dgDtl.rows.child(node)[row];	
			tempXml	=  new XML(XML(dgDtl.rows).copy());
			dgDtl.rows	=	tempXml; 
					
			dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));
			
			if(recordStatusEnabled)
			{
				recordStatusEvent = new	RecordStatusEvent("MODIFY");
				recordStatusEvent.dispatch();
			}
		}
		
	}
}

private function creationCompleteHandler():void
{
	dgDtl.rows  = new XML('<' + rootNode + '/>');
	dgDtl.selectedRow	=	null;
	dgDtl.deletedRows	=	new XML('<' + rootNode + '/>');
	//deletedRows	=	new XML('<' + rootNode + '/>');
}

