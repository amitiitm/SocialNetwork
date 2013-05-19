import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

import saoi.sampleorder.SampleOrderModelLocator;
import saoi.virtualorder.VirtualOrderModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:VirtualOrderModelLocator = (VirtualOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var shippingMethidsValue:String ;
private var shipping_detail:GetInformationEvent;
private function init():void
{
	dcCustomer_shipping_id.dataProvider = __localModel.customerShipping.children();
}


private function getShippingAddress():void
{
	if(dcCustomer_shipping_id.selectedIndex >= 0)
	{
		tiShip_nm.text 			= dcCustomer_shipping_id.selectedItem.name.toString();
		tiShip_address1.text 	= dcCustomer_shipping_id.selectedItem.address1.toString();
		tiShip_address2.text 	= dcCustomer_shipping_id.selectedItem.address2.toString();
		tiShip_city.text 		= dcCustomer_shipping_id.selectedItem.city.toString();
		tiShip_fax1.text 		= dcCustomer_shipping_id.selectedItem.fax1.toString();
		tiShip_phone1.text 		= dcCustomer_shipping_id.selectedItem.phone1.toString();
		tiShip_state.text 		= dcCustomer_shipping_id.selectedItem.state.toString();
		tiShip_zip.text 		= dcCustomer_shipping_id.selectedItem.zip.toString();
		tiShip_country.text 	= dcCustomer_shipping_id.selectedItem.country.toString();
	}
	else
	{
		tiShip_nm.text 			= '';
		tiShip_address1.text 	= '';
		tiShip_address2.text 	= '';
		tiShip_city.text 		= '';
		tiShip_fax1.text 		= '';
		tiShip_phone1.text 		= '';
		tiShip_state.text 		= '';
		tiShip_zip.text 		= '';
		tiShip_country.text 	= '';
	}
}
private function setAccountNo():void
{
	if(dcShipping_code.dataValue == 'THIRDPARTY')
	{
		tiAccountNo.enabled = true;
		tiAmount.dataValue 			= tiAmount.defaultValue;
		tiShipMethod.dataValue		= tiShipMethod.defaultValue
	}
	else
	{
		tiAccountNo.dataValue = '';
		tiAccountNo.enabled = false;
	}
	setShippingMethods();
}
private function setShippingMethods():void
{
	if(dcShipping_code.text != '' && dcShipping_code.text!= null)
	{
		shippingMethidsValue	= dcShippingMethods.dataValue;
		var callbacks:IResponder = new mx.rpc.Responder(getShippingDetailHandler, null);
		shipping_detail	=	new GetInformationEvent('fetch_shipvia_methods', callbacks, dcShipping_code.dataValue);
		shipping_detail.dispatch(); 
	}
}
private function getShippingDetailHandler(resultXml:XML):void
{
	dcShippingMethods.dataProvider	= resultXml.children();
	dcShippingMethods.dataValue		= shippingMethidsValue;
}
private function setShippingMethodToolTip():void
{
	if(dcShipping_code.text != '' && dcShipping_code.text != null)
	{
		dcShippingMethods.toolTip	= dcShippingMethods.selectedItem.ship_method_description.toString();
	}
}

private function setshippingMethodsvalue(value:String):void
{
	dcShippingMethods.dataValue	= value;
}
protected override function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	var recordXml:XML					= event.rowXml;
	setShippingMethods();                    // data in shipping methods on drilldown and retrieve open screen first time
	var shippingMethidsValue:String		= recordXml.ship_method.toString();
	setTimeout(setshippingMethodsvalue,1000*5,shippingMethidsValue);
}
	