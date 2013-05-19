import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

import saoi.salesorder.SalesOrderModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:SalesOrderModelLocator = (SalesOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var getCouponsDetail:GetInformationEvent;

public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	
	if(__localModel.customer_id =='' || __localModel.catalotg_item_id=='' )
	{
		dcDiscountCoupons_id.filterKeyValue  =  '';
	}	
	
	else
	{
		dcDiscountCoupons_id.filterKeyValue  = __localModel.customer_id+','+__localModel.catalotg_item_id;
	}
}

private function getCouponsDetails():void
{
	if(__localModel.customer_id!='' && __localModel.customer_id!=null && __localModel.catalotg_item_id!='')
	{
		if(dcDiscountCoupons_id.dataValue!='' || dcDiscountCoupons_id.dataValue!=null)
		{
			var callbacks:IResponder 	= 	new mx.rpc.Responder(getCouponsDetailsHandler, null);
			getCouponsDetail			=	new GetInformationEvent('get_coupons_details', callbacks, dcDiscountCoupons_id.dataValue);
			getCouponsDetail.dispatch();
		}
		else
		{
			Alert.show("Please Select Discount Coupon");
		}
	}
	else
	{
		Alert.show("Please Select Customer");
	}
}
private function getCouponsDetailsHandler(resultXml:XML):void
{
	Alert.show(resultXml.toXMLString());
}
override protected function resetObjectEventHandler():void
{
	dcDiscountCoupons_id.enabled	  = true;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	var rowId:Number   = Number(event.rowXml.id.toString());
	if(rowId>0)
	{
		dcDiscountCoupons_id.enabled	  = false;
	}
	else
	{
		dcDiscountCoupons_id.enabled	  = true;
	}
}
	