package business.commands
{
	import business.delegates.CreateCompanyDelegate;
	import business.events.CreateCompanyEvent;
	
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
	
	public class CreateCompanyCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __viewHandler:IResponder;
			
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;
			
			var callbacks:Responder = new Responder(handleCreateCompanyResult, faultHandler);
			var delegate:CreateCompanyDelegate = new CreateCompanyDelegate(callbacks);

			__viewHandler = (event as CreateCompanyEvent).callbacks;
			delegate.createCompany((event as CreateCompanyEvent).companyXML);
		}
		
		private function handleCreateCompanyResult(event:ResultEvent):void 
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
			
			Alert.show('create company command' + event.fault.toString());
		}
	}
}