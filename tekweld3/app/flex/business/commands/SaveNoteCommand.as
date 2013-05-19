package business.commands
{
	import business.delegates.SaveNoteDelegate;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import business.events.SaveNoteEvent
	
	import model.GenModelLocator;
	import mx.rpc.IResponder;
	import mx.controls.Alert;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.NoteAttachmentVO;
	
	public class SaveNoteCommand implements ICommand
	{
		private var __genModel:GenModelLocator	=	 GenModelLocator.getInstance();
		private var viewHandlers  : IResponder = null;
				
		public function execute(event:CairngormEvent):void
		{
			var _tmp:XML = new XML(<notes></notes>);
			var _notes:XML	=	(event as SaveNoteEvent).notesXml.copy()
			
			for(var i:int=0; i <  _notes.children().length(); i++)
			{
				if(_notes.children()[i].child('id') == '')
				{
					var xml:XML = XML(_notes.children()[i])
					_tmp.appendChild(xml);
				}
			}
			if(_tmp.children().length() > 0)
			{
				viewHandlers = (event as SaveNoteEvent).callbacks
				
				var callbacks:Responder = new Responder(saveNoteResultHandler, faultHandler);
				var delegate:SaveNoteDelegate = new SaveNoteDelegate(callbacks);
				delegate.saveNotes(_tmp);
			}
		}
		private function saveNoteResultHandler(event:ResultEvent):void
		{
			//Alert.show('Notes Saved Successfully')
			
			viewHandlers.result(XML(event.result));
		}

		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(GetNoteCommand + " : " + event.fault.toString());
		}		

	}
}

