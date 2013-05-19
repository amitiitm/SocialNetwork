// ActionScript file
import business.events.PrintEvent;
import business.events.PrintRecordsEvent;

import mx.controls.Alert;
import mx.managers.PopUpManager;

private var printEvent:PrintEvent;	
private var printRecordsEvent:PrintRecordsEvent;

private function creationCompleteHandler():void
{
	this.setFocus();
	this.x = (this.screen.width - this.width) / 3;
	this.y =  (this.screen.height - this.height) / 3; 
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
		case  'RECORDS' :
							var xml:XML = new XML(<params>
								  						<from_trans_no>{ti_trans_no_from.text}</from_trans_no>
								  						<to_trans_no>{ti_trans_no_to.text}</to_trans_no>
								  						<in_trans_no>{ti_trans_no_multipal.text}</in_trans_no>
													 </params>)
							printRecordsEvent	=	new PrintRecordsEvent(xml);
							printRecordsEvent.dispatch();
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