package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	import com.generic.genclass.URL;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class UploadAttachmentDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __uploadFileService:HTTPService;
		private var __responder:IResponder;

		public function UploadAttachmentDelegate(responder:IResponder)
		{
			__uploadFileService = __locator.getHTTPService("uploadAttachment");
			__responder = responder;
		}

		public function uploadFile(fileReference:FileReference , paramXml:XML):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	=	false;
			
			try
			{ 
				var urlObj:URL					=	new URL();
				var url:String					=	urlObj.getURL(__uploadFileService.url.toString());
				var _request:URLRequest 		=  new URLRequest(url);//uploadServiceURL
				var _variables:URLVariables 	=  new URLVariables();
			
				
				_request.method				    =  URLRequestMethod.POST;
				
				
				_variables.paramXml				=	paramXml;
							
				_request.data = _variables;
		
				fileReference.addEventListener(Event.COMPLETE, uploadCompleteHandler);
				fileReference.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				fileReference.upload(_request);
			}
			catch (error:Error) 
			{
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;
				Alert.show("Unable to upload file. " + error);
			}
		}
		private function onIOError(event:IOErrorEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			Alert.show('UploadFileDelegate' + event.text )
		}
		
		private function uploadCompleteHandler(event:Event):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			__responder.result(event);
		}	
	}
}



