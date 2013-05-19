package saoi.muduleclasses
{
	import business.commands.GetMenuCommand;
	import business.events.GetInformationEvent;
	import business.events.GetRecordEvent;
	import business.events.RecordStatusEvent;
	
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
	
	public class CalculateEstimateShipDateAndPackages
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		
		
		private var __responder:IResponder;
		private var numericFormatter:GenNumberFormatter 						= 	new GenNumberFormatter();
		
		
		private var shipping_code:Object;
		private var tiship_amt:Object;
		private var tiShipMethod:Object;
		private var tiShipMethodCode:Object;
		private var dfEstimatedInhandDate:Object;
		private var dfEstimatedShipDate:Object;
		private var lblShipAmountFormula:Object;
		private var dfShip_date:Object;
		private var dfInhand_date:Object;
		private var lblApiCalling:Object
		private var cbBillingTransportationTo:Object
		private var order_type:String;
		private var resultXmlFromItem:XML;
		private var dgpackets:Object;
		private var defaultCall:Boolean;
		private var tiShipZip:Object;
		private var tiShipCountry:Object;
		private var tiShipState:Object;
		private var screenComponents:UIComponent;
		private var tiQty:Object;
		private var default_method:String;
		
		private var customer_id:String;
		private var ext_ref_date:String;
		private var rush_order_type:String;
		private var paper_proof_flag:String;
		private var catalog_item_id:String;
		private var next_day_flag:String;
		private var cbBlankOrderFlag:String;
		private var item_qty:String;
		
		private var getestimateshipdateandpackages_service_url:String 	= '/shipping/shipping/calculate_estimated_ship_date_and_packages';
		private var commonUtility:CommonUtility   		  				= new CommonUtility();
		private var commonFunctions:CommonMooduleFunctions  			= new CommonMooduleFunctions();
		
		public function CalculateEstimateShipDateAndPackages()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
			
			numericFormatter.precision = 2;
			numericFormatter.rounding = "nearest";
		}
		private function getShipMethodCodeValue():String
		{
			if(tiShipMethodCode.dataValue=='')
			{
				if(shipping_code.dataValue==ApplicationConstant.SHIPPING_PROVIDER_FEDEX)
				{
					return ApplicationConstant.DEFAULT_SHIPPING_METHOD_FEDEX;
				}
				else if(shipping_code.dataValue==ApplicationConstant.SHIPPING_PROVIDER_USPS)
				{
					return ApplicationConstant.DEFAULT_SHIPPING_METHOD_USPS
				}
				else
				{
					return ApplicationConstant.DEFAULT_SHIPPING_METHOD_UPS
				}
			}
			else
			{
				return tiShipMethodCode.dataValue;
			}
		}
		public function getEstimateDateAndPackages(screenComponent:UIComponent,shipping_code:Object,zip_code:Object,country:Object,tiship_amt:Object,tiShipMethod:Object,dfEstimatedInhandDate:Object,dfEstimatedShipDate:Object,dfShip_date:Object,dfInhand_date:Object,tiState:Object,lblShipAmountFormula:Object,lblApiCalling:Object,cbBillingTransportationTo:Object,tiShipMethodCode:Object,dgPackets:Object,order_type:String,resultXmlFromItem:XML,tiQty:Object,defaultCall:Boolean,customer_id:String,ext_ref_date:String,next_day_flag:String,rush_order_type:String,paper_proof_flag:String,catalog_item_id:String,item_qty:String,cbBlankOrderFlag:String):void
		{
			
			this.tiShipZip				= zip_code;
			this.tiShipCountry			= country;
			this.tiShipState			= tiState;
			this.shipping_code			= shipping_code;
			this.tiship_amt   			= tiship_amt;
			this.lblShipAmountFormula	= lblShipAmountFormula;
			this.tiShipMethod 			= tiShipMethod;
			this.dfEstimatedInhandDate	= dfEstimatedInhandDate;
			this.dfEstimatedShipDate	= dfEstimatedShipDate;
			this.dfShip_date			= dfShip_date;
			this.dfInhand_date			= dfInhand_date;
			this.lblApiCalling			= lblApiCalling;
			//this.lblApiCalling.visible	= true;			
			this.cbBillingTransportationTo	= cbBillingTransportationTo;
			this.tiShipMethodCode			= tiShipMethodCode;
			this.order_type				= order_type;
			this.resultXmlFromItem		= resultXmlFromItem;
			this.dgpackets				= dgPackets;
			this.defaultCall			= defaultCall;
			this.default_method			= getShipMethodCodeValue();
			this.screenComponents		= screenComponent;
			this.screenComponents.setStyle('disabledOverlayAlpha',0);
			this.tiQty					= tiQty;
			
			this.customer_id			= customer_id;
			this.ext_ref_date			= ext_ref_date;
			this.rush_order_type		= rush_order_type;
			this.next_day_flag			= next_day_flag;
			this.cbBlankOrderFlag		= cbBlankOrderFlag;
			this.paper_proof_flag		= paper_proof_flag;
			this.catalog_item_id		= catalog_item_id;
			this.item_qty				= item_qty;
			
			if(__localModel.ext_ref_date != '' && __localModel.ext_ref_date != null && __localModel.catalotg_item_id != '' && __localModel.catalotg_item_id != null && __localModel.customer_id!=''&& __localModel.customer_id!=null)
			{
				if(order_type=='P')
				{
					catalog_item_id  	= '';
				}
				var tempXml:XML				= new XML(<params></params>);
				
				tempXml.catalog_item_id		= catalog_item_id;
				tempXml.customer_id			= customer_id;
				tempXml.ship_qty			= tiQty.dataValue;
				tempXml.item_qty			= item_qty;
				tempXml.ext_ref_date		= ext_ref_date;
				tempXml.rushday				= rush_order_type;
				tempXml.paper_proof_flag	= paper_proof_flag;
				tempXml.next_day_flag		= next_day_flag;
				tempXml.blank_order_flag	= cbBlankOrderFlag;
				tempXml.company_id			=__genModel.user.id;
				
				
				this.screenComponents.enabled= false;
				this.screenComponents.setStyle('disabledOverlayAlpha',0);
				__genModel.isLockScreen		= true;
				
				
				var httpservice:HTTPService					= new HTTPService();
				httpservice.url								= getestimateshipdateandpackages_service_url;
				var http:HTTPService 						= commonUtility.dataService(httpservice);
				var __responder:IResponder 					= new mx.rpc.Responder(getEstimateDateAndPackagesResultHandler,getEstimateDateAndPackagesFaultHandler);
				var token:AsyncToken 						= http.send(tempXml);
				token.addResponder(__responder);
				
			}
			else
			{
				Alert.show("Select Customer , Item ,Customer PO Date ,and Item Qty");
				dfEstimatedShipDate.dataValue  = '';
			}
		}
		public function getEstimateDateAndPackagesResultHandler(event:ResultEvent):void
		{
			__genModel.isLockScreen		 = false;
			this.screenComponents.enabled= true;
			this.screenComponents.setStyle('disabledOverlayAlpha',.5);
			
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
				setPackagesXml(resultXml);
			}
		}
		
		private function setPackagesXml(resultXml:XML):void
		{
			var rowsLength:Number   					= dgpackets.rows.children().length();
			
			if(order_type!='P')  // P for sample
			{
				for(var row:int=0;row<rowsLength;row++)
				{
					dgpackets.deleteRow(0);
				}
				
				var packages:XML							= XML(resultXml.sales_order_shipping_packages);
				
				for(var i:int=0;i<packages.children().length();i++)
				{
					packages.children()[i].company_id		= __genModel.user.id;
					packages.children()[i].updated_by		= __genModel.user.userID;
					packages.children()[i].created_by		= __genModel.user.userID;
					packages.children()[i].id				= '';
					packages.children()[i].trans_flag		= 'A';
					packages.children()[i].lock_version		= 0;
				}
				
				dgpackets.rows								= packages.copy();
			}
			
			var date:String 							= resultXml.estimated_ship_date.toString();
			dfEstimatedShipDate.dataValue				= date;
			
			var recordStatusEvent:RecordStatusEvent     = new RecordStatusEvent("MODIFY");
			recordStatusEvent.dispatch();
			
			getDefaultShipping();	
			
		}
		private function getDefaultShipping():void
		{
			commonFunctions.openShippingApiMethods(screenComponents,shipping_code,tiShipZip,tiShipCountry,tiship_amt,tiShipMethod,dfEstimatedInhandDate,dfEstimatedShipDate,dfShip_date,dfInhand_date,tiShipState,lblShipAmountFormula,lblApiCalling,cbBillingTransportationTo,tiShipMethodCode,dgpackets,__localModel.order_type,__localModel.resultXmlFromItem,tiQty,true);
		}
		
		public function getEstimateDateAndPackagesFaultHandler(event:FaultEvent):void
		{
			__genModel.isLockScreen		 = false;
			this.screenComponents.enabled= true;
			this.screenComponents.setStyle('disabledOverlayAlpha',.5);
			
			Alert.show("updateShipInfo"+event.fault.faultDetail);
		}
		
		
		
	}  // end of class
}  // end of package