import com.generic.events.GenUploadButtonEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.FileReferenceList;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var fileList:XML;

private var _request:URLRequest = new URLRequest(GenModelLocator.getInstance().services.getHTTPService("imageUploadUrl").url.toString());
private var selectedFileArray:Array;
private var fileUploadCounter:int;
private var imageFilter:FileFilter = new FileFilter("Image Files (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg; *.jpeg; *.gif; *.png");
private var fileRefList:FileReferenceList = new FileReferenceList();

private function handleClickEvent():void
{
	try
	{
		fileRefList.addEventListener(Event.SELECT, handleSelectEvent);
		fileRefList.browse([imageFilter]);
	}
	catch(error:Error) 
	{
		Alert.show("Unable to browse for files. " + error);  
	}
}


private function handleSelectEvent(event:Event):void
{
    var files:FileReferenceList = FileReferenceList(event.target);
	var xml:XML;

    selectedFileArray = files.fileList;
		
	fileList = new XML(<image_files></image_files>)
	
	for(var i:uint = 0; i < selectedFileArray.length; i++)
    {
    	xml = new XML(<file></file>)
    	
    	xml.appendChild(new XML(<name>{selectedFileArray[i].name.toString()}</name>));
    	xml.appendChild(new XML(<modificationDate>{selectedFileArray[i].modificationDate.toString()}</modificationDate>));
    	xml.appendChild(new XML(<size>{selectedFileArray[i].size.toString()}</size>));
    	xml.appendChild(new XML(<type>{selectedFileArray[i].type.toString()}</type>));
    	xml.appendChild(new XML(<status>Selected</status>));
		
		fileList.appendChild(xml)
	}
    
    dtlLine.dataProvider = fileList.children()
    
    fileUploadCounter = 0
    uploadFile()	
}

private function uploadFile():void
{
    var file:FileReference;

	if(fileUploadCounter < selectedFileArray.length)
	{
	    file = FileReference(selectedFileArray[fileUploadCounter]);
	
	    file.addEventListener(Event.OPEN, handleOpen);
	    file.addEventListener(ProgressEvent.PROGRESS, handleProgress);
	    file.addEventListener(Event.COMPLETE, handleComplete);
	    file.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
	    file.addEventListener(IOErrorEvent.NETWORK_ERROR, handleNetworkError);
		
	    try
	    {
	        file.upload(_request);
	    }
	    catch (error:Error)
	    {
	        trace("Unable to upload files.");
	    }
	}
}

private function handleIOError(event:IOErrorEvent):void
{
	fileUploadCounter++
	uploadFile()
}

private function handleNetworkError(event:IOErrorEvent):void
{
	fileUploadCounter++
	uploadFile()
}

private function handleOpen(event:Event):void
{
	var file_name:String = event.target.name
	fileList.children().(name == file_name)['status'] = "Started"
}
 
private function handleProgress(event:ProgressEvent):void
{
	var file_name:String = event.target.name
	fileList.children().(name == file_name)['status'] = "In Progess..."
}
 
private function handleComplete(event:Event):void
{
	var file_name:String = event.target.name
	fileList.children().(name == file_name)['status'] = "Completed"
	
	if(fileUploadCounter == selectedFileArray.length - 1)
	{
		Alert.show("Upload completed !")		
	}

	fileUploadCounter++
	uploadFile()
}
