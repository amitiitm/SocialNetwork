package business.commands
{
	import business.delegates.ForgotPasswordDelegate;
	import business.events.ForgotPasswordEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class ForgotPasswordCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __viewHandler:IResponder;

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;
			
			var callbacks:Responder = new Responder(handleForgotPasswordResult, faultHandler);
			var delegate:ForgotPasswordDelegate = new ForgotPasswordDelegate(callbacks);

			__viewHandler = (event as ForgotPasswordEvent).callbacks;
			delegate.resetPassword((event as ForgotPasswordEvent).userXML);
		}
		
		private function handleForgotPasswordResult(event:ResultEvent):void 
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			
			var _resultXml:XML;
		
			_resultXml = (XML)(event.result.toString());

			if(_resultXml.name() == "errors")
			{
				__viewHandler.result(false);
			}
			else
			{
				__viewHandler.result(true);
			}
		}
		
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
			
			Alert.show('forgot password command' + event.fault.toString());
		}
	}
}
