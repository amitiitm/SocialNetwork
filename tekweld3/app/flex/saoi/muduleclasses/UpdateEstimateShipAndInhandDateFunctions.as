package saoi.muduleclasses
{
	import business.commands.GetMenuCommand;
	import business.events.GetInformationEvent;
	import business.events.GetRecordEvent;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.components.DataEntry;
	import com.generic.components.Detail;
	import com.generic.customcomponents.GenDateField;
	import com.generic.customcomponents.GenTextInput;
	import com.generic.events.DetailEvent;
	import com.generic.events.GenTextInputEvent;
	import com.generic.genclass.GenNumberFormatter;
	import com.generic.genclass.TabPage;
	import com.generic.genclass.URL;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getQualifiedClassName;
	
	import model.GenModelLocator;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.messaging.channels.HTTPChannel;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import saoi.muduleclasses.event.MissingInfoEvent;
	
	import valueObjects.ApplicationVO;
	
	public class UpdateEstimateShipAndInhandDateFunctions
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		
		
		private var __responder:IResponder;
		private var numericFormatter:GenNumberFormatter 						= 	new GenNumberFormatter();
		
		
		private var order_type:Object;
		private var customer_id:Object;
		private var ext_ref_date:Object;
		private var rush_order_type:Object;
		private var paper_proof_flag:Object;
		private var catalog_item_id:Object;
		private var isShipInfoBaseChange:Object;
		private var dtlShipping:Object;
		private var next_day_flag:Object;
		private var item_qty:Object;
		private var cbBlankOrder_flag:String;
		
		private var updateshippingInfo_service_url:String = '/shipping/shipping/calculate_estimated_ship_date_and_inhand_dates';
		
		public function UpdateEstimateShipAndInhandDateFunctions()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
			
			numericFormatter.precision = 2;
			numericFormatter.rounding = "nearest";
		}
		
		public function dataService(service:HTTPService):HTTPService
		{
			var urlObj:URL				=	new URL();
			service.url					=	urlObj.getURL(service.url);
			service.resultFormat 		= "e4x";					
			service.method 				= "POST";
			service.useProxy			= false;
			service.contentType			="application/xml";
			service.requestTimeout	 	= 1800
			service.showBusyCursor		= true;
			
			return service;
		}
				
		public function updateShippingInfo(order_type:Object,customer_id:Object,ext_ref_date:Object,next_day_flag:Object,rush_order_type:Object,paper_proof_flag:Object,catalog_item_id:Object,item_qty:Object,dtlShipping:Object,cbBlankOrder_flag:String):void
		{
			this.order_type			= order_type;
			this.customer_id		= customer_id;
			this.ext_ref_date		= ext_ref_date;
			this.rush_order_type	= rush_order_type;
			this.next_day_flag		= next_day_flag;
			this.paper_proof_flag	= paper_proof_flag;
			this.catalog_item_id	= catalog_item_id;
			this.dtlShipping		= dtlShipping;
			this.item_qty			= item_qty;
			this.cbBlankOrder_flag  = cbBlankOrder_flag;
			
			
			var tempXml:XML			= new XML(<sales_order></sales_order>);
			tempXml.customer_id		= customer_id.dataValue;
			tempXml.ext_ref_date	= ext_ref_date.dataValue;
			tempXml.rushday			= rush_order_type.dataValue;
			tempXml.blank_order_flag= cbBlankOrder_flag;
			tempXml.company_id		= __genModel.user.id;
			if(order_type.dataValue=='P')
			{
				tempXml.paper_proof_flag= paper_proof_flag;
				tempXml.catalog_item_id	= catalog_item_id;
			}
			else
			{
				tempXml.paper_proof_flag= paper_proof_flag.dataValue;
				tempXml.catalog_item_id	= catalog_item_id.dataValue;
			}
			
			tempXml.next_day_flag	= next_day_flag.dataValue;
		
			tempXml.item_qty		= item_qty;
			tempXml.appendChild(getShippingXml().copy());	
			
			
			FlexGlobals.topLevelApplication.enabled    = false;
			FlexGlobals.topLevelApplication.setStyle('disabledOverlayAlpha',0);
			
			
			var httpservice:HTTPService					= new HTTPService();
			httpservice.url								= updateshippingInfo_service_url;
			var http:HTTPService 						= dataService(httpservice);
			var __responder:IResponder 					= new mx.rpc.Responder(updateShipInfoResultHandler,updateShipInfoFaultHandler);
			var token:AsyncToken 						= http.send(tempXml);
			token.addResponder(__responder);
			
		}
		public function updateShipInfoResultHandler(event:ResultEvent):void
		{
			
			FlexGlobals.topLevelApplication.enabled    = true;
			FlexGlobals.topLevelApplication.setStyle('disabledOverlayAlpha',.5);
			
			var resultXml:XML			= XML(event.result);
			
			if(resultXml.name() == "errors")
			{
				if(resultXml.children().length() > 0) 
				{
					var message:String = '';
					
					for(var i:uint = 0; i < resultXml.children().length(); i++) 
					{
						message += resultXml.children()[i] + "\n";
					}
					Alert.show(message);
				} 
			}
			else
			{
				setShippingXml(resultXml);
				__localModel.isShipInfoBaseChange  = false;
			}
		}
		
		private function getShippingXml():XML
		{
			var tempXml:XML			= dtlShipping.dgDtl.rows.copy();
			for(var i:int=0;i<tempXml.children().length();i++)
			{
				tempXml.children()[i].unique_no	= i;
			}
			return tempXml;
		}
		
		private function setShippingXml(resultXml:XML):void
		{
			var tempXml:XML			= dtlShipping.dgDtl.rows.copy();
			
			for(var i:int=0;i<tempXml.children().length();i++)
			{
				tempXml.children()[i].estimated_ship_date		= resultXml.children().(unique_no==i).estimated_ship_date.toString();
				tempXml.children()[i].estimated_arrival_date  	= resultXml.children().(unique_no==i).estimated_arrival_date.toString();
				
				if(tempXml.children()[i].inhand_date.toString()=='' || tempXml.children()[i].ship_date.toString()=='')
				{
					tempXml.children()[i].internal_ship_date	= resultXml.children().(unique_no==i).estimated_ship_date.toString();
					tempXml.children()[i].internal_inhand_date  = resultXml.children().(unique_no==i).estimated_arrival_date.toString();

				}
			}
			dtlShipping.dgDtl.rows  = tempXml.copy();
			dtlShipping.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));   
		}
		
		public function updateShipInfoFaultHandler(event:FaultEvent):void
		{
			FlexGlobals.topLevelApplication.enabled    = true; 
			FlexGlobals.topLevelApplication.setStyle('disabledOverlayAlpha',.5);
			
			Alert.show("updateShipInfo"+event.fault.faultDetail);
		}
		
		
		
	}  // end of class
}  // end of package