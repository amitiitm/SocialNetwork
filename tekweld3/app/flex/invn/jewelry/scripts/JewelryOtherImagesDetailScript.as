import business.events.RecordStatusEvent;

import com.generic.events.DetailAddEditEvent;
import com.generic.events.GenUploadButtonEvent;

import model.GenModelLocator;

import mx.core.Application;
import mx.managers.CursorManager;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function handleUploadEvent(event:GenUploadButtonEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;

	var recordStstusEvent:RecordStatusEvent	=	new RecordStatusEvent('MODIFY');
	recordStstusEvent.dispatch();
}

private function handleCompleteEvent(event:GenUploadButtonEvent):void
{
	setImage(event.currentTarget.id);	
}

private function setImages():void
{
	setImage('btnBrowse_imageThumnail')
	setImage('btnBrowse_imageSmall')
	setImage('btnBrowse_imageNormal')
	setImage('btnBrowse_imageEnlarge')

}

private function setImage(str:String):void
{
	switch(str)
	{
		case 'btnBrowse_imageThumnail':
			imageThumnail.source = __genModel.path.image + tiImage_Thumnail.dataValue;	
			break;
			
		case 'btnBrowse_imageSmall':
			imageSmall.source = __genModel.path.image + tiImage_Small.dataValue;	
		    break;

		case 'btnBrowse_imageNormal':
			imageNormal.source = __genModel.path.image + tiImage_Normal.dataValue;	
		    break;                    

		case 'btnBrowse_imageEnlarge':
			imageEnlarge.source = __genModel.path.image + tiImage_Enlarge.dataValue;	
		    break;
	}
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	setImages();
}

override protected function resetObjectEventHandler():void
{
	setImages();
}