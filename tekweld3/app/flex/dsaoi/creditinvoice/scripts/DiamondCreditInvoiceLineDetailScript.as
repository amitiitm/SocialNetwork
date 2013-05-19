import business.events.GetInformationEvent;
import com.generic.events.DetailAddEditEvent;
import com.generic.genclass.GenNumberFormatter;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.rpc.IResponder;

private var numericFormatter:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatterWt:GenNumberFormatter = new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function creationCompleteHandler():void 
{
	numericFormatterWt.precision = 3;
	numericFormatterWt.rounding = "nearest";

	numericFormatter.precision = 2;
	numericFormatter.rounding =	"nearest";
}

private function calculateNetAmount():void
{
	if(cbSell_unit.dataValue.toLowerCase()	== "wt" || cbSell_unit.dataValue.toLowerCase()	== "c")
	{
		tiLine_amt.dataValue = numericFormatter.format(Number(tiWt.dataValue) * Number(tiPrice.dataValue));
	}
	else if(cbSell_unit.dataValue.toLowerCase()	== "pcs" || cbSell_unit.dataValue.toLowerCase()	== "e")
	{
		tiLine_amt.dataValue = numericFormatter.format(Number(tiPcs.dataValue) * Number(tiPrice.dataValue));
	}
	
	discountAmtCalculation();
	netAmountCalculation();
}

private function discountAmtCalculation():void
{
	tiDiscount_amt.dataValue	= numericFormatter.format((Number(tiLine_amt.dataValue) * Number(tiDiscount_per.dataValue))/ 100);
}

private function netAmountCalculation():void
{
	tiNet_amt.dataValue = numericFormatter.format(Number(tiLine_amt.dataValue) - Number(tiDiscount_amt.dataValue));
}

private function itemAmountChangeHandler():void
{
	// on changing item amount we are calculating price and net amount
	if(cbSell_unit.dataValue.toLowerCase() == "wt" || cbSell_unit.dataValue.toLowerCase() == "c")
	{
		if(Number(tiWt.dataValue) > 0)
		{
			tiPrice.dataValue = numericFormatter.format(Number(tiLine_amt.dataValue)/ Number(tiWt.dataValue));
			discountAmtCalculation();
			netAmountCalculation();
		}
		else
		{
			tiWt.dataValue = tiWt.defaultValue;
			Alert.show('WT cannot be 0');
		}
	}
	if(cbSell_unit.dataValue.toLowerCase() == "pcs" || cbSell_unit.dataValue.toLowerCase() == "e")
	{
		if(Number(tiPrice.dataValue) > 0)
		{
			tiPrice.dataValue = numericFormatter.format(Number(tiLine_amt.dataValue)/ Number(tiPrice.dataValue));
			discountAmtCalculation();
			netAmountCalculation();
		}
		else
		{
			tiPcs.dataValue = tiPcs.defaultValue;
			Alert.show('PCS cannot be 0');
		}
	}
}

private function discPerCalculation():void
{
	tiDiscount_per.dataValue	= numericFormatter.format((Number(tiDiscount_amt.dataValue) * 100)/ Number(tiLine_amt.dataValue));
	calculateNetAmount();
}

private function getPacketDetails():void
{
	if(tiDiamond_packet_no.dataValue != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('diamondpacketinfo', callbacks, tiDiamond_packet_no.dataValue, 'N');
		getInformationEvent.dispatch();
	}
	else
	{
		tiDiamond_packet_id.dataValue = ""	
	}
}

public function getLotsDetails():void
{
	if(dcDiamond_lot_id.dataValue != '')
	{
		var callbacks:IResponder = new mx..rpc.Responder(getLotsDetailsHandler, null);

		getInformationEvent	=	new GetInformationEvent('diamondlotinfo', callbacks, dcDiamond_lot_id.dataValue);
		getInformationEvent.dispatch(); 
	}
	else
	{
		resetOtherValues();
		
		tiDiamond_lot_no.dataValue = tiDiamond_lot_no.defaultValue;
		tiPrice.dataValue = tiPrice.defaultValue;
		dcLocation_code.dataValue = dcLocation_code.defaultValue;
		cbClarity.dataValue = cbClarity.defaultValue;
		cbColor.dataValue = cbColor.defaultValue;
		cbQuality.dataValue = cbQuality.defaultValue;
	 	cbSell_unit.dataValue = cbSell_unit.defaultValue; 	
		cbShape.dataValue = cbShape.defaultValue;
		cbStone_type.dataValue = cbStone_type.defaultValue;
		tiDiamond_packet_no.dataValue = "";
		tiDiamond_packet_id.dataValue = "";
	}
}

public function getLotsDetailsHandler(resultXml:XML):void
{
	var diamond_cert_flag:String;

	resetOtherValues();
	
	tiDiamond_lot_no.dataValue = resultXml.children()[0].lot_number.toString();
	tiPrice.dataValue = resultXml.children()[0].price_per_ct.toString();
	dcLocation_code.dataValue = resultXml.children()[0].location.toString();
	cbClarity.dataValue = resultXml.children()[0].clarity.toString();
	cbColor.dataValue = resultXml.children()[0].color.toString();
	cbQuality.dataValue = resultXml.children()[0].quality.toString();
	cbShape.dataValue = resultXml.children()[0].shape.toString();
	cbStone_type.dataValue = resultXml.children()[0].stone_type.toString();
	
	diamond_cert_flag = resultXml.children()[0].diamond_cert_flag.toString();

	tiDiamond_packet_no.dataValue = "";
	tiDiamond_packet_id.dataValue = "";
		
	if(diamond_cert_flag=='N')
	{
		tiDiamond_packet_no.enabled = false;
	}
	else
	{
		tiDiamond_packet_no.enabled = true;
	}	

	tiPcs.enabled = true;
	tiWt.enabled = true;
	tiDiamond_cert_flag.dataValue = diamond_cert_flag;

	calculateNetAmount()
}

public function getPacketDetailsHandler(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		resetOtherValues();

		tiDiamond_packet_id.dataValue = resultXml.children()[0].id.toString();
		tiDiamond_packet_no.dataValue = resultXml.children()[0].packet_no.toString();
	
		tiDiamond_lot_no.dataValue = resultXml.children()[0].diamond_lot_number.toString();;
		dcDiamond_lot_id.dataValue = resultXml.children()[0].diamond_lot_id.toString();
		tiPrice.dataValue = resultXml.children()[0].rapaport_price.toString();
		dcLocation_code.dataValue = resultXml.children()[0].location.toString();
		cbClarity.dataValue = resultXml.children()[0].clarity.toString();
		cbColor.dataValue = resultXml.children()[0].color.toString();
		cbShape.dataValue = resultXml.children()[0].shape.toString();
		cbStone_type.dataValue = resultXml.children()[0].stone_type.toString();
		tiSize.dataValue = resultXml.children()[0].size.toString();
		tiDiamond_cert_flag.dataValue = resultXml.children()[0].diamond_cert_flag.toString();

		cbSell_unit.dataValue = "PCS" 	
		
		tiPcs.dataValue = "1";
		tiPcs.enabled = false;
		
		tiWt.dataValue = resultXml.children()[0].weight.toString();
		tiWt.enabled = false;
	}
	else
	{
		tiDiamond_packet_id.dataValue = tiDiamond_packet_id.defaultValue;
		tiDiamond_packet_no.dataValue = tiDiamond_packet_no.defaultValue;
	
		tiPcs.enabled = true;
		tiWt.enabled = true;
	}

	calculateNetAmount()
}

	
private function resetOtherValues():void
{
	//we can call resetObjects method also but it will reset id also in the case of updation, which should not happened.
	tiClear_pcs.dataValue = tiClear_pcs.defaultValue;
	tiClear_wt.dataValue = tiClear_wt.defaultValue;
	tiDiscount_amt.dataValue = tiDiscount_amt.defaultValue;
	tiDiscount_per.dataValue = tiDiscount_per.defaultValue;
	tiLine_amt.dataValue = tiLine_amt.defaultValue;
	tiNet_amt.dataValue = tiNet_amt.defaultValue;
	tiPcs.dataValue = tiPcs.defaultValue;
	tiRef_pcs.dataValue = tiRef_pcs.defaultValue;
	tiRef_wt.dataValue = tiRef_wt.defaultValue;
	tiWt.dataValue = tiWt.defaultValue;
}

override protected function resetObjectEventHandler():void
{
	tiPcs.enabled = true;
	tiWt.enabled = true;
	tiDiamond_packet_no.enabled = true;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	var diamond_cert_flag:String = tiDiamond_cert_flag.dataValue;
	var diamond_packet_no:String = tiDiamond_packet_no.dataValue;

	if(diamond_cert_flag == null || diamond_cert_flag == "" || diamond_cert_flag.toLocaleUpperCase() =='N')
	{
		tiDiamond_packet_no.enabled = false
	}
	else
	{
		tiDiamond_packet_no.enabled = true
	}

	if(diamond_packet_no == null || diamond_packet_no == "")
	{
		tiPcs.enabled = true;
		tiWt.enabled = true;
	}
	else
	{
		tiPcs.enabled = false;
		tiWt.enabled = false;
	}
}
	