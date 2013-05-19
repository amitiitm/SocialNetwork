import com.generic.events.ImportEvent;

import model.GenModelLocator;

import mx.controls.Alert;

import valueObjects.ImportVO;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
public var __importObj:ImportVO = __genModel.activeModelLocator.importObj;

private var resultXml:XML		=	new XML(<rows/>);

private var tableNames:Array	=	new Array({tablename:'term'});

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
	var returnVal:int = 0;
	var str:String;
	var tempList:XMLList = dgValues.rows.children();

		for (var i:int = 0 ; i < tempList.length(); i++)
		{
			var _total:Number = 0;
			
			if (tempList[i].length() > 0)
			{
				_total  = 	Number(tempList[i]['pay1_per'].toString())+ Number(tempList[i]['pay2_per'].toString())+ Number(tempList[i]['pay3_per'].toString())+	
							Number(tempList[i]['pay4_per'].toString())+	Number(tempList[i]['pay5_per'].toString())+ Number(tempList[i]['pay6_per'].toString())+	
							Number(tempList[i]['pay7_per'].toString())+ Number(tempList[i]['pay8_per'].toString())+	Number(tempList[i]['pay9_per'].toString())+	
							Number(tempList[i]['pay10_per'].toString())+Number(tempList[i]['pay11_per'].toString())+Number(tempList[i]['pay12_per'].toString())	
				
				if(_total != 100)
				{  var k:int = i+1;
					str = str + k +'\n';
					returnVal= 1;
				}
			}		
		}
	    if(returnVal ==1)
	    {
	    	Alert.show('Total Payment % Should be 100 for following rows'+'\n'+str)
	    }

	var message:XMLList	=	new XMLList(<message/>);
	
	message	=	dgValues.rows.children().(child('message').toString()	!=	'')
	
	if(message.children().length() > 0)
	{
		Alert.show('one or many row has invalid data please correct it.');
		returnVal = 1;	
	}
	
		__importObj.tablenames = tableNames;
		__importObj.records = dgValues.rows;
	
	return returnVal;
}

override protected function retrieveRecordEventHandler(event:ImportEvent):void{}
