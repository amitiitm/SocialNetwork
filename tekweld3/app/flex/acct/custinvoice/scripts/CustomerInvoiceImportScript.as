import com.generic.events.ImportEvent;

import model.GenModelLocator;

import mx.controls.Alert;

import valueObjects.ImportVO;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
public var __importObj:ImportVO = __genModel.activeModelLocator.importObj;

private var resultXml:XML		=	new XML(<rows/>);

private var tableNames:Array	=	new Array({tablename:'customer_invoice'});

override protected function downloadCompleteEventHandler(event:ImportEvent):void
{	
	resultXml 	= 	XML(event.recordXml);
	//Alert.show(resultXml)
	dgCustomerInvoices.rows	=	resultXml
}

private function clickHandler():void
{
	var message:String	=	XML(dgCustomerInvoices.selectedItem).child('message').toString();
	
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
	var tempList:XMLList = dgCustomerInvoices.rows.children();
	
	var message:XMLList	=	new XMLList(<message/>);
	
	message	=	dgCustomerInvoices.rows.children().(child('message').toString()	!=	'')
	
	if(message.children().length() > 0)
	{
		Alert.show('one or many row has invalid data please correct it.');
		returnVal = 1;	
	}
	
		__importObj.tablenames = tableNames;
		__importObj.records = makeXmlForSave(dgCustomerInvoices.rows.copy());
	
	return returnVal;
}

private function makeXmlForSave(gridXml:XML):XML
{
	var saveXml:XML   = new XML(<customer_invoices/>);
	
	if(gridXml.children().length() > 1)
	{
		saveXml.multiple_invoices		= 'Y'
	} 
		 
	for (var i:int = 0; i < gridXml.children().length();i++)
	{
		var headerXml:XML = new XML(<customer_invoice/>);
		var linesXml:XML  = new XML(<customer_invoice_lines/>);
		
		headerXml.name				 = gridXml.children()[i]['name'].toString();
		headerXml.city 				 = gridXml.children()[i]['city'].toString();
		headerXml.state				 = gridXml.children()[i]['state'].toString();
		headerXml.phone1			 = gridXml.children()[i]['phone1'].toString();
		headerXml.zip				 = gridXml.children()[i]['zip'].toString();
		headerXml.trans_type		 = 'I';					
		headerXml.customer_id 		 = gridXml.children()[i]['customer_id'].toString();
		headerXml.customer_code 	 = gridXml.children()[i]['customer_code'].toString();
		headerXml.parent_id 		 = gridXml.children()[i]['billto_id'].toString();
		headerXml.parent_code 		 = gridXml.children()[i]['billto_code'].toString();
		headerXml.term_code 		 = gridXml.children()[i]['term_code'].toString();
		headerXml.description 		 = gridXml.children()[i]['description'].toString();
		headerXml.due_date 			 = gridXml.children()[i]['due_date'].toString();
		headerXml.inv_type	 		 = gridXml.children()[i]['invoice_type'].toString();
		headerXml.inv_amt	 		 = gridXml.children()[i]['inv_amt'].toString();
		headerXml.paid_amt 			 = '0.00';				
		headerXml.disctaken_amt		 = '0.00';				
		headerXml.balance_amt 		 = gridXml.children()[i]['inv_amt'].toString();
		headerXml.inv_no 			 = '';
		headerXml.inv_date	 		 = gridXml.children()[i]['trans_date'].toString();
		headerXml.salesperson_code	 = '';
		headerXml.sale_date 		 = gridXml.children()[i]['trans_date'].toString();
		headerXml.invoice_number 	 = gridXml.children()[i]['invoice_no'].toString();
		headerXml.trans_bk 			 = 'IN01'
		headerXml.trans_date 		 = gridXml.children()[i]['trans_date'].toString();
		headerXml.account_period_code	 = gridXml.children()[i]['account_period_code'].toString();
		headerXml.trans_flag		 = 'A'
		headerXml.action_flag		 = 'O'
		headerXml.post_flag			 = 'U'
		headerXml.discount_per		 = '0.00'
		headerXml.discount_amt		 = '0.00'
		headerXml.discount_date		 = '';
		headerXml.updated_by_code	 = __genModel.user.user_cd; 
		headerXml.created_by         = __genModel.user.userID;
		headerXml.updated_by		 = __genModel.user.userID;
		
		linesXml.customer_invoice_line.serial_no 			=  '101'
		linesXml.customer_invoice_line.gl_amt 				=  gridXml.children()[i]['inv_amt'].toString();
		linesXml.customer_invoice_line.customer_invoice_id 	=  ''
		linesXml.customer_invoice_line.gl_account_id 		=  gridXml.children()[i]['customer_invoice_line_gl_account_id'].toString();
		linesXml.customer_invoice_line.gl_account_code 		=  gridXml.children()[i]['customer_invoice_line_gl_code'].toString();
		linesXml.customer_invoice_line.gl_account_name 		=  gridXml.children()[i]['customer_invoice_line_gl_name'].toString();
		linesXml.customer_invoice_line.trans_no 			=  ''
		linesXml.customer_invoice_line.trans_flag 			=  'A';
		linesXml.customer_invoice_line.trans_bk				=  ''
		
		linesXml.customer_invoice_line.updated_by_code 		=  __genModel.user.user_cd;
		linesXml.customer_invoice_line.description 			=  ''
	//	linesXml.customer_invoice_line.gl_code				=  gridXml.children()[i]['customer_invoice_line_gl_code'].toString();
	//	linesXml.customer_invoice_line.gl_name				=  gridXml.children()[i]['customer_invoice_line_gl_name'].toString();
		
		headerXml.appendChild(linesXml);
		
		saveXml.appendChild(headerXml);
	}
	
	return saveXml;
}
