package saoi.muduleclasses
{
	
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class ShippingPackageTracking
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		private var __responder:Responder;
		private var commonUtility:CommonUtility   		  				= new CommonUtility();
		
		public function ShippingPackageTracking()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
		}
		
		public function trackPackage(shippingProvider:String,tracking_no:String):void
		{
			if(shippingProvider=='')
			{
				Alert.show("Please Select Shipping Provider");
				return ;
			}
			if(tracking_no=='')
			{
				Alert.show("Tracking # Not Found");
				return ;
			}
			else
			{
				var url:String					= "";
				switch(shippingProvider)
				{
					case ApplicationConstant.SHIPPING_PROVIDER_UPS:
						url	= "http://wwwapps.ups.com/WebTracking/OnlineTool?InquiryNumber1="+tracking_no+"&TypeOfInquiryNumber=T&UPS_HTML_License=6C921F3E7B6B3698&UPS_HTML_Version=3.0&IATA=us&Lang=eng&submit=Track+package%28s%29";
						navigateToURL(new URLRequest(url));
						break;
					case ApplicationConstant.SHIPPING_PROVIDER_FEDEX:
						url	= "http://www.fedex.com/Tracking/Detail?trackNum="+tracking_no+"&clienttype=dotcom&totalPieceNum=&ascend_header=1&cntry_code=us&pieceNum=&language=english&tracknumber_list=999999999999&mi=n&spnlk=spnl0";
						navigateToURL(new URLRequest(url));
						break;
					case ApplicationConstant.SHIPPING_PROVIDER_USPS:
						url	= "http://usps.ems-tracking.net/usps-tracking.php?number="+tracking_no;
						navigateToURL(new URLRequest(url));
						break;
					default:
						Alert.show("Please Select Valid Shipping Provider");
						break;
				}
			}
				
				
		}
	}
}