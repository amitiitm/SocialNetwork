import business.events.GetInformationEvent;
import com.generic.events.AddEditEvent;
import com.generic.events.GenUploadButtonEvent;
import com.generic.genclass.GenValidator;
import invn.itemtransfer.ItemTransferModelLocator;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

private var genValidator:GenValidator = new GenValidator();
private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:ItemTransferModelLocator = (ItemTransferModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var image_name:String;

public function init():void 
{
	numericFormatter.precision = 3;
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
	numericFormatter.precision = 2;
	tiItem_amt.text = numericFormatter.format(Number(tiQty.text) * Number(tiPrice.text));
}

private function itemAmountChangeHandler():void
{
	// on changing item amount we are calculating price and net amount
	
	numericFormatter.precision = 2;
	
	if(Number(tiQty.text) > 0)
	{
		tiPrice.text = numericFormatter.format(Number(tiItem_amt.text)/ Number(tiQty.text));
	}
	else
	{
		tiQty.text = tiQty.defaultValue;
		Alert.show('Item Qty cannot be 0');
	}
}

private function getItemDetails():void
{
	if(dcItemId.text != '' && dcItemId.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('iteminfo', callbacks, dcItemId.dataValue, __localModel.trans_date);
		getInformationEvent.dispatch(); 
	}
	else
	{
		tiPrice.text = tiPrice.defaultValue;
		cbItem_type.dataValue = cbItem_type.defaultValue;
		
		dcItemId.dataValue		=	dcItemId.defaultDataValue;
		dcItemId.labelValue		=	dcItemId.defaultLabelValue
		tiItemCode.dataValue	=	tiItemCode.defaultValue
		
		//tiItemDescription.text = tiItemDescription.defaultValue;
		//tiImage_thumnail.text = tiImage_thumnail.defaultValue;
		//tiTaxable.text = tiTaxable.defaultValue;
	}
}

public function getItemDetailsHandler(resultXml:XML):void
{
	var packet_require_yn:String;
	
	resetOtherValues();
	
	dcItemId.dataValue		=	resultXml.children()[0].catalog_item_id.toString();
	dcItemId.labelValue		=	resultXml.children()[0].store_code.toString();
	tiItemCode.dataValue	=	resultXml.children()[0].store_code.toString();
	
	tiPrice.text = resultXml.children()[0].price.toString();
	cbItem_type.dataValue = resultXml.children()[0].item_type.toString();
	//tiItemDescription.text = resultXml.children()[0].name.toString();
	//tiImage_thumnail.text = resultXml.children()[0].image_thumnail.toString();
	//tiTaxable.text = resultXml.children()[0].taxable.toString();
	packet_require_yn = resultXml.children()[0].packet_require_yn.toString();

	tiCatalog_item_packet_code.text = "";
	tiCatalog_item_packet_id.text = "";

	tiQty.dataValue = tiQty.defaultValue;
	tiQty.enabled = true;
		
	if(packet_require_yn=='N')
	{
		tiCatalog_item_packet_code.enabled = false;
	}
	else
	{
		tiCatalog_item_packet_code.enabled = true;
	}

	calculateNetAmount();
}

private function getPacketDetails():void
{
	if(tiCatalog_item_packet_code.text != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('packetinfo', callbacks, tiCatalog_item_packet_code.dataValue, __localModel.trans_date, 'Y');
		getInformationEvent.dispatch();
	}
	else
	{
		tiCatalog_item_packet_id.dataValue = ""
	}
}

public function getPacketDetailsHandler(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		resetOtherValues();

		tiCatalog_item_packet_id.dataValue = resultXml.children()[0].catalog_item_packet_id.toString();
		tiCatalog_item_packet_code.dataValue = resultXml.children()[0].catalog_item_packet_code.toString();
	
		dcItemId.dataValue = resultXml.children()[0].catalog_item_id.toString();
		tiPrice.text = resultXml.children()[0].price.toString();
		cbItem_type.dataValue = resultXml.children()[0].item_type.toString();
		//tiItemDescription.text = resultXml.children()[0].name.toString();
		//tiImage_thumnail.text = resultXml.children()[0].image_thumnail.toString();
		//tiTaxable.text = resultXml.children()[0].taxable.toString();
		
		tiQty.dataValue = "1";
		tiQty.enabled = false;
		
	}
	else
	{
		tiCatalog_item_packet_id.dataValue = tiCatalog_item_packet_id.defaultValue;
		tiCatalog_item_packet_code.dataValue = tiCatalog_item_packet_code.defaultValue;

		dcItemId.dataValue = dcItemId.defaultValue;
		tiPrice.text = tiPrice.defaultValue;
		cbItem_type.dataValue = cbItem_type.defaultValue;
		//tiItemDescription.text = tiItemDescription.defaultValue;
		//tiImage_thumnail.text = tiImage_thumnail.defaultValue;
		//tiTaxable.text = tiTaxable.defaultValue;

		tiQty.dataValue = tiQty.defaultValue;
		tiQty.enabled = true;
	}
	calculateNetAmount();
}

private function resetOtherValues():void
{
	tiItem_amt.text = tiItem_amt.defaultValue;
	tiQty.text = tiQty.defaultValue;	
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
			_item_qty = _item_qty + (Number)(dtlLine.dgDtl.dataProvider[i].rec_qty);
		}

		lblTotal_items.text = dtlLine.dgDtl.dataProvider.length.toString()
		lblItem_qty.text = _item_qty.toString()
	}
	else
	{
		lblTotal_items.text = '0'
		lblItem_qty.text = '0'
	}
	
	tiRecItem_amt.text = String(_grossAmount);
}

private function changeImage():void
{
	if(dtlLine.dgDtl.selectedRow != null)
	{
		image_name = dtlLine.dgDtl.selectedRow["image_thumnail"]
	}
	else
	{
		image_name = null
	}
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	if(Number(tiItem_amt.text)== Number(tiRecItem_amt.text) && Number(tiQty.text)== Number(lblItem_qty.text))
	{
		if(dtlIssueLine.dgDtl.rows.children().length() > 0)
		{
			dtlIssueLine.dgDtl.rows.children()[0].catalog_item_id				=	dcItemId.dataValue
			dtlIssueLine.dgDtl.rows.children()[0].catalog_item_code				=	tiItemCode.text;
			
			dtlIssueLine.dgDtl.rows.children()[0].catalog_item_packet_code		=	tiCatalog_item_packet_code.text;
			dtlIssueLine.dgDtl.rows.children()[0].catalog_item_packet_id		=	tiCatalog_item_packet_id.text;
			dtlIssueLine.dgDtl.rows.children()[0].iss_qty						= 	tiQty.text
			dtlIssueLine.dgDtl.rows.children()[0].iss_price						=	tiPrice.text
			dtlIssueLine.dgDtl.rows.children()[0].iss_amt						=	tiItem_amt.text
			dtlIssueLine.dgDtl.rows.children()[0].receipt_issue_flag			=	'I'
			dtlIssueLine.dgDtl.rows.children()[0].item_type						=	cbItem_type.dataValue
		}
		else
		{
			dtlIssueLine.dgDtl.rows.appendChild(new XML(<inventory_transaction_issue_line>
															<id/>
															<catalog_item_id>{dcItemId.dataValue}</catalog_item_id>
															<catalog_item_code>{tiItemCode.text}</catalog_item_code>
															<catalog_item_packet_id>{tiCatalog_item_packet_id.text}</catalog_item_packet_id>
															<catalog_item_packet_code>{tiCatalog_item_packet_code.text}</catalog_item_packet_code>
															<iss_qty>{tiQty.text}</iss_qty>
															<iss_price>{tiPrice.text}</iss_price>
															<iss_amt>{tiItem_amt.text}</iss_amt>
															<receipt_issue_flag>I</receipt_issue_flag>
															<item_type>{cbItem_type.dataValue}</item_type>
														</inventory_transaction_issue_line>))
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
	
	dcItemId.dataValue					=	issueDetailXml.children()[0].child('catalog_item_id');
	dcItemId.labelValue					=	issueDetailXml.children()[0].child('catalog_item_code');
	tiItemCode.dataValue				=	issueDetailXml.children()[0].child('catalog_item_code');
	tiCatalog_item_packet_code.text		=	issueDetailXml.children()[0].child('catalog_item_packet_code');
	tiQty.text							=	issueDetailXml.children()[0].child('iss_qty');
	tiPrice.text						=	issueDetailXml.children()[0].child('iss_price');
	tiItem_amt.text						=	issueDetailXml.children()[0].child('iss_amt');
	tiRecIssFlag.text					=	issueDetailXml.children()[0].child('receipt_issue_flag');
	cbItem_type.dataValue				=	issueDetailXml.children()[0].child('item_type');
	
	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		dtlLine.dgDtl.selectedIndex = 0
	}
	
	changeImage();
	
	setGrossAmount();
	
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	getAccountPeriod();
	tiCatalog_item_packet_code.enabled = true;
	tiQty.enabled = true;
	__localModel.trans_date = dfTrans_date.text;
	changeImage();
	
	lblTotal_items.text = "";
	lblItem_qty.text = "";
}