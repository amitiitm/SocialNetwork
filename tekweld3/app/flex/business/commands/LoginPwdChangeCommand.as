package business.commands
{
	import business.delegates.LoginPwdChangeDelegate;
	import business.events.LoginPwdChangeEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;;

	public class LoginPwdChangeCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __viewHandler:IResponder;
			
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;
			
			var callbacks:Responder = new Responder(handleLoginPwdChangeResult, faultHandler);
			var delegate:LoginPwdChangeDelegate = new LoginPwdChangeDelegate(callbacks);
			
			__viewHandler = (event as LoginPwdChangeEvent).callbacks;
			delegate.loginPwdChange((event as LoginPwdChangeEvent).userXML);
		}
		
		private function handleLoginPwdChangeResult(event:ResultEvent):void 
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
			
			Alert.show('login password change command' + event.fault.toString());
		}
	}
}