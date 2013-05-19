import com.generic.components.Detail;
import com.generic.events.DetailAddEditEvent;
import com.generic.events.DetailEvent;
import com.generic.genclass.URL;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import model.GenModelLocator;
import mx.formatters.NumberFormatter;
import mx.controls.Alert;

import valueObjects.DetailEditVO;

private var resultXml:XML		=	new XML(<rows/>);
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
private var numericFormatter2:NumberFormatter 	= new NumberFormatter();
private var tableNames:Array	=	new Array({tablename:'purchase_order_line'});

private function creationCompleteHandler():void
{
	numericFormatter2.precision = 2;
	numericFormatter2.rounding = "nearest";
	numericFormatter2.useThousandsSeparator = false;
}
	
private function itemClickHandler():void
{
	var message:String	=	XML(dgMain.selectedItem).child('message').toString();
	
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

//it will call after save 
override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	// we will set data in detail grid from here.
 	var __detailEditObj:DetailEditVO	=	__genModel.activeModelLocator.detailEditObj;
		
	__detailEditObj.genDataGrid.rows	=	dgMain.rows;		
	Detail(__detailEditObj.genDataGrid.parentDocument).dispatchEvent(new DetailEvent(DetailEvent.DETAIL_SAVE_IMPORTED_XML_COMPLETE,null,null,null));
}

override protected function downloadCompleteEventHandler(event:DetailAddEditEvent):void
{
	resultXml 	= 	XML(event.rowXml);
	
	if(resultXml.name() == "errors")
	{
		if(resultXml.children().length() > 0) 
		{
			var message:String = '';
	
			for(var i:uint = 0; i < resultXml.children().length(); i++) 
			{
				message += resultXml.children()[i] + "\n";
			}
			Alert.show(message);
		} 
	}
	else
	{
		var temp:XMLList = resultXml.children();
		 if (temp.length() > 0)
		{
			for(var j:int = 0 ; j < temp.length() ; j++)
			{
				temp[j]['discount_amt']  			=   '0.00';
				temp[j]['discount_per'] 			=   '0.00';
				temp[j]['item_amt']  	 			=   numericFormatter2.format(Number(temp[j]['item_price']) * Number(temp[j]['item_qty']));
				temp[j]['net_amt']      			=   numericFormatter2.format(Number(temp[j]['item_price']) * Number(temp[j]['item_qty']));
				temp[j]['store_id']		 			=	__genModel.user.default_company_id.toString()
				temp[j]['item_type']				=	'I';
				temp[j]['packet_require_yn']		=	'N';
				temp[j]['taxable']					=   'Y'; 
				temp[j]['customer_sku_no']			=	''; 
				temp[j]['vendor_sku_no']			= 	'';
				temp[j]['catalog_item_batch_code']	=	'';
				temp[j]['catalog_item_packet_code']	= 	'';
				temp[j]['catalog_item_packet_id']	=	'0';
				temp[j]['trans_flag']				=	'A';
			}
		} 
		dgMain.rows	=	resultXml;							
	}		
}

override protected function  preSaveImportedXMLEventHandler(event:DetailAddEditEvent):int
{
	var message:XMLList	=	new XMLList(<message/>);
	
	message	=	dgMain.rows.children().(child('message').toString()	!=	'')
	
	if(message.children().length() > 0)
	{
		Alert.show('one or many row has invalid data please correct it.');
		return 1;	
	}
	
	var __detailEditObj:DetailEditVO	=	__genModel.activeModelLocator.detailEditObj;
	
	__detailEditObj.tablenames			=	tableNames;
	__detailEditObj.isCallServiceOnSave	=	false;
		
	return 0;
}
private function handleSampleXLS():void
{
	var file_name:String  = 'purchase_order_detail_import.xls'
	var folderName:String = '/sampleformats/';
	
	var urlObj:URL		=	new URL();
	var url:String		=	urlObj.getURL(folderName + file_name) 
		
	var request:URLRequest = new URLRequest(url);
	navigateToURL(request);
}