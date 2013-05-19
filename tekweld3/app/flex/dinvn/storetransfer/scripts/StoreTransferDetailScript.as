import business.events.GetInformationEvent;
import com.generic.events.DetailAddEditEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.GenValidator;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.rpc.IResponder;

private var genValidator:GenValidator = new GenValidator();
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
		tiLine_amt.text = numericFormatter.format(Number(tiWt.text) * Number(tiPrice.text));
	}
	else if(cbSell_unit.dataValue.toLowerCase()	== "pcs" || cbSell_unit.dataValue.toLowerCase()	== "e")
	{
		tiLine_amt.text = numericFormatter.format(Number(tiPcs.text) * Number(tiPrice.text));
	}
}

private function itemAmountChangeHandler():void
{
	// on changing item amount we are calculating price and net amount
	if(cbSell_unit.dataValue.toLowerCase() == "wt" || cbSell_unit.dataValue.toLowerCase() == "c")
	{
		if(Number(tiWt.text) > 0)
		{
			tiPrice.text = numericFormatter.format(Number(tiLine_amt.text)/ Number(tiWt.text));
		}
		else
		{
			tiWt.text = tiWt.defaultValue;
			Alert.show('WT cannot be 0');
		}
	}
	if(cbSell_unit.dataValue.toLowerCase() == "pcs" || cbSell_unit.dataValue.toLowerCase() == "e")
	{
		if(Number(tiPrice.text) > 0)
		{
			tiPrice.text = numericFormatter.format(Number(tiLine_amt.text)/ Number(tiPrice.text));
		}
		else
		{
			tiPcs.text = tiPcs.defaultValue;
			Alert.show('PCS cannot be 0');
		}
	}
}
private function getPacketDetails():void
{
	if(tiDiamond_packet_no.text != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('diamondpacketinfo', callbacks, tiDiamond_packet_no.dataValue, 'Y');
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
		tiPrice.text = tiPrice.defaultValue;
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
		tiDiamond_packet_no.validationFlag = "false";
		tiDiamond_packet_no.errorString = "";
		tiDiamond_packet_no.validateNow();	
		tiDiamond_packet_no.enabled = false;
		
	 	cbSell_unit.dataValue = resultXml.children()[0].cost_unit.toString();

		tiPcs.enabled = true;
		tiPcs.dataValue = tiPcs.defaultValue;
		
		tiWt.enabled = true;
		tiWt.dataValue = tiWt.defaultValue;
	}
	else
	{
		tiDiamond_packet_no.validationFlag = "true";
		tiDiamond_packet_no.enabled = true;

	 	cbSell_unit.dataValue = "PCS"

		tiPcs.dataValue = "1";
		tiPcs.enabled = false;
		
		tiWt.enabled = false;
	}	

	tiDiamond_cert_flag.dataValue = diamond_cert_flag;

	calculateNetAmount()
	__genModel.activeModelLocator.detailEditObj.validators = genValidator.applyValidation(__genModel.activeModelLocator.detailEditObj.genObjects)
}

public function getPacketDetailsHandler(resultXml:XML):void
{
	resetOtherValues();
	
	if(resultXml.children().length() > 0)
	{
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
	
		tiDiamond_lot_no.dataValue = tiDiamond_lot_no.defaultValue;
		dcDiamond_lot_id.dataValue = dcDiamond_lot_id.defaultValue; 
		tiPrice.dataValue = tiPrice.defaultValue; 
		dcLocation_code.dataValue = dcLocation_code.defaultValue; 
		cbClarity.dataValue = cbClarity.defaultValue; 
		cbColor.dataValue = cbColor.defaultValue; 
		cbSell_unit.dataValue = cbSell_unit.defaultValue; 
		cbShape.dataValue = cbShape.defaultValue; 
		cbStone_type.dataValue = cbStone_type.defaultValue; 
		tiSize.dataValue = tiSize.defaultValue;
		tiDiamond_cert_flag.dataValue = tiDiamond_cert_flag.defaultValue;

		tiPcs.enabled = true;
		tiWt.enabled = true;
	}
	
	calculateNetAmount()
}

private function resetOtherValues():void
{
	// we can call resetObjects method also but it will reset id also in the case of updation, which should not happened.
	tiLine_amt.dataValue = tiLine_amt.defaultValue;
	tiPcs.dataValue = tiPcs.defaultValue;
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
	
	if(diamond_cert_flag == null || diamond_cert_flag == "" || diamond_cert_flag.toLocaleUpperCase() =='N')
	{
		tiPcs.enabled = true;
		tiWt.enabled = true;
		tiDiamond_packet_no.enabled = false
	}
	else
	{
		tiPcs.enabled = false;
		tiWt.enabled = false;
		tiDiamond_packet_no.enabled = true
	}
}
