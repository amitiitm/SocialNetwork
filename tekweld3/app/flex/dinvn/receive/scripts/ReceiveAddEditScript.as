import business.events.GetInformationEvent;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenValidator;
import dinvn.receive.ReceiveModelLocator;
import model.GenModelLocator;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:ReceiveModelLocator = (ReceiveModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private function init():void
{
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	getAccountPeriod();
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent = new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue = resultXml.child('code');
}

private function ReceiveTypeChangeEvent():void
{
	setReferenceLookUp(cbReceive_type.dataValue.toString());
	
}

private function setReferenceLookUp(ReceiveType:String):void
{
	switch(ReceiveType.toUpperCase())
	{
		 case 'C':
			   dcReference_id.visible = true;
	 		   dcReference_id.dataProvider = __genModel.lookupObj.customer.children();
	 		   dcReference_id.dataSourceName="Customer"
	 		   dcReference_id.dataValue	= ''
	 		   taReference.text = ''
	 		   lblReference.text = 'From Customer'
	 		   dcReference_id.validationFlag = 'true' 
	 		   dcReference_id.toolTip = 'From Customer'
				var genValidator:GenValidator = new GenValidator();
				__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects) 		 		    
	 		   
	           break;
		 case 'V':
	 		   dcReference_id.visible = true;		 
	           dcReference_id.dataProvider = __genModel.lookupObj.vendor.children();
	           dcReference_id.dataSourceName="Vendor" 
	           dcReference_id.dataValue	= ''
	           taReference.text	= ''
	           lblReference.text = 'From Vendor '
	           dcReference_id.validationFlag = 'true' 
	           dcReference_id.toolTip = 'From Vendor'
				var genValidator:GenValidator = new GenValidator();
				__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects) 		            
	           
	           break;
		 case 'A':  
	 			dcReference_id.visible = false;
				taReference.text = '';    	
				dcReference_id.dataValue = ''
				lblReference.text = ''	       
				dcReference_id.validationFlag = 'false'    
				var genValidator:GenValidator = new GenValidator();
				__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects) 
				
				break;
		 case 'O':  
	 			dcReference_id.visible = false;
				taReference.text = '';    	
				dcReference_id.dataValue = ''
				lblReference.text = ''	       
				dcReference_id.validationFlag = 'false'    
				var genValidator:GenValidator = new GenValidator();
				__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects)	
				
				break;				
		 case 'S':
	 		   dcReference_id.visible = true;		 
	           dcReference_id.dataProvider = __genModel.lookupObj.companystore.children(); 
	           dcReference_id.dataSourceName="CompanyStore"
	           dcReference_id.dataValue = ''
	           taReference.text = ''
	           lblReference.text = 'From Store'
	           dcReference_id.validationFlag = 'true' 
	           dcReference_id.toolTip = 'From Store'
				var genValidator:GenValidator = new GenValidator();
				__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects) 	
				
				break;
	}
}

private function getReferenceDetails():void
{
	if(dcReference_id.text != "" && dcReference_id.text != null)
	{
		if(cbReceive_type.dataValue == 'V')
		{
			var callbacks:IResponder = new mx.rpc.Responder(vendorDetailsHandler, null);
			getInformationEvent = new GetInformationEvent('vendorinfo', callbacks, dcReference_id.dataValue);
			getInformationEvent.dispatch();
		}
		else if(cbReceive_type.dataValue == 'C')
		{
			var callbacks:IResponder = new mx.rpc.Responder(customerDetailsHandler, null);
			getInformationEvent = new GetInformationEvent('customerdetail', callbacks, dcReference_id.dataValue ,"I");
			getInformationEvent.dispatch();   
		}
		else if(cbReceive_type.dataValue == 'S')
		{
			var callbacks:IResponder = new mx.rpc.Responder(getStoreInfoHandler, null);
		
			getInformationEvent = new GetInformationEvent('companystoreinfo', callbacks, XML(dcReference_id.selectedItem).child('id').toString());
			getInformationEvent.dispatch(); 
		}
	}
}

private function vendorDetailsHandler(resultXml:XML):void
{
	taReference.text = setAddress(resultXml);
}

private function customerDetailsHandler(resultXml:XML):void
{
	taReference.text = setCustomerAddress(resultXml);	
}

private function getStoreInfoHandler(resultXml:XML):void
{
	taReference.text = setAddress(resultXml);
}

private function setCustomerAddress(aXml:XML):String
{
	var address:String = '';
	
	if(aXml.children().child('ship_name').toString() != '')
	{
		address = address + aXml.children().child('ship_name').toString() + "\n" 	
	}
	
	if(aXml.children().child('ship_address1').toString() != '')
	{
		address = address +  aXml.children().child('ship_address1').toString() + "," 	
	}
	
	if(aXml.children().child('ship_address2').toString() != '')
	{
		address = address +  aXml.children().child('ship_address2').toString() + "\n" 	
	}
	
	if(aXml.children().child('ship_city').toString() != '')
	{
		address = address +  aXml.children().child('ship_city').toString() + ',' 	
	}

	if(aXml.children().child('ship_state').toString() != '')
	{
		address = address +  aXml.children().child('ship_state').toString() + " - " 	
	}
	
	if(aXml.children().child('ship_zip').toString() != '')
	{
		address = address + aXml.children().child('ship_zip').toString() + "\n" 	
	}

	if(aXml.children().child('ship_phone1').toString() != '')
	{
		address = address + "Phone1 : " + aXml.children().child('ship_phone1').toString()
	}

	if(aXml.children().child('ship_fax1').toString()!= '')
	{
		address = address + " Fax1 : " + aXml.children().child('ship_fax1').toString()
	}
	return address; 		
}
	
private function setAddress(aXml:XML):String
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
			
			_item_qty = _item_qty + (Number)(dtlLine.dgDtl.dataProvider[i].rec_pcs);
		}

		lblTotal_items.text = dtlLine.dgDtl.dataProvider.length.toString()
		lblItem_qty.text = _item_qty.toString()
	}
	else
	{
		lblTotal_items.text = '0'
		lblItem_qty.text = '0'
	}
	
	tiItem_amt.text = String(_grossAmount);
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	cbReceive_type.enabled = false;
	dcReference_id.enabled = false;
	
	setReferenceLookUp(event.recordXml.children().child('trans_type').toString());
	
	dcReference_id.dataValue = event.recordXml.children().child('trans_type_id').toString()
	
	taReference.text = setAddress(event.recordXml);
	__localModel.trans_date = dfTrans_date.text;
	
	setGrossAmount();
}

override protected function resetObjectEventHandler():void
{
	cbReceive_type.enabled = true;
	dcReference_id.enabled = true;
	
	ReceiveTypeChangeEvent(); 
	
	taReference.text = '';
	getAccountPeriod();
	__localModel.trans_date = dfTrans_date.text;
	
	setGrossAmount();
}
