import model.GenModelLocator;

import mx.collections.ArrayCollection;

import saoi.muduleclasses.CommonArtworkXml;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private var columnArray:ArrayCollection = new ArrayCollection();
private var columnIndex:int=0;
private var commonartworkXml:CommonArtworkXml   			= new CommonArtworkXml(); 

private function setColumnsOrder():void
{
	if(!isColumnsCorrectOrder())
	{
		var lastColumnValue:Number = columnArray.getItemAt(columnIndex).dataValue ;
		for(var i:int=columnIndex;i<columnArray.length;i++)
		{
			columnArray.getItemAt(i).dataValue = lastColumnValue.toString();
		}
	}
}


private function isColumnsCorrectOrder():Boolean
{
	columnArray.removeAll();
	columnArray.addItem(tiColumn1);
	columnArray.addItem(tiColumn2);
	columnArray.addItem(tiColumn3);
	columnArray.addItem(tiColumn4);
	columnArray.addItem(tiColumn5);
	columnArray.addItem(tiColumn6);
	columnArray.addItem(tiColumn7);
	columnArray.addItem(tiColumn8);
	columnArray.addItem(tiColumn9);
	columnArray.addItem(tiColumn10);
	columnArray.addItem(tiColumn11);
	columnArray.addItem(tiColumn12);
	columnArray.addItem(tiColumn13);
	columnArray.addItem(tiColumn14);
	columnArray.addItem(tiColumn15);
	
	var returnValue:Boolean = true;
	for(var i:int=0;i<columnArray.length-1;i++)
	{
		if(Number(columnArray.getItemAt(i).dataValue) < Number(columnArray.getItemAt(i+1).dataValue))
		{
			returnValue = false;
			columnIndex	= i;
			break;
		}
	}
	return returnValue;
}
private function setNetPrice():void
{
	tiBlank_good_price.dataValue  	= (Number(tiBlank_good_price_before_discount.dataValue) - ((Number(cbDiscountBlankGoods.dataValue)* Number(tiBlank_good_price_before_discount.dataValue))/100)).toString();
	tiColumn1.dataValue  			= (Number(tiColumn1_price_before_discount.dataValue) - 	 ((Number(cbDiscountcolumn1.dataValue)* Number(tiColumn1_price_before_discount.dataValue))/100)).toString();
	tiColumn2.dataValue  			= (Number(tiColumn2_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn2.dataValue)* Number(tiColumn2_price_before_discount.dataValue))/100)).toString();
	tiColumn3.dataValue  			= (Number(tiColumn3_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn3.dataValue)* Number(tiColumn3_price_before_discount.dataValue))/100)).toString();
	tiColumn4.dataValue  			= (Number(tiColumn4_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn4.dataValue)* Number(tiColumn4_price_before_discount.dataValue))/100)).toString();
	tiColumn5.dataValue  			= (Number(tiColumn5_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn5.dataValue)* Number(tiColumn5_price_before_discount.dataValue))/100)).toString();
	tiColumn6.dataValue  			= (Number(tiColumn6_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn6.dataValue)* Number(tiColumn6_price_before_discount.dataValue))/100)).toString();
	tiColumn7.dataValue  			= (Number(tiColumn7_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn7.dataValue)* Number(tiColumn7_price_before_discount.dataValue))/100)).toString();
	tiColumn8.dataValue  			= (Number(tiColumn8_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn8.dataValue)* Number(tiColumn8_price_before_discount.dataValue))/100)).toString();
	tiColumn9.dataValue  			= (Number(tiColumn9_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn9.dataValue)* Number(tiColumn9_price_before_discount.dataValue))/100)).toString();
	tiColumn10.dataValue  			= (Number(tiColumn10_price_before_discount.dataValue) -   ((Number(cbDiscountcolumn10.dataValue)* Number(tiColumn10_price_before_discount.dataValue))/100)).toString();
	tiColumn11.dataValue  			= (Number(tiColumn11_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn11.dataValue)* Number(tiColumn11_price_before_discount.dataValue))/100)).toString();
	tiColumn12.dataValue  			= (Number(tiColumn12_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn12.dataValue)* Number(tiColumn12_price_before_discount.dataValue))/100)).toString();
	tiColumn13.dataValue  			= (Number(tiColumn13_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn13.dataValue)* Number(tiColumn13_price_before_discount.dataValue))/100)).toString();
	tiColumn14.dataValue  			= (Number(tiColumn14_price_before_discount.dataValue) -    ((Number(cbDiscountcolumn14.dataValue)* Number(tiColumn14_price_before_discount.dataValue))/100)).toString();
	tiColumn15.dataValue  			= (Number(tiColumn15_price_before_discount.dataValue) -   ((Number(cbDiscountcolumn15.dataValue)* Number(tiColumn15_price_before_discount.dataValue))/100)).toString();
}
