package business.commands
{
	import business.delegates.GetGenListDataDelegate;
	import business.events.GetGenListDataEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenList;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class GetGenListDataCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var genList:GenList;
		
		public function execute(event:CairngormEvent):void
		{
			var callbacksListData:Responder = new Responder(listDataResultHandler, faultHandler);

			genList = (event as GetGenListDataEvent).genList;

			var delegate:GetGenListDataDelegate = new GetGenListDataDelegate(callbacksListData)
				
			delegate.getRows(genList);
		}
		
		private function listDataResultHandler(event:ResultEvent):void
		{
			genList.rows = (XML)(event.result);
		}
		
		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(event.fault.toString());
		}
	}
}
