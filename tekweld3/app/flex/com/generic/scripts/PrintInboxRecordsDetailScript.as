// ActionScript file
import business.events.PreSaveEvent;
import business.events.PrintEvent;
import business.events.PrintRecordsEvent;

import flash.events.KeyboardEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.managers.PopUpManager;

private var printEvent:PrintEvent;	
private var printRecordsEvent:PrintRecordsEvent;
private var preSaveEvent:PreSaveEvent;
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
public var sourceButton:String = 'PRINT';

private function creationCompleteHandler():void
{
	this.setFocus();
	this.x = (this.screen.width - this.width) / 3;
	this.y =  (this.screen.height - this.height) / 3; 
}
public function setValues(aXML:XML):void
{
	rdoRecords.selected	=	true;
	rdoList.enabled		=	false;
	btnCancel.visible	=	false;
	
	var value:String		=	'';
	var dataField:String	=	'trans_no';
	for(var i:int = 0 ; i < aXML.children().length() ; i++)
	{
		if(value != '')
		{
			value	=	value + ',' + XML(aXML.children()[i]).child(dataField).toString()	;
		}
		else
		{
			value	=	XML(aXML.children()[i]).child(dataField).toString();
		}		
	}
	ti_trans_no_multipal.dataValue	=	value;
}
private function btnOKClickHandler():void
{
	switch(String(rdogroupPrint.selectedValue).toUpperCase())
	{
		case  'LIST' 	:
							printEvent = new PrintEvent();
							printEvent.dispatch();
							btnCancelClickHandler()
							break;
							
		case  'RECORDS' :	if(sourceButton == 'SAVE' && ckSaveAndPrint.selected == true)
							{
								preSaveEvent = new PreSaveEvent();
								preSaveEvent.dispatch();
								
								var xml:XML = new XML(<params>
								  						<from_trans_no>{ti_trans_no_from.text}</from_trans_no>
								  						<to_trans_no>{ti_trans_no_to.text}</to_trans_no>
								  						<in_trans_no>{ti_trans_no_multipal.text}</in_trans_no>
													 </params>)
								printRecordsEvent	=	new PrintRecordsEvent(xml);
								printRecordsEvent.dispatch();
							}
							else if (sourceButton == 'SAVE' && ckSaveAndPrint.selected == false)
							{
								preSaveEvent = new PreSaveEvent();
								preSaveEvent.dispatch();
							}
							else if(sourceButton == 'PRINT')
							{
								
								var xml:XML = new XML(<params>
								  						<from_trans_no>{ti_trans_no_from.text}</from_trans_no>
								  						<to_trans_no>{ti_trans_no_to.text}</to_trans_no>
								  						<in_trans_no>{ti_trans_no_multipal.text}</in_trans_no>
													 </params>)
								printRecordsEvent	=	new PrintRecordsEvent(xml);
								printRecordsEvent.dispatch();
							}
							else
							{
								Alert.show('something is wrong');
							}
							
							btnCancelClickHandler()
							break;
		default			:	Alert.show('Please Select Print Type');					
	}
	
}
private function btnCancelClickHandler():void
{
	this.parentApplication.focusManager.activate();
	PopUpManager.removePopUp(this);	
}
private function detailKeyDownHandler(event:KeyboardEvent):void
{
	//it is needed otherwise keydown at application level will also work.

	var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();	
	
	if(event.ctrlKey &&  char != 'V')// we donot want to stop event when user press  ctrl + V(paste),so we cannot take ctrl + V as shortcust now 
	{
		event.stopImmediatePropagation();
		event.stopPropagation();
	}	

}