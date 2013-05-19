import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.formatters.NumberFormatter;

import saoi.reorder.ReOrderModelLocator;
import saoi.salesorder.SalesOrderModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:ReOrderModelLocator = (ReOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	
	dfTrans_date.dataValue = __localModel.trans_date;
	dcItemId.dataProvider = __localModel.itemXml.assemble_items.assemble_item
}


private function getItemDetails():void
{
	 if(dcItemId.selectedIndex >= 0)
	{
		var price:String 			= dcItemId.selectedItem.price.toString()
		var description:String 		= dcItemId.selectedItem.description.toString()
		var code :String      		= dcItemId.selectedItem.catalog_item_code.toString()	
		
		tiItemPrice.dataValue = price;
		taItemDescription.dataValue = description;
		tiItemCode.dataValue     = code;
		
	}
	else
	{
		tiItemPrice.dataValue 		= tiItemPrice.defaultValue;
		taItemDescription.dataValue = taItemDescription.defaultValue;
		tiItemCode.dataValue    	= tiItemCode.defaultValue;
	} 
	
	setItemCost();
}


private function setItemCost():void
{
	tiAmount.dataValue = (Number(tiItemPrice.dataValue)*Number(tiItemQty.dataValue)).toString();
}

public function getItemDetailsHandler(resultXml:XML):void
{
	tiImage_thumnail.dataValue = resultXml.children()[0].image_thumnail.toString();
}


override protected function resetObjectEventHandler():void
{
	//tiQty.enabled = true;
	//tiCatalog_item_packet_code.enabled = true;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{

}
	