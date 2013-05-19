// ActionScript file
import business.events.GetGenDataGridFormatEvent;
import business.events.GetRecordEvent;

import model.GenModelLocator;
import mx.controls.Alert;
import mx.core.Application;
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Bindable]
private var isPaymentComplete:Boolean	=	false;
private var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
[Bindable]
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
private var totalPayment:Number = 0.00
private var totalReturn:Number = 0.00
private var totalAmtToTake:Number = 0.00
private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getRecordEvent:GetRecordEvent


private function creationCompleteHandler():void
{
	
	
	getGenDataGridFormatEvent =	new GetGenDataGridFormatEvent(dgHeldList);
	getGenDataGridFormatEvent.dispatch();
	
	getGenDataGridFormatEvent =	new GetGenDataGridFormatEvent(dgHeldItemDetail);
	getGenDataGridFormatEvent.dispatch();
	
	numericFormatter.precision = 2;
	numericFormatter.rounding	=	"nearest";
	numericFormatter.useThousandsSeparator	=	false;
	
	getHeldList();
	
}
private function closeHandler():void
{
	PopUpManager.removePopUp(this)
}
private function unholdReceiptClickHandler():void
{
	if(dgHeldList.selectedIndex >= 0)
	{
		getRecordEvent	=	new GetRecordEvent(int(dgHeldList.selectedRow.id.toString()));
		getRecordEvent.dispatch();
	}
	closeHandler();
}
private function getHeldList():void
{
	
		 var xml:XML = new XML(	<criteria>
									
								</criteria>); 

		var service:HTTPService = GenModelLocator.getInstance().services.getHTTPService("getHeldList");
	
		setDataService(service);
	
		service.addEventListener(ResultEvent.RESULT, getHeldListResultHandler)													
		service.addEventListener(FaultEvent.FAULT, faultHandler)
	
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		
	
		service.send(xml);
			
	
}
private function getHeldListResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	dgHeldList.rows	=	XML(event.result)
}
private function getRecord():void
{
		var params:XML = new XML(<params><id>{dgHeldList.selectedRow.id.toString()}</id></params>)
			
		var service:HTTPService = GenModelLocator.getInstance().services.getHTTPService("getRecord");
	
		setDataService(service);
	
		service.addEventListener(ResultEvent.RESULT, getRecordResultHandler)													
		service.addEventListener(FaultEvent.FAULT, faultHandler)

		service.send(params);		
	
}
private function getRecordResultHandler(event:ResultEvent):void
{
	resetValues() //it  is required otherwise payment will have some previous value
	
	var record:XML	=	XML(event.result);
	
	setBilliingAddress(record);
	setPayment(XML(record.children()[0]['pos_invoice_payments']))		
	setOtherFields(record)
	setItems(record)

}
private function resetValues():void
{
	isPaymentComplete		=	false;	
	
	tiCashPayment.text		=	'0.00'
	tiCashReturn.text		=	'0.00'
   
   	tiCheckPayment.text		=	'0.00'
	tiCheckReturn.text		=	'0.00'
	tiCheckNo.text			=	'0.00'
	
	tiAccountPayment.text	=	'0.00'
	tiAccountRefund.text	=	'0.00'	
	
	tiCreditPayment.text	=	'0.00'	
	tiCreditRefund.text		=	'0.00'
	tiCreditCardNo.text		=	'0.00'
	cbCreditCard.dataValue	=	''
	
	tiNet_amt.text			=	'0.00'
	tiDueAmt.text			=	'0.00'
	tiChangeDue.text		=	'0.00'
	
		
}
private function setItems(record:XML):void
{
	dgHeldItemDetail.rows	=	XML(record.children()[0]['pos_invoice_lines'])	
}
private function setBilliingAddress(customerXml:XML):void
{
	tiBill_nm.text = customerXml.children().child('bill_name').toString();
	tiBill_address1.text = customerXml.children().child('bill_address1').toString();
	tiBill_address2.text = customerXml.children().child('bill_address2').toString();
	tiBill_city.text = customerXml.children().child('bill_city').toString();
	//tiBill_fax1.text = customerXml.children().child('bill_fax').toString();
	//tiBill_phone1.text = customerXml.children().child('bill_phone').toString();
	tiBill_state.text = customerXml.children().child('bill_state').toString();
	//tiBill_zip.text = customerXml.children().child('bill_zip').toString();	
	tiBill_country.text = customerXml.children().child('bill_country').toString();

}
private function setOtherFields(record:XML):void
{
	totalPayment	=	0;
	totalReturn		=	0;
	totalAmtToTake	=	0;
	
	dfTransDate.text			=	record.children()[0].child('trans_date').toString();
	dcCashier.dataValue			=	record.children()[0].child('cashier_id').toString();
	//tiWorkstationNo.text
	tiReceiptType.text			=	'Sales'
	
	if(XML(record.children()[0]['pos_invoice_payments']).children().length() == 0)
	{
		tiPaymentType.text			=	'None'	
	}
	else if(XML(record.children()[0]['pos_invoice_payments']).children().length() == 1)
	{
		tiPaymentType.text			=		XML(record.children()[0]['pos_invoice_payments']).children()[0].payment_method.toString()
	}
	else
	{
		tiPaymentType.text			=		'Split'
	}	
	
	tiNoOfItems.text				=		String(XML(record.children()[0]['pos_invoice_lines']).children().length())
	
	var totalSoldQty:Number	=	0;
	for(var i:int=0 ; i< XML(record.children()[0]['pos_invoice_lines']).children().length() ; i++)
	{
		totalSoldQty	=	totalSoldQty	+	Number(XML(record.children()[0]['pos_invoice_lines']).children()[i].item_qty)
	}
	tiTotalSoldQty.text	=	String(totalSoldQty);
		

	for(var i:int=0 ; i< XML(record.children()[0]['pos_invoice_payments']).children().length() ; i++)
	{
		totalPayment	=	totalPayment	+	Number(XML(record.children()[0]['pos_invoice_payments']).children()[i].payment_amt)
		totalReturn		=	totalReturn		+	Number(XML(record.children()[0]['pos_invoice_payments']).children()[i].return_amt)
	}	
	
	tiTotalPayment.text	=	numericFormatter.format(totalPayment.toString())
	tiTotalRefund.text	=	numericFormatter.format(totalReturn.toString())

	
	tiNet_amt.text		=	record.children()[0].child('net_amt').toString();

	totalAmtToTake		=	Number(tiNet_amt.text)
	
	if((totalPayment - totalReturn) == totalAmtToTake)  // it means payment complete
	{
		//Alert.show('complete');
		isPaymentComplete	=	true;
		tiDueAmt.text		=	'0.00'
		tiChangeDue.text	=	'0.00'
		
	}
	else if((totalAmtToTake + totalReturn) > totalPayment ) //it means payment is due
	{
		//Alert.show('payment due');
		isPaymentComplete		=	false;
		tiDueAmt.text			= 	numericFormatter.format((String((totalAmtToTake + totalReturn) - totalPayment)))	
		tiChangeDue.text		=	'0.00'
	}
	else if((totalAmtToTake + totalReturn) < totalPayment ) //it means change is due
	{
		//Alert.show('change due');
		isPaymentComplete		=	false;
		tiChangeDue.text		=	numericFormatter.format((String(totalPayment - (totalAmtToTake + totalReturn))))
		tiDueAmt.text			=	'0.00'
	}
	else
	{
		Alert.show('something is going wrong');
	}	
}
private function setPayment(paymentXml:XML):void
{
	
	for(var i:int=0; i < paymentXml.children().length() ; i++)
	{
		switch(String(paymentXml.children()[i].payment_method).toUpperCase())
		{
			case 'CASH':
							tiCashPayment.text	=	paymentXml.children()[i].payment_amt.toString()
							tiCashReturn.text	=	paymentXml.children()[i].return_amt.toString()
		           		 	break;
			case 'CHECK':
							tiCheckPayment.text	=	paymentXml.children()[i].payment_amt.toString()
							tiCheckReturn.text	=	paymentXml.children()[i].return_amt.toString()
				            tiCheckNo.text		=	paymentXml.children()[i].reference_no.toString()
				            break;

			case 'ACCOUNT':
							tiAccountPayment.text	=	paymentXml.children()[i].payment_amt.toString()
							tiAccountRefund.text	=	paymentXml.children()[i].return_amt.toString()	

				            break;

			case 'CREDIT_CARD':
							
							tiCreditPayment.text	=	paymentXml.children()[i].payment_amt.toString()
							tiCreditRefund.text		=	paymentXml.children()[i].return_amt.toString()
							tiCreditCardNo.text		=	paymentXml.children()[i].reference_no.toString()
							cbCreditCard.dataValue	=	paymentXml.children()[i].card_type.toString()
				            break;
				            
		     default:       Alert.show('this payment type not found');       

		}
	}
	
}
private function faultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
private function setDataService(service:HTTPService):void
{
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";
}