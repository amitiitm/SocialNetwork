import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;
import com.generic.events.GenUploadButtonEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.GenValidator;

import dinvn.certificateassignment.CertificateAssignmentModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.rpc.IResponder;
private var genValidator:GenValidator = new GenValidator();
private var numericFormatter:GenNumberFormatter = new GenNumberFormatter();
private var numericFormatterWt:GenNumberFormatter = new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function init():void 
{
	numericFormatterWt.precision = 3;
	numericFormatterWt.rounding = "nearest";

	numericFormatter.precision = 2;
	numericFormatter.rounding =	"nearest";
		
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
private function handleImportEvent(event:GenUploadButtonEvent):void
{
	tiXlsFile.text = event.fileName;
}
private function handleDownloadCompleteEvent(event:GenUploadButtonEvent):void
{
	if(dcDiamond_lot_id.text == '')
	{
		Alert.show('please select Lot# before Importing');
		return;
	}
	
	if(event.downloadedObj != null &&  XML(event.downloadedObj).children().length() > 0)
	{
		dtlLine.rows	=	XML(event.downloadedObj);
		
		for(var i:int = 0 ; i < dtlLine.rows.children().length(); i++)
		{
			dtlLine.rows.children()[i].rec_pcs					=	'1';
			dtlLine.rows.children()[i].rec_wt					=	'1';
			
			if(dtlLine.rows.children()[i].sell_unit.toLowerCase()	== "wt" || dtlLine.rows.children()[i].sell_unit.toLowerCase()	== "c")
			{
				dtlLine.rows.children()[i].rec_amt = numericFormatter.format(Number(dtlLine.rows.children()[i].rec_wt) *  Number(dtlLine.rows.children()[i].rec_price))
			}
			else if(dtlLine.rows.children()[i].sell_unit.toLowerCase()	== "pcs" || dtlLine.rows.children()[i].sell_unit.toLowerCase()	== "e")
			{
				dtlLine.rows.children()[i].rec_amt = numericFormatter.format(Number(dtlLine.rows.children()[i].rec_pcs) *  Number(dtlLine.rows.children()[i].rec_price))
			}
			
			
			
			dtlLine.rows.children()[i].trans_flag				=	'A'
			dtlLine.rows.children()[i].ri_flag					=	'R'
			
			dtlLine.rows.children()[i].diamond_lot_no			= 	dcDiamond_lot_id.text
			dtlLine.rows.children()[i].diamond_lot_id			= 	dcDiamond_lot_id.dataValue
			
			/* dtlLine.rows.children()[i].stone_type				=	cbStone_type.dataValue
			dtlLine.rows.children()[i].shape					=	cbShape.dataValue
			dtlLine.rows.children()[i].color					=	cbColor.dataValue
			dtlLine.rows.children()[i].clarity					=	cbClarity.dataValue
			dtlLine.rows.children()[i].location_code			=	dcLocation_code.dataValue
			dtlLine.rows.children()[i].sell_unit				=	cbSell_unit.dataValue */
		}
		setGrossAmount();
	}
}	

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	=	resultXml.child('code');
}
private function calculateNetAmount():void
{
	if(cbSell_unit.dataValue.toLowerCase()	== "wt" || cbSell_unit.dataValue.toLowerCase()	== "c")
	{
		tiItem_amt.text = numericFormatter.format(Number(tiWt.text) * Number(tiPrice.text));
	}
	else if(cbSell_unit.dataValue.toLowerCase()	== "pcs" || cbSell_unit.dataValue.toLowerCase()	== "e")
	{
		tiItem_amt.text = numericFormatter.format(Number(tiPcs.text) * Number(tiPrice.text));
	}
}
private function itemAmountChangeHandler():void
{
	// on changing item amount we are calculating price and net amount
	if(cbSell_unit.dataValue.toLowerCase() == "wt" || cbSell_unit.dataValue.toLowerCase() == "c")
	{
		if(Number(tiWt.text) > 0)
		{
			tiPrice.text = numericFormatter.format(Number(tiItem_amt.text)/ Number(tiWt.text));
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
			tiPrice.text = numericFormatter.format(Number(tiItem_amt.text)/ Number(tiPrice.text));
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
		tiDiamond_lot_no.dataValue 			= tiDiamond_lot_no.defaultValue;
		tiPrice.text 				= tiPrice.defaultValue;
		dcLocation_code.dataValue 	= dcLocation_code.defaultValue;
		cbClarity.dataValue			= cbClarity.defaultValue;
		cbColor.dataValue 			= cbColor.defaultValue;
		cbQuality.dataValue 		= cbQuality.defaultValue;
	 	cbSell_unit.dataValue 		= cbSell_unit.defaultValue; 	
		cbShape.dataValue 			= cbShape.defaultValue;
		cbStone_type.dataValue 		= cbStone_type.defaultValue;
	}
}
public function getLotsDetailsHandler(resultXml:XML):void
{
	resetOtherValues();
	
	tiDiamond_lot_no.dataValue = resultXml.children()[0].lot_number.toString();
	tiPrice.dataValue = resultXml.children()[0].price_per_ct.toString();
	dcLocation_code.dataValue = resultXml.children()[0].location.toString();
	cbClarity.dataValue = resultXml.children()[0].clarity.toString();
	cbColor.dataValue = resultXml.children()[0].color.toString();
	cbQuality.dataValue = resultXml.children()[0].quality.toString();
	cbShape.dataValue = resultXml.children()[0].shape.toString();
	cbStone_type.dataValue = resultXml.children()[0].stone_type.toString();
	cbSell_unit.dataValue = resultXml.children()[0].cost_unit.toString();
	
	calculateNetAmount()

}

private function resetOtherValues():void
{
	// we can call resetObjects method also but it will reset id also in the case of updation, which should not happened.
	
	tiItem_amt.dataValue = tiItem_amt.defaultValue;
	tiPcs.dataValue = tiPcs.defaultValue;
	tiWt.dataValue = tiWt.defaultValue;
}

private function setGrossAmount():void
{
	var _grossAmount:Number = 0;
	var _item_qty:Number = 0;
	
	numericFormatter.precision = 2;
	
	if(dtlLine.dataProvider != null)
	{
		for(var i:int = 0; i < dtlLine.dataProvider.length; i++)
		{
			_grossAmount = _grossAmount + (Number)(dtlLine.dataProvider[i].rec_amt);
			
			if(String(dtlLine.dataProvider[i].sell_unit).toLowerCase() == 'wt' || String(dtlLine.dataProvider[i].sell_unit).toLowerCase() == 'c')
			{
				_item_qty = _item_qty + (Number)(dtlLine.dataProvider[i].rec_wt);	
			}
			else if(String(dtlLine.dataProvider[i].sell_unit).toLowerCase() == 'pcs' || String(dtlLine.dataProvider[i].sell_unit).toLowerCase() == 'e')
			{
				_item_qty = _item_qty + (Number)(dtlLine.dataProvider[i].rec_pcs);	
			}
		}

		lblTotal_items.text = dtlLine.dataProvider.length.toString()
		lblItem_qty.text = _item_qty.toString()
	}
	else
	{
		lblTotal_items.text = '0'
		lblItem_qty.text = '0'
	}
	
	tiRecItem_amt.text 	=	String(_grossAmount);
}
private function handleSampleXLS():void
{
	var file_name:String = 'sample_item_upload_format.xls';
	var folderName:String = '/sampleformats/';
	var url:String = folderName + file_name;
	var request:URLRequest = new URLRequest(url);

    navigateToURL(request);
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
	
	if(Number(tiItem_amt.text)== Number(tiRecItem_amt.text) && Number(issue_qty)== Number(lblItem_qty.text))
	{
		if(dtlIssueLine.dgDtl.rows.children().length() > 0)
		{
			dtlIssueLine.dgDtl.rows.children()[0].diamond_lot_id				=	dcDiamond_lot_id.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].diamond_lot_no				=	tiDiamond_lot_no.text;
			dtlIssueLine.dgDtl.rows.children()[0].iss_wt						= 	tiWt.text
			dtlIssueLine.dgDtl.rows.children()[0].iss_pcs						= 	tiPcs.text
			dtlIssueLine.dgDtl.rows.children()[0].iss_price						=	tiPrice.text
			dtlIssueLine.dgDtl.rows.children()[0].iss_amt						=	tiItem_amt.text
			dtlIssueLine.dgDtl.rows.children()[0].ri_flag						=	'I'
			
			dtlIssueLine.dgDtl.rows.children()[0].stone_type					=	cbStone_type.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].shape							=	cbShape.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].color							=	cbColor.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].clarity						=	cbClarity.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].location_code					=	dcLocation_code.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].sell_unit						=	cbSell_unit.dataValue
		}
		else
		{
			dtlIssueLine.dgDtl.rows.appendChild(new XML(<diamond_inventory_issue_line>
															<id/>
															<diamond_lot_id>{dcDiamond_lot_id.dataValue}</diamond_lot_id>
															<diamond_lot_no>{tiDiamond_lot_no.text}</diamond_lot_no>
															<iss_wt>{tiWt.text}</iss_wt>
															<iss_pcs>{tiPcs.text}</iss_pcs>
															<iss_price>{tiPrice.text}</iss_price>
															<iss_amt>{tiItem_amt.text}</iss_amt>
															<ri_flag>I</ri_flag>
															
															<stone_type>{cbStone_type.dataValue}</stone_type>
															<shape>{cbShape.dataValue}</shape>
															<color>{cbColor.dataValue}</color>
															<clarity>{cbClarity.dataValue}</clarity>
															<location_code>{dcLocation_code.dataValue}</location_code>
															<sell_unit>{cbSell_unit.dataValue}</sell_unit>
															
														</diamond_inventory_issue_line>))
		}
		return 0;
	}
	else
	{
		Alert.show('Issued Qty/Amount should match with Received Qty/Amount.');
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
	tiWt.text							=	issueDetailXml.children()[0].child('iss_wt');
	tiPcs.text							=	issueDetailXml.children()[0].child('iss_pcs');	
	tiPrice.text						=	issueDetailXml.children()[0].child('iss_price');
	tiItem_amt.text						=	issueDetailXml.children()[0].child('iss_amt');
	
	cbStone_type.dataValue				=	issueDetailXml.children()[0].child('stone_type');
	cbShape.dataValue					=	issueDetailXml.children()[0].child('shape');
	cbColor.dataValue					=	issueDetailXml.children()[0].child('color');
	cbClarity.dataValue					=	issueDetailXml.children()[0].child('clarity');
	dcLocation_code.dataValue			=	issueDetailXml.children()[0].child('location_code');
	cbSell_unit.dataValue				=	issueDetailXml.children()[0].child('sell_unit');
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	getAccountPeriod();
}