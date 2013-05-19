import business.events.GetInformationEvent;

import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.rpc.IResponder;

private function creationCompleteHandler():void {}

private var __genModel:GenModelLocator  = GenModelLocator.getInstance();
private var getInformationEvent:GetInformationEvent;
private var getInvnAndSetupItem:GetInformationEvent;
private var currentRowXml:XML = new XML();

private function setItemDataProvider():void
{
	var callbacks:IResponder	=	new mx.rpc.Responder(getInvnAndSetupItemHandler, null);
	getInvnAndSetupItem			=	new GetInformationEvent('fetch_invn_and_setup_item', callbacks);
	getInvnAndSetupItem.dispatch();
	

}
private function getInvnAndSetupItemHandler(resultXml:XML):void
{
	var result:XML 			= resultXml.copy();
	//dcItem_id.dataProvider  = result.children();
	dcItem_id.dataValue		= '';
	
	
	dcItem_id.dataValue	= currentRowXml.catalog_item_id.toString();
	setColumnValueOnRetrieve();
	setToolTip();
	//setColumnValue();
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	//setItemDataProvider();
	currentRowXml = event.rowXml;
	/* dcItem_id.dataValue	= event.rowXml.catalog_item_id.toString();
	setToolTip();
	setColumnValue(); */
}

override protected function resetObjectEventHandler():void
{
	//setItemDataProvider();
	currentRowXml = new XML();
	tiColumn1.toolTip	=  	"column1";
	tiColumn2.toolTip 	=  	"column2";
	tiColumn3.toolTip 	=  	"column3";
	tiColumn4.toolTip	=  	"column4";
	tiColumn5.toolTip 	= 	"column5";
	tiColumn6.toolTip 	=  	"column6";
	tiColumn7.toolTip 	= 	"column7";
	tiColumn8.toolTip 	=  	"column8";
	tiColumn9.toolTip 	=   "column9";
	tiColumn10.toolTip 	=  	"column10";
	tiColumn11.toolTip 	=  	"column11";
	tiColumn12.toolTip 	= 	"column12";
	tiColumn13.toolTip 	=  	"column13";
	tiColumn14.toolTip 	=   "column14";
	tiColumn15.toolTip 	=  	"column15";
}

private function setToolTip():void
{
	if(dcItem_id.text != "" && dcItem_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(itemColumnDetailsHandler, null);
		getInformationEvent			=	new GetInformationEvent('item_column_detail', callbacks, dcItem_id.dataValue);
		getInformationEvent.dispatch();
	}

}

private function itemColumnDetailsHandler(resultXml:XML):void
{
	
	var xmllist:XMLList = resultXml.catalog_item; 
	
	tiColumn1.toolTip	=  	xmllist.column1.toString();
	tiColumn2.toolTip 	=  	xmllist.column2.toString();
	tiColumn3.toolTip 	=  	xmllist.column3.toString();
	tiColumn4.toolTip	=  	xmllist.column4.toString();
	tiColumn5.toolTip 	=  	xmllist.column5.toString();
	tiColumn6.toolTip 	=  	xmllist.column6.toString();
	tiColumn7.toolTip 	=  	xmllist.column7.toString();
	tiColumn8.toolTip 	=  	xmllist.column8.toString();
	tiColumn9.toolTip 	=  	xmllist.column9.toString();
	tiColumn10.toolTip 	=  	xmllist.column10.toString();
	tiColumn11.toolTip 	=  	xmllist.column11.toString();
	tiColumn12.toolTip 	=  	xmllist.column12.toString();
	tiColumn13.toolTip 	=  	xmllist.column13.toString();
	tiColumn14.toolTip 	=  	xmllist.column14.toString();
	tiColumn15.toolTip 	=  	xmllist.column15.toString();
}

private function setItemCode():void
{
	tiItem_Code.dataValue	=	dcItem_id.labelValue
	setToolTip();
}
private function setColumnValue():void
{
	if(cbCharge_Code.dataValue	== '')
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
	tiBlankprice.dataValue	= tiBlankprice.defaultValue;
	tiColumn1.dataValue		= tiColumn1.defaultValue;
	tiColumn2.dataValue		= tiColumn2.defaultValue;
	tiColumn3.dataValue		= tiColumn3.defaultValue;
	tiColumn4.dataValue		= tiColumn4.defaultValue;
	tiColumn5.dataValue		= tiColumn5.defaultValue;
	tiColumn6.dataValue		= tiColumn6.defaultValue;
	tiColumn7.dataValue		= tiColumn7.defaultValue;
	tiColumn8.dataValue		= tiColumn8.defaultValue;
	tiColumn9.dataValue		= tiColumn9.defaultValue;
	tiColumn10.dataValue	= tiColumn10.defaultValue;
	tiColumn11.dataValue	= tiColumn11.defaultValue;
	tiColumn12.dataValue	= tiColumn12.defaultValue;
	tiColumn13.dataValue	= tiColumn13.defaultValue;
	tiColumn14.dataValue	= tiColumn14.defaultValue;
	tiColumn15.dataValue	= tiColumn15.defaultValue;
	
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
	if(cbCharge_Code.dataValue	== '')
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



