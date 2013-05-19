package com.generic.genclass
{
	import com.generic.genclass.URL;
	
	import flash.net.URLRequestDefaults;
	
	import model.GenModelLocator;
	
	import mx.rpc.http.HTTPService;
	
	public class Delegate
	{
		protected function dataService(service:HTTPService):HTTPService
		{
			var urlObj:URL	=	new URL();
			
			service.url		=	urlObj.getURL(service.url);
			/*if(service.url.search(GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString()) == -1)
			{
				service.url = GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() + service.url;
			}*/
			
			service.resultFormat = "e4x";
			service.method = "POST";
			service.useProxy = false;
			service.contentType="application/xml";
			service.requestTimeout = 300000;
			URLRequestDefaults.idleTimeout	=	300000;
			
			return service;
		}
		
		protected function formatService(service:HTTPService):HTTPService
		{
			service.resultFormat = "e4x";
			service.method = "POST";
			service.useProxy = false;
			
			return service;
		}
		
		protected function objectService(service:HTTPService):HTTPService
		{
			
			var urlObj:URL	=	new URL();
			
			service.url		=	urlObj.getURL(service.url);
			
			/*if(service.url.search(GenModelLocator.comapnyShortName +GenModelLocator.main_url.toString()) == -1)
			{
				service.url = GenModelLocator.comapnyShortName +GenModelLocator.main_url.toString() + service.url;
			}*/
			
			service.resultFormat = "e4x";
			service.method = "POST";
			service.useProxy = false;
			
			return service;
		}
		
	}
}