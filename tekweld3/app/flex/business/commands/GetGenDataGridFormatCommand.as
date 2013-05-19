package business.commands
{
	import business.delegates.GetGenDataGridFormatDelegate;
	import business.events.GetGenDataGridFormatEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class GetGenDataGridFormatCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var object:Object;
		private var callbacks:IResponder	=	null;

		public function execute(event:CairngormEvent):void
		{
			var callbacksGridFormat:Responder = new Responder(gridFormatResultHandler, faultHandler);

			object = (event as GetGenDataGridFormatEvent).object;
			callbacks = (event as GetGenDataGridFormatEvent).callbacks;
			var delegate:GetGenDataGridFormatDelegate = new GetGenDataGridFormatDelegate(callbacksGridFormat)

			delegate.getGridFormat(object.formatServiceID);
		}
		
		private function gridFormatResultHandler(event:ResultEvent):void
		{
			object.structure = (XML)(event.result);
			if(callbacks != null)
			{
				callbacks.result('STRUCTURE COMPLETED');	
			}
		}

		private function faultHandler(event:FaultEvent):void
		{
			Alert.show(event.fault.toString());
		}
	}
}
