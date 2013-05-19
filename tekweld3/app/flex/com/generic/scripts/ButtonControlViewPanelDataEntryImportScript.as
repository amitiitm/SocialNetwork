// ActionScript file
import business.events.*;

import com.generic.events.GenModuleEvent;
import com.generic.events.GenUploadButtonEvent;
import com.generic.events.ImportEvent;
import com.generic.genclass.ShortCut;
import com.generic.genclass.URL;

import flash.events.KeyboardEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.core.Container;
import mx.managers.CursorManager;

[Bindable]
public var isAddPermission:String	=	"Y";

private var addEvent:AddEvent;
private var preSaveImportEvent:PreSaveImportEvent;			
private var cancelImportEvent:CancelImportEvent; 		
private var closeAddEditView:CloseAddEditViewEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
public var importedXml:XML;
[Bindable]
public var uploadServiceID:String = "recordUploadUrl";
[Bindable]
public var downloadedRootNode:String = "rows";
[Bindable]
public var sampleURL:String = "";

public function btnSaveClickHandler():void
{
	preSaveImportEvent = new PreSaveImportEvent();
	preSaveImportEvent.dispatch();
}		
//it is called from dataentryscript
public function reset():void
{
	btnCancelClickHandler();
}
 
private function btnCancelClickHandler():void
{
	tiFileName.text	=	'';
	
	cancelImportEvent = new CancelImportEvent();
	cancelImportEvent.dispatch(); 
}

private function btnCloseImportViewClickHandler():void
{
	closeAddEditView = new CloseAddEditViewEvent();
	closeAddEditView.dispatch();
}
public function btnAddClickHandler():void
{
	addEvent = new AddEvent();
	addEvent.dispatch();	
}
private function handleUploadEvent(event:GenUploadButtonEvent):void
{
	CursorManager.setBusyCursor();
	Application.application.enabled = false;

	tiFileName.text = event.fileName;
}

private function handleDownloadCompleteEvent(event:GenUploadButtonEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	
	importedXml	=	new XML(<rows/>)
	if(event.downloadedObj != null &&  XML(event.downloadedObj).children().length() > 0)
	{
		importedXml	=	XML(event.downloadedObj);
		var recordStatusEvent:RecordStatusEvent = new	RecordStatusEvent("MODIFY")
		recordStatusEvent.dispatch()
	}
	var container:Container = __genModel.activeModelLocator.importObj.container;
	container.dispatchEvent(new ImportEvent(ImportEvent.DOWNLOAD_COMPLETE_EVENT,importedXml));
	
}
private function handleSampleXLS():void
{
	if(sampleURL	==	'')
	{
		Alert.show('URL doesnot exist.');
	}
	else
	{
		var urlObj:URL		=	new URL();
		var url:String		=	urlObj.getURL(sampleURL)
		
		var request:URLRequest = new URLRequest(url);
		navigateToURL(request);
	}    
}
public function shortcutKeyHandler(event:GenModuleEvent):void
{
	var char:String = String.fromCharCode(KeyboardEvent(event.keyBoardEvent).charCode).toUpperCase();

	var keyCode:int 			= 	KeyboardEvent(event.keyBoardEvent).keyCode;
	var isShiftKey:Boolean		=	KeyboardEvent(event.keyBoardEvent).shiftKey;
	
	
	if(ShortCut.isSave(event.keyBoardEvent,btnSave))// 
 	{
		btnSave.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}
	else if(ShortCut.isReset(event.keyBoardEvent,btnCancel))// 
 	{
		btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isListMode(event.keyBoardEvent,btnCloseImportView))// 
 	{
		btnCloseImportView.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isADD(event.keyBoardEvent,btnAdd))// 
 	{
		btnAdd.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
	else if(ShortCut.isBrowse(event.keyBoardEvent,btnBrowse_Xls))// 
 	{
		btnBrowse_Xls.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
	}	
									
}
