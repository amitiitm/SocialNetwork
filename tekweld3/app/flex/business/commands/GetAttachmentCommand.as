package business.commands
{
	import business.delegates.GetAttachmentDelegate;
	import business.events.GetAttachmentEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.NoteAttachmentVO;
	
	
	public class GetAttachmentCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __noteAttachObj:NoteAttachmentVO;
		private var viewHandlers  : IResponder = null; 
		
		public function execute(event:CairngormEvent):void
		{
			__noteAttachObj	=	__genModel.activeModelLocator.noteAttachObj;
			
			viewHandlers = (event as GetAttachmentEvent).callbacks
			
			var callbacks:Responder 			= new Responder(GetAttachmentResultHandler, faultHandler);
			var delegate:GetAttachmentDelegate 	= new GetAttachmentDelegate(callbacks);
			delegate.getAttachment(__noteAttachObj.recordId,__noteAttachObj.tableName);
		}
		private function GetAttachmentResultHandler(event:ResultEvent):void
		{
			viewHandlers.result(XML(event.result));
		}

		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(GetNoteCommand + " : " + event.fault.toString());
		}		
	}
}

