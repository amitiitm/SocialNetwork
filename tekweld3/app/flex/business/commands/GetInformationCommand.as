package business.commands
{
	import business.delegates.GetInformationDelegate;
	import business.events.GetInformationEvent;
	
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
	
	import valueObjects.InformationCriteria;
	
	public class GetInformationCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		private var __viewHandler:IResponder;
		
		public function execute(event:CairngormEvent):void
		{
			var callbacks:Responder = new Responder(GetInformationHandler, faultHandler);
			var delegate:GetInformationDelegate = new GetInformationDelegate(callbacks);
			
			__viewHandler = (event as GetInformationEvent).callbacks;
			
			var criteria:XML;
			var getCriteriaObj:InformationCriteria = new InformationCriteria();

			criteria = getCriteriaObj.getCriteria(
													(event as GetInformationEvent).action,
													(event as GetInformationEvent).value1,
													(event as GetInformationEvent).value2,
													(event as GetInformationEvent).value3,
													(event as GetInformationEvent).value4,
													(event as GetInformationEvent).value5,
													(event as GetInformationEvent).value6,
													(event as GetInformationEvent).value7,
													(event as GetInformationEvent).value8,
													(event as GetInformationEvent).value9,
													(event as GetInformationEvent).value10
												  );
			if(criteria != null)
			{
				// Application.application.enabled = false;
				__genModel.isLockScreen = true;
				CursorManager.setBusyCursor(); 
				
				delegate.getInformation(criteria);
			}
			
		}
		private function GetInformationHandler(event:ResultEvent):void 
		{
			__viewHandler.result(XML(event.result));
			
			//Application.application.enabled = true;
			CursorManager.removeBusyCursor(); 
			__genModel.isLockScreen = false;
		}
		
		private function faultHandler(event:FaultEvent):void
		{
			// Application.application.enabled = true;
			CursorManager.removeBusyCursor(); 
			__genModel.isLockScreen = false;
			Alert.show('getInformationCommand' + event.fault.toString());
		}
	}
}
