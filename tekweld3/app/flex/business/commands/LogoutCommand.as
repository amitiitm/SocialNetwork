package business.commands
{
	import business.delegates.LogoutDelegate;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import model.GenModelLocator;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.core.Application;
	import mx.managers.CursorManager;
	
	public class LogoutCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;

			var callbacks:Responder = new Responder(logoutResultHandler, faultHandler);
			var delegate:LogoutDelegate = new LogoutDelegate(callbacks)
			
			delegate.getLogout();
		}

		private function logoutResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
			
			if (event.result.toString() == "badlogin") 
			{
				if(GenModelLocator.main_url	==	"")
				{
					//means web application 
					var _url:String = Application.application.url;
					var _endIndex:int = _url.indexOf("bin",0)
					_url = _url.substr(0,_endIndex)
					var adobeURL:URLRequest = new URLRequest(_url)
					navigateToURL(adobeURL,'_self');
						
				}
				else
				{
					//means window application	
					Application.application.close();
				}
				
			}
		}

		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
			
			Alert.show(event.fault.toString());
		}
	}
}