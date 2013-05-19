package business.commands
{
	import business.delegates.GetNoteDelegate;
	import business.events.GetNoteEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDataGrid;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.NoteAttachmentVO;
	
	
	public class GetNoteCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __noteAttachObj:NoteAttachmentVO;
		private var viewHandlers  : IResponder = null; 
		
		public function execute(event:CairngormEvent):void
		{
			__noteAttachObj	=	__genModel.activeModelLocator.noteAttachObj;
			
			var callbacks:Responder 		= new Responder(getNoteResultHandler, faultHandler);
			var delegate:GetNoteDelegate 	= new GetNoteDelegate(callbacks);
			
			viewHandlers = (event as GetNoteEvent).callbacks
			
			delegate.getNote(__noteAttachObj.recordId,__noteAttachObj.tableName);
		}
		private function getNoteResultHandler(event:ResultEvent):void
		{
			viewHandlers.result(XML(event.result));
		}

		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(GetNoteCommand + " : " + event.fault.toString());
		}		
	}
}

