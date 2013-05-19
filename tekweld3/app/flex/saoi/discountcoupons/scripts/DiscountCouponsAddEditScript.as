import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

import saoi.muduleclasses.ValidatePoPopUp;
import saoi.muduleclasses.event.MissingInfoEvent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var columnArray:ArrayCollection = new ArrayCollection();
private var columnIndex:int=0;
private var resultXmlFromItem:XML = new XML();

private function validatePassword():void
{
	var validatePoPopUp:ValidatePoPopUp			= ValidatePoPopUp(PopUpManager.createPopUp(this,ValidatePoPopUp,true));
	validatePoPopUp.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,validatePasswordMissingInfoEventListner);
	validatePoPopUp.x							= ((Application.application.width/2)-(validatePoPopUp.width/2));
	validatePoPopUp.y							= ((Application.application.height/2)-(validatePoPopUp.height/2));
	
}
private function validatePasswordMissingInfoEventListner(event:MissingInfoEvent):void
{
	var resultXml:XML   = event.xml.copy();
	if(resultXml.children()[0].toString()=='VALID')
	{
		
	}
	else
	{
		if(cbapprove_Flag.dataValue   == 'N')
		{
			cbapprove_Flag.dataValue   = 'Y'
		}
		else
		{
			cbapprove_Flag.dataValue   = 'N'
		}
	}
}

private function getItemDetails():void
{
	if(tiCustomerCode.dataValue!='' && tiCustomerCode.dataValue!=null)
	{
		if(dcItemId.text!='' && dcItemId.text!=null)
		{
			var callbacks:IResponder = new mx.rpc.Responder(getItemDetailHandler, null);
			var item_detail:GetInformationEvent	=	new GetInformationEvent('item_detail_sample_order', callbacks, dcItemId.dataValue,dcCustomer_id.dataValue);
			item_detail.dispatch(); 
		}
		else
		{
			resultXmlFromItem				= new XML();
			setTiers();
			setDefaultpricing();
		}
	}
	else
	{
		Alert.show("Please Select Customer");
		
		resultXmlFromItem				= new XML();
		setTiers();
		setDefaultpricing();
	}
}

private function getItemDetailHandler(resultXml:XML):void
{
	resultXmlFromItem			= resultXml.copy();
	
	setTiers();
	setDefaultpricing();
}
private function setTiers():void
{
	if(resultXmlFromItem.children().length()>0)
	{
		lblBlank.text				= 1+'';
		lblTier1.text				= resultXmlFromItem.columns.column1.toString();
		lblTier2.text				= resultXmlFromItem.columns.column2.toString();
		lblTier3.text				= resultXmlFromItem.columns.column3.toString();
		lblTier4.text				= resultXmlFromItem.columns.column4.toString();
		lblTier5.text				= resultXmlFromItem.columns.column5.toString();
		lblTier6.text				= resultXmlFromItem.columns.column6.toString();
		lblTier7.text				= resultXmlFromItem.columns.column7.toString();
		lblTier8.text				= resultXmlFromItem.columns.column8.toString();
		lblTier9.text				= resultXmlFromItem.columns.column9.toString();
		lblTier10.text				= resultXmlFromItem.columns.column10.toString();
		lblTier11.text				= resultXmlFromItem.columns.column11.toString();
		lblTier12.text				= resultXmlFromItem.columns.column12.toString();
		lblTier13.text				= resultXmlFromItem.columns.column13.toString();
		lblTier14.text				= resultXmlFromItem.columns.column14.toString();
		lblTier15.text				= resultXmlFromItem.columns.column15.toString();
		
	}
	else
	{
		lblBlank.text				= 'Blank';
		lblTier1.text				= 'Tier1';
		lblTier2.text				= 'Tier2';
		lblTier3.text				= 'Tier3';
		lblTier4.text				= 'Tier4';
		lblTier5.text				= 'Tier5';
		lblTier6.text				= 'Tier6';
		lblTier7.text				= 'Tier7';
		lblTier8.text				= 'Tier8';
		lblTier9.text				= 'Tier9';
		lblTier10.text				= 'Tier10';
		lblTier11.text				= 'Tier11';
		lblTier12.text				= 'Tier12';
		lblTier13.text				= 'Tier13';
		lblTier14.text				= 'Tier14';
		lblTier14.text				= 'Tier15';
	}
	
}
private function setDefaultpricing():void
{
	if(resultXmlFromItem.children().length()>0)
	{
		tiBlankprice.text			= resultXmlFromItem.catalog_item_prices.catalog_item_price.blank_good_price.toString();
		tiColumn1.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column1.toString();
		tiColumn2.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column2.toString();
		tiColumn3.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column3.toString();
		tiColumn4.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column4.toString();
		tiColumn5.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column5.toString();
		tiColumn6.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column6.toString();
		tiColumn7.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column7.toString();
		tiColumn8.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column8.toString();
		tiColumn9.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column9.toString();
		tiColumn10.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column10.toString();
		tiColumn11.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column11.toString();
		tiColumn12.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column12.toString();
		tiColumn13.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column13.toString();
		tiColumn14.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column14.toString();
		tiColumn15.text				= resultXmlFromItem.catalog_item_prices.catalog_item_price.column15.toString();
		
	}
	else
	{
		tiBlankprice.text			= tiBlankprice.defaultValue;
		tiColumn1.text				= tiColumn1.defaultValue;
		tiColumn2.text				= tiColumn2.defaultValue;
		tiColumn3.text				= tiColumn3.defaultValue;
		tiColumn4.text				= tiColumn4.defaultValue;
		tiColumn5.text				= tiColumn5.defaultValue;
		tiColumn6.text				= tiColumn6.defaultValue;
		tiColumn7.text				= tiColumn7.defaultValue;
		tiColumn8.text				= tiColumn8.defaultValue;
		tiColumn9.text				= tiColumn9.defaultValue;
		tiColumn10.text				= tiColumn10.defaultValue;
		tiColumn11.text				= tiColumn11.defaultValue;
		tiColumn12.text				= tiColumn12.defaultValue;
		tiColumn13.text				= tiColumn13.defaultValue;
		tiColumn14.text				= tiColumn14.defaultValue;
		tiColumn15.text				= tiColumn15.defaultValue;
	}
	
}


override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	//tiCode.enabled = false;
	var recordXml:XML    = event.recordXml;
	
	var catalog_items_xml:XML				= XML(recordXml.children()[0].catalog_items);
	if(catalog_items_xml.children().length()>0)
	{
		resultXmlFromItem	= catalog_items_xml.children()[0];
	}
	else
	{
		resultXmlFromItem	= new XML();
	}
	
	//getItemDetails();
	setTiers();
	setColumnValue();
	if(cbapprove_Flag.dataValue=='Y')
	{
		cbapprove_Flag.enabled  = false
	}
	else
	{
		cbapprove_Flag.enabled  = true
	}
}

override protected function resetObjectEventHandler():void
{
	cbapprove_Flag.enabled  	= true
	lblBlank.text				= 'Blank';
	lblTier1.text				= 'Tier1';
	lblTier2.text				= 'Tier2';
	lblTier3.text				= 'Tier3';
	lblTier4.text				= 'Tier4';
	lblTier5.text				= 'Tier5';
	lblTier6.text				= 'Tier6';
	lblTier7.text				= 'Tier7';
	lblTier8.text				= 'Tier8';
	lblTier9.text				= 'Tier9';
	lblTier10.text				= 'Tier10';
	lblTier11.text				= 'Tier11';
	lblTier12.text				= 'Tier12';
	lblTier13.text				= 'Tier13';
	lblTier14.text				= 'Tier14';
	lblTier14.text				= 'Tier15';
	setColumnValue();
}
private function setColumnsOrder():void
{
	/*if(!isColumnsCorrectOrder())
	{
		var lastColumnValue:Number = columnArray.getItemAt(columnIndex).dataValue ;
		for(var i:int=columnIndex;i<columnArray.length;i++)
		{
			columnArray.getItemAt(i).dataValue = lastColumnValue.toString();
		}
	}*/
}


private function isColumnsCorrectOrder():Boolean
{
	columnArray.removeAll();
	columnArray.addItem(tiColumn1);
	columnArray.addItem(tiColumn2);
	columnArray.addItem(tiColumn3);
	columnArray.addItem(tiColumn4);
	columnArray.addItem(tiColumn5);
	columnArray.addItem(tiColumn6);
	columnArray.addItem(tiColumn7);
	columnArray.addItem(tiColumn8);
	columnArray.addItem(tiColumn9);
	columnArray.addItem(tiColumn10);
	columnArray.addItem(tiColumn11);
	columnArray.addItem(tiColumn12);
	columnArray.addItem(tiColumn13);
	columnArray.addItem(tiColumn14);
	columnArray.addItem(tiColumn15);
	
	var returnValue:Boolean = true;
	for(var i:int=0;i<columnArray.length-1;i++)
	{
		if(Number(columnArray.getItemAt(i).dataValue) < Number(columnArray.getItemAt(i+1).dataValue))
		{
			returnValue = false;
			columnIndex	= i;
			break;
		}
	}
	return returnValue;
}

private function setColumnValue():void
{
	if(cbType.dataValue	== '')
	{
		setColumnComponent(true);
	}
	else
	{
		setColumnComponent(false);
	}
}
private function setColumnComponent(flag:Boolean):void
{
	setDefaultpricing();
	
	tiBlankprice.enabled	= flag;
	tiColumn1.enabled		= flag;
	tiColumn2.enabled		= flag;
	tiColumn3.enabled		= flag;
	tiColumn4.enabled		= flag;
	tiColumn5.enabled		= flag;
	tiColumn6.enabled		= flag;
	tiColumn7.enabled		= flag;
	tiColumn8.enabled		= flag;
	tiColumn9.enabled		= flag;
	tiColumn10.enabled		= flag;
	tiColumn11.enabled		= flag;
	tiColumn12.enabled		= flag;
	tiColumn13.enabled		= flag;
	tiColumn14.enabled		= flag;
	tiColumn15.enabled		= flag;
	
}
private function setColumnValueOnRetrieve():void
{
	if(cbType.dataValue	== '')
	{
		tiBlankprice.enabled    = true;
		tiColumn1.enabled		= true;
		tiColumn2.enabled		= true;
		tiColumn3.enabled		= true;
		tiColumn4.enabled		= true;
		tiColumn5.enabled		= true;
		tiColumn6.enabled		= true;
		tiColumn7.enabled		= true;
		tiColumn8.enabled		= true;
		tiColumn9.enabled		= true;
		tiColumn10.enabled		= true;
		tiColumn11.enabled		= true;
		tiColumn12.enabled		= true;
		tiColumn13.enabled		= true;
		tiColumn14.enabled		= true;
		tiColumn15.enabled		= true;
	}
	else
	{
		tiBlankprice.enabled	= false;
		tiColumn1.enabled		= false;
		tiColumn2.enabled		= false;
		tiColumn3.enabled		= false;
		tiColumn4.enabled		= false;
		tiColumn5.enabled		= false;
		tiColumn6.enabled		= false;
		tiColumn7.enabled		= false;
		tiColumn8.enabled		= false;
		tiColumn9.enabled		= false;
		tiColumn10.enabled		= false;
		tiColumn11.enabled		= false;
		tiColumn12.enabled		= false;
		tiColumn13.enabled		= false;
		tiColumn14.enabled		= false;
		tiColumn15.enabled		= false;
	}
}