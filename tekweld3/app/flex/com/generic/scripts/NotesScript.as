import business.events.GetGenDataGridFormatEvent;
import business.events.GetNoteEvent;
import business.events.SaveNoteEvent;

import com.generic.customcomponents.GenDateField;

import flash.events.ContextMenuEvent;
import flash.events.KeyboardEvent;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.TextArea;
import mx.core.Application;
import mx.core.FlexGlobals;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

public var _tableName:String;
public var _id:int;
public var _companyId:int;
public var _userId:int;
public var _login_type:String;

public var _email_to:String;
public var _email_cc:String;
public var _general_email_id:String;
public var _subject:String;

[Bindable]
private var notes:XML	=	new XML(<notes/>);
private var _email_from:String;
private var windowStatus:String;
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var getNoteEvent:GetNoteEvent;
private var saveNoteEvent:SaveNoteEvent;
private var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;


private function creationCompleteHandler():void
{
	this.setFocus();
	getGenDataGridFormatEvent = new GetGenDataGridFormatEvent(dgNotes);
	getGenDataGridFormatEvent.dispatch();
	
	 var callbacks:IResponder =  new mx.rpc.Responder(getNotesResultHandler,null);
	 
	getNoteEvent	=	new GetNoteEvent(callbacks);
	getNoteEvent.dispatch();
	
	setEmailAddress();

	this.x 		=  (this.screen.width - this.width) / 3
	this.y 		=  (this.screen.height - this.height) / 3	
	addRightClickMenuItem();
}
private function getNotesResultHandler(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		notes	=	resultXml
		dgNotes.dataProvider	=	notes.children();		
	}
}
private function dgItemClickHandler():void
{
	var _tmpXml:XML = XML(dgNotes.selectedItem);
	if(_tmpXml.child('id') != '')
	{
		tiEmail_Cc.editable  = false;
		tiEmail_To.editable  = false;
		tiSubject.editable 	 = false;
		taNotes.editable	 = false;
	}
	else
	{
		tiEmail_Cc.editable = true;
		tiEmail_To.editable = true;
		tiSubject.editable 	= true;
		taNotes.editable 	= true;
	}
	tiId.text		 	= 	_tmpXml.child('id');
	tiSubject.text 		= 	_tmpXml.child('subject');
	taNotes.text 		= 	_tmpXml.child('description');
	tiEmail_To.text 	= 	_tmpXml.child('email_to');
	tiEmail_Cc.text 	=   _tmpXml.child('email_cc');
	cbNotesCategory.dataValue	= _tmpXml.child('notes_category');
	
	windowStatus = 'QUERY'
}
private function addRowHandler():void
{
	tiSubject.editable = true;
	taNotes.editable = true;
	tiEmail_Cc.editable = true;
	tiEmail_To.editable = true;
	
	var _tmpXml:XML;

	if(windowStatus != 'MODIFIED' || windowStatus == null)
	{
		setEmailAddress()	;
	}
	if(dgNotes.selectedIndex >= 0)
	{
		if(tiId.text == '' &&  taNotes.text != '')
		{
			XML(dgNotes.selectedItem).email_to		= tiEmail_To.text.toLowerCase()
			XML(dgNotes.selectedItem).subject		= tiSubject.text
			XML(dgNotes.selectedItem).description	= taNotes.text
			XML(dgNotes.selectedItem).email_cc		=	tiEmail_Cc.text.toLowerCase()
		}
		
		tiSubject.text = _subject;
		taNotes.text = '';
		dgNotes.selectedIndex = -1;
		
		return
	}

	if(windowStatus == 'MODIFIED' && taNotes.text != '')
	{
		_tmpXml = new  XML(<note>
						<id></id>
						<company_id>{_companyId}</company_id>
					    <user_id>{_userId}</user_id>
						<table_name>{_tableName}</table_name>
    					<trans_id>{_id}</trans_id>
						<created_at>{new GenDateField().currentDate()}</created_at>
						<subject>{tiSubject.text}</subject>
						<description>{taNotes.text}</description>
						<email_from>{_email_from.toLowerCase()}</email_from>
						<email_to>{tiEmail_To.text.toLowerCase()}</email_to>
						<email_cc>{tiEmail_Cc.text.toLowerCase()}</email_cc>
						<notes_category>{cbNotesCategory.dataValue}</notes_category>
					  </note>);

		notes.appendChild(_tmpXml);
		
		dgNotes.dataProvider = notes.children();
		dgNotes.selectedIndex = -1;
		
		tiSubject.text = _subject;
		taNotes.text = '';
	}
}
private function setEmailAddress():void
{
	if (_login_type == 'G')
	{
		_email_from 	= _general_email_id.toLowerCase();
		tiEmail_To.text = _email_to.toLowerCase();
		tiEmail_Cc.text = _general_email_id.toLowerCase() + '' + _email_cc.toLowerCase(); //_general_email_id.toLowerCase() + ', ' + _email_cc.toLowerCase();
	}
	if (_login_type == 'V')
	{
		_email_from =  _email_to.toLowerCase();
		tiEmail_To.text = _general_email_id.toLowerCase();
		tiEmail_Cc.text = _email_to.toLowerCase() + ',' + _email_cc.toLowerCase();
	}
	tiSubject.text = _subject;
}
private function saveHandler():void
{
	addRowHandler();
	
	if(windowStatus == 'MODIFIED')
	{
	    var callbacks:IResponder =  new mx.rpc.Responder(btnSaveResultHandler,null);
		//windowStatus = 'SAVE';
		
		saveNoteEvent	=	new SaveNoteEvent(notes ,callbacks);
		saveNoteEvent.dispatch();
	}
}
private function btnSaveResultHandler(resultXml:XML):void
{
	windowStatus = 'SAVE';
	notes		=	resultXml
	dgNotes.dataProvider	=	notes.children();
}
private function firstRowHandler():void
{
	if(notes.children().length() >= 0)
	{
		dgNotes.selectedIndex = 0;
		dgItemClickHandler();
	}
}
private function lastRowHandler():void
{
	if(notes.children().length() >= 0)
	{
		dgNotes.selectedIndex = notes.children().length();
		dgItemClickHandler();		
	}
}
private function nextRowHandler():void
{
	if(dgNotes.selectedIndex < notes.children().length() - 1)
	{
		dgNotes.selectedIndex = dgNotes.selectedIndex + 1;
		dgItemClickHandler();			
	}	
}
private function previousRowHandler():void
{
	if(dgNotes.selectedIndex > 0)
	{
		dgNotes.selectedIndex = dgNotes.selectedIndex - 1;
		dgItemClickHandler();
	}
}
private function closeHandler():void
{
	if(windowStatus != 'MODIFIED')
	{
		this.parentApplication.focusManager.activate();
		PopUpManager.removePopUp(this)
		removeAllRightMenu();
	}
	else
	{
		Alert.show('Record Modified\nDiscard changes & exit ?', "Confirm", Alert.YES | Alert.NO, null, discardChangesAlertResultHandler, null,  Alert.YES);
	}
}
private function discardChangesAlertResultHandler(event:CloseEvent):void
{
	if(event.detail == Alert.YES)
	{
		this.parentApplication.focusManager.activate();
		PopUpManager.removePopUp(this) 
		removeAllRightMenu();
	}
} 
private function setWindowStatus():void
{
	windowStatus = 'MODIFIED';
}
[Bindable]private var cm:ContextMenu;
[Bindable]private var myContextMenuItem:ContextMenuItem;

private function addRightClickMenuItem():void
{
	if(__genModel.activeModelLocator.hasOwnProperty('notes_emails'))
	{
		for(var i:int=0;i<__genModel.activeModelLocator.notes_emails.length;i++)
		{
			myContextMenuItem   = new ContextMenuItem(__genModel.activeModelLocator.notes_emails[i].dataValue,true,true,true);
			myContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,rightmenuClickHandler);
			cm   = Application.application.contextMenu;
			//cm.hideBuiltInItems();
			cm.customItems.push(myContextMenuItem);
		}
		
		
	}
	else
	{
		removeAllRightMenu();
	}
}
private function rightmenuClickHandler(event:ContextMenuEvent):void
{
	tiEmail_To.dataValue	= event.currentTarget.caption;
}
private function removeAllRightMenu():void
{
	Application.application.contextMenu.customItems = new Array ();
}

private function detailKeyDownHandler(event:KeyboardEvent):void
{
	//it is needed otherwise keydown at application level will also work.
	
	var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();	
	
	if(event.ctrlKey &&  char != 'V')// we donot want to stop event when user press  ctrl + V(paste),so we cannot take ctrl + V as shortcust now 
	{
		event.stopImmediatePropagation();
		event.stopPropagation();
	}	
	
}
