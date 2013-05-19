import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.generic.components.DetailEdit;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.DetailAddEditEvent;
import com.generic.events.GenTextInputEvent;

import flash.events.Event;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.core.Application;
import mx.events.ListEvent;
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.rpc.IResponder;

import saoi.muduleclasses.CommonMooduleFunctions;
import saoi.muduleclasses.OptionsSetupChargeCalculation;
import saoi.sendmultipleartworktocustomer.SendMultipleArtworkToCustomerModelLocator;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:SendMultipleArtworkToCustomerModelLocator = (SendMultipleArtworkToCustomerModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var item_detail:GetInformationEvent;
private var optionsSetupChargeCalculation:OptionsSetupChargeCalculation	= 	new OptionsSetupChargeCalculation();

public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	
	dfTrans_date.dataValue = __localModel.trans_date;
	setAllEnableFalse();
	
}

private function setAllEnableFalse():void
{
	DetailEdit(this.parentDocument).bcp.btnAdd.visible = false;
	DetailEdit(this.parentDocument).bcp.btnSave.visible = false;
	DetailEdit(this.parentDocument).bcp.btnCancel.visible = false;
	DetailEdit(this.parentDocument).bcp.btnCopyRow.visible = false;
	
	DetailEdit(this.parentDocument).bcp.btnAdd.includeInLayout = false;
	DetailEdit(this.parentDocument).bcp.btnSave.includeInLayout = false;
	DetailEdit(this.parentDocument).bcp.btnCancel.includeInLayout = false;
	DetailEdit(this.parentDocument).bcp.btnCopyRow.includeInLayout = false;
	
	DetailEdit(this.parentDocument).vbAddEdit.enabled = false;
	DetailEdit(this.parentDocument).vbAddEdit.setStyle('disabledOverlayAlpha','0.0');
}


private function getItemDetails():void
{
	 if(dcItemId.text != null && dcItemId.text != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailHandler, null);
		item_detail	=	new GetInformationEvent('item_detail_sample_order', callbacks, dcItemId.dataValue);
		item_detail.dispatch(); 
		
	}
	setItemCost();
}

private function getItemDetailHandler(resultXml:XML):void
{
	tiItemCode.dataValue 			= resultXml.code;
	tiItemPrice.dataValue			= resultXml.cost;
	cbUnit.dataValue	 			= resultXml.unit;
	taItemDescription.dataValue 	= resultXml.description;
	tiImage_thumnail.text 			= resultXml.image_thumnail;
	tiType.dataValue				= resultXml.item_type;
}


private function setItemCost():void
{
	tiAmount.dataValue = (Number(tiItemPrice.dataValue)*Number(tiItemQty.dataValue)).toString();
}

override protected function resetObjectEventHandler():void
{
	//tiQty.enabled = true;
	//tiCatalog_item_packet_code.enabled = true;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	var rowXml:XML		= event.rowXml.copy();
	dgItemOptions.seprateRows();                             // it seprate rows and deleteRows becouse grid all rows deleted rows as well as rows  
	
	new CommonMooduleFunctions().setDisableOptions(vbMain,XML(rowXml.sales_order_attributes_values).copy());
}
