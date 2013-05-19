package business.commands
{
	import business.delegates.UserLoginDelegate;
	import business.events.UserLoginEvent;
	
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
	
	import valueObjects.UserVO;
	
	public class UserLoginCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __viewHandler:IResponder;
			
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;
			
			var callbacks:Responder = new Responder(handleUserLoginResult, faultHandler);
			var delegate:UserLoginDelegate = new UserLoginDelegate(callbacks);
			
			__viewHandler = (event as UserLoginEvent).callbacks;
			delegate.login((event as UserLoginEvent).loginObj);
		}
		
		private function handleUserLoginResult(event:ResultEvent):void 
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			
			var _resultXml:XML;
		
			_resultXml = (XML)(event.result.toString());

			if(_resultXml.name() == "errors")
			{
				if(_resultXml.children().length() > 0) 
				{
					var message:String = '';
			
					for(var i:uint = 0; i < _resultXml.children().length(); i++) 
					{
						message += _resultXml.children()[i] + "\n";
					}
					Alert.show(message);
				} 
				__viewHandler.result(false);
			}
			else
			{
				__genModel.user = new UserVO(_resultXml)
				__viewHandler.result(true);
			}
		}
		
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
			
			Alert.show('user login command' + event.fault.toString());
		}
	}
}