package business.commands
{
	import business.delegates.CreateUserDelegate;
	import business.events.CreateUserEvent;
	
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
	
	public class CreateUserCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __viewHandler:IResponder;
			
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;
			
			var callbacks:Responder = new Responder(handleCreateUserResult, faultHandler);
			var delegate:CreateUserDelegate = new CreateUserDelegate(callbacks);
			
			__viewHandler = (event as CreateUserEvent).callbacks;
			delegate.createUser((event as CreateUserEvent).userXML);
		}
		
		private function handleCreateUserResult(event:ResultEvent):void 
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			
			var _resultXml:XML;
			var obj:Object = new Object()
			
			_resultXml = (XML)(event.result.toString());

			if(_resultXml.name() == "errors")
			{
				obj.LoginFlag = false;
				obj.user_id = null;

				__viewHandler.result(false);
			}
			else
			{
				obj.LoginFlag = true;
				obj.user_id = _resultXml.id.toString();
				
				__viewHandler.result(obj);
			}
		}
		
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
			
			Alert.show('create user command' + event.fault.toString());
		}
	}
}