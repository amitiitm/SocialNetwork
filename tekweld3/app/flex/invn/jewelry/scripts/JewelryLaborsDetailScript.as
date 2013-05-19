import com.generic.events.GenTextInputEvent;
import com.generic.genclass.GenNumberFormatter;
import model.GenModelLocator;

private var numericFormatter2:GenNumberFormatter = new GenNumberFormatter();

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function init():void
{
	numericFormatter2.precision = 2;
	numericFormatter2.rounding = "nearest";
	numericFormatter2.useThousandsSeparator = false;
}

private function handleQtyItemChanged(event:GenTextInputEvent):void
{
	calculateTotalCost();	
}

private function handleCostItemChanged(event:GenTextInputEvent):void
{
	calculateTotalCost();	
}

private function calculateTotalCost():void
{
	var _qty:Number		= Number(tiQty.dataValue);
	var _cost:Number 	= Number(tiCost.dataValue);
	var _markup:Number 	= 0;
	
	var _total_cost:Number	= _qty * _cost;
	
	_total_cost	= Number(numericFormatter2.format((_total_cost + (_total_cost * _markup / 100))));
	
	tiTotal_cost.dataValue	= _total_cost.toString();
}
