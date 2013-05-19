import business.events.GetAttachmentEvent;
import business.events.GetGenDataGridFormatEvent;
import business.events.UploadAttachmentEvent;

import com.generic.genclass.URL;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.net.FileReference;
import flash.net.URLRequest;

import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.Responder;

public var windowStatus:String;

public var _id:int;
public var _tableName:String;
public var _companyId:int
public var _userId:int

public var _login_type:String;
public var _email_to:String;
public var _email_cc:String;
public var _general_email_id:String;
public var _subject:String;

private var _email_from:String;

public var fileReference:FileReference  = new FileReference();
private var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
private var uploadAttachmentEvent:UploadAttachmentEvent;
private var getAttachmentsEvent:GetAttachmentEvent;
public  var fileRefDown:FileReference = new FileReference();
private  function btnDownlaodClickHandler():void
{
	var _xml:XML = XML(dgAttachments.selectedItem)
	if(_xml.children().length()>0)
	{
		var folderName:String = _xml.child('folder_name').toString()
		var pos:int = folderName.indexOf('public', 0)
		folderName = folderName.substr(6) // public length is 6
		var relativeUrl:String = folderName + _xml.child('file_name').toString();
		
		var urlObj:URL	=	new URL();
		var url:String  =	urlObj.getURL(relativeUrl);
		
		var _request:URLRequest = new URLRequest(url);            
		_request.method = URLRequestMethod.GET;
		fileRefDown.addEventListener(Event.OPEN,openHandler);
		fileRefDown.addEventListener(Event.COMPLETE,downloadCompletehandler);
	  	try
	  	{
	  	 	fileRefDown.download(_request);
	  	}
	 	catch (error:Error)
		{
	    	Alert.show("Unable to download file.");
		}
	}
	else
	{
		Alert.show("Please Select Attachment");
	}
	
}
private function openHandler(event:Event):void
{
	
}
private function downloadCompletehandler(event:Event):void
{
	Alert.show("Download Complete");
}
private function creationCompleteHandler():void
{
	this.setFocus();
	bcp.btnSave.visible = false;
	bcp.btnSave.width = 0;
	
	getGenDataGridFormatEvent = new GetGenDataGridFormatEvent(dgAttachments);
	getGenDataGridFormatEvent.dispatch();
	
	this.x 		=  (this.screen.width - this.width) / 3
	this.y 		=  (this.screen.height - this.height) / 3
	
	getAttachments();	
}
private function getAttachments():void
{
	var callbacks:mx.rpc.Responder	= new mx.rpc.Responder(getAttachmentResultHandler , null);
	
	getAttachmentsEvent		=	new GetAttachmentEvent(callbacks);
	getAttachmentsEvent.dispatch();
}
private function getAttachmentResultHandler(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		dgAttachments.rows	=	resultXml;
	}
	else
	{
		dgAttachments.rows = new XML();
	}
}
private function dgItemDoubleClickHandler():void
{
	var _xml:XML = XML(dgAttachments.selectedItem)
	var folderName:String = _xml.child('folder_name').toString()
	var pos:int = folderName.indexOf('public', 0)
	
	folderName = folderName.substr(6) // public length is 6
	
	var urlObj:URL	=	new URL();
	var url:String  =	urlObj.getURL(folderName + _xml.child('file_name').toString());
	/*var url:String =folderName + _xml.child('file_name').toString();*/
	var request:URLRequest = new URLRequest(url);

    navigateToURL(request);
    dgItemClickHandler();
}

private function dgItemClickHandler():void
{
	windowStatus = 'QUERY'
	
	var _xml:XML = XML(dgAttachments.selectedItem)
    tiFile.text = _xml.child('file_name').toString();
    tiSubject.text = _xml.child('subject').toString();
   	tiEmail_To.text 	= 	_xml.child('email_to');
	tiEmail_Cc.text 	=   _xml.child('email_cc');
    
    if(_xml.child('id').toString() != '')
    {
    	tiEmail_Cc.editable  	= 	false;
		tiEmail_To.editable  	= 	false;
    	tiSubject.editable  	= 	false;	
    	btnBrowse.enabled		=	false;
    	btnUpload.enabled		=	false;
    }
    else
    {
    	tiEmail_Cc.editable  	= 	true;
		tiEmail_To.editable 	= 	true;
    	tiSubject.editable  	= 	true;
    	btnBrowse.enabled		=	true;
    	btnUpload.enabled		=	true;
    }
    
}

private function addRowHandler():void
{
	windowStatus = 'NEW'
	
	btnBrowse.enabled	=	true;
	btnUpload.enabled	=	true;
	
	
	tiSubject.text = '';
	tiFile.text = '';
	//tiEmail_Cc.text	=	'';
	//tiEmail_To.text	=	'';
	tiSubject.editable = true;
	tiEmail_Cc.editable = 	true;
	tiEmail_To.editable = 	true;
	dgAttachments.selectedIndex = -1;
	
	setEmailAddress()	;
}
private function setEmailAddress():void
{
	if(tiEmail_Cc.text != "" || tiEmail_To.text != "")
	{
		return; //because we want previous value to set in.
	}
	
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
private function firstRowHandler():void
{
	if(dgAttachments.rows.children().length() > 0)
	{
		dgAttachments.selectedIndex = 0;
		dgItemClickHandler();
	}
}

private function lastRowHandler():void
{
	if(dgAttachments.rows.children().length() > 0)
	{
		dgAttachments.selectedIndex = dgAttachments.rows.children().length();
		dgItemClickHandler();
	}	
}

private function nextRowHandler():void
{
	if(dgAttachments.selectedIndex < dgAttachments.rows.children().length() - 1)
	{
		dgAttachments.selectedIndex = dgAttachments.selectedIndex + 1;
		dgItemClickHandler();		
	}

}

private function previousRowHandler():void
{
	if(dgAttachments.selectedIndex > 0)
	{
		dgAttachments.selectedIndex = dgAttachments.selectedIndex - 1;
		dgItemClickHandler();
	}
}

private function btnBrowseClickHandler():void
{
	try 
	{
		fileReference.addEventListener(Event.SELECT, browseSelectHandler);
		fileReference.addEventListener(Event.CANCEL, browseCancelHandler);
	    fileReference.browse();
	}
	catch(error:Error) 
	{
		trace("Unable to browse for files. " + error);  
	}
}

private function browseSelectHandler(event:Event):void
{
	tiFile.text = fileReference.name;
	setWindowStatus();
}

private function browseCancelHandler(event:Event):void
{
	windowStatus = 'NEW';
}

private function btnUploadClickHandler(event:Event):void
{
	if(tiFile.text != '')
	{
		var callbacks:mx.rpc.Responder	= new mx.rpc.Responder(uploadCompleteHandler , null);
		
		uploadAttachmentEvent	=	new UploadAttachmentEvent(fileReference , tiFile.text , tiSubject.text ,tiEmail_To.text,tiEmail_Cc.text, callbacks);
		uploadAttachmentEvent.dispatch();	
				//call event to upload file
	}
	else
	{
		Alert.show('Select File To UpLoad')
	}

}

private function uploadCompleteHandler(event:Event):void
{
	Alert.show('File UpLoaded Successfully')
	getAttachments();
	addRowHandler();
	windowStatus = 'SAVE'
}

protected function closeHandler():void
{
	this.parentApplication.focusManager.activate();
	PopUpManager.removePopUp(this)
}

private function setWindowStatus():void
{
	windowStatus = 'MODIFIED'
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