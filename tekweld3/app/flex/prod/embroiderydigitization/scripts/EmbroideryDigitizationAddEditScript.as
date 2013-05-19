import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.TabPage;
import com.generic.customcomponents.GenButton;

import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Spacer;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.IResponder;

import prod.embroiderydigitization.EmbroideryDigitizationModelLocator;
import prod.embroiderydigitization.components.EmbroideryDigitization;

import saoi.muduleclasses.PrintObject;



[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:EmbroideryDigitizationModelLocator =  EmbroideryDigitizationModelLocator(__genModel.activeModelLocator);

[Embed("com/generic/assets/btn_print_pick_slip.png")]
private const printPickSlipButtonIcon:Class;
[Embed("com/generic/assets/btn_answer_queries.png")]
private const queriesAnswerSlipButtonIcon:Class;

private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var colName:String;
	var rowIndex:int;
	colName = event.object.id
	rowIndex = event.currentTarget.editBarRowPosition;
	
	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["send_digitization_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["send_digitization_flag"] = 'N';
	}
	
	if(colName == "vendor_code")
	{
		if(event.object.text != null && event.object.text != '')
		{
			inbox.focusedRow["vendor_id"]	 = event.object.dataValue;
			inbox.focusedRow["vendor_code"]	 = event.object.labelValue;
		}
		else
		{
			inbox.focusedRow["vendor_id"]	 = ''
			inbox.focusedRow["vendor_code"]	 = ''
		}
	}

}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["vendor_id"] == '')
			{
				retValue = -1;
				Alert.show("Please Enter Vendor");
				break
			}						
		}	
	}
	return retValue;
}
private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	hb.setStyle('horizontalGap' , 10);
	
	var btnQueriesAnswerSlip:Button        			= new Button();
	btnQueriesAnswerSlip.height						= 20;
	btnQueriesAnswerSlip.label						= "ANSWER QUERIES";
	btnQueriesAnswerSlip.styleName					= "promoButton";
	//btnQueriesAnswerSlip.setStyle('icon' , queriesAnswerSlipButtonIcon);
	btnQueriesAnswerSlip.addEventListener(MouseEvent.CLICK,answerQueriesHandler);

	
	var space:Spacer	 = new Spacer();
	space.width			 = 200;
	
	hb.addChild(space);
	hb.addChild(btnQueriesAnswerSlip);
	
	
	EmbroideryDigitization(this.parentDocument).bcp.addChildAt(hb,7);
}
private function answerQueriesHandler(event:MouseEvent):void
{
	if(inbox.selectedRows.children().length()==1)
	{
		__genModel.drillObj.drillrow					=	inbox.selectedRows.children()[0];
		
		__localModel.listObj.drilldown_component_code   = "saoi/artworkquery/components/ArtworkQuery.swf"	
			
		var tabpage:TabPage	=	new TabPage();
		tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
	}
	else
	{
		Alert.show("Please select one record");
	}
	
}
private function genratePickSlipHandler(event:MouseEvent):void
{
	new PrintObject().genratePickSlipHandler(inbox);
}