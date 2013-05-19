import com.generic.events.AddEditEvent;

import melt.printcheck.PrintCheckModelLocator;
import melt.printcheck.components.PrintCheck;
import melt.printcommissioncheck.PrintCommissionCheckModelLocator;

import model.GenModelLocator;

import mx.formatters.DateFormatter;

[Bindable]
private var __localModel:PrintCommissionCheckModelLocator = (PrintCommissionCheckModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var dateFormatter:DateFormatter = new DateFormatter();

private function init():void
{
	PrintCommissionCheck(this.parentDocument).bcpList.btnAdd.enabled=false;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	dateFormatter.formatString = "MM/DD/YYYY";
	
	tiMelting_packet_request_id.dataValue = event.recordXml.children()['melting_packet_request_id'].toString();
	
	if(event.recordXml.children()[0]['commission_check_date'].toString() == "")
	{
		dfCommissionCheckDate.dataValue = dateFormatter.format(new Date());	
	}

	tiCurrent_melting_stage_code.dataValue	=	"PRINTCOMMISSIONCHECK";
}


