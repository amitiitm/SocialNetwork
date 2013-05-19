package business.delegates
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.genclass.Delegate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class GetAttachmentDelegate extends Delegate
	{
		private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		private var __getAttachmentService:HTTPService;
		private var __responder:IResponder;

		public function GetAttachmentDelegate(responder:IResponder)
		{
			__getAttachmentService = __locator.getHTTPService("getAttachment");
			__responder = responder;
		}

		public function getAttachment(id:int , tableName:String):void
		{
			var _criteria:XML = new XML(<criteria>
							   				<default_request>N</default_request>
				                			<str1>{tableName}</str1>   
				               				 <int1>{id}</int1>   
					        			</criteria>); 
			
			dataService(__getAttachmentService);
			
			
			var token:AsyncToken = __getAttachmentService.send(_criteria);
			token.addResponder(__responder); 
		}
	}
}
