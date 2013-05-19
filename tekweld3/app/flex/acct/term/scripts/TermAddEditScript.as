import com.generic.events.AddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiCode.enabled	=	false;
	calculateTotalPer()
}

override protected function resetObjectEventHandler():void
{
	tiCode.enabled	=	true;
	tiPayment1_per.dataValue = '100.00';

	calculateTotalPer()
}

override protected function copyRecordCompleteEventHandler():void
{
	tiCode.dataValue	=	''; 
	calculateTotalPer()
}

private function calculateTotalPer():void
{
	var _totalPer:Number = 0;
			
	_totalPer = Number(tiPayment1_per.dataValue)+ Number(tiPayment2_per.dataValue)+ Number(tiPayment3_per.dataValue)+
			 Number(tiPayment4_per.dataValue)+ Number(tiPayment5_per.dataValue)+ Number(tiPayment6_per.dataValue)+
			 Number(tiPayment7_per.dataValue)+ Number(tiPayment8_per.dataValue)+ Number(tiPayment9_per.dataValue)+
			 Number(tiPayment10_per.dataValue)+ Number(tiPayment11_per.dataValue)+ Number(tiPayment12_per.dataValue);
			 
	tiTotal_per.dataValue = _totalPer.toString();	 
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var returnVal:int = 0;
	var mesg:String = "";
    
    if(Number(tiTotal_per.dataValue) != 100.00)
	{
		returnVal = 1;
		mesg = 'Total Pavment % should be 100'+'\n'
	}
	if(returnVal == 1)
	{
		Alert.show(mesg)
	}
	return returnVal
}
