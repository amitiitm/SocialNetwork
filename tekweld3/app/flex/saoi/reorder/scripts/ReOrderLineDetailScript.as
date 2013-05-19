import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

import saoi.muduleclasses.TierPricingFunctions;
import saoi.reorder.ReOrderModelLocator;
import saoi.salesorder.SalesOrderModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:ReOrderModelLocator = (ReOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var resultXmlFromItem:XML = new XML();
private var item_detail:GetInformationEvent;

public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	
	dfTrans_date.dataValue = __localModel.trans_date;
	dcItemId.filterKeyValue = __localModel.catalotg_item_id;
	
	//dcItemId.dataProvider = __localModel.itemXml.accessory_items.accessory_item;
}


private function getItemDetails():void
{
	if(dcItemId.text != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccessriesItemHandler, null);
		var getAccessoriesItem:GetInformationEvent	=	new GetInformationEvent('accessories_item_detail', callbacks, dcItemId.dataValue);
		getAccessoriesItem.dispatch();
	}
	else
	{
		tiItemPrice.dataValue 		= tiItemPrice.defaultValue;
		taItemDescription.dataValue = taItemDescription.defaultValue;
		tiItemCode.dataValue    	= tiItemCode.defaultValue;
	} 
}

private function getAccessriesItemHandler(resultXml:XML):void
{
	var price:String 			= resultXml.price.toString()
	var description:String 		= resultXml.description.toString()
	var code :String      		= resultXml.catalog_item_code.toString()	
	
	tiItemPrice.dataValue = price;
	taItemDescription.dataValue = description;
	//tiItemCode.dataValue     = code;
	
	if(__localModel.customer_id!='' && __localModel.customer_id!=null)
	{
		if(dcItemId.dataValue!='' || dcItemId.dataValue!=null)
		{
			var callbacks:IResponder = new mx.rpc.Responder(getItemPriceHandler, null);
			item_detail	=	new GetInformationEvent('fetch_cust_specific_setup_item_price', callbacks, dcItemId.dataValue,__localModel.customer_id);
			item_detail.dispatch();
		}
	}
	else
	{
		Alert.show("Please Select Customer");
	}
}



private function getItemPriceHandler(resultXml:XML):void
{
	resultXmlFromItem = resultXml;
	setItemCost();
}

override protected function resetObjectEventHandler():void
{
	tiItemQty.dataValue	= __localModel.main_item_qty_total;
	resultXmlFromItem  = new XML();
}
private function setItemCost():void
{
	var index:int 			= new TierPricingFunctions().getColumnSize(resultXmlFromItem.columns,Number(tiItemQty.dataValue));
	tiItemPrice.dataValue  	= new TierPricingFunctions().returnColumnPrice(resultXmlFromItem.catalog_item_prices.catalog_item_price,index);
	tiAmount.dataValue 		= (Number(tiItemPrice.dataValue)*Number(tiItemQty.dataValue)).toString();
}
/*private function  getColumnSize(columnXml:XMLList,size:int):int
{
	var index:int=1;
	if(size<=Number(columnXml.column1.toString()))
	{
		index = 1;
	}
	else if(size<=Number(columnXml.column2.toString()) && size>Number(columnXml.column1.toString()))
	{
		index = 2;
	}
	else if(size<=Number(columnXml.column3.toString()) && size>Number(columnXml.column2.toString()))
	{
		index = 3;
	}
	else if(size<=Number(columnXml.column4.toString()) && size>Number(columnXml.column3.toString()))
	{
		index = 4;
	}
	else if(size<=Number(columnXml.column5.toString()) && size>Number(columnXml.column4.toString()))
	{
		index = 5;
	}
	else if(size<=Number(columnXml.column6.toString()) && size>Number(columnXml.column5.toString()))
	{
		index = 6;
	}
	else if(size<=Number(columnXml.column7.toString()) && size>Number(columnXml.column6.toString()))
	{
		index = 7;
	}
	else if(size<=Number(columnXml.column8.toString()) && size>Number(columnXml.column7.toString()))
	{
		index = 8;
	}
	else if(size<=Number(columnXml.column9.toString()) && size>Number(columnXml.column8.toString()))
	{
		index = 9;
	}
	else if(size<=Number(columnXml.column10.toString()) && size>Number(columnXml.column9.toString()))
	{
		index = 10;
	} 
	return index;
	
	
}

private function returnColumnPrice(column_pricing:XMLList,index:int):String
{
	var price:String = column_pricing.column10.toString();
	if(index==1)
	{
		price =  column_pricing.column1.toString();
	}
	else if(index==2)
	{
		price =  column_pricing.column2.toString();
	}
	else if(index==3)
	{
		price =  column_pricing.column3.toString();
	}
	else if(index==4)
	{
		price =  column_pricing.column4.toString();
	}
	else if(index==5)
	{
		price =  column_pricing.column5.toString();
	}
	else if(index==6)
	{
		price =  column_pricing.column6.toString();
	}
	else if(index==7)
	{
		price =  column_pricing.column7.toString();
	}
	else if(index==8)
	{
		price =  column_pricing.column8.toString();
	}
	else if(index==9)
	{
		price =  column_pricing.column9.toString();
	}
	else if(index==10)
	{
		price =  column_pricing.column10.toString();
	}
	return price;
}	*/
