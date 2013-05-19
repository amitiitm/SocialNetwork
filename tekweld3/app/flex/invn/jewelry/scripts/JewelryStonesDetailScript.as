import business.events.GetInformationEvent;
import com.generic.events.GenTextInputEvent;
import com.generic.genclass.GenNumberFormatter;
import invn.jewelry.JewelryModelLocator;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.rpc.IResponder;
import mx.managers.CursorManager;
import mx.core.Application;
import com.generic.events.DetailAddEditEvent;

protected var getInformationEvent:GetInformationEvent;
private var numericFormatter2:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatter4:GenNumberFormatter = new GenNumberFormatter();

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:JewelryModelLocator = (JewelryModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private function init():void
{
	numericFormatter2.precision = 2;
	numericFormatter2.rounding = "nearest";
	numericFormatter2.useThousandsSeparator = false;

	numericFormatter4.precision = 4;
	numericFormatter4.rounding = "nearest";
	numericFormatter4.useThousandsSeparator = false;
	
	if(__genModel.masterData.child('jewelry_default').apply_stone_wt_chart.value.toString() == 'Y')
	{
		tiStone_size.height	 =	0;
		tiStone_size.width	 =	0;
		tiStone_size.visible =  false ;
		tiStone_size.includeInLayout = false ;	
		//tiStone_size.updatableFlag = "false" ;
		
		cbStone_size.height	 =  20;
 		cbStone_size.width   =  125;
 		cbStone_size.validationFlag = "true" ;
		cbStone_size.visible =  true ;
		cbStone_size.includeInLayout = true ;
		//cbStone_size.updatableFlag = "true" ;
	}
}

private function handleWtItemChanged(event:GenTextInputEvent):void
{
	var _wt:Number			=	Number(tiWt.dataValue);
	var _qty:Number			=	Number(tiQty.dataValue);
	var _total_wt:Number	=	_wt * _qty;
	
	tiTotal_wt.dataValue	=	numericFormatter4.format(_total_wt.toString())

	calculateValues();
}

private function handleQtyItemChanged(event:GenTextInputEvent):void
{
	var _qty:Number			=	Number(tiQty.dataValue);
	var _wt:Number			=	Number(tiWt.dataValue);
	var _total_wt:Number	=	_wt * _qty;
	
	tiTotal_wt.dataValue	=	numericFormatter4.format(_total_wt.toString())	

	calculateValues();
}

private function handleCostItemChanged(event:GenTextInputEvent):void
{
	var _cost:Number = Number(tiCost.dataValue)
	
	if(_cost > 0)
	{
		tiPrice_per_pcs.dataValue = "0";
	}
	
	calculateValues();
}

private function handlePricePerPcsItemChanged(event:GenTextInputEvent):void
{
	var _price_per_pcs:Number = Number(tiPrice_per_pcs.dataValue)
	
	if(_price_per_pcs > 0)
	{
		tiCost.dataValue = "0";
	}
	
	calculateValues();
}

private function handleLaborItemChanged(event:GenTextInputEvent):void
{
	calculateValues();
}

private function calculateValues():void
{
	var stone_loss_per:Number 	= 	__localModel.stone_loss_percentage;
	var _stone_loss_amt:Number	=	0;
	var _markup_per:Number 		= 	Number(tiMarkup_per.dataValue);
	var _total_wt:Number		= 	Number(tiTotal_wt.dataValue);
	var _cost:Number 			= 	Number(tiCost.dataValue);
	var _price_per_pcs:Number 	= 	Number(tiPrice_per_pcs.dataValue);
	var _total_cost:Number		= 	0;
	var _labor:Number 			= 	Number(tiLabor.dataValue);
	var _setting_cost:Number	= 	0;
	var _qty:Number 			= 	Number(tiQty.dataValue);
	var _price:Number			=	0;

	if(isNaN(_stone_loss_amt))
	{
		_stone_loss_amt = 0;	
	}	
		
	if(stone_loss_per > 0)
	{
		_stone_loss_amt = ((_total_wt * _cost) * stone_loss_per)/ 100;
		tiStone_loss_amt.dataValue = _stone_loss_amt.toString();
	}

	if(_cost > 0)
	{
		_total_cost = (_total_wt * _cost) + _stone_loss_amt;
	}
	else if(_price_per_pcs > 0)
	{
		_total_cost = _price_per_pcs * _qty;
	}

	tiTotal_cost.dataValue = numericFormatter2.format(_total_cost.toString());
	
	_markup_per = _total_cost * (_markup_per / 100);
	
	if(isNaN(_markup_per))
	{
		_markup_per = 0;
	}
	
	tiMarkup_per.dataValue 		= 	numericFormatter2.format(_markup_per.toString());

	_setting_cost 				=	_qty * _labor;
	_price						= 	_total_cost + _markup_per + _setting_cost;
	
	tiPrice.dataValue			=	_price.toString();
	tiSetting_cost.dataValue	=	_setting_cost.toString();
}

private function calculateAvgWt():void
{
	
	if(__genModel.masterData.child('jewelry_default').apply_stone_wt_chart.value.toString() == 'Y')
	{
		if(cbStone_type.dataValue != '' && cbStone_shape.dataValue != '' && cbStone_size.dataValue != '' && cbCut.dataValue != '')
		{
			var callbacks:IResponder = new mx.rpc.Responder(getAvgWtHandler, null);
		
			CursorManager.setBusyCursor();
			Application.application.enabled = false; 
			
			getInformationEvent	= new GetInformationEvent('stonewtinfo', callbacks,cbStone_type.dataValue,cbStone_shape.dataValue,cbStone_size.dataValue,cbCut.dataValue);
			getInformationEvent.dispatch(); 
		}	
	}
}

private function getAvgWtHandler(resultXml:XML):void
{
	tiWt.dataValue = resultXml ;
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true; 
}

private function getLotsDetails():void
{
	if(dcDiamond_lot_id.text != '' && dcDiamond_lot_id.text != null)
	{
		var callbacks:IResponder = new mx..rpc.Responder(getLotsDetailsHandler, null);

		getInformationEvent	=	new GetInformationEvent('diamondlotinfo', callbacks, dcDiamond_lot_id.dataValue);
		getInformationEvent.dispatch(); 
	}
}

public function getLotsDetailsHandler(resultXml:XML):void
{	
	cbStone_shape.dataValue		= 	resultXml.children()[0].shape.toString();
	cbStone_size.dataValue		=	resultXml.children()[0].size.toString();	
	cbStone_quality.dataValue	=	resultXml.children()[0].quality.toString();
	cbColor_from.dataValue		=	resultXml.children()[0].color.toString();
	cbClarity_from.dataValue	=	resultXml.children()[0].clarity.toString();	
	tiCost.dataValue 			=	resultXml.children()[0].cost_per_ct.toString();
	tiPrice_per_pcs.dataValue  	=	resultXml.children()[0].price_per_pcs.toString();
	cbStone_setting.dataValue 	=	resultXml.children()[0].setting.toString();
	cbStone_type.dataValue		=	resultXml.children()[0].stone_type.toString();
	tiWt.dataValue				=	resultXml.children()[0].ct_average.toString();
	
	dcDiamond_lot_id.labelValue		=	resultXml.children()[0].lot_number.toString();
	dcDiamond_lot_id.dataValue		=	resultXml.children()[0].id.toString();
	tiDiam_lot_no.dataValue 		=	resultXml.children()[0].lot_number.toString();
	var _cost:Number = Number(tiCost.dataValue)
	var _price_per_pcs:Number = Number(tiPrice_per_pcs.dataValue)
	
	if(_cost > 0)
	{
		tiPrice_per_pcs.dataValue = "0";
	}
	else if(_price_per_pcs > 0)
	{
		tiCost.dataValue = "0";
	}
	
	calculateValues();
}

override protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	var returnVal:int = 0;
	var message:String;
	
	if(Number(tiWt.dataValue)<= 0)
	{
		message = 'Avg Wt'
		returnVal = 1
	}
	if(Number(tiQty.dataValue)<= 0)
	{
		if(message != '')
		{
			message = message + '\n'+'Qty'
		}
		else
		{
			message = 'Qty'
		}
			returnVal = 1
	}
	if(returnVal == 1)
	{
		Alert.show('The following fields are Invalid :'+ '\n'+ message) ;
	}
	return returnVal;
}