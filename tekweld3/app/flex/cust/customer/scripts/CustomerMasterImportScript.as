import com.generic.events.ImportEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import model.GenModelLocator;
import mx.controls.Alert;
import valueObjects.ImportVO;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
public var __importObj:ImportVO = __genModel.activeModelLocator.importObj;

private var resultXml:XML		=	new XML(<rows/>);

private var tableNames:Array	=	new Array({tablename:'customer'},{tablename:'shipping'});

private function generateShipXML(tempXml:XML):XML
{
	var	shipXml:XML = new XML(<shippings/>)
	var xml:XML = new XML(<shipping/>)
	       
	xml.serial_no		=	'101'
    xml.trans_flag		=	'A'
	xml.code			=	tempXml.code + ' - Main';
	xml.name			=	tempXml.code + ' - Main';
	xml.contact1		=	tempXml.concact1
	xml.address1		=	tempXml.address1
	xml.address2		=	tempXml.address2
	xml.city			=	tempXml.city
	xml.state			=	tempXml.state
	xml.zip				=	tempXml.zip
	xml.country			=	tempXml.country
	xml.phone1			=	tempXml.phone1
	xml.fax1			=	tempXml.fax1
    
    shipXml.appendChild(xml)		
				
	return shipXml;
}

override protected function downloadCompleteEventHandler(event:ImportEvent):void
{	
	resultXml 	= 	XML(event.recordXml);
	
	var tempList:XMLList = resultXml.children();
	if(tempList.length() > 0)
	{
		for (var i:int = 0 ; i < tempList.length(); i++)
		{
			if (tempList[i].length() > 0)
			{
				tempList[i]['memo_term_code']  	=	tempList[i]['invoice_term_code'].toString();
				tempList[i]['shippings']		=	generateShipXML(tempList[i])
			}		
		}
	}

	dgValues.rows	=	resultXml
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

override protected function preSaveEventHandler(event:ImportEvent):int
{
	var message:XMLList	=	new XMLList(<message/>);
	
	message	=	dgValues.rows.children().(child('message').toString()	!=	'')
	
	if(message.children().length() > 0)
	{
		Alert.show('one or many row has invalid data please correct it.');
		return 1;	
	}
	
		__importObj.tablenames = tableNames;
		__importObj.records = dgValues.rows;
	
	return 0;
}

override protected function retrieveRecordEventHandler(event:ImportEvent):void {}
