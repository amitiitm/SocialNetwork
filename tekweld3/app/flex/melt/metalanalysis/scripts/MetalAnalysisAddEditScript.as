
import business.events.GetInformationEvent;
import business.events.PreSaveEvent;
import business.events.RecordStatusEvent;

import com.generic.events.AddEditEvent;
import com.generic.genclass.GenValidator;
import com.generic.genclass.TabPage;

import melt.metalanalysis.MetalAnalysisModelLocator;
import melt.metalanalysis.components.MetalAnalysis;

import model.GenModelLocator;

import mx.controls.Alert;

import valueObjects.AddEditVO;

private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:MetalAnalysisModelLocator = (MetalAnalysisModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();


[Embed(source='../../../com/generic/assets/nextbutton.JPG')]
public var nextEnable:Class;

private var nextFlag:int;

private function init():void
{
	MetalAnalysis(this.parentDocument).bcpList.btnAdd.enabled=false;
	
	dtlLine.bcdp.btnImport.width = 0;
	dtlLine.bcdp.btnImport.height = 0;
	
	dtlLine.bcdp.btnImport.visible = false;
	dtlLine.bcdp.btnImport.enabled = false;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiMelting_packet_request_id.dataValue = event.recordXml.children()['melting_packet_request_id'].toString();
	tiCurrent_melting_stage_code.dataValue	=	"METALANALYSIS"
	next.setStyle("icon",nextEnable);
	
	next.enabled = true;
	next.useHandCursor = true;
	
}

private function cbAnalysisStatusChangeHandler():void
{
	
	if(cbAnalysis_status.dataValue == "R")
	{
		tiAccpet_reject_flag.text = "R";			
	}
	else
	{
		tiAccpet_reject_flag.text = "";
	}
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var returnValue:int = 0;
	
	var dgXml:XML = dtlLine.dgDtl.rows;
	var total_pcs:Number = 0;
	var gold_weight:Number = 0;
	
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		gold_weight += Number(dgXml.children()[i]['gold_weight'].toString());
		total_pcs += Number(dgXml.children()[i]['total_pcs'].toString());
	}
	
	if(Number(tiGold_weight.dataValue) != gold_weight || Number(tiTotal_Pcs.dataValue) != total_pcs)
	{
		Alert.show("Gram Weight/Total Pcs should match with detail Gold Weight/Total Pcs");
		returnValue = -1;
	}
	
	nextFlag = returnValue;
	
	return returnValue;
	
}  

public function nextClickHandler():void
{
	var genValidator:GenValidator = new GenValidator();
	var __addEditObj:AddEditVO = __genModel.activeModelLocator.addEditObj;
	var preSaveEvent:PreSaveEvent = new PreSaveEvent();
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("SAVE");
	
	if(!(genValidator.runCustomValidator(__addEditObj.validators) >= 0))
	{
		return;
	}
	else
	{
		preSaveEvent.dispatch();
	}
	
	 if(MetalAnalysis(this.parentDocument).bcpDataEntry.btnSave.enabled)
	{
		if(nextFlag != -1)
		{
			recordStatusEvent.dispatch();
			openNextPage();
		}
	} 
	else
	{
		if(cbAnalysis_status.dataValue != '')
		{
			openNextPage();
		}
	}
}

override protected function resetObjectEventHandler():void
{

}

private function openNextPage():void
{
	var critriaXML:XML					=	new XML(<root>
														<trans_no>{tiTrans_no.dataValue}</trans_no>
														<trans_date>{dfTrans_date.dataValue}</trans_date>
													</root>)

	__genModel.drillObj.drillrow		=	critriaXML
	
	var tabpage:TabPage	=	new TabPage();
	
	if(cbAnalysis_status.dataValue == "A")
	{
		tabpage.openDrillDownPage("melt/calculateoffer/components/CalculateOffer.swf");	
	}
	else if(cbAnalysis_status.dataValue == "R")
	{
		tabpage.openDrillDownPage("melt/returnpacket/components/ReturnPacket.swf");
	}
}