package saoi.muduleclasses
{
	import business.events.GetInformationEvent;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.components.DataEntry;
	import com.generic.components.Detail;
	import com.generic.events.DetailEvent;
	import com.generic.genclass.TabPage;
	import com.generic.genclass.URL;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import flashx.textLayout.elements.BreakElement;
	
	import model.GenModelLocator;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.INavigatorContent;
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import saoi.muduleclasses.event.MissingInfoEvent;

	public class ThirdPartyShippingChargeCalculation
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		
		private var getInformationEvent:GetInformationEvent;
		private var dtlSetup:Object;
		private var selectedOptionsCode:String;
		private var selectedOptionsValue:String;
		private var main_item_qty:String;
		private var vbMain:VBox	;
		private var isAdd:Boolean;
		
		private var catalog_attribute_values:XML;
		private var catalog_attribute_codes:XML;
		
		public function ThirdPartyShippingChargeCalculation()
		{
			__genModel		= 	GenModelLocator.getInstance();
			__localModel	= 	__genModel.activeModelLocator;
			__services		= 	__genModel.services;
		}
	
		public function checkForThirdPartyShippingCharge(dtlShipping:Detail,dtlSetup:Detail,thirdPartyShippingCharge:XML):void
		{
			var shippingXml:XML  			= dtlShipping.dgDtl.rows.copy();
			var setupXml:XML	 			= dtlSetup.dgDtl.rows.copy();
			
			var thirdPartyShipingCount:int 	= getThirdPartyShippingChargeCount(dtlShipping);
			var isThirdPartyChargeExist:int = isThirdPartyChargeExist(dtlSetup,thirdPartyShippingCharge);
			
			if(thirdPartyShippingCharge.children().length()>0)
			{
				if(thirdPartyShipingCount>0)
				{
					if(isThirdPartyChargeExist >= 0)
					{
						// update chnarge
						if(Number(setupXml.children()[isThirdPartyChargeExist].item_price.toString())>0)
						{
							var tempXml:XML	= dtlSetup.dgDtl.rows.copy();
							tempXml.children()[isThirdPartyChargeExist].item_qty = thirdPartyShipingCount;
							tempXml.children()[isThirdPartyChargeExist].item_amt = (Number(tempXml.children()[isThirdPartyChargeExist].item_price.toString())* Number(tempXml.children()[isThirdPartyChargeExist].item_qty.toString())).toString();
							dtlSetup.dgDtl.rows = tempXml.copy();
						}
					}
					else
					{
						//add charge
						var tempXml:XML	= dtlSetup.dgDtl.rows.copy();
						tempXml.appendChild(thirdPartyShippingCharge.children().copy());
						dtlSetup.dgDtl.rows = tempXml.copy();
					}
					dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));
				}
				else
				{
					// remove third party shipping charge
					removeThirdPartyShippingCharge(dtlSetup,isThirdPartyChargeExist);
				}
			}
			else
			{
				removeThirdPartyShippingCharge(dtlSetup,isThirdPartyChargeExist);
				// remove third party shipping charge
			}
		}
		private function removeThirdPartyShippingCharge(dtlSetup:Detail,index:int):void
		{
			if(index>=0)
			{
				dtlSetup.deleteRow(index);
				dtlSetup.dispatchEvent(new Event('optionsComboboxChange'));
			}
		}
		private function isThirdPartyChargeExist(dtlSetup:Detail,thirdPartyShippingCharge:XML):int
		{
			var setupXml:XML	 = dtlSetup.dgDtl.rows.copy();
			var returnValue:int	 = -1;
			
			if(thirdPartyShippingCharge.children().length()<1)
			{
				return returnValue;
			}
			var thirdPartyShippingChargeCode:String	= thirdPartyShippingCharge.children()[0].catalog_item_code.toString();
			
			for(var i:int=0;i<setupXml.children().length();i++)
			{
				var catalog_item_code:String  = setupXml.children()[i].catalog_item_code.toString();
				var item_price:String  		  = setupXml.children()[i].item_price.toString();
				if(catalog_item_code == thirdPartyShippingChargeCode && Number(item_price)>0)
				{
					returnValue = i;
				}
			}
			return returnValue;
		}
		private function getThirdPartyShippingChargeCount(dtlShipping:Detail):int
		{
			var shippingXml:XML	 = dtlShipping.dgDtl.rows.copy();
			var thirdPartyShipingCount:int = 0;
			
			for(var i:int=0;i<shippingXml.children().length();i++)
			{
				var billing_transporation_to:String  = shippingXml.children()[i].bill_transportation_to.toString();
				if(billing_transporation_to=='Third Party' || billing_transporation_to=='Receiver')
				{
					++thirdPartyShipingCount;
				}
			}
			return thirdPartyShipingCount;
		}
		
	}           // end of class
}  // end of package