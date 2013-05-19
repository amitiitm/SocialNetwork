import business.events.GetInformationEvent;
import business.events.GetRecordEvent;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenNumberFormatter;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.core.Application
import mx.managers.CursorManager;

import pos.repairentry.RepairEntryModelLocator;

private var getRecordEvent:GetRecordEvent;
private var numericFormatter:GenNumberFormatter = 	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:RepairEntryModelLocator = (RepairEntryModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();


private function init():void
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	getAccountPeriod();
	__localModel.trans_date=dfTrans_date.text
	tnDetail.selectedChild = hbDetail;
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
	dcAccount_period_code.dataValue	=	resultXml.child('code');
}

private function getCustomerDetails():void
{	
	if(dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{	dcCustomer_shipping_id.filterKeyValue = dcCustomer_id.dataValue
		var callbacks:IResponder	=	new mx.rpc.Responder(customerDetailsHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('customerdetail', callbacks, dcCustomer_id.dataValue, "I");
		getInformationEvent.dispatch();  
	}
	else
	{
		resetShippingAddress();
		resetBillingAddress();
	}
}

private function customerDetailsHandler(resultXml:XML):void
{
	setValue(resultXml);
}

private function setValue(customerXml:XML):void
{
	dcCustomer_shipping_id.dataValue = customerXml.children().child('customer_shipping_id').toString();
	dcTerm_code.dataValue = customerXml.children().child('term_code').toString();	
	dcShipping_code.dataValue = customerXml.children().child('shipping_code').toString();
	setShippingAddress(customerXml);
	setBilliingAddress(customerXml);

}

private function setShippingAddress(customerXml:XML):void
{
	tiShip_nm.text = customerXml.children().child('ship_name').toString();
	tiShip_address1.text = customerXml.children().child('ship_address1').toString();
	tiShip_address2.text = customerXml.children().child('ship_address2').toString();
	tiShip_city.text = customerXml.children().child('ship_city').toString();
	tiShip_fax1.text = customerXml.children().child('ship_fax').toString();
	tiShip_phone1.text = customerXml.children().child('ship_phone').toString();
	tiShip_state.text = customerXml.children().child('ship_state').toString();
	tiShip_zip.text = customerXml.children().child('ship_zip').toString();	
	tiShip_country.text = customerXml.children().child('ship_country').toString();
	tiShipFirstName.text = customerXml.children().child('first_name').toString();
	tiShipLastName.text = customerXml.children().child('last_name').toString();
	tiShipCell_no.text = customerXml.children().child('cell_no').toString();
	tiShipEmail.text = customerXml.children().child('email').toString();
}

private function setBilliingAddress(customerXml:XML):void
{
	tiBill_nm.text = customerXml.children().child('name').toString();
	tiBill_address1.text = customerXml.children().child('bill_address1').toString();
	tiBill_address2.text = customerXml.children().child('bill_address2').toString();
	tiBill_city.text = customerXml.children().child('bill_city').toString();
	tiBill_fax1.text = customerXml.children().child('bill_fax').toString();
	tiBill_phone1.text = customerXml.children().child('bill_phone').toString();
	tiBill_state.text = customerXml.children().child('bill_state').toString();
	tiBill_zip.text = customerXml.children().child('bill_zip').toString();	
	tiBill_country.text = customerXml.children().child('bill_country').toString();
	tiBillFirstName.text = customerXml.children().child('first_name').toString();
	tiBillLastName.text = customerXml.children().child('last_name').toString();
	tiBillCell_no.text = customerXml.children().child('cell_no').toString();
	tiBillEmail.text = customerXml.children().child('email').toString();

}

private function setCustomerTab():void
{
	tnDetail.selectedChild = hbCustomer ;
}

private function resetShippingAddress():void
{
	tiShip_nm.text = ''
	tiShip_address1.text = '' 
	tiShip_address2.text = ''
	tiShip_city.text = ''
	tiShip_fax1.text = ''
	tiShip_phone1.text = ''
	tiShip_state.text = ''
	tiShip_zip.text = ''	
	tiShip_country.text = ''
	tiShipFirstName.text = ''
	tiShipLastName.text = ''
	tiShipCell_no.text = ''
	tiShipEmail.text = ''
}

private function resetBillingAddress():void
{
	tiBill_nm.text = ''
	tiBill_address1.text = ''
	tiBill_address2.text = ''
	tiBill_city.text = ''
	tiBill_fax1.text = ''
	tiBill_phone1.text = ''
	tiBill_state.text = ''
	tiBill_zip.text = ''	
	tiBill_country.text = ''
	tiBillFirstName.text = ''
	tiBillLastName.text = ''
	tiBillCell_no.text = ''
	tiBillEmail.text = ''
}

private function getShippingAddress():void
{
	if(dcCustomer_shipping_id.text != '')
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getShippingAddressHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('customershippings', callbacks, dcCustomer_shipping_id.dataValue);
		getInformationEvent.dispatch();
	}
}

private function getShippingAddressHandler(resultXml:XML):void
{
	setShippingAddress(resultXml);
}

private function refreshShip(event:Event):void
{
	dcCustomer_shipping_id.btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
}

private function getItemDetails():void
{
	if(dcItemId.dataValue != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('iteminfo', callbacks, dcItemId.dataValue, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
	else
	{
	
		tiItemDescription.dataValue = tiItemDescription.defaultValue;
		tiImage_thumnail.dataValue = tiImage_thumnail.defaultValue;
		tiCatalog_item_packet_code.dataValue = "";
		tiCatalog_item_packet_id.dataValue = "";
	}
}

public function getItemDetailsHandler(resultXml:XML):void
{
		var packet_require_yn:String;
	
	tiItemDescription.dataValue = resultXml.children()[0].name.toString();
	tiImage_thumnail.dataValue = resultXml.children()[0].image_thumnail.toString();
	
	packet_require_yn = resultXml.children()[0].packet_require_yn.toString();

	tiCatalog_item_packet_code.dataValue = "";
	tiCatalog_item_packet_id.dataValue = "";

	if(packet_require_yn=='N')
	{
		tiCatalog_item_packet_code.enabled = false;
	}
	else
	{
		tiCatalog_item_packet_code.enabled = true;
	}	
	tiPacket_require_yn.dataValue = packet_require_yn;	
}

private function getPacketDetails():void
{
	if(tiCatalog_item_packet_code.dataValue != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getPacketDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('packetinfo', callbacks, tiCatalog_item_packet_code.dataValue, dfTrans_date.dataValue, 'N');
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
	
		tiCatalog_item_packet_id.dataValue = resultXml.children()[0].catalog_item_packet_id.toString();
		tiCatalog_item_packet_code.dataValue = resultXml.children()[0].catalog_item_packet_code.toString();
	
		dcItemId.dataValue = resultXml.children()[0].catalog_item_id.toString();
		tiItemDescription.dataValue = resultXml.children()[0].name.toString();
		tiImage_thumnail.dataValue = resultXml.children()[0].image_thumnail.toString();
		tiPacket_require_yn.dataValue = resultXml.children()[0].packet_require_yn.toString();
	}
	else
	{
		tiCatalog_item_packet_id.dataValue = tiCatalog_item_packet_id.defaultValue;
		tiCatalog_item_packet_code.dataValue = tiCatalog_item_packet_code.defaultValue;
	}
}
//--------------------------------
public function getLotsDetails():void
{
	if(dcStone_lot_id.dataValue != '')
	{
		var callbacks:IResponder = new mx..rpc.Responder(getLotsDetailsHandler, null);

		getInformationEvent	=	new GetInformationEvent('diamondlotinfo', callbacks, dcStone_lot_id.dataValue);
		getInformationEvent.dispatch(); 
	}
}

public function getLotsDetailsHandler(resultXml:XML):void
{	
	var diamond_cert_flag:String;

	tiStone_lot_no.dataValue 	= resultXml.children()[0].lot_number.toString();
	cbStone_shape.dataValue 	= resultXml.children()[0].shape.toString();
	tiSize.dataValue 			= resultXml.children()[0].size.toString();
	cbStone_clarity.dataValue 	= resultXml.children()[0].clarity.toString();
	cbStone_color.dataValue 	= resultXml.children()[0].color.toString();
	cbDiamond_quality.dataValue = resultXml.children()[0].quality.toString();
	cbStone_color.dataValue 	= resultXml.children()[0].color.toString();
	cbStone_clarity.dataValue	= resultXml.children()[0].clarity.toString();
	cbStone_type.dataValue 		= resultXml.children()[0].stone_type.toString();
	cbStone_setting.dataValue	= resultXml.children()[0].setting.toString();
	
	diamond_cert_flag = resultXml.children()[0].diamond_cert_flag.toString();

	tiStone_packet_code.dataValue = "";
	tiStone_packet_id.dataValue = "";
		
	if(diamond_cert_flag=='N')
	{
		tiStone_packet_code.enabled = false;
	}
	else
	{
		tiStone_packet_code.enabled = true;
	}	
	tiDiamond_cert_flag.dataValue = diamond_cert_flag;
}

private function getStonePacketDetails():void
{
	if(tiStone_packet_code.dataValue != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getStonePacketDetailsHandler, null);

		getInformationEvent	= new GetInformationEvent('diamondpacketinfo', callbacks, tiStone_packet_code.dataValue, 'N');
		getInformationEvent.dispatch();
	}
	else
	{
		tiStone_packet_id.dataValue = ""	
	}
}

public function getStonePacketDetailsHandler(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		
		tiStone_packet_id.dataValue = resultXml.children()[0].id.toString();
		tiStone_packet_code.dataValue = resultXml.children()[0].packet_no.toString();
	
		tiStone_lot_no.dataValue = resultXml.children()[0].diamond_lot_number.toString();;
		dcStone_lot_id.dataValue = resultXml.children()[0].diamond_lot_id.toString();
		cbStone_clarity.dataValue = resultXml.children()[0].clarity.toString();
		cbStone_color.dataValue = resultXml.children()[0].color.toString();
		cbStone_shape.dataValue = resultXml.children()[0].shape.toString();
		cbStone_type.dataValue = resultXml.children()[0].stone_type.toString();
		tiSize.dataValue = resultXml.children()[0].size.toString();
		tiDiamond_cert_flag.dataValue = resultXml.children()[0].diamond_cert_flag.toString();
			
		tiStone_weight.dataValue = resultXml.children()[0].weight.toString();
	}
	else
	{
		tiStone_packet_id.dataValue = tiStone_packet_id.defaultValue;
		tiStone_packet_code.dataValue = tiStone_packet_code.defaultValue;
	}

}

//--------------------------

private function shipping_amtChange():void
{
	var _sub_total:Number 	= Number(tiItem_amt.text);
	if (_sub_total >= 0)
	{
		var _ship_amt:Number 	= parseFloat(tiShipping.text);
		if (String(_ship_amt) == 'NaN' || String(_ship_amt) == '') 
		{
			tiShipping.text = numericFormatter.format(String(0.00));
		}
		tiShipping.text = numericFormatter.format(tiShipping.text);
		setNetAmount(); 
	}
}

private function discount_perChange():void
{
	var _sub_total:Number = Number(tiItem_amt.text);
	
	if (tiItem_amt.text != '')
	{
		var _dis_per:Number = parseFloat(tiDiscount_per.text);
		var _dis_amt:Number;
		
		if (_dis_per == 0 || String(_dis_per) == 'NaN' || String(_dis_per) == '')
		{
			_dis_amt = 0;
			tiDiscount_per.text = numericFormatter.format(String(0.00));
		}
		else
		{
			_dis_amt = Number(numericFormatter.format(_sub_total * _dis_per / 100));
		} 
		tiDiscount_amt.text = numericFormatter.format(String(_dis_amt));
		tiDiscount_per.text = numericFormatter.format(tiDiscount_per.text);				
		setNetAmount(); 
	}
}				

private function discount_amtChange():void
{
	var _sub_total:Number = Number(tiItem_amt.text);
	
	if (tiItem_amt.text != '')
	{
		var _dis_amt:Number = parseFloat(tiDiscount_amt.text);
	 	if (_dis_amt == 0 || String(_dis_amt) == 'NaN')
		{
			tiDiscount_per.text = String(0.00);
		}
		else
		{
			tiDiscount_per.text = numericFormatter.format(String(Number(_dis_amt / _sub_total * 100)));
		} 
		tiDiscount_amt.text	 = numericFormatter.format(tiDiscount_amt.text);
		setNetAmount(); 
	}
}

private function tax_perChange():void
{
	numericFormatter.precision = 4;
	var _sub_total:Number = Number(tiItem_amt.text);
	
	if (tiItem_amt.text != '')
	{
		var _tax_per:Number = parseFloat(tiTax_per.text);
		var _tax_amt:Number;
		 if (_tax_per == 0 || String(_tax_per) == 'NaN' || String(_tax_per) == '')
		{
			_tax_amt = 0;
			tiTax_per.text = numericFormatter.format(String(0));
		}
		else
		{
			_tax_amt = Number(numericFormatter.format(_sub_total *_tax_per / 100));
		} 
		tiTax_amt.text = numericFormatter.format(String(_tax_amt));
		numericFormatter.precision = 2;
		tiTax_per.text = numericFormatter.format(tiTax_per.text);
		setNetAmount(); 
	}
}
	
private function tax_amtChange():void
{
	var _tax_amt:Number 	= parseFloat(tiTax_amt.text);
	var _sub_total:Number = Number(tiItem_amt.text);
	if (_tax_amt == 0 || String(_tax_amt) == 'NaN')
	{
		tiTax_per.text = String(0.00);
	}
	else
	{
		tiTax_per.text = numericFormatter.format(String(Number(_tax_amt / _sub_total * 100)));
	}
	numericFormatter.precision = 4;
	tiTax_amt.text = numericFormatter.format(tiTax_amt.text);
	numericFormatter.precision = 2;
	setNetAmount(); 
}

private function setNetAmount():void
{
	var _sub_total:Number 	= Number(tiItem_amt.text);
	
	if (tiItem_amt.text != '')
	{
		if(parseFloat(tiDiscount_amt.text) == 0 || tiDiscount_amt.text == ''|| tiDiscount_amt.text == 'NaN')
		{
			tiDiscount_amt.text = numericFormatter.format(String(0.00));
			
		}
		if(parseFloat(tiTax_amt.text) == 0 || tiTax_amt.text == ''|| tiTax_amt.text == 'NaN')
		{
			tiTax_amt.text = numericFormatter.format(String(0.00));
			
		}
		if(parseFloat(tiShipping.text) == 0 || tiShipping.text == ''|| tiShipping.text == 'NaN')
		{
			tiShipping.text = numericFormatter.format(String(0.00));
			
		}
		var _dis_amt:Number  = Number(numericFormatter.format(tiDiscount_amt.text));
		var _sal_tax:Number  = Number(numericFormatter.format(tiTax_amt.text));
		var _ship_amt:Number = parseFloat(numericFormatter.format(tiShipping.text));
		
		tiNet_amt.text = numericFormatter.format(String(_sub_total - _dis_amt + _sal_tax + _ship_amt));
	} 
	
	// beacause after filling payment info if user add/remove or somehow changes netAmt then paymentStatus and calculation should done
	 setBalanceAmount();

}

private function setBalanceAmount():void
{
	var _net_amt:Number 	 = Number(tiNet_amt.text);
	var _deposit_amt:Number  = Number(numericFormatter.format(tiDeposit_amt.text));

	tiBalanced_amt.text = numericFormatter.format(String(_net_amt - _deposit_amt));
}
//--------------------------------------------------------------------------------

private function calculateEstimateTotalAmt():void
{
	var _totalAmount:Number = 0.00;
	
	if(dtlEstimateLine.dgDtl.dataProvider != null)
	{
		for(var i:int = 0; i < dtlEstimateLine.dgDtl.dataProvider.length; i++)
		{
			_totalAmount = _totalAmount + (Number)(dtlEstimateLine.dgDtl.dataProvider[i].total_amt);
		}
	}
	
	tiTotalEstimateAmt.text = String(_totalAmount);
}

private function calculateActualTotalAmt():void
{
	var _totalAmount:Number = 0.00;

	if(dgItems.dataProvider != null)
	{
		for(var i:int = 0; i < dgItems.dataProvider.length; i++)
		{
			_totalAmount = _totalAmount + (Number)(dgItems.dataProvider[i].item_amt);
		}
	}
	
	tiTotalActualAmt.text = String(_totalAmount);
}
//--------------------------------------------------------------------------------
private function calculatePricing():void
{
	var _part_total:Number = 0.00
	var _labor_total:Number = 0.00

	if(dtlEstimateLine.dgDtl.dataProvider != null)
	{
		for(var i:int = 0; i < dtlEstimateLine.dgDtl.dataProvider.length; i++)
		{
			if(dtlEstimateLine.dgDtl.dataProvider[i].item_type == 'L')
			{
				_labor_total = _labor_total + (Number)(dtlEstimateLine.dgDtl.dataProvider[i].total_amt);
			}
			else
			{
				_part_total = _part_total + (Number)(dtlEstimateLine.dgDtl.dataProvider[i].total_amt);
			}
		}
	}
	tiPart_total.dataValue	=	String(_part_total)
	tiLabor_total.dataValue =	String(_labor_total)
	tiEstimateAmt.dataValue	=	numericFormatter.format(Number(tiPart_total.dataValue) + Number(tiLabor_total.dataValue));
	tiItem_amt.dataValue 	= 	numericFormatter.format(Number(tiPart_total.dataValue) + Number(tiLabor_total.dataValue));

		setNetAmount(); 
}
//-----------------------------------------------
private function btnCreateWorkbagClickHandler():void
{
	if(tiWb_trans_no.text != '')
	{
		Alert.show('Workbag Already Created.');
		return;
	}
	if(!__genModel.activeModelLocator.addEditObj.editStatus &&  tiId.text != '')
	{
		var xml:XML = new XML(	<params>
										<order_id>{tiId.dataValue}</order_id>	
								</params>)
	
		var service:HTTPService = GenModelLocator.getInstance().services.getHTTPService("save_workbag");
	
		setDataService(service);
	
		service.addEventListener(ResultEvent.RESULT, saveOrderResultHandler)													
		service.addEventListener(FaultEvent.FAULT, faultHandler)
	
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		
		service.send(xml);
	}	
	else
	{
		Alert.show('Please Save Record And then Try.');
	}
}

private function setDataService(service:HTTPService):void
{
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";
}
private function saveOrderResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var _resultXml:XML;
	_resultXml = (XML)(event.result.toString());

	if(_resultXml.name() == "errors")
	{
		if(_resultXml.children().length() > 0) 
		{
			var message:String = '';
	
			for(var i:uint = 0; i < _resultXml.children().length(); i++) 
			{
				message += _resultXml.children()[i] + "\n";
			}
			Alert.show(message);
		} 
		}
		else
		{
			getRecordEvent = new GetRecordEvent(int(tiId.dataValue));
			getRecordEvent.dispatch();	
		}	

}
private function faultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}

private function btnPrintWorkbagClickHandler():void
{
	if(!__genModel.activeModelLocator.addEditObj.editStatus &&  tiId.text != '')
	{
		if(tiWb_trans_id.text != '')
		{
			var xml:XML = new XML(	<params>
											<id>{tiWb_trans_id.text}</id>
											<date_format>{__genModel.user.date_format}</date_format>
									</params>);		
			var service:HTTPService = GenModelLocator.getInstance().services.getHTTPService("printWorkbag");
		
			setDataService(service);
		
			service.addEventListener(ResultEvent.RESULT, printCommandResultHandler)													
			service.addEventListener(FaultEvent.FAULT, faultHandler)
		
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;
			
			service.send(xml);		
			
		}
		else
		{
			Alert.show('Please Create Order And then Try.');	
		}
	}
	else
	{
		Alert.show('Please Save Record And then Try.');	
	}
}
private function printCommandResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
	var request:URLRequest = new URLRequest(url);

	navigateToURL(request);
}	
//----------------------------------------------
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	
	var recordXml:XML	= event.recordXml;
	dcCustomer_id.enabled	=	false;
	dfTrans_date.enabled    =   false;
	
	__localModel.trans_date=dfTrans_date.text
	
	dcCustomer_shipping_id.filterKeyValue = dcCustomer_id.dataValue;
	dcCustomer_shipping_id.dataValue = recordXml.children()["customer_shipping_id"];
	
	calculateEstimateTotalAmt();
	calculateActualTotalAmt();
	
	var packet_require_yn:String = tiPacket_require_yn.dataValue;
	
	if(packet_require_yn == null || packet_require_yn == "" || packet_require_yn.toLocaleUpperCase() =='N')
	{
		tiCatalog_item_packet_code.enabled = false
	}
	else
	{
		tiCatalog_item_packet_code.enabled = true
	}
	var diamond_cert_flag:String = tiDiamond_cert_flag.dataValue;
	
	if(diamond_cert_flag == null || diamond_cert_flag == "" || diamond_cert_flag.toLocaleUpperCase() =='N')
	{
		tiStone_packet_code.enabled = false
	}
	else
	{
		tiStone_packet_code.enabled = true
	}
	
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	getAccountPeriod();
	
	dcCustomer_shipping_id.filterKeyValue = "" // BECAUSE LOOKUP SHOULD EMPTY NOW
	tiCatalog_item_packet_code.enabled = true;
	tiStone_packet_code.enabled = true;
	dfTrans_date.enabled    =  true;

	__localModel.trans_date=dfTrans_date.text
	
	dcCustomer_id.enabled	=	true;
	getCustomerDetails();

}
