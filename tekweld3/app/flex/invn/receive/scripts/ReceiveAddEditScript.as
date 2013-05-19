import business.events.GetInformationEvent;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenValidator;
import invn.receive.ReceiveModelLocator;
import model.GenModelLocator;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:ReceiveModelLocator = (ReceiveModelLocator)(GenModelLocator.getInstance().activeModelLocator);

[Bindable]
private var image_name:String;

private function init():void
{
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	__localModel.trans_date = dfTrans_date.text;
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

private function setVisibility(ReceiveType:String):void
{
	if(ReceiveType == 'V' || ReceiveType == 'C')
	{
		vsReference.selectedIndex = 1;
		
		dcReference_id.validationFlag = 'false'
		dcReference_id.updatableFlag  = 'false'
		
		dcVendCust_id.validationFlag 	  = 'true';
		dcVendCust_id.updatableFlag 	  = 'true';
	}
	else
	{
		vsReference.selectedIndex = 0;
		
		dcReference_id.validationFlag = 'true'
		dcReference_id.updatableFlag  = 'true'
		
		dcVendCust_id.validationFlag 	  = 'false';
		dcVendCust_id.updatableFlag 	  = 'false';
	}
}

private function setReferenceLookUp(ReceiveType:String):void
{
	switch(ReceiveType.toUpperCase())
	{
		case 'C':
			setVisibility(ReceiveType);
			taReference.text	=	''
			lblReference.text	=	'From Customer'
			
			dcVendCust_id.dataSourceName	=	'Customer'
			dcVendCust_id.toolTip		=	'From Customer'
			dcVendCust_id.dataValue	= '';
			dcVendCust_id.labelValue	= '';
			
			var genValidator:GenValidator = new GenValidator();
			__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects) 		 		    
			
			break;
		case 'V':
			setVisibility(ReceiveType);
			taReference.text	=	''
			lblReference.text	=	'From Vendor'
			
			dcVendCust_id.dataSourceName	=	'Vendor'
			dcVendCust_id.toolTip		=	'From Vendor'
			dcVendCust_id.dataValue	= '';
			dcVendCust_id.labelValue	= '';
			
			var genValidator:GenValidator = new GenValidator();
			__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects) 		            
			
			break;
		case 'A':  
			setVisibility(ReceiveType);
			dcReference_id.visible = false;
			taReference.text = '';    	
			dcReference_id.dataValue = ''
			dcReference_id.labelValue = ''
			lblReference.text = ''	       
			dcReference_id.validationFlag = 'false'    
			var genValidator:GenValidator = new GenValidator();
			__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects) 
			
			break;
		case 'O':  
			setVisibility(ReceiveType);
			dcReference_id.visible = false;
			taReference.text = '';    	
			dcReference_id.dataValue = ''
			dcReference_id.labelValue = ''
			lblReference.text = ''	       
			dcReference_id.validationFlag = 'false'    
			var genValidator:GenValidator = new GenValidator();
			__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects)	
			
			break;				
		case 'S':
			setVisibility(ReceiveType);
			dcReference_id.visible = true;		 
			//dcReference_id.dataProvider = __genModel.lookupObj.companystore.children(); 
			//dcReference_id.dataSourceName="CompanyStore"
			dcReference_id.dataValue = ''
			dcReference_id.labelValue = ''
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
	if(cbReceive_type.dataValue == 'V' && dcVendCust_id.text != null && dcVendCust_id.text != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(vendorDetailsHandler, null);
		getInformationEvent = new GetInformationEvent('vendorinfo', callbacks, dcVendCust_id.dataValue);
		getInformationEvent.dispatch();
	}
	else if(cbReceive_type.dataValue == 'C' && dcVendCust_id.text != "" && dcVendCust_id.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(customerDetailsHandler, null);
		getInformationEvent = new GetInformationEvent('customerdetail', callbacks, dcVendCust_id.dataValue ,"I");
		getInformationEvent.dispatch();   
	}
	else if(cbReceive_type.dataValue == 'S' && dcReference_id.text != "" && dcReference_id.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getStoreInfoHandler, null);
		
		getInformationEvent = new GetInformationEvent('companystoreinfo', callbacks, dcReference_id.dataValue);
		getInformationEvent.dispatch(); 
	}
}

private function vendorDetailsHandler(resultXml:XML):void
{
	tiRef_code.dataValue = resultXml.children().child('code').toString()
	dcVendCust_id.labelValue = resultXml.children().child('code').toString()
	dcVendCust_id.dataValue  = resultXml.children().child('id').toString()
	taReference.text = setAddress(resultXml);
}

private function customerDetailsHandler(resultXml:XML):void
{
	tiRef_code.dataValue = resultXml.children().child('code').toString()
	dcVendCust_id.labelValue = resultXml.children().child('code').toString()
	dcVendCust_id.dataValue  = resultXml.children().child('id').toString()
	taReference.text = setCustomerAddress(resultXml);	
}

private function getStoreInfoHandler(resultXml:XML):void
{
	dcReference_id.dataValue	=	resultXml.children().child('id').toString()
	dcReference_id.labelValue	=	resultXml.children().child('company_cd').toString()
	tiRef_code.dataValue		=	resultXml.children().child('company_cd').toString()
	
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
	
	numericFormatter.precision = 3;
	
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
	
	tiItem_amt.text = String(_grossAmount);
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

override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	cbReceive_type.enabled = false;
	dcReference_id.enabled = false;
	
	setReferenceLookUp(event.recordXml.children().child('trans_type').toString());
	
	if(event.recordXml.children().child('trans_type').toString() != 'V' && event.recordXml.children().child('trans_type').toString() != 'C')
	{
		dcReference_id.dataValue			=	event.recordXml.children().child('trans_type_id').toString()
		dcReference_id.labelValue			=	event.recordXml.children().child('trans_type_code').toString()
		dcReference_id.enabled				=	false;	
	}
	else
	{
		dcVendCust_id.dataValue 			= 	event.recordXml.children().child('trans_type_id').toString()
		dcVendCust_id.labelValue			= 	event.recordXml.children().child('trans_type_code').toString()
		dcVendCust_id.enabled				= false
	}
	
	taReference.text = setAddress(event.recordXml);
	__localModel.trans_date = dfTrans_date.text;

	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		dtlLine.dgDtl.selectedIndex = 0
	}

	changeImage();
	
	getReferenceDetails();
	
	setGrossAmount();

}

override protected function resetObjectEventHandler():void
{
	cbReceive_type.enabled = true;
	dcReference_id.enabled = true;
	dcVendCust_id.enabled	= 	true;
	ReceiveTypeChangeEvent(); 
	
	taReference.text = '';
	getAccountPeriod();
	__localModel.trans_date = dfTrans_date.text;
	
	changeImage();
	
	lblTotal_items.text = "";
	lblItem_qty.text = "";
	
}
