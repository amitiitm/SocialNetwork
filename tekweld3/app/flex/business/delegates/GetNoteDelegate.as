package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;

	public class GetNoteDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __getNoteService:HTTPService;
		private var __responder:IResponder;

		public function GetNoteDelegate(responder:IResponder)
		{
			__getNoteService = __locator.getHTTPService("getNote");
			__responder = responder;
		}
		
		public function getNote(id:int , tableName:String):void
		{
			var _criteria:XML = new XML(<criteria>
							   				<default_request>N</default_request>
				                			<str1>{tableName}</str1>   
				               				 <int1>{id}</int1>   
					        			</criteria>); 
			
			dataService(__getNoteService);
			
			
			var token:AsyncToken = __getNoteService.send(_criteria);
			token.addResponder(__responder); 
		}
	}
}
