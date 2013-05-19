import com.generic.events.GenUploadButtonEvent;
import com.generic.genclass.URL;

import flash.events.DataEvent;
import flash.events.Event;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import model.GenModelLocator;

import mx.controls.Alert;

public var fileReference:FileReference;
public var uploadServiceID:String;

private var _fileTitle:String;
private var _fileTypes:String;
private var _fileName:String;

private var _viewOnlyFlag:Boolean = false
private var _keyColumn:Boolean = false
private var _initialEditableFlag:Boolean = true
private var _tableName:String = "";

public function set initialEditableFlag(aBoolean:Boolean):void //jeetu 21/01/2010 
{
 	_initialEditableFlag	=	this.enabled;
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
public function set viewOnlyFlag(aBoolean:Boolean):void
{
 	_viewOnlyFlag = aBoolean
 	
 	if(initialEditableFlag)
 	{
 		enabled = !aBoolean
 	}
}

public function get viewOnlyFlag():Boolean
{
 	return _viewOnlyFlag
}

public function set keyColumn(aBoolean:Boolean):void
{
 	_keyColumn = aBoolean
}

public function get keyColumn():Boolean
{
	return _keyColumn
}
public function set tableName(aString:String):void 
{
 	_tableName = aString
}

public function get tableName():String
{
 	return _tableName
}

// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

public function set fileTitle(aString:String):void 
{
	_fileTitle = aString
}

public function get fileTitle():String
{
	return _fileTitle
}

public function set fileTypes(aString:String):void 
{
 	_fileTypes = aString
}

public function get fileTypes():String
{
 	return _fileTypes
}

public function set fileName(aString:String):void 
{
	_fileName = aString
}

[Bindable]
public function get fileName():String
{
 	return _fileName
}

public function handleClickEvent(event:Event):void
{
	try
	{
		var description:String = fileTitle + " (" + fileTypes + ")"
		var extension:String = fileTypes.split(",").join(';')

  		fileReference = new FileReference();
		fileReference.addEventListener(Event.SELECT, handleSelectEvent);
		fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, handleResponseCompleteData);
		fileReference.addEventListener(Event.COMPLETE, handleCompleteEvent);

	    var _typeFiler:FileFilter = new FileFilter(description, extension);
	    fileReference.browse([_typeFiler]);
	}
	catch(error:Error) 
	{
		Alert.show("Unable to browse for files. " + error);  
	}
}

private function handleSelectEvent(event:Event):void
{
	uploadHandler(event)
	fileName = fileReference.name.toString();
	dispatchEvent(new GenUploadButtonEvent("uploadFileNameSetEvent", fileName))
}

private function uploadHandler(event:Event):void
{
	try
	{
		var urlObj:URL	=	new URL();
		var url:String	=	urlObj.getURL(GenModelLocator.getInstance().services.getHTTPService(uploadServiceID).url.toString())
		var _request:URLRequest = new URLRequest(url);
		var _variables:URLVariables = new URLVariables();
		
		_variables.file_name 	= fileName
		_variables.table_name	= tableName
		_request.method 		= URLRequestMethod.POST;
		_request.data 			= _variables;

		fileReference.upload(_request);
	}
	catch (error:Error) 
	{
		trace("Unable to upload file. " + error);
	}
}


private function handleCompleteEvent(event:Event):void
{
	dispatchEvent(new GenUploadButtonEvent(GenUploadButtonEvent.COMPLETE,''))
}

private function handleResponseCompleteData(event:DataEvent):void
{
	dispatchEvent(new GenUploadButtonEvent(GenUploadButtonEvent.DOWNLOAD_COMPLETE,'', event.data))
}

/*
private function setHttpService(service:HTTPService, url:String):void
{
	service.url = url ;
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
}
*/