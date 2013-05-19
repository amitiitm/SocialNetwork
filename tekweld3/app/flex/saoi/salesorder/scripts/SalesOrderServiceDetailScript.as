import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

import saoi.muduleclasses.TierPricingFunctions;
import saoi.salesorder.SalesOrderModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:SalesOrderModelLocator = (SalesOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var item_detail:GetInformationEvent;
private var resultXmlFromItem:XML = new XML();
public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	
	dfTrans_date.dataValue = __localModel.trans_date;
	var setupTotalXml:XML 		= new XML(<setup_items></setup_items>)
	for(var i:int=0;i<__localModel.setupXml.children().length();i++)
	{
		var temp:XMLList  			= new XMLList(<setup_item></setup_item>);
        temp.qty		   			= __localModel.setupXml.children()[i].qty.toString();
        temp.updated_at				= __localModel.setupXml.children()[i].updated_at.toString();
        temp.serial_no				= __localModel.setupXml.children()[i].serial_no.toString();
       	temp.update_flag			= __localModel.setupXml.children()[i].update_flag.toString();
        temp.cost					= __localModel.setupXml.children()[i].cost.toString();
        temp.trans_flag				= __localModel.setupXml.children()[i].trans_flag.toString();
        temp.created_by				= __localModel.setupXml.children()[i].created_by.toString();
        temp.lock_version			= __localModel.setupXml.children()[i].lock_version.toString();
        temp.updated_by				= __localModel.setupXml.children()[i].updated_by.toString();
        temp.setup_item_id			= __localModel.setupXml.children()[i].setup_item_id.toString();
        temp.id						= __localModel.setupXml.children()[i].id.toString();
        temp.catalog_item_id		= __localModel.setupXml.children()[i].catalog_item_id.toString();	
        temp.company_id				= __localModel.setupXml.children()[i].company_id.toString();
        temp.created_at				= __localModel.setupXml.children()[i].created_at.toString();
        temp.catalog_item_code		= __localModel.setupXml.children()[i].catalog_item_code.toString();
        temp.catalog_item_name		= __localModel.setupXml.children()[i].catalog_item_name.toString();	
        temp.description			= __localModel.setupXml.children()[i].description.toString();
        temp.unit					= __localModel.setupXml.children()[i].unit.toString();
        temp.price					= __localModel.setupXml.children()[i].price.toString();	
        setupTotalXml.appendChild(temp.copy());
	}
	setupTotalXml.appendChild(__localModel.itemXml.setup_items.setup_item);
	dcItemId.dataProvider = setupTotalXml.children();
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
	//tiQty.enabled = true;
	//tiCatalog_item_packet_code.enabled = true;
	resultXmlFromItem  = new XML();
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	getCatalogItemPriceXmlAfterSave();
}
private function setItemCost():void
{
	var index:int 			= new TierPricingFunctions().getColumnSize(resultXmlFromItem.columns,Number(tiItemQty.dataValue));
	var item_price:String	= new TierPricingFunctions().returnColumnPrice(resultXmlFromItem.catalog_item_prices.catalog_item_price,index);
	
	if(item_price=='')
	{
		tiItemPrice.dataValue		= tiItemPrice.defaultValue;
	}
	else
	{
		tiItemPrice.dataValue  	= item_price;
	}
	tiAmount.dataValue 		= (Number(tiItemPrice.dataValue)*Number(tiItemQty.dataValue)).toString();
}
private function  getColumnSize(columnXml:XMLList,size:int):int
{
	
	var index:int=1;
	/* if(size<=Number(columnXml.column1.toString()))
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
	} */
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
}

private function getCatalogItemPriceXmlAfterSave():void
{
	if(__localModel.customer_id!='' && __localModel.customer_id!=null)
	{
		if(dcItemId.dataValue!='' || dcItemId.dataValue!=null)
		{
			var callbacks:IResponder = new mx.rpc.Responder(getItemPriceAfterSaveHandler, null);
			item_detail	=	new GetInformationEvent('fetch_cust_specific_setup_item_price', callbacks, dcItemId.dataValue,__localModel.customer_id);
			item_detail.dispatch(); 
		}
	}
	else
	{
		Alert.show("Please Select Customer");
	}
}
private function getItemPriceAfterSaveHandler(resultXml:XML):void
{
	resultXmlFromItem = resultXml;
}