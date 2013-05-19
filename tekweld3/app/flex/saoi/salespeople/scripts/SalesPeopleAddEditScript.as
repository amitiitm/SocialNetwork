import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;

import flash.events.Event;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;
import mx.validators.RegExpValidator;

import saoi.salespeople.SalesPeopleModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:SalesPeopleModelLocator = (SalesPeopleModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiCode.enabled	=	false;
}

override protected function resetObjectEventHandler():void
{
	tiCode.enabled	=	true;
}


private function init():void
{
	var equipment_flag:String = __genModel.masterData.child('saoi').equipment_flag.value.toString();
	
	if(equipment_flag == 'N')
	{
		tnDetail.removeChildAt(2);
	}
}
private function OnInvalidPassword(event:Event):void
{
	var validator:RegExpValidator = event.target as RegExpValidator;
	//Alert.show(validator.noMatchError.toString());
}