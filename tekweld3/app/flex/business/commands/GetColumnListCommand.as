package business.commands
{
	import business.delegates.LayoutDelegate;
	import business.events.GetColumnListEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class GetColumnListCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var viewHandlers  : IResponder = null; 
		
		public function execute(event:CairngormEvent):void
		{
			viewHandlers = (event as GetColumnListEvent).callbacks
			
			var callbacks:Responder 			= new Responder(GetColumnListResultHandler, faultHandler);
			var delegate:LayoutDelegate 		= new LayoutDelegate();
			delegate.getColumnList(__genModel.user.userID, __genModel.activeModelLocator.documentObj.documentID,callbacks);
		}
		private function GetColumnListResultHandler(event:ResultEvent):void
		{
			viewHandlers.result(XML(event.result));
		}

		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(GetNoteCommand + " : " + event.fault.toString());
		}		
	}
}

