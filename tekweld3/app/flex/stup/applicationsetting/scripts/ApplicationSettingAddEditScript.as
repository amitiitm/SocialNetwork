import business.events.RecordStatusEvent;

import com.generic.components.DataEntryWithNoList;
import com.generic.events.AddEditEvent;

import flash.events.MouseEvent;

import flashx.textLayout.formats.WhiteSpaceCollapse;

import model.GenModelLocator;

import mx.controls.Alert;

import stup.applicationsetting.ApplicationSettingModelLocator;

[Bindable]
private var __localModel:ApplicationSettingModelLocator = (ApplicationSettingModelLocator)(GenModelLocator.getInstance().activeModelLocator);

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var showXml:XML					= new XML();

private function init():void
{
	dtlDiscountCode.bcdp.visible  = false;
	dtlIndigoFileSavePath.bcdp.visible = false;
}
private function cmbChangeEvent():void
{
	var recordStatusChange:RecordStatusEvent = new RecordStatusEvent('MODIFY');
	recordStatusChange.dispatch();
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	
	
	showXml  								= 	event.recordXml.copy();
	
	var typesDetail:XML						=	XML(XML(event.recordXml.children()[0]).child('details'))
	
	var validateXml:XMLList					=	typesDetail.children().(type_cd == 'validate');
	
	var artworksendproofXml:XMLList			=	typesDetail.children().(type_cd == 'artwork_send_proof');
	
	var inventoryXml:XMLList				=	typesDetail.children().(type_cd == 'invn');
	
	var indigoFilePathXml:XMLList			=	typesDetail.children().(type_cd == 'indigo_file_path');
	
	var invnSalesAllocationXml:XMLList		=	typesDetail.children().(type_cd == 'inventory');
	
	
	
	
	
	var masterAccessXml:XMLList				=	typesDetail.children().(type_cd == 'master_access');
	
	var salesXml:XMLList					=	typesDetail.children().(type_cd == 'saoi');
	var ShippingXml:XMLList					=	typesDetail.children().(type_cd == 'ship');
	var prodXml:XMLList						=	typesDetail.children().(type_cd == 'prod');
	var purchaseXml:XMLList					=	typesDetail.children().(type_cd == 'puoi');	
	
	var printFormatXml:XMLList				=	typesDetail.children().(type_cd == 'print_format');
	
	
	
	var priceLevelDiscountXML:XMLList	=	typesDetail.children().(type_cd == 'price_level');
	
	if(indigoFilePathXml != XMLList(undefined))
	{
		setIndigoFilePathXml(indigoFilePathXml);	
	}
	if(validateXml != XMLList(undefined))
	{
		setValidateDetail(validateXml);	
	}
	if(inventoryXml != XMLList(undefined))
	{
		setInventoryDetail(inventoryXml);	
	}
	if(artworksendproofXml != XMLList(undefined))
	{
		setArtworksendproofXmlDetail(artworksendproofXml);	
	}
	
	
	
	if(masterAccessXml != XMLList(undefined))	
	{
		setMasterAccessDetail(masterAccessXml)
	}
	if(prodXml != XMLList(undefined))
	{
		setProdDetail(prodXml);	
	}
	if(salesXml != XMLList(undefined))
	{
		setSalesDetail(salesXml);	
	}
	if(ShippingXml != XMLList(undefined))
	{
		setShippingDetail(ShippingXml);	
	}
	if(purchaseXml != XMLList(undefined))
	{
		setPurchaseDetail(purchaseXml);	
	}
	
	if(printFormatXml != XMLList(undefined))
	{
		setPrintFormat(printFormatXml);	
	}
	
	//btnSetXml.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
}
private function setIndigoFileSavePathXml():void
{
	var typesDetail:XML						=	XML(XML(showXml.children()[0]).child('details'))

	var indigoFilePathXml:XMLList			=	typesDetail.children().(type_cd == 'indigo_file_path');
	
	setIndigoFilePathXml(indigoFilePathXml);
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var validateXml:XMLList				=	dgTypes.rows.children().(type_cd == 'validate');
	var inventoryXml:XMLList			=	dgTypes.rows.children().(type_cd == 'invn');
	var indigo_file_path:XMLList		=	dgTypes.rows.children().(type_cd == 'indigo_file_path');
	var artworksendproofXml:XMLList		=	dgTypes.rows.children().(type_cd == 'artwork_send_proof');
	var invnSalesAllocationXml:XMLList	=	dgTypes.rows.children().(type_cd == 'inventory');
	var accountsFAARXml:XMLList			=	dgTypes.rows.children().(type_cd == 'FAAR');
	var	accountsFAAPXml:XMLList			=	dgTypes.rows.children().(type_cd == 'FAAP');
	var masterAccessXml:XMLList			=	dgTypes.rows.children().(type_cd == 'master_access');
	var salesXml:XMLList				=	dgTypes.rows.children().(type_cd == 'saoi');
	var shippingXml:XMLList				=	dgTypes.rows.children().(type_cd == 'ship');
	
	var prodXml:XMLList					=	dgTypes.rows.children().(type_cd == 'prod');
	var purchaseXml:XMLList				=	dgTypes.rows.children().(type_cd == 'puoi');
	
	var printFormatXml:XMLList			=	dgTypes.rows.children().(type_cd == 'print_format');
	
	var priceLevelDiscountXml:XMLList	=	dgTypes.rows.children().(type_cd == 'price_level');
	
	
	
	generateValidteXML(validateXml);
	generateSendArtworkDetailXML(artworksendproofXml);
	generateInventoryDetailXML(inventoryXml);
	generateIndigoFilePathDetailXML(indigo_file_path);
	
	
	
	generateMasterAccessXML(masterAccessXml);
	generateSalesXml(salesXml);
	generateShippingXml(shippingXml);
	generateProdXml(prodXml);
	generatepurchaseXml(purchaseXml);
	
	generatePrintFormatXml(printFormatXml);	
	
	
	return 0;
}



private function setArtworksendproofXmlDetail(artwork_send_proof:XMLList):void
{
	tiSendProofText1.dataValue				=	XMLList(artwork_send_proof.(subtype_cd	==	'text1')).child('value').toString();
	tiSendProofText2.dataValue				=	XMLList(artwork_send_proof.(subtype_cd	==	'text2')).child('value').toString();
	tiSendProofText3.dataValue				=	XMLList(artwork_send_proof.(subtype_cd	==	'text3')).child('value').toString();
	tiSendProofText4.dataValue				=	XMLList(artwork_send_proof.(subtype_cd	==	'text4')).child('value').toString();
	tiSendProofText5.dataValue				=	XMLList(artwork_send_proof.(subtype_cd	==	'text5')).child('value').toString();
	tiSendProofText6.dataValue				=	XMLList(artwork_send_proof.(subtype_cd	==	'text6')).child('value').toString();
}
private function setIndigoFilePathXml(indigoFilePathXml:XMLList):void
{
	var dataXml:XML							=   new XML('<'+dtlIndigoFileSavePath.rootNode+'/>');
	var tempXml:XMLList						=   XMLList(indigoFilePathXml);
	dataXml.appendChild(tempXml.copy());
	dtlIndigoFileSavePath.rows				=  dataXml.copy();
}
private function setValidateDetail(validateXmlList:XMLList):void
{
	tiRushPassword.dataValue				=	XMLList(validateXmlList.(subtype_cd	==	'rush_password')).child('value').toString();
}
//set xml value to inventory controls
private function setInventoryDetail(inventoryXmlList:XMLList):void
{
	cbCheckInventory.dataValue				=	XMLList(inventoryXmlList.(subtype_cd	==	'check_inventory')).child('value').toString();
	
	var tempXml:XMLList						=   XMLList(inventoryXmlList.(subtype_cd	==	'column_discount_code'));
	var dataXml:XML							=   new XML('<'+dtlDiscountCode.rootNode+'/>');
	dataXml.appendChild(tempXml.copy());
	dtlDiscountCode.rows				= dataXml.copy();
}



private function setMasterAccessDetail(masterAccessXml:XMLList):void
{
	for(var i:int=0 ; cmbCustomerAccess.dataProvider.length ; i++)
	{
		if(cmbCustomerAccess.dataProvider[i].data	==	XMLList(masterAccessXml.(subtype_cd	==	'customer')).child('value').toString())
		{
			cmbCustomerAccess.selectedIndex	=	i;
			break;
		}
	}
	for(var i:int=0 ; cmbVendorAccess.dataProvider.length ; i++)
	{
		if(cmbVendorAccess.dataProvider[i].data	==	XMLList(masterAccessXml.(subtype_cd	==	'vendor')).child('value').toString())
		{
			cmbVendorAccess.selectedIndex	=	i;
			break;
		}
	}	
}

private function setProdDetail(prodXml:XMLList):void
{
	tiFreeStichCount.dataValue				=	XMLList(prodXml.(subtype_cd	==	'free_stitch_count')).child('value').toString();
	tiFreeStichQuantity.dataValue			=	XMLList(prodXml.(subtype_cd	==	'free_stitch_qty')).child('value').toString();
	tiStichPerUnit.dataValue				=	XMLList(prodXml.(subtype_cd	==	'stitches_per_unit')).child('value').toString();
	cbStitchEstimation.dataValue			=	XMLList(prodXml.(subtype_cd	==	'stitch_estimation')).child('value').toString();
	cbEmbdDigitization.dataValue			=	XMLList(prodXml.(subtype_cd	==	'embd_digitization')).child('value').toString();
	dcVendor_id.dataValue					=   XMLList(prodXml.(subtype_cd	==	'estimation_vendor')).child('value').toString();
	dcVendor_id.labelValue					=   XMLList(prodXml.(subtype_cd	==	'estimation_vendor')).child('value').toString();
	dcVendor_digitization.dataValue			=   XMLList(prodXml.(subtype_cd	==	'digitization_vendor')).child('value').toString();
	dcVendor_digitization.labelValue		=   XMLList(prodXml.(subtype_cd	==	'digitization_vendor')).child('value').toString();
	dcWater_digitization.dataValue			=   XMLList(prodXml.(subtype_cd	==	'water_vendor')).child('value').toString();
	dcWater_digitization.labelValue			=   XMLList(prodXml.(subtype_cd	==	'water_vendor')).child('value').toString();	
}
private function setSalesDetail(salesXml:XMLList):void
{
	cbSalespersonEquipment.dataValue		=	XMLList(salesXml.(subtype_cd	==	'equipment_flag')).child('value').toString();
	cbSalesInvoiceTypeAllow.dataValue		=	XMLList(salesXml.(subtype_cd	==	'other_custs_mem_ord')).child('value').toString();	
	cbAuthorizenetCustomerProfile.dataValue		=	XMLList(salesXml.(subtype_cd	==	'customer_profile')).child('value').toString();
	cbGenerateInvoiceAutomatically.dataValue		=	XMLList(salesXml.(subtype_cd	==	'auto_invoiced')).child('value').toString();
}
private function setShippingDetail(shippingXml:XMLList):void
{
	tiShippingMarkup.dataValue		=	XMLList(shippingXml.(subtype_cd	==	'shipping_markup')).child('value').toString();	
}

private function setPurchaseDetail(purchaseXml:XMLList):void
{
	cbPurchaseInvoiceTypeAllow.dataValue		=	XMLList(purchaseXml.(subtype_cd	==	'other_vends_mem_ord')).child('value').toString();
}


private function setPrintFormat(printFormatXml:XMLList):void
{
	tiPrintFormatSalesInvoice.dataValue				=	XMLList(printFormatXml.(subtype_cd	==	'sinvoice')).child('value').toString();
	tiPrintFormatSalesOrder.dataValue				=	XMLList(printFormatXml.(subtype_cd	==	'sorder')).child('value').toString();
	tiPrintFormatSalesCreditInvoice.dataValue		=	XMLList(printFormatXml.(subtype_cd	==	'screditinvoice')).child('value').toString();

	tiPrintFormatPurchaseOrder.dataValue			=	XMLList(printFormatXml.(subtype_cd	==	'porder')).child('value').toString();
	tiPrintFormatPurchaseInvoice.dataValue			=	XMLList(printFormatXml.(subtype_cd	==	'pinvoice')).child('value').toString();
	tiPrintFormatPurchaseCreditInvoice.dataValue	=	XMLList(printFormatXml.(subtype_cd	==	'pcreditinvoice')).child('value').toString();
	
	tiPrintFormatAcctCustomerInvoice.dataValue		=   XMLList(printFormatXml.(subtype_cd	==	'acinvoice')).child('value').toString();
	tiPrintFormatAcctCustomerCreditInvoice.dataValue=   XMLList(printFormatXml.(subtype_cd	==	'accreditinvoice')).child('value').toString();
	tiPrintFormatAcctCustomerReceipt.dataValue		=   XMLList(printFormatXml.(subtype_cd	==	'acreceipt')).child('value').toString();
	
	tiPrintFormatAccVendorInvoice.dataValue			=   XMLList(printFormatXml.(subtype_cd	==	'avinvoice')).child('value').toString();
	tiPrintFormatAccVendorCreditInvoice.dataValue	=   XMLList(printFormatXml.(subtype_cd	==	'avcreditinvoice')).child('value').toString();
	tiPrintFormatAccVendorWtireCheck.dataValue		=   XMLList(printFormatXml.(subtype_cd	==	'avwritecheck')).child('value').toString();
	
	tiPrintFormatAccBankPayment.dataValue			=   XMLList(printFormatXml.(subtype_cd	==	'abpayment')).child('value').toString();
	tiPrintFormatAccBankDeposit.dataValue			=   XMLList(printFormatXml.(subtype_cd	==	'abdeposit')).child('value').toString();
	tiPrintFormatAccBankTransfer.dataValue			=   XMLList(printFormatXml.(subtype_cd	==	'abtransfer')).child('value').toString();
	
	tiPrintFormatAccJournal.dataValue				=   XMLList(printFormatXml.(subtype_cd	==	'ajournal')).child('value').toString();
}




private function generateValidteXML(validateXml:XMLList):void
{
	for(var i:int = 0; i< validateXml.length() ; i++)
	{
		switch(validateXml[i].subtype_cd.toString())
		{
			case 'rush_password':
				validateXml[i].value	=	tiRushPassword.dataValue;
				break;
		}
	}
}


/*.......................................................................................................................*/


private function generateSendArtworkDetailXML(sendArtowrkXml:XMLList):void
{
	
	for(var i:int = 0; i< sendArtowrkXml.length() ; i++)
	{
		switch(sendArtowrkXml[i].subtype_cd.toString())
		{
			case 'text1':
				sendArtowrkXml[i].value	=	tiSendProofText1.dataValue;
				break;
			case 'text2':
				sendArtowrkXml[i].value	=	tiSendProofText2.dataValue;
				break;
			case 'text3':
				sendArtowrkXml[i].value	=	tiSendProofText3.dataValue;
				break;
			case 'text4':
				sendArtowrkXml[i].value	=	tiSendProofText4.dataValue;
				break;
			case 'text5':
				sendArtowrkXml[i].value	=	tiSendProofText5.dataValue;
				break;
			case 'text6':
				sendArtowrkXml[i].value	=	tiSendProofText6.dataValue;
				break;
		}
	}
}

//set inventory control values to datagrid row
private function generateInventoryDetailXML(inventoryXml:XMLList):void
{
	
	for(var i:int = 0; i< inventoryXml.length() ; i++)
	{
		switch(inventoryXml[i].subtype_cd.toString())
		{
			case 'check_inventory':
				inventoryXml[i].value	=	cbCheckInventory.dataValue;
				break;
			case 'column_discount_code':
				updatecolumn_discount_code(inventoryXml[i],dtlDiscountCode.rows);
				break;
		}
	}
}
private function generateIndigoFilePathDetailXML(indigo_file_path_Xml:XMLList):void
{
	
	for(var i:int = 0; i< indigo_file_path_Xml.length() ; i++)
	{
		updateIndigoFilePath(indigo_file_path_Xml[i],dtlIndigoFileSavePath.dgDtl.rows);
		/*switch(indigo_file_path_Xml[i].subtype_cd.toString())
		{
			case 'column_discount_code':
				updateIndigoFilePath(indigo_file_path_Xml[i],dtlIndigoFileSavePath.rows);
				break;
		}*/
	}
}
private function updateIndigoFilePath(indigo_file_path_Xml:XML,xml:XML):void
{
	var id:Number  = Number(indigo_file_path_Xml.id.toString());
	for(var i:int=0;i<xml.children().length();i++)
	{
		if(id == Number(xml.children()[i].id.toString()))
		{
			indigo_file_path_Xml.value  = xml.children()[i].value.toString();
		}
	}
}

private function updatecolumn_discount_code(inventoryXml:XML,xml:XML):void
{
	var id:Number  = Number(inventoryXml.id.toString());
	for(var i:int=0;i<xml.children().length();i++)
	{
		if(id == Number(xml.children()[i].id.toString()))
		{
			inventoryXml.value  = xml.children()[i].value.toString();
		}
	}
}
//set Account's FAAR control values to datagrid row
/*generate xml from create update detail data (generic)*/
private function generateCreateUpdateXML(newDataXml:XML , typeCD:String):void
{
	var oldDataXml:XMLList	=	dgTypes.rows.children().(type_cd == typeCD.toString());
	var newRows:XML	=	new XML(<rows/>);
	var tempXml:XML;
	if(oldDataXml == XMLList(undefined) && newDataXml.children().length() <= 0)
	{
		return;
	}
	else if(oldDataXml == XMLList(undefined) && newDataXml.children().length() > 0)
	{
		for(var j:int = 0 ; j < newDataXml.children().length() ;j++)
		{
			newDataXml.children()[i].type_cd	=	typeCD;
			newDataXml.children()[i].subtype_cd	=	typeCD;
		}
		dgTypes.rows.appendChild( newDataXml.children());
		return;
	}
	
	for(var i:int=0; i< newDataXml.children().length() ; i++)
	{
		if(newDataXml.children()[i].id.toString() == '' || newDataXml.children()[i].id.toString() == '0')
		{
			//means new row
			newDataXml.children()[i].type_cd	=	typeCD;
			newDataXml.children()[i].subtype_cd	=	typeCD;
			
			newRows.appendChild(newDataXml.children()[i]);
			
		}
		else
		{
			//means dealing with existing row
			newDataXml.children()[i].type_cd	=	typeCD;
			newDataXml.children()[i].subtype_cd	=	typeCD;
			tempXml	=	XML(oldDataXml.(id.toString() == newDataXml.children()[i].id.toString()));
			tempXml.setChildren(XML(newDataXml.children()[i]).children());
		}
	}
	if(newRows.children().length() > 0)
	{
		dgTypes.rows.appendChild(newRows.children());
	}
}

private function generateMasterAccessXML(masterAccessXml:XMLList):void
{
	for(var i:int = 0; i< masterAccessXml.length() ; i++)
	{
		switch(masterAccessXml[i].subtype_cd.toString())
		{
			case 'customer':
				masterAccessXml[i].value	=	cmbCustomerAccess.selectedItem.data.toString();
				break;
			case 'vendor':
				masterAccessXml[i].value	=	cmbVendorAccess.selectedItem.data.toString();
				break;
		}
	}		
}
private function generateProdXml(prodXml:XMLList):void
{
	for(var i:int = 0; i< prodXml.length() ; i++)
	{
		switch(prodXml[i].subtype_cd.toString())
		{
			case 'free_stitch_count':
				prodXml[i].value	=	tiFreeStichCount.dataValue;
				break;
			case 'free_stitch_qty':
				prodXml[i].value	=	tiFreeStichQuantity.dataValue;
				break;
			case 'stitches_per_unit':
				prodXml[i].value	=	tiStichPerUnit.dataValue;
				break;
			case 'stitch_estimation':
				prodXml[i].value	=	cbStitchEstimation.dataValue;
				break;
			case 'embd_digitization':
				prodXml[i].value	=	cbEmbdDigitization.dataValue;
				break;
			case 'estimation_vendor':
				prodXml[i].value	=	dcVendor_id.dataValue;
				break;
			case 'digitization_vendor':
				prodXml[i].value	=	dcVendor_digitization.dataValue;
				break;
			case 'water_vendor':
				prodXml[i].value	=	dcWater_digitization.dataValue;
				break;
			
			
		}
	}		
}

private function generateShippingXml(shippingXml:XMLList):void
{
	for(var i:int = 0; i< shippingXml.length() ; i++)
	{
		switch(shippingXml[i].subtype_cd.toString())
		{
			case 'shipping_markup':
				shippingXml[i].value	=	tiShippingMarkup.dataValue;
				break;
		}
	}		
}
private function generateSalesXml(salesXml:XMLList):void
{
	for(var i:int = 0; i< salesXml.length() ; i++)
	{
		switch(salesXml[i].subtype_cd.toString())
		{
			case 'equipment_flag':
				salesXml[i].value	=	cbSalespersonEquipment.dataValue;
				break;
			case 'other_custs_mem_ord':
				salesXml[i].value	=	cbSalesInvoiceTypeAllow.dataValue;
				break;
			case 'customer_profile':
				salesXml[i].value	=	cbAuthorizenetCustomerProfile.dataValue;
				break;
			case 'auto_invoiced':
				salesXml[i].value	=	cbGenerateInvoiceAutomatically.dataValue;
		}
	}		
}
private function generatepurchaseXml(purchaseXml:XMLList):void
{
	for(var i:int = 0; i< purchaseXml.length() ; i++)
	{
		switch(purchaseXml[i].subtype_cd.toString())
		{
			case 'other_vends_mem_ord':
				purchaseXml[i].value	=	cbPurchaseInvoiceTypeAllow.dataValue;
				break;
		}
	}	
}

private function generatePrintFormatXml(printFormatXml:XMLList):void
{
	for(var i:int = 0; i< printFormatXml.length() ; i++)
	{
		switch(printFormatXml[i].subtype_cd.toString())
		{
			case 'sorder':
				printFormatXml[i].value	=	tiPrintFormatSalesOrder.dataValue;
				break;
			
			case 'sinvoice':
				printFormatXml[i].value	=	tiPrintFormatSalesInvoice.dataValue;
				break;
			
			case 'screditinvoice':
				printFormatXml[i].value	=	tiPrintFormatSalesCreditInvoice.dataValue;
				break;
			
			case 'porder':
				printFormatXml[i].value	=	tiPrintFormatPurchaseOrder.dataValue;
				break;
			
			case 'pinvoice':
				printFormatXml[i].value	=	tiPrintFormatPurchaseInvoice.dataValue;
				break;
			
			case 'pcreditinvoice':
				printFormatXml[i].value	=	tiPrintFormatPurchaseCreditInvoice.dataValue;
				break;
			
			case 'acinvoice':
				printFormatXml[i].value	=	tiPrintFormatAcctCustomerInvoice.dataValue;
				break;
			
			case 'accreditinvoice':
				printFormatXml[i].value	=	tiPrintFormatAcctCustomerCreditInvoice.dataValue;
				break;
			
			case 'acreceipt':
				printFormatXml[i].value	=	tiPrintFormatAcctCustomerReceipt.dataValue;
				break;
			
			case 'avinvoice':
				printFormatXml[i].value	=	tiPrintFormatAccVendorInvoice.dataValue;
				break;
			
			case 'avcreditinvoice':
				printFormatXml[i].value	=	tiPrintFormatAccVendorCreditInvoice.dataValue;
				break;
			
			case 'avwritecheck':
				printFormatXml[i].value	=	tiPrintFormatAccVendorWtireCheck.dataValue;
				break;
			
			case 'abpayment':
				printFormatXml[i].value	=	tiPrintFormatAccBankPayment.dataValue;
				break;
			
			case 'abdeposit':
				printFormatXml[i].value	=	tiPrintFormatAccBankDeposit.dataValue;
				break;
			
			case 'abtransfer':
				printFormatXml[i].value	=	tiPrintFormatAccBankTransfer.dataValue;
				break;
			
			case 'ajournal':
				printFormatXml[i].value	=	tiPrintFormatAccJournal.dataValue;
				break;														
			
		}
	}	
}



private function setDefaultTempGrid():void
{
	var str :String = tnMain.selectedChild.label.toString();
	
	switch(str)
	{
		case 'Inventory':	
			break;
		case 'Master Access':
			break;
	}
}

