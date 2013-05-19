import business.events.GetInformationEvent;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenValidator;
import dinvn.lottransfer.LotTransferModelLocator;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

private var genValidator:GenValidator = new GenValidator();
private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var __localModel:LotTransferModelLocator = (LotTransferModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var image_name:String;

public function init():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	__localModel.trans_date = dfTrans_date.text	
	getAccountPeriod();
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	= resultXml.child('code');
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
//		tiDiamond_lot_no.dataValue = tiDiamond_lot_no.defaultValue;
		tiPrice.text = tiPrice.defaultValue;
		dcLocation_code.dataValue = dcLocation_code.defaultValue;
		cbClarity.dataValue = cbClarity.defaultValue;
		cbColor.dataValue = cbColor.defaultValue;
		cbQuality.dataValue = cbQuality.defaultValue;
	 	cbSell_unit.dataValue = cbSell_unit.defaultValue; 	
		cbShape.dataValue = cbShape.defaultValue;
		cbStone_type.dataValue = cbStone_type.defaultValue;
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

	tiPcs.enabled = true;
	tiPcs.dataValue = tiPcs.defaultValue;
	
	tiWt.enabled = true;
	tiWt.dataValue = tiWt.defaultValue;
		
	if(diamond_cert_flag=='N')
	{
		tiDiamond_packet_no.enabled = false;
	}
	else
	{
		tiDiamond_packet_no.enabled = true;
	}	

	tiDiamond_cert_flag.dataValue = diamond_cert_flag;

	calculateNetAmount()
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

private function setGrossAmount():void
{
	var _grossAmount:Number = 0;
	var _item_qty:Number = 0;
	
	numericFormatter.precision = 2;
	
	if(dtlLine.dgDtl.dataProvider != null)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			_grossAmount = _grossAmount + (Number)(dtlLine.dgDtl.dataProvider[i].rec_amt);
			
			if(String(dtlLine.dgDtl.dataProvider[i].sell_unit).toLowerCase() == 'wt' || String(dtlLine.dgDtl.dataProvider[i].sell_unit).toLowerCase() == 'c')
			{
				_item_qty = _item_qty + (Number)(dtlLine.dgDtl.dataProvider[i].rec_wt);	
			}
			else if(String(dtlLine.dgDtl.dataProvider[i].sell_unit).toLowerCase() == 'pcs' || String(dtlLine.dgDtl.dataProvider[i].sell_unit).toLowerCase() == 'e')
			{
				_item_qty = _item_qty + (Number)(dtlLine.dgDtl.dataProvider[i].rec_pcs);	
			}
		}

		lblTotal_items.text = dtlLine.dgDtl.dataProvider.length.toString()
		lblItem_qty.text = _item_qty.toString()
	}
	else
	{
		lblTotal_items.text = '0'
		lblItem_qty.text = '0'
	}
	
	tiRecItem_amt.text 	=	String(_grossAmount);
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var issue_qty:Number;
	if(cbSell_unit.dataValue.toLowerCase()	== "wt" || cbSell_unit.dataValue.toLowerCase()	== "c")
	{
		issue_qty	=	Number(tiWt.text)
	}
	else if(cbSell_unit.dataValue.toLowerCase() == "pcs" || cbSell_unit.dataValue.toLowerCase() == "e")
	{
		issue_qty	=	Number(tiPcs.text)
	}
	if(Number(tiLine_amt.text)== Number(tiRecItem_amt.text) && Number(issue_qty)== Number(lblItem_qty.text))
	{
		if(dtlIssueLine.dgDtl.rows.children().length() > 0)
		{
			dtlIssueLine.dgDtl.rows.children()[0].diamond_lot_id				=	dcDiamond_lot_id.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].diamond_lot_no				=	tiDiamond_lot_no.text;
			
			dtlIssueLine.dgDtl.rows.children()[0].diamond_packet_no				=	tiDiamond_packet_no.text;
			dtlIssueLine.dgDtl.rows.children()[0].diamond_packet_id				=	tiDiamond_packet_id.text;
			dtlIssueLine.dgDtl.rows.children()[0].iss_wt						= 	tiWt.text
			dtlIssueLine.dgDtl.rows.children()[0].iss_pcs						= 	tiPcs.text
			dtlIssueLine.dgDtl.rows.children()[0].iss_price						=	tiPrice.text
			dtlIssueLine.dgDtl.rows.children()[0].iss_amt						=	tiLine_amt.text
			dtlIssueLine.dgDtl.rows.children()[0].ri_flag						=	'I'
			
			dtlIssueLine.dgDtl.rows.children()[0].stone_type					=	cbStone_type.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].shape							=	cbShape.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].color							=	cbColor.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].clarity						=	cbClarity.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].location_code					=	dcLocation_code.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].sell_unit						=	cbSell_unit.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].quality						=	cbQuality.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].size							=	tiSize.text
			
		}
		else
		{
			dtlIssueLine.dgDtl.rows.appendChild(new XML(<diamond_inventory_issue_line>
															<id/>
															<diamond_lot_id>{dcDiamond_lot_id.dataValue}</diamond_lot_id>
															<diamond_lot_no>{tiDiamond_lot_no.text}</diamond_lot_no>
															<diamond_packet_id>{tiDiamond_packet_id.text}</diamond_packet_id>
															<diamond_packet_no>{tiDiamond_packet_no.text}</diamond_packet_no>
															<iss_wt>{tiWt.text}</iss_wt>
															<iss_pcs>{tiPcs.text}</iss_pcs>
															<iss_price>{tiPrice.text}</iss_price>
															<iss_amt>{tiLine_amt.text}</iss_amt>
															<ri_flag>I</ri_flag>
															
															<stone_type>{cbStone_type.dataValue}</stone_type>
															<shape>{cbShape.dataValue}</shape>
															<color>{cbColor.dataValue}</color>
															<clarity>{cbClarity.dataValue}</clarity>
															<location_code>{dcLocation_code.dataValue}</location_code>
															<sell_unit>{cbSell_unit.dataValue}</sell_unit>
															<quality>{cbQuality.dataValue}</quality>
															<size>{tiSize.text}</size>
															
														</diamond_inventory_issue_line>))
		}
		return 0;
	}
	else
	{
		Alert.show('Issue Net amount/Qty is not equal to Receipt Net Amt/Qty ');
		return 1;
	}
	return 0;
	//total sum of detail must equal to the header and qty as well
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	
	var issueDetailXml:XML				=	XML(event.recordXml.children()[0][dtlIssueLine.rootNode]);
	
	dcDiamond_lot_id.dataValue			=	issueDetailXml.children()[0].child('diamond_lot_id');
	tiDiamond_lot_no.text				=	issueDetailXml.children()[0].child('diamond_lot_no');
	tiDiamond_packet_id.text			=	issueDetailXml.children()[0].child('diamond_packet_id');
	tiDiamond_packet_no.text			=	issueDetailXml.children()[0].child('diamond_packet_no');
	
	tiWt.text							=	issueDetailXml.children()[0].child('iss_wt');
	tiPcs.text							=	issueDetailXml.children()[0].child('iss_pcs');
	
	tiPrice.text						=	issueDetailXml.children()[0].child('iss_price');
	tiLine_amt.text						=	issueDetailXml.children()[0].child('iss_amt');
	tiRecIssFlag.text					=	issueDetailXml.children()[0].child('ri_flag');
	
	cbStone_type.dataValue				=	issueDetailXml.children()[0].child('stone_type');
	cbShape.dataValue					=	issueDetailXml.children()[0].child('shape');
	cbColor.dataValue					=	issueDetailXml.children()[0].child('color');
	cbClarity.dataValue					=	issueDetailXml.children()[0].child('clarity');
	dcLocation_code.dataValue				=	issueDetailXml.children()[0].child('location_code');
	cbSell_unit.dataValue				=	issueDetailXml.children()[0].child('sell_unit');
	cbQuality.dataValue					=	issueDetailXml.children()[0].child('quality');
	tiSize.dataValue					=	issueDetailXml.children()[0].child('size');
	
	setGrossAmount();
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	getAccountPeriod();
	tiDiamond_packet_no.enabled = true;
	tiWt.enabled	=	true;
	tiPcs.enabled	=	true;
	
	__localModel.trans_date = dfTrans_date.text;
	
	setGrossAmount();
}