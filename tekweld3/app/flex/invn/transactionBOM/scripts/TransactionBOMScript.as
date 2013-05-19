import business.events.QuickDetailUpdateEvent;
import business.events.RecordStatusEvent;

import com.generic.events.GenComponentEvent;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function creationCompleteHandler():void
{
	resetDeletedRows();
}

private function resetDeletedRows():void
{
	dtlCasting.deletedRows	=	new XML(<catalog_item_castings/>);
	dtlFinding.deletedRows	=	new XML(<catalog_item_findings/>);
	dtlDiamond.deletedRows	=	new XML(<catalog_item_diamonds/>);
	dtlStone.deletedRows	=	new XML(<catalog_item_stones/>);
	dtlLabor.deletedRows	=	new XML(<catalog_item_others/>);
}

private function resetRows():void
{
	dtlCasting.rows	=	new XML(<catalog_item_castings/>);
	dtlFinding.rows	=	new XML(<catalog_item_findings/>);
	dtlDiamond.rows	=	new XML(<catalog_item_diamonds/>);
	dtlStone.rows	=	new XML(<catalog_item_stones/>);
	dtlLabor.rows	=	new XML(<catalog_item_others/>);
}

private function btnUpdateBOMClickEvent():void
{
	__genModel.detailUpdateObj.gencomponent = this;
		
	var quickDetailUpdateEvent:QuickDetailUpdateEvent = new QuickDetailUpdateEvent("jewelry")
	quickDetailUpdateEvent.dispatch();	 	
	

}	

private function setValue():void
{
	tiGold_base_rate.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['gold_base_rate'].toString();
	tiGold_surcharge.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['gold_surcharge'].toString();
	tiGold_total_rate.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['gold_total_rate'].toString();
	tiGold_mu.dataValue					=	__genModel.detailUpdateObj.value.children()[0]['gold_mu'].toString();
	
	tiMm_size.dataValue					=	__genModel.detailUpdateObj.value.children()[0]['mm_size'].toString();
	cbSize_unit.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['size_unit'].toString();
	cbProduction_type.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['production_type'].toString();
	
	tiSilver_base_rate.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['silver_base_rate'].toString();
	tiSilver_surcharge.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['silver_surcharge'].toString();
	tiSilver_total_rate.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['silver_total_rate'].toString();
	tiSilver_mu.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['silver_mu'].toString();
	
	tiPlatinum_base_rate.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['platinum_base_rate'].toString();
	tiPlatinum_surcharge.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['platinum_surcharge'].toString();
	tiPlatinum_total_rate.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['platinum_total_rate'].toString();
	tiPlatinum_mu.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['platinum_mu'].toString();
	
	tiPalladium_base_rate.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['palladium_base_rate'].toString();
	tiPalladium_surcharge.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['palladium_surcharge'].toString();
	tiPalladium_total_rate.dataValue	=	__genModel.detailUpdateObj.value.children()[0]['palladium_total_rate'].toString();
	tiPalladium_mu.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['palladium_mu'].toString();
	
	
	tiCasting_type.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['casting_type'].toString();
	tiCasting_color.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['casting_color'].toString();
	tiCasting_wt.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['casting_wt'].toString();
	tiCasting_unit.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['casting_unit'].toString();
	tiCasting_cost.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['casting_cost'].toString();
	tiFinding_type.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['finding_type'].toString();
	tiFinding_color.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['finding_color'].toString();
	tiFinding_wt.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['finding_wt'].toString();
	tiFinding_unit.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['finding_unit'].toString();
	tiFinding_cost.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['finding_cost'].toString();
	tiDiamond_qlty.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['diamond_qlty'].toString();
	tiDiamond_wt.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['diamond_wt'].toString();
	tiDiamond_cost.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['diamond_cost'].toString();
	tiColor_stone_type.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['color_stone_type'].toString();
	tiColor_stone_shape.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['color_stone_shape'].toString();
	tiColor_stone_wt.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['color_stone_wt'].toString();
	tiColor_stone_cost.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['color_stone_cost'].toString();
	tiCenter_stone_type.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['center_stone_type'].toString();
	tiCenter_stone_shape.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['center_stone_shape'].toString();
	tiCenter_stone_qlty.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['center_stone_qlty'].toString();
	tiCenter_stone_cost.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['center_stone_cost'].toString();
	tiSurcharge_per.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['surcharge_per'].toString();
	tiSurcharge_amt.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['surcharge_amt'].toString();
	tiSettinglabor_cost.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['settinglabor_cost'].toString();
	tiVendor_po_cost.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['vendor_po_cost'].toString();
	tiFinishing_labor_cost.dataValue	=	__genModel.detailUpdateObj.value.children()[0]['finishing_labor_cost'].toString();
	tiOther_cost.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['other_cost'].toString();
	tiDiscount_per.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['discount_per'].toString();
	tiDiscount_amt.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['discount_amt'].toString();
	tiSubTotal_cost.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['subtotal_cost'].toString();
	tiDuty_per.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['duty_per'].toString();
	tiDuty_amt.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['duty_amt'].toString();
	tiVendor_fixed_cost.dataValue		=	__genModel.detailUpdateObj.value.children()[0]['vendor_fixed_cost'].toString();
	tiGold_increment.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['gold_increment'].toString();
	tiTotal_cost.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['total_cost'].toString();
	
	tiImage_Thumnail.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['image_thumnail'].toString();
	tiImage_Small.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['image_small'].toString();
	tiImage_Normal.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['image_normal'].toString();
	tiImage_Enlarge.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['image_enlarge'].toString();
	tiSketch_image1.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['sketch_image1'].toString();
	tiSketch_image2.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['sketch_image2'].toString();
	tiSketch_image3.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['sketch_image3'].toString();

	tiStore_code.dataValue					=	__genModel.detailUpdateObj.value.children()[0]['store_code'].toString();
	tiWeb_code.dataValue					=	__genModel.detailUpdateObj.value.children()[0]['web_code'].toString();
	dcCatalog_item_category_id.dataValue	=	__genModel.detailUpdateObj.value.children()[0]['catalog_item_category_id'].toString();
	tiName.dataValue						=	__genModel.detailUpdateObj.value.children()[0]['name'].toString();
	dfItem_Date.dataValue					=	__genModel.detailUpdateObj.value.children()[0]['item_date'].toString();
	tiJewelry_design_flag.dataValue			=	__genModel.detailUpdateObj.value.children()[0]['jewelry_design_flag'].toString();

	tiLength.dataValue					=	__genModel.detailUpdateObj.value.children()[0]['length'].toString();
	tiBreadth.dataValue					=	__genModel.detailUpdateObj.value.children()[0]['breadth'].toString();
	tiHeight.dataValue					=	__genModel.detailUpdateObj.value.children()[0]['height'].toString();
	tiSizeCountry.dataValue				=	__genModel.detailUpdateObj.value.children()[0]['size_country'].toString();
	tiTransaction_bom_id.dataValue		= 	__genModel.detailUpdateObj.value.children()[0]['transaction_bom_id'].toString();
	tiPrice.dataValue					=   __genModel.detailUpdateObj.value.children()[0]['price'].toString();
	tiRetail_price.dataValue			=   __genModel.detailUpdateObj.value.children()[0]['retail_price'].toString();
	
	updateCasting();
	updateFinding();
	updateDiamond();
	updateStone();
	updateLabor();
	setImage();
	
}

private function resetValue():void
{
	tiGold_base_rate.dataValue			=	tiGold_base_rate.defaultValue;
	tiGold_surcharge.dataValue			=	tiGold_surcharge.defaultValue;
	tiGold_total_rate.dataValue			=	tiGold_total_rate.defaultValue;
	tiGold_mu.dataValue					=	tiGold_mu.defaultValue;
	
	tiMm_size.dataValue					=	tiMm_size.defaultValue;
	cbProduction_type.dataValue			=	cbProduction_type.defaultValue;
	
	tiSilver_base_rate.dataValue		=	tiSilver_base_rate.defaultValue;
	tiSilver_surcharge.dataValue		=	tiSilver_surcharge.defaultValue;
	tiSilver_total_rate.dataValue		=	tiSilver_total_rate.defaultValue
	tiSilver_mu.dataValue				=	tiSilver_mu.defaultValue
	
	tiPlatinum_base_rate.dataValue		=	tiPlatinum_base_rate.defaultValue;
	tiPlatinum_surcharge.dataValue		=	tiPlatinum_surcharge.defaultValue;
	tiPlatinum_total_rate.dataValue		=	tiPlatinum_total_rate.defaultValue
	tiPlatinum_mu.dataValue				=	tiPlatinum_mu.defaultValue
	
	tiPalladium_base_rate.dataValue		=	tiPalladium_base_rate.defaultValue
	tiPalladium_surcharge.dataValue		=	tiPalladium_surcharge.defaultValue
	tiPalladium_total_rate.dataValue	=	tiPalladium_total_rate.defaultValue
	tiPalladium_mu.dataValue			=	tiPalladium_mu.defaultValue
	
	
	tiCasting_type.dataValue			=	tiCasting_type.defaultValue
	tiCasting_color.dataValue			=	tiCasting_color.defaultValue
	tiCasting_wt.dataValue				=	tiCasting_wt.defaultValue
	tiCasting_unit.dataValue			=	tiCasting_unit.defaultValue
	tiCasting_cost.dataValue			=	tiCasting_unit.defaultValue
	tiFinding_type.dataValue			=	tiFinding_type.defaultValue
	tiFinding_color.dataValue			=	tiFinding_color.defaultValue
	tiFinding_wt.dataValue				=	tiFinding_wt.defaultValue
	tiFinding_unit.dataValue			=	tiFinding_unit.defaultValue
	tiFinding_cost.dataValue			=	tiFinding_cost.defaultValue
	tiDiamond_qlty.dataValue			=	tiDiamond_qlty.defaultValue
	tiDiamond_wt.dataValue				=	tiDiamond_wt.defaultValue;
	tiDiamond_cost.dataValue			=	tiDiamond_cost.defaultValue;
	tiColor_stone_type.dataValue		=	tiColor_stone_type.defaultValue
	tiColor_stone_shape.dataValue		=	tiColor_stone_shape.defaultValue
	tiColor_stone_wt.dataValue			=	tiColor_stone_wt.defaultValue
	tiColor_stone_cost.dataValue		=	tiColor_stone_cost.defaultValue
	tiCenter_stone_type.dataValue		=	tiCenter_stone_type.defaultValue
	tiCenter_stone_shape.dataValue		=	tiCenter_stone_shape.defaultValue
	tiCenter_stone_qlty.dataValue		=	tiCenter_stone_qlty.defaultValue
	tiCenter_stone_cost.dataValue		=	tiCenter_stone_cost.defaultValue
	tiSurcharge_per.dataValue			=	tiSurcharge_per.defaultValue
	tiSurcharge_amt.dataValue			=	tiSurcharge_amt.defaultValue
	tiSettinglabor_cost.dataValue		=	tiSettinglabor_cost.defaultValue
	tiVendor_po_cost.dataValue			=	tiVendor_po_cost.defaultValue
	tiFinishing_labor_cost.dataValue	=	tiFinishing_labor_cost.defaultValue
	tiOther_cost.dataValue				=	tiOther_cost.defaultValue
	tiDiscount_per.dataValue			=	tiDiscount_per.defaultValue
	tiDiscount_amt.dataValue			=	tiDiscount_amt.defaultValue
	tiSubTotal_cost.dataValue			=	tiSubTotal_cost.defaultValue
	tiDuty_per.dataValue				=	tiDuty_per.defaultValue
	tiDuty_amt.dataValue				=	tiDuty_amt.defaultValue
	tiVendor_fixed_cost.dataValue		=	tiVendor_fixed_cost.defaultValue
	tiGold_increment.dataValue			=	tiGold_increment.defaultValue
	tiTotal_cost.dataValue				=	tiTotal_cost.defaultValue
	
	tiImage_Thumnail.dataValue			=	tiImage_Thumnail.defaultValue
	tiImage_Small.dataValue				=	tiImage_Small.defaultValue
	tiImage_Normal.dataValue			=	tiImage_Normal.defaultValue
	tiImage_Enlarge.dataValue			=	tiImage_Enlarge.defaultValue
	tiSketch_image1.dataValue			=	tiSketch_image1.defaultValue
	tiSketch_image2.dataValue			=	tiSketch_image2.defaultValue
	tiSketch_image3.dataValue			=	tiSketch_image3.defaultValue

	tiStore_code.dataValue					=	tiStore_code.defaultValue
	tiWeb_code.dataValue					=	tiWeb_code.defaultValue
	dcCatalog_item_category_id.dataValue	=	dcCatalog_item_category_id.defaultValue
	tiName.dataValue						=	tiName.defaultValue
	dfItem_Date.dataValue					=	dfItem_Date.defaultValue
	tiTransaction_bom_id.dataValue			= 	tiTransaction_bom_id.defaultValue;
	tiPrice.dataValue						=   tiPrice.defaultValue;
	tiRetail_price.dataValue 				=  	tiRetail_price.defaultValue;
	resetRows();
}


private function updateLabor():void
{
	var otherXML:XML	=	XML(__genModel.detailUpdateObj.value.children()[0]['catalog_item_others']);
	
	for(var count:int = 0 ; count < otherXML.children().length() ; count++)
	{
		if(otherXML.children()[count].hasOwnProperty('trans_flag'))
		{
			if(otherXML.children()[count].trans_flag	==	"D")
			{
				dtlLabor.deletedRows.appendChild(XML(otherXML.children()[count]).copy());	
				delete 	otherXML.children()[count];
			}
		}
	}
	dtlLabor.rows	=			otherXML;		
}

private function updateStone():void
{
	var stoneXML:XML	=	XML(__genModel.detailUpdateObj.value.children()[0]['catalog_item_stones']);
	
	for(var count:int = 0 ; count < stoneXML.children().length() ; count++)
	{
		if(stoneXML.children()[count].hasOwnProperty('trans_flag'))
		{
			if(stoneXML.children()[count].trans_flag	==	"D")
			{
				dtlStone.deletedRows.appendChild(XML(stoneXML.children()[count]).copy());	
				delete 	stoneXML.children()[count];
			}
		}
	}
	dtlStone.rows	=			stoneXML;
}

private function updateDiamond():void
{
	var diamondXML:XML	=		XML(__genModel.detailUpdateObj.value.children()[0]['catalog_item_diamonds']);
	
	for(var count:int = 0 ; count < diamondXML.children().length() ; count++)
	{
		if(diamondXML.children()[count].hasOwnProperty('trans_flag'))
		{
			if(diamondXML.children()[count].trans_flag	==	"D")
			{
				dtlDiamond.deletedRows.appendChild(XML(diamondXML.children()[count]).copy());	
				delete 	diamondXML.children()[count];
			}
		}
	}
	dtlDiamond.rows	=			diamondXML;	
}

private function updateFinding():void
{
	var findingXML:XML	=		XML(__genModel.detailUpdateObj.value.children()[0]['catalog_item_findings']);
	
	for(var count:int = 0 ; count < findingXML.children().length() ; count++)
	{
		if(findingXML.children()[count].hasOwnProperty('trans_flag'))
		{
			if(findingXML.children()[count].trans_flag	==	"D")
			{
				dtlFinding.deletedRows.appendChild(XML(findingXML.children()[count]).copy());	
				delete 	findingXML.children()[count];
			}
		}
	}
	dtlFinding.rows	=			findingXML;	
}

private function updateCasting():void
{
	var castingXML:XML		=	XML(__genModel.detailUpdateObj.value.children()[0]['catalog_item_castings']);
	
	for(var count:int = 0 ; count < castingXML.children().length() ; count++)
	{
		if(castingXML.children()[count].hasOwnProperty('trans_flag'))
		{
			if(castingXML.children()[count].trans_flag	==	"D")
			{
				dtlCasting.deletedRows.appendChild(XML(castingXML.children()[count]).copy());	
				delete 	castingXML.children()[count];
			}
		}
	}
	dtlCasting.rows	=	castingXML;
}

private function setImage():void
{
	imageThumnail.source = __genModel.path.image + tiImage_Thumnail.dataValue;	
	imageSmall.source 	 = __genModel.path.image + tiImage_Small.dataValue;	
	imageNormal.source   = __genModel.path.image + tiImage_Normal.dataValue;	
	imageEnlarge.source  = __genModel.path.image + tiImage_Enlarge.dataValue;	
	image1Sketch1.source = __genModel.path.image + tiSketch_image1.dataValue;	
	image1Sketch2.source = __genModel.path.image + tiSketch_image2.dataValue;	
	image1Sketch3.source = __genModel.path.image + tiSketch_image3.dataValue;	
		
}
override protected function valueUpdateHandler(event:GenComponentEvent):void
{
	var recordStatusEvent:RecordStatusEvent;

	var tempXMLList:XMLList		=	XML(event.value)..transaction_bom_id
			
	for(var i:int= 0 ; i< tempXMLList.length() ; i++)
	{
		tempXMLList[i]	=	'';
	}
	
	tempXMLList		=	XML(event.value)..id
	
	for(var i:int= 0 ; i< tempXMLList.length() ; i++)
	{
		tempXMLList[i]	=	'';
	}
	
	//event.value.children()[0]['transaction_bom_id'] = '';		// set transaction bom id null when BOM updates.
	
	if(__genModel.activeModelLocator.hasOwnProperty('update_bom'))
	{
		if(__genModel.activeModelLocator.update_bom)
		{
			btnUpdateBOM.enabled = true;
		}
		else
		{
			
		}
	}
	else
	{
		btnUpdateBOM.enabled = true;	
	}	

	__genModel.detailUpdateObj.gencomponent = this;
	__genModel.detailUpdateObj.value = event.value;
	setValue();
	
	recordStatusEvent = new	RecordStatusEvent("MODIFY")
	recordStatusEvent.dispatch()
}

override protected function retrieveEndHandler(event:GenComponentEvent):void
{

	if(__genModel.activeModelLocator.hasOwnProperty('update_bom'))
	{
		if(__genModel.activeModelLocator.update_bom)
		{
			btnUpdateBOM.enabled = true;
		}
		else
		{
			
		}
	}
	else
	{
		btnUpdateBOM.enabled = true;	
	}	


	__genModel.detailUpdateObj.gencomponent = this;
	__genModel.detailUpdateObj.value = event.value;
	setValue();
}

override protected function resetHandler(event:GenComponentEvent):void
{

	if(__genModel.activeModelLocator.hasOwnProperty('update_bom'))
	{
		if(__genModel.activeModelLocator.update_bom)
		{
			btnUpdateBOM.enabled = false;
		}
		else
		{
			
		}
	}
	else
	{
		btnUpdateBOM.enabled = false;	
	}	

	__genModel.detailUpdateObj.gencomponent = this;
	__genModel.detailUpdateObj.value = event.value;
	resetValue();
}

override protected function makeDisableEventHandler(event:GenComponentEvent):void
{
	if(__genModel.activeModelLocator.hasOwnProperty('update_bom'))
	{
		if(__genModel.activeModelLocator.update_bom)
		{
				if(event.value.toString()	==	"Y")
				{
					btnUpdateBOM.enabled	=	false;	
				}
				else
				{
					btnUpdateBOM.enabled	=	true;
				}
			
		}
		else
		{
			
		}
	}
	else
	{
		if(event.value.toString()	==	"Y")
		{
			btnUpdateBOM.enabled	=	false;	
		}
		else
		{
			btnUpdateBOM.enabled	=	true;
		}
		
	}
	
}
