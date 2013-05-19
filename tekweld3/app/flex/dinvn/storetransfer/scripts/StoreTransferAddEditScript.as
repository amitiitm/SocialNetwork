import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;

import dinvn.storetransfer.StoreTransferModelLocator;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

private var getInformationEvent:GetInformationEvent;
private var numericFormatter:NumberFormatter = new NumberFormatter();
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:StoreTransferModelLocator = (StoreTransferModelLocator)(GenModelLocator.getInstance().activeModelLocator);

[Bindable]
private var image_name:String;

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
private function toStoreChangeEventHandler(store_id:String):void
{
	if(store_id != '' && store_id != null) 
	{
		if(dcStore_id.text.toString()	==	GenModelLocator.getInstance().user.company_cd.toString())
		{
			Alert.show('Cannot be transferred to the same store');
			dcStore_id.dataValue	=	'';
			taReference.text		=	'';	
			return;
		}
		getStoreInfo(store_id)
	}
}

private function getStoreInfo(store_id:String):void
{
	if(store_id != '' && store_id != null) 
	{
		var callbacks:IResponder = new mx.rpc.Responder(getStoreInfoHandler, null);
		
		getInformationEvent = new GetInformationEvent('companystoreinfo', callbacks, store_id);
		getInformationEvent.dispatch(); 
	}
}

private function getStoreInfoHandler(resultXml:XML):void
{
	taReference.text = setAddress(resultXml);
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
			_grossAmount = _grossAmount + (Number)(dtlLine.dgDtl.dataProvider[i].iss_amt);
			
			if(String(dtlLine.dgDtl.dataProvider[i].sell_unit).toLowerCase() == 'wt' || String(dtlLine.dgDtl.dataProvider[i].sell_unit).toLowerCase() == 'c')
			{
				_item_qty = _item_qty + (Number)(dtlLine.dgDtl.dataProvider[i].iss_wt);	
			}
			else if(String(dtlLine.dgDtl.dataProvider[i].sell_unit).toLowerCase() == 'pcs' || String(dtlLine.dgDtl.dataProvider[i].sell_unit).toLowerCase() == 'e')
			{
				_item_qty = _item_qty + (Number)(dtlLine.dgDtl.dataProvider[i].iss_pcs);	
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
	
	tiItem_amt.text 	=	String(_grossAmount);
}



override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	dcStore_id.enabled = false;
	__localModel.trans_date = dfTrans_date.text;
	
	setGrossAmount();
}

override protected function resetObjectEventHandler():void
{
	getStoreInfo(GenModelLocator.getInstance().user.default_company_id.toString());//get default store info
	getAccountPeriod();
	
	dcStore_id.enabled = true;
	
	__localModel.trans_date = dfTrans_date.text;
	
	setGrossAmount();
}
