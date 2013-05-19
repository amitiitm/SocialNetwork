import com.generic.events.ImportEvent;

import model.GenModelLocator;

import mx.controls.Alert;

import valueObjects.ImportVO;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
public var __importObj:ImportVO = __genModel.activeModelLocator.importObj;

private var resultXml:XML		=	new XML(<rows/>);

private var tableNames:Array	=	new Array({tablename:'vendor_invoice'});

override protected function downloadCompleteEventHandler(event:ImportEvent):void
{	
	resultXml 	= 	XML(event.recordXml);
	Alert.show(resultXml.toString())
	dgVendorInvoices.rows	=	resultXml
}

private function clickHandler():void
{
	var message:String	=	XML(dgVendorInvoices.selectedItem).child('message').toString();
	
	var arr:Array;
				
	if(message != '')
	{
		arr	=	message.split('\\n')
		
		message	=	'';
		for(var i:uint = 0; i < arr.length ; i++) 
		{
			message += arr[i] + "\n";
		}
		Alert.show(message);
	}  	
}

override protected function preSaveEventHandler(event:ImportEvent):int
{
	var returnVal:int = 0;
	var str:String;
	var tempList:XMLList = dgVendorInvoices.rows.children();
	
	var message:XMLList	=	new XMLList(<message/>);
	
	message	=	dgVendorInvoices.rows.children().(child('message').toString()	!=	'')
	
	if(message.children().length() > 0)
	{
		Alert.show('one or many row has invalid data please correct it.');
		returnVal = 1;	
	}
	
		__importObj.tablenames = tableNames;
		__importObj.records = makeXmlForSave(dgVendorInvoices.rows.copy());
	
	return returnVal;
}

private function makeXmlForSave(gridXml:XML):XML
{
	var saveXml:XML 	= new XML(<vendor_invoices/>);
	
	if(gridXml.children().length() > 1)
	{
		saveXml.multiple_invoices		= 'Y'
	}
	
	for(var i:int = 0 ; i < gridXml.children().length() ; i++)
	{
		var headerXml:XML = new XML(<vendor_invoice/>);
		var linesXml:XML  = new XML(<vendor_invoice_lines/>);
		
		headerXml.vendor_id				= gridXml.children()[i]['vendor_id'].toString();
		headerXml.vendor_code			= gridXml.children()[i]['vendor_code'].toString();
		headerXml.term_code				= gridXml.children()[i]['term_code'].toString();
		headerXml.due_date				= gridXml.children()[i]['due_date'].toString();
		headerXml.description			= gridXml.children()[i]['description'].toString();
		headerXml.inv_type				= gridXml.children()[i]['inv_type'].toString();
		headerXml.inv_amt				= gridXml.children()[i]['inv_amt'].toString();
		headerXml.paid_amt				= '0.00';
		headerXml.disctaken_amt			= '0.00';
		headerXml.balance_amt			= gridXml.children()[i]['inv_amt'].toString();
		headerXml.inv_no				= '';					//gridXml.children()[i][''].toString();
		headerXml.inv_date				= gridXml.children()[i]['trans_date'].toString();
		headerXml.ref_trans_bk			= '';					//gridXml.children()[i][''].toString();
		headerXml.ref_trans_no			= '';					//gridXml.children()[i][''].toString();
		headerXml.ref_trans_date		= '';					//gridXml.children()[i][''].toString();
		headerXml.item_qty				= '';					//gridXml.children()[i][''].toString();
		headerXml.purchaseperson_code	= gridXml.children()[i]['purchaseperson_code'].toString();
		headerXml.invoice_number		= gridXml.children()[i]['invoice_no'].toString();
		headerXml.trans_bk				= 'IN02'
		headerXml.trans_date			= gridXml.children()[i]['trans_date'].toString();
		headerXml.account_period_code	= gridXml.children()[i]['account_period_code'].toString();
		headerXml.trans_flag			= 'A';
		headerXml.action_flag			= 'O';
		headerXml.post_flag				= 'U';
		headerXml.discount_date			= '';
		headerXml.discount_per			= '0.00'
		headerXml.discount_amt			= '0.00'
		headerXml.updated_by_code		= __genModel.user.user_cd;
		headerXml.created_by			= __genModel.user.userID;
		headerXml.updated_by			= __genModel.user.userID;
		
		linesXml.vendor_invoice_line.serial_no					=  '101'
		linesXml.vendor_invoice_line.trans_flag					=  'A'
		linesXml.vendor_invoice_line.gl_amt						=  gridXml.children()[i]['inv_amt'].toString();
		linesXml.vendor_invoice_line.trans_no					=  ''
		linesXml.vendor_invoice_line.trans_bk					=  ''
		linesXml.vendor_invoice_line.updated_by_code			=  __genModel.user.user_cd;
		linesXml.vendor_invoice_line.description				=  ''
		linesXml.vendor_invoice_line.gl_account_id				=  gridXml.children()[i]['vendor_invoice_line_gl_account_id'].toString();
		linesXml.vendor_invoice_line.gl_account_code			=  gridXml.children()[i]['vendor_invoice_line_gl_code'].toString();
		linesXml.vendor_invoice_line.gl_account_name			=  gridXml.children()[i]['vendor_invoice_line_gl_name'].toString();
		linesXml.vendor_invoice_line.vendor_invoice_id			=  ''
		linesXml.vendor_invoice_line.trans_date					=  gridXml.children()[i]['trans_date'].toString();
		//linesXml.vendor_invoice_line.gl_code					=  gridXml.children()[i]['vendor_invoice_line_gl_code'].toString();
		//linesXml.vendor_invoice_line.gl_name					=  gridXml.children()[i]['vendor_invoice_line_gl_name'].toString();
		
		headerXml.appendChild(linesXml);
		
		saveXml.appendChild(headerXml);
	}
	
	return saveXml;
}
