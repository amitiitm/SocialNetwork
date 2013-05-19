import com.generic.events.ImportEvent;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import mx.controls.Alert;

import model.GenModelLocator;
import valueObjects.ImportVO;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
public var __importObj:ImportVO = __genModel.activeModelLocator.importObj;

private var resultXml:XML		=	new XML(<rows/>);

private var tableNames:Array	=	new Array({tablename:'catalog_item_category'});

override protected function downloadCompleteEventHandler(event:ImportEvent):void
{	
	resultXml 	= 	XML(event.recordXml);
	//Alert.show(resultXml)
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

override protected function retrieveRecordEventHandler(event:ImportEvent):void{}
