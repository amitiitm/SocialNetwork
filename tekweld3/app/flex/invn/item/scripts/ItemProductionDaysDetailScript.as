import model.GenModelLocator;

import mx.collections.ArrayCollection;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private var columnArray:ArrayCollection = new ArrayCollection();
private var columnIndex:int=0;

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
		if(Number(columnArray.getItemAt(i).dataValue) > Number(columnArray.getItemAt(i+1).dataValue))
		{
			returnValue = false;
			columnIndex	= i;
			break;
		}
	}
	return returnValue;
}

