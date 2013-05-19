package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class SaveNoteDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __saveNoteService:HTTPService;
		private var __responder:IResponder;

		public function SaveNoteDelegate(responder:IResponder)
		{
			__saveNoteService = __locator.getHTTPService("saveNote");
			__responder = responder;
		}

		public function saveNotes(notesXml:XML):void
		{
			dataService(__saveNoteService);

			var token:AsyncToken = __saveNoteService.send(notesXml);
			token.addResponder(__responder); 
		}
	}
}


