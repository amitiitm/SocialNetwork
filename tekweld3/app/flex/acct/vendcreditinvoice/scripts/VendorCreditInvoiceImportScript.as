import com.generic.events.ImportEvent;
import model.GenModelLocator;
import mx.controls.Alert;
import valueObjects.ImportVO;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
public var __importObj:ImportVO = __genModel.activeModelLocator.importObj;

private var resultXml:XML		=	new XML(<rows/>);

private var tableNames:Array	=	new Array({tablename:'vendor_payment'});

override protected function downloadCompleteEventHandler(event:ImportEvent):void
{	
	resultXml 	= 	XML(event.recordXml);
	//Alert.show(resultXml)
	dgVendorCreditInvoices.rows	=	resultXml
}

private function clickHandler():void
{
	var message:String	=	XML(dgVendorCreditInvoices.selectedItem).child('message').toString();
	
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
	var returnVal:int = 0;
	var str:String;
	var tempList:XMLList = dgVendorCreditInvoices.rows.children();


	var message:XMLList	=	new XMLList(<message/>);
	
	message	=	dgVendorCreditInvoices.rows.children().(child('message').toString()	!=	'')
	
	if(message.children().length() > 0)
	{
		Alert.show('one or many row has invalid data please correct it.');
		returnVal = 1;	
	}
	
		__importObj.tablenames = tableNames;
		__importObj.records = dgVendorCreditInvoices.rows;
	
	return returnVal;
}

// ActionScript file
