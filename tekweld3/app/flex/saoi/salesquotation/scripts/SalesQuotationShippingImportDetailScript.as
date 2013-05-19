import com.generic.components.Detail;
import com.generic.customcomponents.GenDateField;
import com.generic.events.DetailAddEditEvent;
import com.generic.events.DetailEvent;
import com.generic.events.ImportEvent;
import com.generic.genclass.URL;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;

import valueObjects.DetailEditVO;
import valueObjects.ImportVO;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var numericFormatter2:NumberFormatter 	= new NumberFormatter();
private var numericFormatter3:NumberFormatter 	= new NumberFormatter();

//[Bindable]
//public var __importObj:ImportVO = __genModel.activeModelLocator.importObj;
private function creationCompleteHandler():void
{
	numericFormatter2.precision = 2;
	numericFormatter2.rounding = "nearest";
	numericFormatter2.useThousandsSeparator = false;
	
	numericFormatter3.precision = 3;
	numericFormatter3.rounding = "nearest";
	numericFormatter3.useThousandsSeparator = false;
}
private var resultXml:XML		=	new XML(<rows/>);

private var tableNames:Array	=	new Array({tablename:'sales_order_shippings'});

override protected function downloadCompleteEventHandler(event:DetailAddEditEvent):void
{	
	resultXml 		= 	XML(event.rowXml);
	dgValues.rows	=	resultXml;
}

private function clickHandler():void
{
	var message:String	=	XML(dgValues.selectedItem).child('message').toString();
	
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

override protected function  preSaveImportedXMLEventHandler(event:DetailAddEditEvent):int
{
	var message:XMLList	=	new XMLList(<message/>);
	
	message	=	dgValues.rows.children().(child('message').toString()	!=	'')
	
	if(message.children().length() > 0)
	{
		Alert.show('one or many row has invalid data please correct it.');
		return 1;	
	}
	
	var __detailEditObj:DetailEditVO	=	__genModel.activeModelLocator.detailEditObj;
	__detailEditObj.tablenames			=	tableNames;
	__detailEditObj.isCallServiceOnSave = false;
	__detailEditObj.saveImportedXML		= dgValues.rows;
	
	return 0;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	// we will set data in detail grid from here.
	var __detailEditObj:DetailEditVO		=	__genModel.activeModelLocator.detailEditObj;
	var retrieveXMLList:XMLList				=	event.rowXml.children();
	var rows:XMLList       					= 	retrieveXMLList.rows;
	var shippingXML:XML						=	new XML(<sales_order_shippings/>);
	var xml:XML;
	for(var i:int =0 ; i<rows.children().length(); i++)
	{
		xml	=	new XML(<sales_order_shipping/>)
		
		xml.id								=	'';
		xml.company_id						=	__genModel.user.default_company_id;
		xml.updated_by						=	__genModel.user.userID;
		xml.created_by						=	__genModel.user.userID;
		xml.lock_version					=	0	; 
		
		xml.serial_no						=	i+1;
		xml.ship_name						=	rows.children()[i].ship_name.toString();
		xml.ship_qty						=	rows.children()[i].ship_qty.toString();
		xml.ship_amt						=	rows.children()[i].ship_amt.toString();
		xml.ship_address1					=	rows.children()[i].ship_address1.toString();
		xml.ship_address2					=	rows.children()[i].ship_address2.toString();
		xml.ship_city						=	rows.children()[i].ship_city.toString();
		xml.ship_state						=	rows.children()[i].ship_state.toString();
		xml.ship_zip						=	rows.children()[i].ship_zip.toString();
		xml.ship_country					=	rows.children()[i].ship_country.toString();
		xml.shipping_code					=	rows.children()[i].shipping_method.toString();
		xml.shipvia_accountnumber			=	rows.children()[i].account_no.toString();
		xml.attention						=	rows.children()[i].attention.toString();
		
		xml.ship_date						=	rows.children()[i].ship_date.toString();
		xml.inhand_date						=	rows.children()[i].inhand_date.toString();
		xml.estimated_ship_date				=	new GenDateField().currentDate();
		xml.estimated_arrival_date			=	new GenDateField().currentDate();
		
		xml.ship_via						=	rows.children()[i].ship_via.toString();
		
		if(rows.children()[i].ship_amt.toString()	==	'' || (Number(rows.children()[i].ship_amt.toString())).toString()	==	'NaN')
		{
			xml.ship_amt					=	"0.00";
		}
		else
		{
			xml.ship_amt					=	numericFormatter3.format(rows.children()[i].ship_amt.toString());
		}		
		shippingXML.appendChild(xml);
	} 
	
	__detailEditObj.genDataGrid.rows			=			shippingXML;
	Detail(__detailEditObj.genDataGrid.parentDocument).dispatchEvent(new DetailEvent(DetailEvent.DETAIL_SAVE_IMPORTED_XML_COMPLETE,null,null,null));
}

private function handleSampleXLS():void
{
	var file_name:String = 'sales_order_shippings.xlsx';
	var folderName:String = '/sampleformats/';
	var urlObj:URL		=	new URL();
	var url:String		=	urlObj.getURL(folderName + file_name) 
	
	var request:URLRequest = new URLRequest(url);
	navigateToURL(request);
}
