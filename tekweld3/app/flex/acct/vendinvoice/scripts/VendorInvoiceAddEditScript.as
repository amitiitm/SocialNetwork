import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;
import com.generic.genclass.GenObject;
import com.generic.genclass.URL;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var getInformationEvent:GetInformationEvent;
private var _numericFormatter:NumberFormatter = new NumberFormatter();

private function init():void
{
	_numericFormatter.precision	=	2;
	_numericFormatter.rounding	=	"nearest";
	_numericFormatter.useThousandsSeparator	=	false;
	
	getAccountPeriod();
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue		=	resultXml.child('code');
	dcAccount_period_code.labelValue	=	resultXml.child('code');
}

private function getDueDate():void
{
	if(dcTerm_code.text != '')
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getDueDateHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('termchange', callbacks, dcTerm_code.dataValue, dfTrans_date.text);
		getInformationEvent.dispatch();
		
	}
}

private function getDueDateHandler(resultXml:XML):void
{
	dfDue_date.text			=	resultXml.children()[0].pay1_date.toString();
	dfDiscount_date.text	=	resultXml.children()[0].pay2_date.toString();
	tiDiscount_per.text			=	resultXml.children()[0].disc_per.toString(); 
}

private function handleItemChangedVendor_id():void
{
	getInvoiceHeaderDetails()
}

private function getInvoiceHeaderDetails():void
{
	if(dcVendor_id.text != "" && dcVendor_id.text != null)
	{
		var xml:XML = new XML(	<criteria>
								<id>{dcVendor_id.dataValue}</id>
							</criteria>);

		var service:HTTPService = GenModelLocator.getInstance().services.getHTTPService("fetch_invoice_header_details");
	
		setDataService(service);
	
		service.addEventListener(ResultEvent.RESULT, fetchinvoiceHeaderDetailsHandler)													
		service.addEventListener(FaultEvent.FAULT, faultHandler)
	
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		
		service.send(xml);
			
	}
}

private function fetchinvoiceHeaderDetailsHandler(event:ResultEvent):void
{
	var genObj:GenObject = new GenObject();
	var xml:XML = (XML)(event.result)
	
	genObj.setRecord(__genModel.activeModelLocator.addEditObj.genObjects, xml);
	taVendor.text	=	setVendorAddress(xml);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}

private function DiscAmtCalculation():void
{
	tiDiscount_amt.text	= _numericFormatter.format((Number(tiInv_amt.text) * Number(tiDiscount_per.text))/ 100);
}

private function discPerCalculation():void
{
	tiDiscount_per.text	=	_numericFormatter.format((Number(tiDiscount_amt.text) * 100)/ Number(tiInv_amt.text));
}

private function BalanceAmtCalculation():void
{
	tiBalance_amt.text	=	_numericFormatter.format(Number(tiInv_amt.text) - (Number(tiPaid_amt.text) + Number(tiDistaken_amt.text)))
	
	tiDiscount_per.text	=	tiDiscount_per.defaultValue;
	tiDiscount_amt.text	=	tiDiscount_amt.defaultValue;
	
 	if(itemDtl.dgDtl.rows.children().length()	==	1)
 	{
 		itemDtl.dgDtl.rows.children()[0].gl_amt	=	_numericFormatter.format(tiInv_amt.text);
 	} 
}

private function calculateDetailTotalAmount():Number
{
	var i:int;
	var sum:Number	=	0.00;
	var rows:XML;
	rows	=	itemDtl.dgDtl.rows
	for(i=0; i< rows.children().length(); i++)
	{
		sum	=	sum	+ Number(rows.children()[i].gl_amt)
	}
	
	return 	sum
}

private function setDataService(service:HTTPService):void
{
	var urlObj:URL	=	new URL();
	service.url		=	urlObj.getURL(service.url.toString())
	
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";
}

private function faultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}

private function setVendorAddress(aXml:XML):String
{
	var address:String = '';
	if(aXml.children().child('name').toString() != '')
	{
		address = address + aXml.children().child('name').toString() + "\n" 	
	}
	
	if(aXml.children().child('address1').toString() != '')
	{
		address = address +  aXml.children().child('address1').toString() + "," 	
	}
	
	if(aXml.children().child('address2').toString() != '')
	{
		address = address +  aXml.children().child('address2').toString() + "\n" 	
	}
	
	if(aXml.children().child('city').toString() != '')
	{
		address = address +  aXml.children().child('city').toString() + ',' 	
	}

	if(aXml.children().child('state').toString() != '')
	{
		address = address +  aXml.children().child('state').toString() + " - " 	
	}
	
	if(aXml.children().child('zip').toString() != '')
	{
		address = address + aXml.children().child('zip').toString() + "\n" 	
	}

	if(aXml.children().child('phone1').toString() != '')
	{
		address = address + "Phone1 : " + aXml.children().child('phone1').toString()
	}

	if(aXml.children().child('fax1').toString()!= '')
	{
		address = address + " Fax1 : " + aXml.children().child('fax1').toString()
	}
	return address; 		
}	

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var totalAmount:String	=	_numericFormatter.format(calculateDetailTotalAmount());
	
	if(Number(tiInv_amt.text)== Number(totalAmount))
	{
		return 0;
	}
	else
	{
		Alert.show('invoice amount is not equal to gl amount');
		return 1;
	}
	return 0;
	
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML	= event.recordXml;
	
	dcVendor_id.enabled	=	false;
	taVendor.text	=	setVendorAddress(recordXml)
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	getAccountPeriod();
	
	dcVendor_id.enabled	=	true;
}