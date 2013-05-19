import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;
import com.generic.genclass.GenNumberFormatter;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

import saoi.discountcoupons.DiscountCouponsModelLocator;
import saoi.salesorder.SalesOrderModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:DiscountCouponsModelLocator = (DiscountCouponsModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var getCouponsDetail:GetInformationEvent;
private var itemXml:XML  = new XML();
private var numericFormatterThreePrecesion:GenNumberFormatter			=	new GenNumberFormatter();

public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	
	
	numericFormatterThreePrecesion.precision = 3;
	numericFormatterThreePrecesion.rounding = "nearest";
	numericFormatterThreePrecesion.useThousandsSeparator = false;
}
private function setDiscountPer():void
{
	tiDiscountPer.dataValue		= tiDiscountPer.defaultValue;
}
private function setDiscountPrice():void
{
	tiDiscountedPrice.dataValue		= tiDiscountedPrice.defaultValue;
}

override protected function resetObjectEventHandler():void
{
	itemXml			 = new XML();
	tiOriginalPrice.dataValue	 = tiOriginalPrice.defaultValue;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	getItemDetails();
}
private function getItemDetails():void
{
	if(dcServiceCharge_id.text != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccessriesItemHandler, null);
		var getAccessoriesItem:GetInformationEvent	=	new GetInformationEvent('accessories_item_detail', callbacks, dcServiceCharge_id.dataValue);
		getAccessoriesItem.dispatch();
	}
	else
	{
		tiOriginalPrice.dataValue	 	= tiOriginalPrice.defaultValue;
		tiDiscountedPrice.dataValue 	= tiDiscountedPrice.defaultValue;
		tiDiscountPer.dataValue 		= tiDiscountPer.defaultValue;
	} 
}

private function getAccessriesItemHandler(resultXml:XML):void
{
	itemXml	 = resultXml.copy();
	setOriginal_Price();
}
private function setOriginal_Price():void
{
	if(itemXml.children().length()>0)
	{
		var column1Price:Number = Number(itemXml.catalog_item_prices.catalog_item_price.column1.toString());
		if (column1Price >= 0)
		{
			tiOriginalPrice.dataValue  = numericFormatter.format(column1Price);
		}
		else
		{
			tiOriginalPrice.dataValue  = tiOriginalPrice.defaultValue;
		}
	}
	else
	{
		tiDiscountedPrice.dataValue = tiDiscountedPrice.defaultValue;
		tiDiscountPer.dataValue = tiDiscountPer.defaultValue;
	}
	
}
private function setDiscount_Per():void
{
	if(itemXml.children().length()>0)
	{
		var column1Price:Number = Number(itemXml.catalog_item_prices.catalog_item_price.column1.toString());
		if (column1Price >= 0)
		{
			var _dis_amt:Number = parseFloat(tiDiscountedPrice.text);
			
			tiDiscountPer.dataValue  = numericFormatter.format(Number(_dis_amt*100)/Number(column1Price))
		}
		else
		{
			tiDiscountPer.dataValue = tiDiscountPer.defaultValue;
		}
	}
	else
	{
		tiDiscountedPrice.dataValue = tiDiscountedPrice.defaultValue;
		tiDiscountPer.dataValue = tiDiscountPer.defaultValue;
	}
	
}
private function setDiscount_Amt():void
{
	if(itemXml.children().length()>0)
	{
		var column1Price:Number = Number(itemXml.catalog_item_prices.catalog_item_price.column1.toString());
		if (column1Price >= 0)
		{
			var _dis_per:Number = parseFloat(tiDiscountPer.text);
			
			tiDiscountedPrice.dataValue  = numericFormatter.format(column1Price-Number(column1Price*_dis_per)/100)
		}
		else
		{
			tiDiscountedPrice.dataValue = tiDiscountedPrice.defaultValue;
		}
	}
	else
	{
		tiDiscountedPrice.dataValue = tiDiscountedPrice.defaultValue;
		tiDiscountPer.dataValue = tiDiscountPer.defaultValue;
	}
}

protected override function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	if(Number(tiDiscountPer.dataValue)<=0 || Number(tiDiscountPer.dataValue)>100)
	{
		Alert.show("Discount % must in range of 0 to 100");
		return -1;
	}
	else
	{
		return 0;
	}
}
	