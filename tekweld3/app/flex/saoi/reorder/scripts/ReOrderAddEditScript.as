import business.events.DetailEditEvent;
import business.events.GetInformationEvent;
import business.events.GetRecordEvent;
import business.events.PreSaveEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.DataEntry;
import com.generic.components.Detail;
import com.generic.components.SubRecordList;
import com.generic.customcomponents.GenDateField;
import com.generic.customcomponents.GenDynamicComboBox;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.AddEditEvent;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.DetailAddEditEvent;
import com.generic.events.DetailEvent;
import com.generic.events.FetchRecordEvent;
import com.generic.events.GenCheckBoxEvent;
import com.generic.events.GenTextInputEvent;
import com.generic.events.LookupRecordSearchEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.GenObject;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.utils.setTimeout;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.core.DragSource;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.embroiderystich.components.ThreadList;

import saoi.muduleclasses.ApplicationConstant;
import saoi.muduleclasses.CommonArtworkXml;
import saoi.muduleclasses.CommonLinksServices;
import saoi.muduleclasses.CommonMooduleFunctions;
import saoi.muduleclasses.DrawItemsOptionsFunctions;
import saoi.muduleclasses.GenNotesAttachmentIcon;
import saoi.muduleclasses.GeneratePoPopUp;
import saoi.muduleclasses.ItemDetailViewer;
import saoi.muduleclasses.MissingInfolViewer;
import saoi.muduleclasses.MultiOptionsFunctions;
import saoi.muduleclasses.OptionsSetupChargeCalculation;
import saoi.muduleclasses.OptionsVisiblityFunctions;
import saoi.muduleclasses.ThirdPartyShippingChargeCalculation;
import saoi.muduleclasses.TierPricingFunctions;
import saoi.muduleclasses.UpdateEstimateShipAndInhandDateFunctions;
import saoi.muduleclasses.ValidatePoPopUp;
import saoi.muduleclasses.event.MissingInfoEvent;
import saoi.reorder.ReOrderModelLocator;

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
[Bindable]
private var __localModel:ReOrderModelLocator = (ReOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var shippingMethidsValue:String ;
[Bindable]
private var image_name:String;
[Bindable]
private var main_image_name:String;
[Bindable]
private var reorderEnable:Boolean = true;
[Bindable]
private var optionEnable:Boolean = true;
private var resultXmlFromItem:XML = new XML();
private var __service:ServiceLocator = __genModel.services;
private var preSaveEvent:PreSaveEvent;
private var shipping_detail:GetInformationEvent;
private var optionXmlAfterSave:XML;
private var saveXml:XML  = new XML();
private var isSerial_no_pk:String;
private var selectUniqueArtworkVersionIndex:int=0;
private var lot_size:int = 1;
private var isOkToSSave:Boolean	=	false;
private var isOkOrderEntrySSave:Boolean	=	false;
private var artwork_view:Boolean  = false;
private var getDefaultSetupEvent:GetInformationEvent;
private var customerContactValue:String ;
private var customer_contact:GetInformationEvent;
private var isCustomerChnage:Boolean    = false;
private var itemDetailWindow:ItemDetailViewer;
private var isMissingInfoSave:Boolean	=	false;
private var missingInfoWindow:MissingInfolViewer;
[Bindable]
private var screenViewMissingInfo:String = '';
private var __responderPick:IResponder;
private var customer_phone:String = '';
private var fetch_order_type:String = '';
private var oldOptionValue:String = '';
private var newOptionValue:String = '';	
private var commonMooduleFunctions:CommonMooduleFunctions				= new CommonMooduleFunctions();
private var commonLinksServices:CommonLinksServices						=   new CommonLinksServices();
private var optionsSetupChargeCalculation:OptionsSetupChargeCalculation	= new OptionsSetupChargeCalculation();
private var drawItemsOptionsFunctions:DrawItemsOptionsFunctions			= new DrawItemsOptionsFunctions();
private const DEFAULTRUSHITEM1:String   = "RUSHDAY1";
private const DEFAULTRUSHITEM2:String	= "RUSHDAY2";
[Bindable]
private var payment_profiles:XML;
[Bindable]
private var isTermCreditCard:Boolean   =  false;
[Bindable]
private var isPaymentProfileBlank:Boolean   =  true;
private var payment_info:XML		= new XML(<row>
													<card_type></card_type>	
													<credit_card_no></credit_card_no>
													<exp_month></exp_month>	
													<exp_year></exp_year>											
													<security></security>	
													<name_on_card></name_on_card>	
											  </row>);

private var paymentProfileCode:String = '';
private var paymentProfileCardNumber:String='';	
private var has_expired_date_flag:String = 'N';
private var commonartworkXml:CommonArtworkXml   			= new CommonArtworkXml(); 
private var multiOptionsFunction:MultiOptionsFunctions		= new MultiOptionsFunctions();
private var sourceScreen:String= '';	
private var blank_good_price:String ;
[Bindable]
private var discountCouponCount:Number=0;

private function createMapping():void
{
	var mappingArrCol:ArrayCollection = new ArrayCollection();
	
	mappingArrCol.addItem({source: 'trans_no',				target: 'trans_no',				isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'trans_date',			target: 'trans_date',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'order_id',				target: 'order_id',				isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'order_type',			target: 'order_type',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'ref_virtual_line_id',	target: 'ref_virtual_line_id',	isPrimaryKey:'Y',	updatable:'N'})	
	
	//id, transFlag , serialNo will be added in FetchRecordSelectCommand because it is commmon in all screens
	dtlEditLine.fetchMapingArrCol	=	mappingArrCol;
}


private function handleBtnGetDataClick(event:Event):void
{
	dtlEditLine.bcdp.dispatchEvent(new ButtonControlDetailEvent(ButtonControlDetailEvent.FETCH_RECORDS_EVENT));
}

override protected function fetchRecordSelectCompleteEventHandler(event:FetchRecordEvent):void   //on add buttton press,
{
		
	tnDetail.selectedIndex	= 0;      // set option tab selected
	
	var id:String 	 			= dtlEditLine.dgDtl.rows.purchase_memo_line.order_id.toString();
	fetch_order_type  			= dtlEditLine.dgDtl.rows.purchase_memo_line.order_type.toString();
	tiVrtualRefItemId.dataValue = dtlEditLine.dgDtl.rows.purchase_memo_line.ref_virtual_line_id.toString();
	tiRef_type.dataValue		= fetch_order_type;
	if(id!='' || id!==null )
	{
		var callbacks:IResponder = new mx.rpc.Responder(getOrderDetailHandler, null);
		item_detail	=	new GetInformationEvent('show_shipped_order_dtls', callbacks, id,null ,tiVrtualRefItemId.dataValue);
		item_detail.dispatch();
	}
	else
	{
		Alert.show("Please select valid record"+dtlEditLine.dgDtl.rows.toXMLString());
	}
	/*
	
	for(var i:int=0 ; i<dgOptionsDelete.rows.children().length();i++)
	{
		dgOptionsDelete.rows.children()[i].trans_flag = 'D';
	}*/

	for(var i:int=0 ; i<dgItemLinesDelete.rows.children().length();i++)
	{
		dgItemLinesDelete.rows.children()[i].trans_flag = 'D';
	} 

}
private function fetchOrderFromTransNo():void
{
	
	if(tiRef_trans_no.dataValue!='' || tiRef_trans_no.dataValue!==null )
	{
		var callbacks:IResponder = new mx.rpc.Responder(getOrderDetailHandler, null);
		item_detail	=	new GetInformationEvent('show_shipped_order_dtls', callbacks, null,tiRef_trans_no.dataValue,tiVrtualRefItemId.dataValue);
		item_detail.dispatch();
	}
	else
	{
		Alert.show("Please select valid record"+dtlEditLine.dgDtl.rows.toXMLString());
	}
	
	
	/*for(var i:int=0 ; i<dgOptionsDelete.rows.children().length();i++)
	{
		dgOptionsDelete.rows.children()[i].trans_flag = 'D';
	}
	*/
	for(var i:int=0 ; i<dgItemLinesDelete.rows.children().length();i++)
	{
		dgItemLinesDelete.rows.children()[i].trans_flag = 'D';
	}
	
	
}
private function getCorrectResultXml(xml:XML):XML
{
	var optionXml:XML  = XML(xml..sales_order_attributes_values);
	for(var i:int=0;i<optionXml.children().length();i++)
	{
		var attribute:XML 					= optionXml.children()[i];
		attribute.id						= '';
		attribute.sales_order_line_id		= '';
		attribute.lock_version				= 0
		var multi_options_xml:XML			= XML(attribute.sales_order_attributes_multiple_values);
		for(var j:int=0;j<multi_options_xml.children().length();j++)
		{
			multi_options_xml.children()[j].id  = '';
			multi_options_xml.children()[j].sales_order_attributes_value_id  = '';
			multi_options_xml.children()[j].ship_qty  	 = '0';
			multi_options_xml.children()[j].damaged_qty  = '0';
			multi_options_xml.children()[j].lock_version  = 0;
		}
	}
	return xml;
}
private function getOrderDetailHandler(result:XML):void
{
	saveXml		= getCorrectResultXml(result.copy());
	setHeatdeDetailFromSelectedOrder(result);
	setOrderDetail(saveXml);
	has_expired_date_flag  = XML(result.children()[0].catalog_items).children()[0].has_expired_date_flag.toString();
	if(cbNewOrder_flag.dataValue=='N')
	{
		setBillingAddress(result);
	}
	
}

private function setHeatdeDetailFromSelectedOrder(result:XML):void
{
	var xml:XMLList  						= 		XMLList(result.sales_order);
	
	resetCouponDiscount();
	tiRef_trans_no.dataValue  				=		xml.trans_no.toString();
	tiRef_trans_bk.dataValue				=       xml.trans_bk.toString();
	dcCustomer_Contact_id.labelValue		= 		xml.customer_contact.toString();
	dcCustomer_Contact_id.dataValue			= 		xml.customer_contact.toString();
	tiCustomer_phone.dataValue				= 		xml.customer_phone.toString();
    //tiRef_po_no.dataValue					= 		xml.ext_ref_no.toString();
    //dfCustomer_po_date.dataValue			= 		xml.ext_ref_date.toString();
    dcSales_person_code.dataValue			= 		xml.salesperson_code.toString();
	taSpecialInstruction.dataValue			= 		xml.special_instructions.toString();

	if(cbNewOrder_flag.dataValue=='N')
	{
		tiLogoField.dataValue				= 		xml.logo_name.toString();
	}
	
}
private function setOrderDetail(result:XML):void
{
	var xml:XMLList  = XMLList(result.sales_order.sales_order_lines);
	
	dtlSetup.dgDtl.rows = new XML(<sales_order_lines/>);
	dtlAssessories.dgDtl.rows = new XML(<sales_order_lines/>);
	
	
	var setupXml:XML  = new XML(<sales_order_lines/>);
	var assembleXml:XML  = new XML(<sales_order_lines/>);
	var accessoriesXml:XML  = new XML(<sales_order_lines/>);
	
	for(var i:int=0;i<xml.children().length();i++)
	{
		var lineType:String = xml.children()[i].line_type.toString();
		var itemType:String = xml.children()[i].item_type.toString();
		var itemPrice:String = xml.children()[i].item_price.toString();
		var code:String = xml.children()[i].catalog_item_code.toString();	
		if(lineType=='M')
		{
			if(result.sales_order.trans_type.toString()=='V')
			{
				var sales_order_id:String  =   xml.children()[i].id.toString();
				if(sales_order_id==tiVrtualRefItemId.dataValue)
				{
					setMainitem(xml.children()[i],"updateEmbroidryCharge");
					tiMainId.dataValue	= '';
				}
			}
			else
			{
				setMainitem(xml.children()[i]);
				tiMainId.dataValue	= '';
			}
			
		}
		else
		{
			if(itemType=='A')
			{	
				xml.children()[i].id = '';
				assembleXml.appendChild(xml.children()[i]);
			}
			else if(Number(itemPrice)>0 && itemType=='S'&& code!='STITCH-CHARGE' && code!='SETUP'&& code!=ApplicationConstant.DEFAULT_CHANGE_WITH_PROOF&& !isExistItemInGivenXml(__genModel.defaultSetupXml.copy(),code))
			{
				xml.children()[i].id = '';
				setupXml.appendChild(xml.children()[i]);
			}
			else if(itemType=='C')
			{
				xml.children()[i].id = '';
				accessoriesXml.appendChild(xml.children()[i]);
			}
		}
	}
	
	dtlSetup.dgDtl.rows 		= setupXml;
	dtlAssessories.dgDtl.rows 	= accessoriesXml;
	var optionXml:XML			= XML(result..sales_order_attributes_values);
	dgOptions.rows				= optionXml.copy();
	if(cbReorderType.dataValue.toUpperCase()==ApplicationConstant.REORDER_TYPE_NORMAL)
	{
		setShippingFromOrder(result);
	}
	else
	{
		
	}
	setArtworkFromOrder(result);
	setEmail(result);
	if(cbNewOrder_flag.dataValue=='Y')
	{
		changeRushOrderType();
		//changeRushOrder();
		rushTypeChnagehandler()
		//cbRushType.dispatchEvent(new ListEvent(ListEvent.CHANGE));
	}
	setMainItemAmount();
	setItemAmount(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));
}
private function isItDefaultRushSetupItem(code:String):Boolean
{
	var return_value:Boolean = false;
	for(var i:int=0;i<XMLList(cbRushType.dataProvider).length();i++)
	{
		if(code ==	XMLList(cbRushType.dataProvider)[i].value.toString())
		{
			return_value = true;
			break;
		}
	}
	return return_value;
}

private function setShippingFromOrder(result:XML):void
{
	var xml:XML  		= XML(result.sales_order.sales_order_shippings).copy();
	
	for(var i:int=0;i<xml.children().length();i++)
	{
		xml.children()[i].id 					= '';
		xml.children()[i].shipping_flag 		= 'N';
		xml.children()[i].packaging_flag 		= 'N';
		xml.children()[i].ship_date 			= '';
		xml.children()[i].estimated_ship_date 	= '';
		xml.children()[i].inhand_date 			= '';
		xml.children()[i].estimated_arrival_date= '';
		xml.children()[i].ship_method			= '';
		xml.children()[i].ship_amt				= '0.00';
		xml.children()[i].ship_qty				= '0';
		
		delete XML(xml.children()[i]).sales_order_shipping_packages;
		/*var packagesXml:XML						= XML(xml.children()[i].sales_order_shipping_packages);
		for(var j:int=0;j<packagesXml.children().length();j++)
		{
			packagesXml.children()[j].id  = '';
			packagesXml.children()[j].tracking_no  = '';
			
		}*/
	}
	dtlShippings.dgDtl.rows			= xml;
	dtlShippingsHeader.dgDtl.rows	= xml;
}
private function resetArtworkFromOrder():void
{
	var remainingXml:XML		= new XML("<"+dtlArtwork.rootNode+"/>");
	
	var tempXml:XML				= dtlArtwork.dgDtl.rows.copy();
	for(var i:int=0 ; i<tempXml.children().length();i++)
	{
		var artwork_type:String = tempXml.children()[i].artwork_version.toString();
		var findIndex:int		= artwork_type.toUpperCase().search(ApplicationConstant.ARTWORK_TYPE_CUSTOMER_PO);
		if(findIndex>=0)
		{
			remainingXml.appendChild(tempXml.children()[i]);
		}
		dtlArtwork.deleteRow(0);
	}
	
	dtlArtwork.dgDtl.rows  = remainingXml.copy();	
}
private function setArtworkFromOrder(result:XML):void
{
	var xml:XMLList  		= XMLList(result.sales_order.sales_order_artworks);
	
	
	if(cbNewOrder_flag.dataValue=='Y')
	{
		//dtlArtwork.dgDtl.rows	= XML(result.sales_order.sales_order_artworks).copy();
	}
	else
	{
		resetArtworkFromOrder();
		var tempXml:XML			= dtlArtwork.dgDtl.rows.copy();
		for(var i:int=0;i<xml.children().length();i++)
		{
			if(xml.children()[i].final_artwork_flag.toString()=='Y')
			{
				//xml.children()[i].id = '';
				xml.children()[i].final_artwork_flag = 'N';
				xml.children()[i].select_yn 		 = 'N';
				xml.children()[i].comment 		 	 = ApplicationConstant.REORDER_COMMENT+tiRef_trans_no.dataValue;
				tempXml.appendChild(xml.children()[i]);
			}
		}
		dtlArtwork.dgDtl.rows	= tempXml.copy();
	}
}

private function setEmail(result:XML):void
{
	var xml:XMLList  					= 		XMLList(result.sales_order);
	
	tiAccounts.dataValue 				= 		xml.account_dept_email.toString();
	tiShipping.dataValue 				= 		xml.shipping_dept_email.toString();
	tiPurchase.dataValue				=		xml.purchase_dept_email.toString();
	tiCorrespondense.dataValue			=	 	xml.corr_dept_email.toString();
	tiArt_work.dataValue				=	 	xml.artwork_dept_email.toString();
	__localModel.artwork_dept_email		= 		xml.artwork_dept_email.toString();
}

private function setBillingAddress(result:XML):void
{
	var xml:XMLList  						= 		XMLList(result.sales_order);
	
	tiName.dataValue						=		xml.bill_name.toString();
	tiBill_address1.dataValue 				= 		xml.bill_address1.toString();
	tiBill_address2.dataValue 				= 		xml.bill_address2.toString();
	tiBill_city.dataValue					=		xml.bill_city.toString();
	tiBill_country.dataValue				=	 	xml.bill_country.toString();
	tiBill_fax1.dataValue					=	 	xml.bill_fax.toString();
	tiBill_phone1.dataValue					=		xml.bill_phone.toString();
	tiBill_state.dataValue					=		xml.bill_state.toString();
	tiBill_zip.dataValue					=    	xml.bill_zip.toString();
	
	setBillingAddressIntoShipping();
}

private function getItemDetail():void
{
	if(dcCustomer_id.text !='' && dcCustomer_id.text	!=null)
	{
		if(dcItemId.text != '' && dcItemId.text != null)
		{
			var callbacks:IResponder = new mx.rpc.Responder(getItemDetailHandler, null);
			item_detail	=	new GetInformationEvent('item_detail', callbacks, dcItemId.dataValue,dcCustomer_id.dataValue,tiRef_type.dataValue,tiRef_trans_no.dataValue);
			item_detail.dispatch(); 
		}
		
	}
	else
	{
		Alert.show("Please Select Customer");
	}
	__localModel.catalotg_item_id  = dcItemId.dataValue;
}

private function getItemDetailHandler(resultXml:XML):void
{
	tiItemCode.dataValue		= resultXml.code.toString();
	taItemDescription.dataValue = resultXml.description.toString();
	tiPrice.dataValue           = resultXml.cost.toString();
	tiUnit.dataValue			= resultXml.unit.toString();
	tiType.dataValue			= resultXml.item_type.toString();
	lot_size					= int(resultXml.lot_size.toString());
	resultXmlFromItem			= resultXml;
	__localModel.resultXmlFromItem		= resultXmlFromItem;
	
	//setMainImage(resultXml);
	main_image_name  = getMainImageName();
	initOrderOption(resultXml.attributes,saveXml);
	__localModel.itemXml = resultXml.catalog_item_line;
	
	var assemblyXml:XMLList = __localModel.itemXml.assemble_items
	var assembleXml:XML = new XML(<sales_order_lines/>);
	
	for(var k:int=0;k<XMLList(assemblyXml.assemble_item).length();k++)
	{
		var tempXml:XMLList 					= new XMLList(<sales_order_line/>);
		
		tempXml.catalog_item_id 				= XMLList(assemblyXml.assemble_item)[k].catalog_item_id.toString();
		tempXml.catalog_item_code				= XMLList(assemblyXml.assemble_item)[k].catalog_item_code.toString();
		tempXml.unit	  						= XMLList(assemblyXml.assemble_item)[k].unit.toString()
		tempXml.item_qty		 				= XMLList(assemblyXml.assemble_item)[k].qty.toString()
		tempXml.item_price		  				= XMLList(assemblyXml.assemble_item)[k].price.toString();
		tempXml.item_type		  				= 'A'
		tempXml.line_type		  				= 'S'
		tempXml.item_amt		 				= Number(XMLList(assemblyXml.assemble_item)[k].qty.toString()) * Number(XMLList(assemblyXml.assemble_item)[k].price.toString());
		tempXml.item_description 				= XMLList(assemblyXml.assemble_item)[k].description.toString();
		tempXml.trans_flag						=	'A'
		tempXml.trans_bk						=	''
		tempXml.trans_no						=	'';
		tempXml.trans_date 						= dfTrans_date.dataValue;
		tempXml.serial_no						=101+k;
		tempXml.image_thumnail					='';
		tempXml.company_id 						= GenModelLocator.getInstance().user.default_company_id.toString();
		
		assembleXml.appendChild(tempXml.copy());
	}
	
	
	
	
	/*for(var i:int=0 ; i<dgOptionsDelete.rows.children().length();i++)
	{
		dgOptionsDelete.rows.children()[i].trans_flag = 'D';
	}*/
	
	for(var i:int=0 ; i<dgItemLinesDelete.rows.children().length();i++)
	{
		dgItemLinesDelete.rows.children()[i].trans_flag = 'D';
	}
	//dgOptions.rows = new XML(<sales_order_attributes_values/>);

	dtlSetup.dgDtl.rows  		= new XML(<sales_order_lines/>); 
	dtlAssessories.dgDtl.rows 	= new XML(<sales_order_lines/>); 
	
	tiMainId.dataValue   = '';
}

public function setMainImage(resultXml:XML):void
{

	if(resultXml.image_thumnail!='')
	main_image_name = resultXml.image_thumnail;
	else
	main_image_name = '';
}
								
private function saveOptions():XML
 {
 	var __saveOption:XML = new XML(<sales_order_attributes_values/>);
 	for(var i:int=0;i<vbMain.getChildren().length;i++)
 	{
 		var attribute:XMLList = new XMLList(<sales_order_attributes_value/>);
 		var hbox:HBox = HBox(vbMain.getChildByName('hb'+i));
 		attribute.catalog_attribute_code = Label(hbox.getChildAt(0)).text;
		var comboBoxValue:ComboBox  = ComboBox(hbox.getChildAt(1));
		
		var remarksValue:GenTextInput  		= GenTextInput(hbox.getChildAt(2));
		attribute.remarks 			   		= remarksValue.dataValue;
		
		if(comboBoxValue.selectedIndex<0)
		{
			attribute.catalog_attribute_value_code  = '';
		}
		else
		{
			attribute.catalog_attribute_value_code = comboBoxValue.selectedItem.code.toString();
		}
		attribute.company_id 		=	__genModel.user.default_company_id;
        attribute.updated_by 		= 	__genModel.user.userID;
        attribute.created_by		= 	__genModel.user.userID;
        attribute.id				= '';
      	attribute.lock_version		= 0
      	attribute.catalog_item_id 	= dcItemId.dataValue.toString();
 		__saveOption.appendChild(attribute);
 	}
 	return __saveOption;
 }									
									
private function initOrderOption(xml:XMLList,resultXml:XML=null,callFrom:String=''):void
{
	//new DrawItemsOptionsFunctions().drawItemOptions(dgOptions,xml,vbMain,resultXml,resultXmlFromItem,tiQty,dtlSetup,cbOrder_type.dataValue,callFrom);
	vbMain.removeAllChildren();
	
	var startTabIndex:int   = 10000;
	for(var i:int =0 ;i<xml.children().length();i++)
	{
		var hbox:HBox = new HBox();
		hbox.percentWidth	  	= 100;
		hbox.height 		 	= 22;
		hbox.name         		= 'hb'+i;	
		hbox.setStyle('verticalAlign','middle');
		
		
		// attribute code
		var tiAttributeName:Label				= new Label();
		tiAttributeName.text 					= xml.attribute[i].code;
		tiAttributeName.width					= 100;
		tiAttributeName.tabEnabled				= false;
		tiAttributeName.setStyle('textAlign','right');
		tiAttributeName.setStyle('borderStyle','none');
		
		// for default value
		var tiDafultValue:Label					= new Label();
		tiDafultValue.text 						= '';
		tiDafultValue.width						= 200;
		tiDafultValue.tabEnabled				= false;
		tiDafultValue.setStyle('textAlign','left');
		tiDafultValue.setStyle('borderStyle','none');
		//
		
		// for attribute code values
		var gcbAttributeValue:ComboBox				= new ComboBox();
		gcbAttributeValue.id						=	 i.toString();
		gcbAttributeValue.tabEnabled				= true;
		gcbAttributeValue.tabIndex					= (startTabIndex+1);
		gcbAttributeValue.addEventListener(ListEvent.CHANGE , comboboxChangeHandler);
		
		gcbAttributeValue.dataProvider				= xml.attribute[i].values.value;
		gcbAttributeValue.labelField				= 'code';
		
		//// for remarks
		var tiRemarksValue:GenTextInput					= new GenTextInput();
		tiRemarksValue.id								= i.toString()
		tiRemarksValue.text 							= '';
		tiRemarksValue.width							= 200;
		tiRemarksValue.tabEnabled						= true;
		tiRemarksValue.enabled							= !__genModel.activeModelLocator.addEditObj.isRecordViewOnly;
		tiRemarksValue.tabIndex							= (startTabIndex+2);
		tiRemarksValue.addEventListener(GenTextInputEvent.ITEMCHANGED_EVENT,remarksItemChnageHandler);
		tiRemarksValue.doubleClickEnabled				= true;
		tiRemarksValue.addEventListener(MouseEvent.DOUBLE_CLICK,remarksItemDoubleClickHandler);
		//
		////
		
		// for options id
		var tiOptionsId:GenTextInput					= new GenTextInput();
		tiOptionsId.id									= i.toString()
		tiOptionsId.text 								= '';
		tiOptionsId.width								= 0;
		tiOptionsId.visible								= false;
		tiOptionsId.tabEnabled							= true;
		tiOptionsId.enabled								= !__genModel.activeModelLocator.addEditObj.isRecordViewOnly;
		tiOptionsId.tabIndex							= (startTabIndex+2);
		//
		
		
		if(resultXml==null)
		{
			setComboBoxValueBlank(gcbAttributeValue);
		}
		gcbAttributeValue.width     				= 150;
		gcbAttributeValue.height					= 20;
		gcbAttributeValue.enabled					= !__genModel.activeModelLocator.addEditObj.isRecordViewOnly;
			
		hbox.addChildAt(tiAttributeName,0);
		hbox.addChildAt(gcbAttributeValue,1);
		hbox.addChildAt(tiRemarksValue,2);
		hbox.addChildAt(tiDafultValue,3);
		hbox.addChildAt(tiOptionsId,4);
		
		
		
		
		vbMain.addChildAt(hbox,i);
		startTabIndex   = startTabIndex +2;
		
		setDefaultLabel(xml.attribute[i].values,i);
		
	}
	if(resultXml!=null)
	{
		setOptionValue(resultXml);
		if(resultXmlFromItem.children().length()>0 && callFrom!='')    // update embroidery stitch charge
		{
			optionsSetupChargeCalculation.updateEmbroideryStichCharges(dtlSetup,XML(resultXmlFromItem.stitch_charges.sales_order_lines),vbMain,tiQty.dataValue);
		}
		
	}
	else
	{
		dgOptions.rows		= drawItemsOptionsFunctions.saveOptions(vbMain,dgOptions.rootNode,getItemId(resultXmlFromItem)).copy();
	}
	if(vbMain.numChildren>0)                 // in this case no options r exist 
	{
		changeVisibilityOfOtheroptions(vbMain,-1);
	}
	CursorManager.removeBusyCursor();
}
private function getCorrectOptionsXml(xml:XML):XML
{
	var optionXml:XML  = XML(xml..sales_order_attributes_values);
	for(var i:int=0;i<optionXml.children().length();i++)
	{
		var attribute:XMLList 				= xml.children()[i];
		attribute.id						= '';
		attribute.lock_version				= 0
	}
	return optionXml;
}
public function remarksItemDoubleClickHandler(event:Event):void
{
	var hbox:HBox					= HBox(GenTextInput(event.currentTarget).parent);
	var comboBoxValue:ComboBox		= ComboBox(hbox.getChildAt(1));
	var code:String					= Label(hbox.getChildAt(0)).text;
	var remarks:String				= GenTextInput(hbox.getChildAt(2)).dataValue;
	if(drawItemsOptionsFunctions.isMultiValueOptions(comboBoxValue) && comboBoxValue.selectedIndex>=0 && comboBoxValue.selectedItem.code.toString()==ApplicationConstant.MULTIOPTION)
	{
		drawItemsOptionsFunctions.openMultiOptionsPopup(VBox(hbox.parent),hbox,true,this.dgOptions);
	}
	
}
private function getItemId(resultXmlFromItem:XML):String
{
	if(resultXmlFromItem.children().length()>0)
	{
		return resultXmlFromItem.id.toString();
	}
	else
	{
		return '';
	}
}
private function remarksItemChnageHandler(event:Event):void
{
	if(dgOptions.rows.children().length()>0)
	{
		for(var i:int = 0 ; i < dgOptions.rows.children().length(); i++)
		{
			dgOptions.rows.children()[Number(GenTextInput(event.target).id)].remarks = GenTextInput(event.target).dataValue;
		}
	}
}
public  function setDefaultLabel(xml:XMLList,index:int):void
{
	for(var i:int =0; i<XMLList(xml.children()).length();i++)
	{
		var defaultValue:String = XMLList(xml.children())[i].default_value;
		if(defaultValue.toUpperCase()=='Y')
		{
			var hbox:HBox = HBox(vbMain.getChildByName('hb'+index));
			var lblDefault:Label  = Label(hbox.getChildAt(3));         //default label
			lblDefault.text       = "Default Value :"+XMLList(xml.children())[i].code.toString();
			break;
		}
	}
}
public  function setComboBoxValueBlank(cb:ComboBox):void
{
	var index:int  = -1;
	cb.selectedIndex = index;
} 
public  function setDefault(cb:ComboBox):void
{
		var index:int  = 0;
		for(var i:int =0; i<XMLList(cb.dataProvider).length();i++)
		{
			var defaultValue:String = XMLList(cb.dataProvider)[i].default_value;
			if(defaultValue.toUpperCase()=='Y')
			{
				index = i;
				break;
			}
		}
		cb.selectedIndex = index;
} 

private function setOptionValue(recordXml:XML):void
{
	drawItemsOptionsFunctions.setOptionValue(recordXml,vbMain);
	/*var optionXml:XMLList  = recordXml.sales_order.sales_order_attributes_values;
	for(var i:int=0;i<vbMain.getChildren().length;i++)
	{
		var hbox:HBox = HBox(vbMain.getChildByName('hb'+i));
		//Label(hbox.getChildAt(0)).text  	   = optionXml.children()[i].catalog_attribute_code.toString();
		
		
		if(vbMain.getChildren().length>optionXml.children().length())                // options may be increase or decrease in between order to reorder stage 
		{
			var remarksValue:TextInput  = TextInput(hbox.getChildAt(2));
			remarksValue.text			= '';
			
			var cb:ComboBox  			= ComboBox(hbox.getChildAt(1));
			var index:int  				= -1;
			cb.selectedIndex 			= index;
		}
		else
		{
			var remarksValue:TextInput  = TextInput(hbox.getChildAt(2));
			remarksValue.text			= optionXml.children()[i].remarks.toString();
			
			var cb:ComboBox  			= ComboBox(hbox.getChildAt(1));
			var value_code:String   	= optionXml.children()[i].catalog_attribute_value_code.toString();
			
			var index:int  = -1;
			for(var k:int =0; k<XMLList(cb.dataProvider).length();k++)
			{
				var code:String = XMLList(cb.dataProvider)[k].code;
				if(code==value_code)
				{
					index = k;
					break;
				}
			}
			cb.selectedIndex = index;
			
		}
		
		
	}*/

}

private function comboboxChangeHandler(event:ListEvent):void
{
	var recordStatusEvent:RecordStatusEvent  = new RecordStatusEvent('MODIFY');
	recordStatusEvent.dispatch();
	
	var selectedId:Number			  = Number(ComboBox(event.target).id);
	changeVisibilityOfOtheroptions(vbMain,selectedId);
	drawItemsOptionsFunctions.openMultioptionPopUpWindow(vbMain,selectedId,dgOptions);
	var imprintTypeIndex:int	 	  		= new OptionsVisiblityFunctions().getImprintTypeOptionsIndex(vbMain); 
	
	if(selectedId==imprintTypeIndex)
	{
		for(var j:int=0;j<vbMain.getChildren().length;j++)                    // reset remarks when no options save in database
		{
			var hbox:HBox 					  							  = HBox(vbMain.getChildByName('hb'+j));
			var remarksTextInput:GenTextInput 							  = GenTextInput(hbox.getChildAt(2))
			var comboBoxValue:ComboBox									  = ComboBox(hbox.getChildAt(1));
			if(drawItemsOptionsFunctions.isMultiValueOptions(comboBoxValue)&& comboBoxValue.selectedIndex>0 && comboBoxValue.selectedItem.code.toString()==ApplicationConstant.MULTIOPTION)
			{
				
			}
			else
			{
				remarksTextInput.dataValue									  = '';
			}

		}
	}
	
	if(dgOptions.rows.children().length()>0)
	{
		for(var i:int=0;i<vbMain.getChildren().length;i++)
		{
			var hbox:HBox 					  							  = HBox(vbMain.getChildByName('hb'+i));
			var comboBoxValue:ComboBox									  = ComboBox(hbox.getChildAt(1))
			var optionsCode:String									  	  = Label(hbox.getChildAt(0)).text;
			
			var attribute_value:String									  = '';
			if(comboBoxValue.selectedIndex>=0)
			{
				attribute_value	 									  	  = ComboBox(hbox.getChildAt(1)).selectedItem.code.toString();
			}
			if(selectedId==imprintTypeIndex)  // means imprint options r changes than we have to reset remarks text
			{		
				if(dgOptions.rows.children()[i].catalog_attribute_value_code.toString()!=ApplicationConstant.MULTIOPTION)
				{
					dgOptions.rows.children()[i].remarks 					  = '';
				}
			}
			var optionsIndex:int				= drawItemsOptionsFunctions.getOptionCodeIndex(dgOptions,optionsCode);
			dgOptions.rows.children()[i].catalog_attribute_value_code = attribute_value;
		}
	}
}

private function changeVisibilityOfOtheroptions(vbMain:VBox,selectedId:Number):void
{
	var optionsVisiblityFunctions:OptionsVisiblityFunctions				= new OptionsVisiblityFunctions();
	optionsVisiblityFunctions.changeVisibilityOfOtheroptions(vbMain,selectedId,resultXmlFromItem,tiQty,dtlSetup);	
}
private function updateSetupCharges(index:Number):void
{
	var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+index));
	var selected_option_code:String  		= Label(hbox.getChildAt(0)).text;                // code
	var cb:ComboBox  						= ComboBox(hbox.getChildAt(1));
	var selected_option_value:String		= '';
	if(cb.selectedIndex>=0)
	{
		selected_option_value  				= cb.selectedItem.code.toString();  
	}
	optionsSetupChargeCalculation.checkForOptionsCharge(dtlSetup,tiQty.dataValue,XML(resultXmlFromItem.catalog_attribute_values),XML(resultXmlFromItem.catalog_attribute_codes),vbMain,resultXmlFromItem);
}

private function init():void
{
	dtlSetup.bcdp.visible				= false;
	dtlSetup.bcdp.includeInLayout		= false;
	dtlSetup.dgDtl.doubleClickEnabled	= false;
	//dtlShippingsHeader.dgDtl.doubleClickEnabled	= false;
	
	numericFormatterWithoutPrecesion.precision	=	0;
	numericFormatterWithoutPrecesion.rounding = "nearest";
	
	numericFormatterThreePrecesion.precision	=	3;
	numericFormatterThreePrecesion.rounding = "nearest";
	
	numericFormatterFourPrecesion.precision		=	4;
	numericFormatterFourPrecesion.rounding = "nearest";
	
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	__localModel.trans_date = dfTrans_date.text	
	//getAccountPeriod();
	setActivityDateLavelFunction();
	setShippingBalanceQty();
	vbMain.addEventListener("optionsComboboxChange",optionsComboboxHandler);
}
private function setActivityDateLavelFunction():void
{
	while(true)
	{
		if(dgActivityLines.columns.length>0)
		{
			DataGridColumn(dgActivityLines.columns[0]).labelFunction = dateFunc;
			break;
		}
	
	}
	
}
private function dateFunc(item:Object, column:DataGridColumn):String
{
	var dateFormatter:DateFormatter = new DateFormatter();
	var date_format:String = GenModelLocator.getInstance().user.date_format.toLocaleUpperCase();
		
	if(date_format == null || date_format == "")
	{
		dateFormatter.formatString = 'MM/DD/YYYY H:NN:SS';
	}
	else
	{
		dateFormatter.formatString = 'MM/DD/YYYY H:NN:SS';
	}

	return dateFormatter.format(item[column.dataField].toString());
}
public function dataService(service:HTTPService):HTTPService
{
	var urlObj:URL	=	new URL();
	service.url		=	urlObj.getURL(service.url);
	service.resultFormat 		= "e4x";					
	service.method 				= "POST";
	service.useProxy			= false;
	service.contentType			="application/xml";
	service.requestTimeout	 	= 1800
	
	return service;
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	=	resultXml.child('code');
}

private function getCustomerDetails():void
{
	tiCustomerCode.dataValue		= dcCustomer_id.labelValue;
	
	if(dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(customerDetailsHandler, null);
		
		getInformationEvent			=	new GetInformationEvent('customerdetail', callbacks, dcCustomer_id.dataValue, "I");
		getInformationEvent.dispatch();
		
		//getCustomerShipping();
	}
	else
	{
		tiCustomer_phone.dataValue		= '';
	}
	__localModel.customer_id			  = dcCustomer_id.dataValue;
	__localModel.customer_code			  = dcCustomer_id.labelValue;
	dcCustomer_Contact_id.filterKeyValue  = dcCustomer_id.dataValue;
	dcPaymentProfle_code.filterKeyValue   = dcCustomer_id.dataValue;
	tiCustomer_coupons_id.filterKeyValue	= dcCustomer_id.dataValue;
	resetItemDetail();
}
private function resetItemDetail():void
{
	dtlSetup.dgDtl.rows 		= new XML(<sales_order_lines/>);
	dtlAssessories.dgDtl.rows 	= new XML(<sales_order_lines/>);
	resultXmlFromItem        	=  new XML();
	__localModel.resultXmlFromItem	= resultXmlFromItem;
} 

private function getCustomerShipping():void
{
		var callbacksShipping:IResponder	=	new mx.rpc.Responder(customerShippingDetailsHandler, null);
		
		getInformationShippingEvent			=	new GetInformationEvent('customer_specific_shippings', callbacksShipping, dcCustomer_id.dataValue);
		getInformationShippingEvent.dispatch();  
}

private function customerDetailsHandler(resultXml:XML):void
{
	setValue(resultXml);
	setBillingAddress(resultXml);
	__localModel.thirdPartyShippingCharge		= XML(resultXml.children()[0].thirdpartyshippingcharge).copy();
}
private function customerShippingDetailsHandler(resultXml:XML):void
{
	__localModel.customerShipping = resultXml;	
}

private function setValue(customerXml:XML):void
{
	discountCouponCount						= Number(customerXml.children().child('coupon_count').toString());
	dcTerm_code.dataValue 					= customerXml.children().child('term_code').toString();
	dcTerm_code.labelValue 					= customerXml.children().child('term_code').toString();
	setPaymentTerm(false);			// no msg
	dcCustomer_Contact_id.labelValue						 = customerXml.children().child('contact_name').toString();
	dcCustomer_Contact_id.dataValue							 = customerXml.children().child('contact_name').toString();
	__localModel.default_customer_third_party_account_number = customerXml.children().child('default_customer_third_party_account_number').toString();
	__localModel.default_customer_bill_transportation_to	 = customerXml.children().child('default_customer_bill_transportation_to').toString();
	__localModel.default_customer_shipping_code				 = customerXml.children().child('default_customer_shipping_code').toString();
	tiCustomer_phone.dataValue				= customerXml.children().child('phone1').toString();
	customer_phone							= customerXml.children().child('phone1').toString();
	tiAccounts.dataValue 					= customerXml.children().child('account_dept_email').toString();
	tiShipping.dataValue 					= customerXml.children().child('shipping_dept_email').toString();
	tiPurchase.dataValue					=	 customerXml.children().child('purchase_dept_email').toString();
	tiCorrespondense.dataValue				=	 customerXml.children().child('corr_dept_email').toString();
	tiArt_work.dataValue					=	 customerXml.children().child('artwork_dept_email').toString();
	cbPPRequired_flag.dataValue				= customerXml.children().child('paper_proof_flag').toString();

	if(customerXml.children().child('business_phone').toString()!='')
	{
		tiCustomer_phone.dataValue			= customerXml.children().child('business_phone').toString();
	}
	
}
private function setScreenView():void
{
	//var sourceScreen:String	 = data.row[0].toString();
	if(sourceScreen.toUpperCase()=='PICKORDER' || sourceScreen.toUpperCase()=='ASSIGNEDORDER')
	{
		cbOrderEnterCompleted.visible			= true;
		cbOrderEnterCompleted.includeInLayout 	= true;
		cbArtworkAttched.visible				= false;
		cbArtworkAttched.includeInLayout		= false;
		cbCustPoAttached.visible				= false;
		cbCustPoAttached.includeInLayout        = false;
		cbQualityCheckCompleted.visible			= false;
		cbQualityCheckCompleted.includeInLayout	= false;
		cbArtworkFinished.visible				= false;
		cbArtworkFinished.includeInLayout		= false;
		cbReassignedToOrderEntry.visible		= false;
		hbAssignUser.visible					= false;
		__localModel.artwork_view				= false;
		screenViewMissingInfo               	= 'ASSIGNEDORDER';
	}
	else if (sourceScreen.toUpperCase()=='QCORDER')
	{
		cbReassignedToOrderEntry.visible		= true;
		cbReassignedToOrderEntry.includeInLayout= true;
		//hbAssignUser.visible					= true;
		cbQualityCheckCompleted.visible			= true;
		cbQualityCheckCompleted.includeInLayout = true;
		cbArtworkAttched.visible				= false;
		cbArtworkAttched.includeInLayout		= false;
		cbCustPoAttached.visible				= false;
		cbCustPoAttached.includeInLayout        = false;
		cbOrderEnterCompleted.visible			= false;
		cbOrderEnterCompleted.includeInLayout 	= false;
		cbArtworkFinished.visible				= false;
		cbArtworkFinished.includeInLayout		= false;
		__localModel.artwork_view				= false;
		tnDetail.selectedChild  				= vbStatus;
		screenViewMissingInfo              		= 'QCORDER';	
	}
	else
	{
		cbOrderEnterCompleted.visible			= false;
		cbOrderEnterCompleted.includeInLayout 	= false;
		cbArtworkAttched.visible				= false;
		cbArtworkAttched.includeInLayout		= false;
		cbCustPoAttached.visible				= false;
		cbCustPoAttached.includeInLayout        = false;
		cbQualityCheckCompleted.visible			= false;
		cbQualityCheckCompleted.includeInLayout	= false;
		cbArtworkFinished.visible				= false;
		cbArtworkFinished.includeInLayout		= false;
		cbReassignedToOrderEntry.visible		= false;
		hbAssignUser.visible					= false;
		screenViewMissingInfo					= '';
	}
	//__genModel.objectFromDrilldown 				= new XML(<rows></rows>);
}
private function checkRushItem(itemXml:XML):void
{
	var returnValue:Boolean = false;
	for(var i:int=0;i<itemXml.children().length();i++)
	{
		var catalog_item_code:String = itemXml.children()[i].catalog_item_code.toString(); 
		var index:int = catalog_item_code.toLowerCase().search('rush');
		if(index>=0)
		{
			returnValue = true;
			break;
		}
	}
	if(returnValue==true)
	{
		tiTrans_bk.setStyle('disabledColor','#D70C0C');
		tiTrans_no.setStyle('disabledColor','#D70C0C');
	}
	else
	{
		tiTrans_no.setStyle('disabledColor','#000000');
		tiTrans_bk.setStyle('disabledColor','#000000');
	}
}
//--------------------------------------------------------------------------------
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	
	
	dcCustomer_Contact_id.filterKeyValue  = dcCustomer_id.dataValue;
	dcPaymentProfle_code.filterKeyValue   = dcCustomer_id.dataValue;
	tiCustomer_coupons_id.filterKeyValue	= dcCustomer_id.dataValue;
	
	var recordXml:XML						= event.recordXml;
	saveXml									= event.recordXml.copy();
	customer_phone							= recordXml.sales_order.cust_phone.toString();
	
	
	__localModel.thirdPartyShippingCharge		= XML(recordXml.children()[0].thirdpartyshippingcharge).copy();
	
	if(tiRefPurchaseOrder.dataValue=='')
	{
		PUOI01.label			= "Generate PO #";
	}
	else
	{
		PUOI01.label		= "View PO #";
	}
	
	if((recordXml.sales_order.qc_off_flag.toString()=='Y' &&  recordXml.sales_order.orderqcstatus_flag.toString()=='N') || (recordXml.sales_order.qc_off_flag.toString()=='N' &&  recordXml.sales_order.orderqcstatus_flag.toString()=='Y') )
	{
		lbtnResendAck.visible			= true;
	}
	else
	{
		lbtnResendAck.visible			= false;
	}
	var catalog_items_xml:XML				= XML(saveXml.children()[0].catalog_items);
	if(catalog_items_xml.children().length()>0)
	{
		var catalog_item:XML				= XML(catalog_items_xml.catalog_item);
		var workflow:String					= catalog_item.workflow.toString();
		if(workflow.toUpperCase()==ApplicationConstant.ITEM_WORKFLOW_EMBROIDERY)
		{
			lbtnViewThreads.visible			= true;
		}
		else
		{
			lbtnViewThreads.visible			= false;
		}
		visiblityOfGenratePo(workflow);
	}
	var data:XML 							=  __genModel.objectFromDrilldown.copy();
	if(data.children().length()>0)
	{
		sourceScreen 						= data.row[0].toString();
		__genModel.objectFromDrilldown 		= new XML(<rows></rows>);
	}
	setScreenView();
	
	
	if(cbNewOrder_flag.dataValue=='Y')
	{
		fetchOrderFromTransNo();
	}
	else
	{
		var xml:XMLList  			= XMLList(recordXml.sales_order.sales_order_lines);
		dtlSetup.dgDtl.rows 		= new XML(<sales_order_lines/>);
		dtlAssessories.dgDtl.rows 	= new XML(<sales_order_lines/>);
		var setupXml:XML  			= new XML(<sales_order_lines/>);
		var assembleXml:XML  		= new XML(<sales_order_lines/>);
		var accessoriesXml:XML  	= new XML(<sales_order_lines/>);
		
		for(var i:int=0;i<xml.children().length();i++)
		{
			var lineType:String = xml.children()[i].line_type.toString();
			var itemType:String = xml.children()[i].item_type.toString();
			
			if(lineType=='M')
			{
				setMainitem(xml.children()[i]);
			}
			else
			{
				if(itemType=='A')
				{	
					assembleXml.appendChild(xml.children()[i]);
				}
				else if(itemType=='S')
				{
					setupXml.appendChild(xml.children()[i]);
				}
				else if(itemType=='C')
				{
					accessoriesXml.appendChild(xml.children()[i]);
				}
			}
		}
		dtlSetup.dgDtl.rows 		= setupXml;
		dtlAssessories.dgDtl.rows 	= accessoriesXml;
		checkRushItem(setupXml);
	}
	__localModel.order_type				= cbOrder_type.dataValue;
	__localModel.default_customer_third_party_account_number = recordXml.children()[0].default_customer_third_party_account_number.toString();
	__localModel.default_customer_bill_transportation_to	 = recordXml.children()[0].default_customer_bill_transportation_to.toString();
	__localModel.default_customer_shipping_code				 = recordXml.children()[0].default_customer_shipping_code.toString();
	__localModel.trans_date 			= 	dfTrans_date.text
	__localModel.trans_no  				= 	recordXml.sales_order.trans_no.toString();
	__localModel.ext_ref_no				=	recordXml.sales_order.ext_ref_no.toString();
	__localModel.customer_id			=   dcCustomer_id.dataValue;
	__localModel.customer_code			=   dcCustomer_id.labelValue;
	__localModel.ext_ref_date   		=   dfCustomer_po_date.dataValue;
	discountCouponCount					= Number(recordXml.children()[0].child('coupon_count').toString());
	
	if(recordXml.sales_order.artworkcompleted_flag.toString()=='N')
	{
	  __localModel.artwork_view		= false;
	}
	else
	{
		__localModel.artwork_view	= true;
	}
	
	changeImage();
	setHeaderPartEnableOrDisable();
	//getCustomerShipping();
	
	if(recordXml.sales_order.term_code.toString()=="CC")
	{
		isTermCreditCard = true;
	}
	else
	{
		isTermCreditCard = false;
	}
	
	dcItemId.enabled 					= false;
	btnGetData.enabled 					= false;
	dcCustomer_id.enabled				= false;
	cbReorderType.enabled				= false;
	cbPPRequired_flag.enabled			= false;
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
	setShippingBalanceQty();
	setBillingAddressIntoShipping();
	
	if(cbPPRequired_flag.dataValue.toUpperCase() 		== 'N')
		__localModel.paper_proof_flag	= false;
	else if(cbPPRequired_flag.dataValue.toUpperCase()	== 'Y')
		__localModel.paper_proof_flag	= true;
	
	if(cbNext_Day_Flag.dataValue.toUpperCase() 		== 'N')
		__localModel.next_day_flag	= false;
	else if(cbNext_Day_Flag.dataValue.toUpperCase()	== 'Y')
		__localModel.next_day_flag	= true;
	
	dcPaymentProfle_code.dataValue 	= paymentProfileCode;
	dcPaymentProfle_code.labelValue = paymentProfileCardNumber;
	/*if(recordXml.sales_order.payment_authorize_flag.toString()=='Y')
	{
		vbAthorizeInfoTemp.enabled			= false;
		setMissingInfo();
	}
	else
	{
		vbAthorizeInfoTemp.enabled			= true;
		setMissingInfo();
	}*/
	setSendArtworkForEsttimationVisiblity(recordXml.copy());
	setReAssignFlagVisiblity(recordXml.copy());
	setVisiblityOfAthorizeButton(recordXml.copy());
	commonMooduleFunctions.setPaperProofDone(recordXml.children()[0].artworkapprovedbycust_flag.toString(),dtlArtwork);
	setParamforEstimate();
	__localModel.isShipInfoBaseChange		 = false;
	__localModel.isDiscountCouponBaseChange  = false;
	commonMooduleFunctions.orderQueriesRemoveAddButton(cbOrderEnterCompleted.dataValue,dtlQueries);
}

private function setMainitem(linesXml:XML,callFrom:String=''):void
{
	dcItemId.dataValue 					= linesXml.catalog_item_id.toString();
	dcItemId.labelValue					= linesXml.catalog_item_code.toString();
	tiQty.dataValue 					= linesXml.item_qty.toString();
	setShippingBalanceQty();
	taItemDescription.dataValue 		= linesXml.item_description.toString();
	tiType.dataValue 					= linesXml.item_type.toString();
	main_image_name 					= linesXml.image_thumnail.toString();
	tiPrice.dataValue					= linesXml.item_price.toString();
	tiMainId.dataValue					= linesXml.id.toString();
	
	tiMainLockVersion.dataValue			= linesXml.lock_version.toString();	 
	tiMainitemSerialNo.dataValue		= linesXml.serial_no.toString();
	setMainItemAmountAfterSave();
	//genrateOptionAfterSave();
	var catalog_items_xml:XML			= XML(saveXml.children()[0].catalog_items);
	if(catalog_items_xml.children().length()>0)
	{
		getItemDetailAfterSaveHandler(XML(catalog_items_xml.catalog_item),callFrom);
	}
	
}


private function genrateOptionAfterSave():void
{
	if(dcCustomer_id.dataValue !='' && dcCustomer_id.dataValue!=null)
	{
		if(dcItemId.dataValue != '' && dcItemId.dataValue != null)
		{
			var callbacks:IResponder = new mx.rpc.Responder(getItemDetailAfterSaveHandler, null);
			item_detail	=	new GetInformationEvent('item_detail', callbacks, dcItemId.dataValue,dcCustomer_id.dataValue,tiRef_type.dataValue,tiRef_trans_no.dataValue);
			item_detail.dispatch(); 
		}
		
	}
	else
	{
		Alert.show("Please Select Customer");
	}
}

private function getItemDetailAfterSaveHandler(resultXml:XML,callFrom:String=''):void
{
	resultXmlFromItem					= resultXml;
	__localModel.resultXmlFromItem		= resultXmlFromItem;
	initOrderOption(resultXml.attributes,saveXml,callFrom);
	lot_size							= int(resultXml.lot_size.toString());
	__localModel.itemXml 				= resultXml.catalog_item_line;
	__localModel.catalotg_item_id  		= dcItemId.dataValue;
	__localModel.ext_ref_date   		= dfCustomer_po_date.dataValue;
}



override protected function resetObjectEventHandler():void   //on add buttton press,
{
	discountCouponCount						 = 0;
	__localModel.isShipInfoBaseChange		 = false;
	__localModel.isDiscountCouponBaseChange  = false;
	setHeaderPartEnableOrDisable();
	paymentProfileCode  			= '';
	paymentProfileCardNumber		= '';
	PUOI01.label						  = "Generate PO #";
	
	dcCustomer_Contact_id.filterKeyValue  = dcCustomer_id.dataValue;
	dcPaymentProfle_code.filterKeyValue   = dcCustomer_id.dataValue;
	
	getAccountPeriod();
	
	dcCustomer_id.enabled			=	true;
	cbReorderType.enabled			= 	true;
	lbtnResendAck.visible			=   false;
	cbPPRequired_flag.enabled		= 	true;
	__localModel.order_type			= cbOrder_type.dataValue;
	__localModel.trans_date 		= dfTrans_date.text
	__localModel.customer_id		= dcCustomer_id.dataValue;
	__localModel.customer_code		= dcCustomer_id.labelValue;
	__localModel.trans_no	='';
	__localModel.ext_ref_no	='';
	setShippingBalanceQty();
	__localModel.artwork_dept_email = '';
	main_image_name					= '';
	customer_phone					= '';
	__localModel.default_customer_third_party_account_number = '';
	__localModel.default_customer_bill_transportation_to	 = '';
	__localModel.default_customer_shipping_code				 = '';
	isTermCreditCard				= false
	tiVrtualRefItemId.dataValue		= tiVrtualRefItemId.defaultValue;
	changeImage()
	
	vbMain.removeAllChildren();
	dcItemId.enabled = false;
	btnGetData.enabled = true;
	resetItemDetail();
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
	setBillingAddressIntoShipping();
	
	visiblityOfGenratePo('');
	setReAssignFlagVisiblity(<rows><row></row></rows>);
	setVisiblityOfAthorizeButton(<rows><row></row></rows>);
	setSendArtworkForEsttimationVisiblity(<rows><row></row></rows>);
	commonMooduleFunctions.setPaperProofDone('',dtlArtwork);
	
	setParamforEstimate();
	commonMooduleFunctions.orderQueriesRemoveAddButton(cbOrderEnterCompleted.dataValue,dtlQueries);
	sourceScreen		= '';
	setScreenView();
}

private function changeImage():void
{
	/* if(dtlLine.dgDtl.selectedRow != null)
	{
		image_name = dtlLine.dgDtl.selectedRow["image_thumnail"]
	}
	else
	{
		image_name = null
	} */
}

private function genrateXml():void
{
	/*if(dgOptions.rows.children().length()>0)
	{
		
	}
	else
	{
		if(dgOptionsDelete.rows.children().length()>0)
		{
			var trans_flag:String  = dgOptionsDelete.rows.children()[0].trans_flag;
			if(trans_flag=='D')
			{
				dgOptions.rows.appendChild(dgOptionsDelete.rows.children().copy());
			}
		}
		dgOptions.rows.appendChild(saveOptions().children().copy());
		
	}*/
	
	dgItemLines.rows = new XML(<sales_order_lines/>);
	
	var mainitem:XMLList 	   = new XMLList(<sales_order_line/>);
	mainitem.catalog_item_id   = dcItemId.dataValue.toString();
	mainitem.catalog_item_code = dcItemId.labelValue.toString();
	mainitem.unit			   = tiUnit.dataValue;
	mainitem.item_qty		   = tiQty.dataValue;	
	mainitem.item_price		   = tiPrice.dataValue	
	mainitem.item_type		   = tiType.dataValue;
	mainitem.line_type		   = 'M';	
	mainitem.item_amt		   = Number(tiQty.dataValue)*Number(tiPrice.dataValue); 
	mainitem.item_description  = taItemDescription.dataValue;
	mainitem.trans_flag		   = 'A';	
	mainitem.trans_bk		   = '';	
	mainitem.trans_date		   = new GenDateField().currentDate();	
	mainitem.serial_no		   = tiMainitemSerialNo.dataValue;		
	mainitem.image_thumnail    = main_image_name;
	mainitem.company_id 	   =	__genModel.user.default_company_id;
    mainitem.updated_by 	   = 	__genModel.user.userID;
    mainitem.created_by		   = 	__genModel.user.userID;
    mainitem.id				   = tiMainId.dataValue;
    
    mainitem.lock_version	   = tiMainLockVersion.dataValue;
	
	dgItemLines.rows.appendChild(dtlAssessories.dgDtl.rows.children().copy());
	dgItemLines.rows.appendChild(dtlSetup.dgDtl.rows.children().copy());
	
	dgItemLines.deletedRows	=	new XML('<' + dgItemLines.rootNode + '/>');
	
	dgItemLines.deletedRows.appendChild(dtlAssessories.dgDtl.deletedRows);
	dgItemLines.deletedRows.appendChild(dtlSetup.dgDtl.deletedRows);
	
	dgItemLines.rows.appendChild(mainitem.copy());
	
	for(var k:int=0;k<dgItemLinesDelete.rows.children().length();k++)
	{
		var trans_flag:String  = dgItemLinesDelete.rows.children()[k].trans_flag;
		if(trans_flag=='D')
		{
			dgItemLines.rows.appendChild(dgItemLinesDelete.rows.children().copy());
		}
	}
}
private function resetFinalArtworkId():void
{
	var tempXml:XML	 = dtlArtwork.dgDtl.rows.copy(); 
	for(var i:int=0;i<tempXml.children().length();i++)
	{
		if(tiTrans_no.dataValue=='')
		{
			tempXml.children()[i].id  = '';
		}
	}
	dtlArtwork.dgDtl.rows  = tempXml;
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var returnValue:int = 0;
	resetFinalArtworkId();
	setMissingInfo();
	if(isOkToSSave)
	{
		isOkToSSave		=  false;
		returnValue 	=  0;
	}
	else if(!isInLots(int(tiQty.dataValue),lot_size))
	{
		Alert.show("Item Quantity should be in the lots of ".concat(lot_size.toString().concat(" . Do you want to continue to save order?")),"",Alert.YES | Alert.NO,this,discardChangeEvent,null,Alert.YES);
		return -1;
	}
	if(cbOrder_type.dataValue=='E')
	{
		if(tiRef_trans_no.dataValue=='')
		{
			Alert.show("Enter Ref. Order# to proceed with Re-ordering.");
			return -1;
		}
		if(cbReorderType.dataValue=='')
		{
			Alert.show("Enter Reorder Type to proceed with Order.");
			return -1;
		}
		if(has_expired_date_flag=='Y' && String(cbReorderType.dataValue).toUpperCase()!=ApplicationConstant.REORDER_TYPE_CHANGEWITHARTWORK)
		{
			Alert.show("Select Reorder Type as "+ApplicationConstant.REORDER_TYPE_CHANGEWITHARTWORK);
			return -1;
		}
	}
	if(!isCustomerPOAttach())
	{
		Alert.show("Customer PO is required. Please attach customer's PO with the order.");
		return -1;
	}
	if(!isItemQtyOk(resultXmlFromItem.columns,Number(tiQty.dataValue)) && dcItemId.dataValue!='')
	{
		Alert.show("Order Qty Can't be less than"+int(resultXmlFromItem.columns.column1.toString())/2);
		return -1;
	}
	if(!isArtworkVersionUnique())
	{
		Alert.show("Artwork/PO Type Should Not Repeat");
		tnDetail.selectedIndex	= 7;
		dtlArtwork.dgDtl.selectedIndex  = selectUniqueArtworkVersionIndex;
		return -1;
	}
	if(isShippingQtyExceedLimit())
	{
		Alert.show("Total shipping qty is greater than item qty ");
		tnDetail.selectedIndex	= 3;
		return -1;
	}
	if(cbReassignedToOrderEntry.dataValue=='Y' && dcAssignUser.dataValue=='')
	{
		Alert.show("Select user to reassign.");
		return -1;
	}
	if(__localModel.isDiscountCouponBaseChange)
	{
		Alert.show("Please recalculate discount Coupon.");
		return -1;
	}
	if(__localModel.isShipInfoBaseChange)
	{
		Alert.show("Please recalculate estimate shipping date.");
		return -1;
	}
	
	if(isMissingInfoSave)
	{
		isMissingInfoSave = false;
		returnValue 0;
	}
	else
	{
		openMissingInfoScreen();
		return -1;
	}
	if(cbQualityCheckCompleted.dataValue=='Y' && (!isAllQueryAnswered()) )
	{
		Alert.show("Answer all queries before saving.");
		cbQualityCheckCompleted.dataValue   = 'N';
		isMissingInfoSave   		     	= false;
		return -1;
	}
	if(cbOrderEnterCompleted.dataValue=='Y' && (!isAllQueryAnswered()) )
	{
		Alert.show("Answer all queries before saving.");
		cbOrderEnterCompleted.dataValue  = 'N';
		isMissingInfoSave   		     = false;
		return -1;
	}
	if(multiOptionsFunction.isMultiOptionsQtyValid(tiQty.dataValue,multiOptionsFunction.getMultiDescription(multiOptionsFunction.getMultiOptionsHbox(vbMain)))!=0)
	{
		Alert.show("Item Quantity does not match with the "+multiOptionsFunction.getMultiOptionsCode(multiOptionsFunction.getMultiOptionsHbox(vbMain))+" multiple quantities.");
		return -1;
	}
	if(Number(tiQty.dataValue)<=0 )
	{
		returnValue = -1;
		Alert.show("Item Quantity should be greater than 0.");
		this.focusManager.setFocus(tiQty);
	}
	else
	{
		if(dtlShippings.dgDtl.rows.children()<=0)
		{
			returnValue = -1;
			Alert.show("At least one shipping address is required.");
			tnDetail.selectedIndex	= 3;
		}
		else
		{
			genrateXml();
		}
	}
	setAccountingStatus();
	setShippingStatus();
	setPaperProofStatus();
	setMissingInfo();
	//setartworkFinalFlag();
	cbNewOrder_flag.dataValue = 'N';
	var multi_description:String	=  multiOptionsFunction.getMultiDescription(multiOptionsFunction.getMultiOptionsHbox(vbMain));
	if(multi_description!='VALID')
	{
		taMultiDescription.dataValue	=  multi_description;
	}
	return returnValue;
	
}
private function openMissingInfoScreen():void
{
	missingInfoWindow 			 = MissingInfolViewer(PopUpManager.createPopUp(this,MissingInfolViewer,true));
	missingInfoWindow.x			 = ((Application.application.width/2)-(missingInfoWindow.width/2));
	missingInfoWindow.y			 = ((Application.application.height/2)-(missingInfoWindow.height/2));
	missingInfoWindow.orderDetail = new XML(<orderDetail>
											<missinginfo>{taMissingInfo.text}</missinginfo>
											<screenview>{screenViewMissingInfo}</screenview>
												<checkboxdata>
												<orderentrycomplete_flag>{cbOrderEnterCompleted.dataValue}</orderentrycomplete_flag>	
												<artworkattached_flag>{cbArtworkAttched.dataValue}</artworkattached_flag>	
												<custpoattached_flag>{cbCustPoAttached.dataValue}</custpoattached_flag>	
												<orderqcstatus_flag>{cbQualityCheckCompleted.dataValue}</orderqcstatus_flag>	
												

												<customer_checked_flag>{cbCustomerChecked.dataValue}</customer_checked_flag>	
												<contact_checked_flag>{cbContactChecked.dataValue}</contact_checked_flag>	
												<item_checked_flag>{cbItemChecked.dataValue}</item_checked_flag>	
												<quantity_checked_flag>{cbQuantityChecked.dataValue}</quantity_checked_flag>
												<imprint_checked_flag>{cbImprintChecked.dataValue}</imprint_checked_flag>
												<shipping_checked_flag>{cbShippingChecked.dataValue}</shipping_checked_flag>	
												<billing_checked_flag>{cbBillingChecked.dataValue}</billing_checked_flag>	
												<email_checked_flag>{cbEmailChecked.dataValue}</email_checked_flag>	
												<payment_checked_flag>{cbPaymentChecked.dataValue}</payment_checked_flag>
												</checkboxdata>
											</orderDetail>);
	
	missingInfoWindow.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoSave);
}
private function missingInfoSave(event:MissingInfoEvent):void
{
	var xmlMissingInfo:XML					= 	event.xml;
	isMissingInfoSave   					= 	true;
	cbOrderEnterCompleted.dataValue 		= 	xmlMissingInfo.orderentrycomplete_flag.toString() ;
	cbArtworkAttched.dataValue				=	xmlMissingInfo.artworkattached_flag.toString();
	cbCustPoAttached.dataValue				=	xmlMissingInfo.custpoattached_flag.toString();
	
	cbCustomerChecked.dataValue				=   xmlMissingInfo.customer_checked_flag.toString();
	cbContactChecked.dataValue				=   xmlMissingInfo.contact_checked_flag.toString();
	cbEmailChecked.dataValue				=   xmlMissingInfo.email_checked_flag.toString();
	cbItemChecked.dataValue					=   xmlMissingInfo.item_checked_flag.toString();
	cbQuantityChecked.dataValue				=   xmlMissingInfo.quantity_checked_flag.toString();
	cbImprintChecked.dataValue				=   xmlMissingInfo.imprint_checked_flag.toString();
	cbShippingChecked.dataValue				=   xmlMissingInfo.shipping_checked_flag.toString();
	cbBillingChecked.dataValue				=   xmlMissingInfo.billing_checked_flag.toString();
	cbPaymentChecked.dataValue				=   xmlMissingInfo.payment_checked_flag.toString();
	cbQualityCheckCompleted.dataValue		=	xmlMissingInfo.orderqcstatus_flag.toString();
	
	
	
	if(cbQualityCheckCompleted.dataValue=='Y')
	{
		cbReassignedToOrderEntry.dataValue	= 'N';
		dcAssignUser.dataValue				= '';
		dcAssignUser.labelValue				= '';
		tiUser_cd.dataValue					= '';
		hbAssignUser.visible				= false;
	}
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}
private function enableCheckBoxes(result:XML):void
{
	cbOrderEnterCompleted.enabled 		 = false;
	cbQualityCheckCompleted.enabled		 = false;
	
	if(result.sales_order.orderpickstatus_flag.toString()=='Y')
	{
		cbOrderEnterCompleted.enabled = true;
	}
	if(result.sales_order.ordercompletestatus_flag.toString()=='Y')
	{
		cbQualityCheckCompleted.enabled = true;
	}
}
private function setOtherDeptEmail():void
{
	tiAccounts.text		= tiCorrespondense.text;
	tiShipping.text		= tiCorrespondense.text;
	tiPurchase.text		= tiCorrespondense.text;
	tiArt_work.text		= tiCorrespondense.text;
}
private function isItemQtyMinimum(columnXml:XMLList,qty:Number):Boolean
{
	var returnValue:Boolean  = false;
	if(qty<Number(columnXml.column1.toString()))   // qty<Number((columnXml.column1.toString())/2)
	{
		returnValue  = true;
	}
	return returnValue;
}
private function setItemCost():void
{
	if(__localModel.discount_item_xml.children().length()>0 && __localModel.discount_item_xml.children()[0].catalog_item_id.toString()!='')   // discount coupon pricing
	{
		setDiscountSpecificPricing();
	}
	else  // customer specific pricing 
	{
		setCustomerSpecificPricing();
	}
}
/*private function setItemCost():void
{
	var index:int 					= new TierPricingFunctions().getColumnSize(resultXmlFromItem.columns,Number(tiQty.dataValue));
	if(isItemQtyMinimum(resultXmlFromItem.columns,Number(tiQty.dataValue)))
	{
		tiPrice.dataValue  				= new TierPricingFunctions().returnColumnPrice(resultXmlFromItem.ltm_price.catalog_item_prices.catalog_item_price,index);
	}
	else
	{
		tiPrice.dataValue  				= new TierPricingFunctions().returnColumnPrice(resultXmlFromItem.catalog_item_prices.catalog_item_price,index);
	}
	
	if(tiPrice.dataValue=='')
	{
		tiPrice.dataValue			= tiPrice.defaultValue;
	}
	setMainItemAmount();
	setShippingBalanceQty();
	
	if(isInLots(int(tiQty.dataValue),lot_size))
	{
		
	}
	else
	{	
		Alert.show("Item Quantity should be in the lots of "+lot_size);
	}
	updateImprintColorCharges();
	if(resultXmlFromItem.children().length()>0)
	{
		optionsSetupChargeCalculation.updateEmbroideryStichCharges(dtlSetup,XML(resultXmlFromItem.stitch_charges.sales_order_lines),vbMain,tiQty.dataValue);
		optionsSetupChargeCalculation.updateLTMCharges(dtlSetup,resultXmlFromItem,tiQty.dataValue);
	}
}*/
private function updateImprintColorCharges():void
{
	for(var i:int=0;i<vbMain.getChildren().length;i++)
	{
		var hbox:HBox = HBox(vbMain.getChildByName('hb'+i));
		
		var optionsCode:String  		= Label(hbox.getChildAt(0)).text;                // code
		var cb:ComboBox  				= ComboBox(hbox.getChildAt(1));
		var optionsValue:String			= '';
		if(cb.selectedIndex>=0)
		{
			optionsValue  				= cb.selectedItem.code.toString();  
		}
		if(hbox.visible  && (optionsCode=='IMPRINTCOLOR2' || optionsCode=='IMPRINTCOLOR3'))
		{
			optionsSetupChargeCalculation.checkForOptionsCharge(dtlSetup,tiQty.dataValue,XML(resultXmlFromItem.catalog_attribute_values),XML(resultXmlFromItem.catalog_attribute_codes),vbMain,resultXmlFromItem);
		}
	}
}
/*private function  getColumnSize(columnXml:XMLList,size:int):int
{
	var index:int=1;
	if(size<Number(columnXml.column2.toString()))
	{
		index = 1;
	}
	else if(size<Number(columnXml.column3.toString()))
	{
		index = 2;
	}
	else if(size<Number(columnXml.column4.toString()))
	{
		index = 3;
	}
	else if(size<Number(columnXml.column5.toString()))
	{
		index = 4;
	}
	else if(size<Number(columnXml.column6.toString()))
	{
		index = 5;
	}
	else if(size<Number(columnXml.column7.toString()))
	{
		index = 6;
	}
	else if(size<Number(columnXml.column8.toString()))
	{
		index = 7;
	}
	else if(size<Number(columnXml.column9.toString()))
	{
		index = 8;
	}
	else if(size<Number(columnXml.column10.toString()))
	{
		index = 9;
	}
	else if(size>=Number(columnXml.column10.toString()))
	{
		index = 10;
	}
	return index;
	
}

private function returnColumnPrice(column_pricing:XMLList,index:int):String
{
	var price:String = column_pricing.column10.toString();
	if(index==1)
	{
		price =  column_pricing.column1.toString();
	}
	else if(index==2)
	{
		price =  column_pricing.column2.toString();
	}
	else if(index==3)
	{
		price =  column_pricing.column3.toString();
	}
	else if(index==4)
	{
		price =  column_pricing.column4.toString();
	}
	else if(index==5)
	{
		price =  column_pricing.column5.toString();
	}
	else if(index==6)
	{
		price =  column_pricing.column6.toString();
	}
	else if(index==7)
	{
		price =  column_pricing.column7.toString();
	}
	else if(index==8)
	{
		price =  column_pricing.column8.toString();
	}
	else if(index==9)
	{
		price =  column_pricing.column9.toString();
	}
	else if(index==10)
	{
		price =  column_pricing.column10.toString();
	}
	return price;
}*/
private function changePaperProofFlag():void
{
	if(cbPPRequired_flag.dataValue.toUpperCase() 		== 'N')
	__localModel.paper_proof_flag	= false;
	else if(cbPPRequired_flag.dataValue.toUpperCase()	== 'Y')
	__localModel.paper_proof_flag	= true;
	
	setParamforEstimate();
	//setEstimatedDateByIncrement(cbPPRequired_flag.dataValue.toUpperCase());
}
private function setShippingStatus():void
{
	var dgXml:XMLList  = dtlShippings.dgDtl.rows.(trans_flag='A');

	var total_qty:Number = 0;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		total_qty = total_qty + Number(dgXml.children()[i]['ship_qty'].toString());
	}
	if(dgXml.children().length()<=0)
	{
		tiShippingStatus.dataValue = "NEED SHIP INFO";
	}
	else if(Number(tiQty.dataValue) != total_qty)
	{
		tiShippingStatus.dataValue = "PARTIAL SHIP INFO RECEIVED";
	}
	else if(Number(tiQty.dataValue) == total_qty)
	{
		tiShippingStatus.dataValue	= "SHIP INFO RECEIVED";
	}
}
private function isShippingQtyExceedLimit():Boolean
{
	var dgXml:XMLList  = dtlShippings.dgDtl.rows.(trans_flag='A');

	var total_main_qty:Number	= Number(tiQty.dataValue);
	var total_qty:Number = 0;
	
	var return_value:Boolean	= false;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		total_qty = total_qty + Number(dgXml.children()[i]['ship_qty'].toString());
	}
	
	if(total_main_qty<total_qty)
	{
		return_value  = true;
	}
	return return_value;
}
private function setAccountingStatus():void
{
	/*if(tiNameOnCard.dataValue !=''&& tiCardNO.dataValue !=''&& tiCvvNO.dataValue !='' && tiExp_Month.dataValue!=''&& tiExp_Year.dataValue != '' )
	{
	tiAccount_status.dataValue	= "CLEAR";
	}
	else
	{
	tiAccount_status.dataValue	= "PAYMENT HOLD";
	}*/
	if(dcTerm_code.dataValue.toUpperCase()=="CC")
	{
		tiAccount_status.dataValue	= "CREDIT CARD";
	}
	else
	{
		tiAccount_status.dataValue	= "TERMS";
	}
}

/*private function setShippingMethods():void
{
	if(dcShipping_code.dataValue != '' && dcShipping_code.dataValue != null)
	{
		shippingMethidsValue	= dcShippingMethods.dataValue;
		var callbacks:IResponder = new mx.rpc.Responder(getShippingDetailHandler, null);
		shipping_detail	=	new GetInformationEvent('fetch_shipvia_methods', callbacks, dcShipping_code.dataValue);
		shipping_detail.dispatch(); 
	}
}
private function getShippingDetailHandler(resultXml:XML):void
{
	dcShippingMethods.dataProvider	= resultXml.children();
	dcShippingMethods.dataValue		= shippingMethidsValue;
}
private function setShippingMethodToolTip():void
{
	if(dcShipping_code.dataValue != '' && dcShipping_code.dataValue != null)
	{
		dcShippingMethods.toolTip	= dcShippingMethods.selectedItem.ship_method_description.toString();
	}
}*/
private function setPaperProofStatus():void
{
	if(cbPPRequired_flag.dataValue =='Y')
	{
		tiPaper_proof_status.dataValue	= "PAPER PROOF REQUIRED";
	}
	else
	{
		tiPaper_proof_status.dataValue	= "NO PROOF REQUIRED";
	}
}
private function isArtworkVersionUnique():Boolean
{
	var dgXml:XMLList  = dtlArtwork.dgDtl.rows.(trans_flag='A');
	var returnValue:Boolean = true;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var currentVersion:String  	= dgXml.children()[i]['artwork_version'].toString();
		for(var j:int = i+1 ; j < dgXml.children().length(); j++)
		{
			var artwotkVersion:String  	= dgXml.children()[j]['artwork_version'].toString();
			if(currentVersion.toUpperCase()	==	artwotkVersion.toUpperCase())
			{
				returnValue = false;
				selectUniqueArtworkVersionIndex = i;
				break;
			}
			
		}
	}
	return returnValue;
}
private function isCustomerPOAttach():Boolean
{
	var dgXml:XMLList  = dtlArtwork.dgDtl.rows.(trans_flag='A');
	var returnValue:Boolean = false;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var artwotkVersion:String  = dgXml.children()[i]['artwork_version'].toString();
		if(artwotkVersion.toUpperCase().search('CUSTOMER PO')>=0)
		{
			returnValue = true;
			break;
		}
	}
	return returnValue;
}

private function setReassignFlag(event:GenCheckBoxEvent):void
{
	var source:String  = event.target.id.toString();
	if(source.toUpperCase()	== 'CBREASSIGNEDTOORDERENTRY')
	{
		if(cbReassignedToOrderEntry.dataValue=='Y')
		{
			cbQualityCheckCompleted.dataValue	= 'N';
			dcAssignUser.dataValue				= '';
			dcAssignUser.labelValue				= '';
			hbAssignUser.visible				= true;
		}
		else
		{
			dcAssignUser.dataValue				= '';
			dcAssignUser.labelValue				= '';
			hbAssignUser.visible				= false;
		}
	}
	else if(source.toUpperCase()	== 'CBQUALITYCHECKCOMPLETED')
	{
		if(cbQualityCheckCompleted.dataValue	== 'Y')
		{
			cbReassignedToOrderEntry.dataValue		= 'N';
			dcAssignUser.dataValue					= '';
			dcAssignUser.labelValue					= '';
			hbAssignUser.visible					= false;
		}
		
	}
}
private function setNextTabSelected(index:int,focusComponent:UIComponent):void
{
	tnDetail.selectedIndex	= index+1;
	focusComponent.setFocus();
}			
private function clickFinishOrder():void
{
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}
private function setRushOrderFlag():Boolean
{
	var returnValue:Boolean = false;
	var dgXml:XMLList  = dtlSetup.dgDtl.rows.(trans_flag='A');
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
		var index:int = catalog_item_code.toLowerCase().search('rush');
		if(index>=0)
		{
			returnValue = true;
			break;
		}
	}
	return returnValue;
}
private function isInLots(qty:int,lotsize:int):Boolean
{
	var returnValue:Boolean= false;
	returnValue =  (((qty %lotsize)==0) ? true : false);
	return returnValue;
}
private function discardChangeEvent(event:CloseEvent):void
{
	if(event.detail == Alert.YES)
	{
		isOkToSSave	=	true;
		preSaveEvent = new PreSaveEvent();
		preSaveEvent.dispatch();
	}
}
private function alertListner(event:CloseEvent):void
{
	if(event.detail == Alert.YES)
	{
		cbOrderEnterCompleted.dataValue = 'Y';
	}
	isOkOrderEntrySSave  = true;
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}
private function setReorderTypeChnages():void
{
	/*if(String(cbReorderType.dataValue).toUpperCase()=='NORMAL')
	{
		cbPPRequired_flag.dataValue   = 'N';
	}
	else if(String(cbReorderType.dataValue).toUpperCase()=='NORMAL WITH PROOF')
	{
		cbPPRequired_flag.dataValue   = 'Y';
	}
	else if(String(cbReorderType.dataValue).toUpperCase()=='CHANGE WITH PROOF')
	{
		cbPPRequired_flag.dataValue   = 'Y';
	}*/
	changePaperProofFlag();
	changeRushOrderType();
	
	if(cbReorderType.dataValue.toUpperCase()==ApplicationConstant.REORDER_TYPE_NORMAL && saveXml.children().length()>0)
	{
		setShippingFromOrder(saveXml);
	}
	
}

private function changeRushOrder():void
{
	if(cbRushOrder.dataValue=='Y')
	{
		addDefaultRushCharge();
	}
	else
	{
		removeDefaultRushSetupItem();
	}
	
}



private function addDefaultRushCharge():void
{
	if(!isExistDefaultRushCharge()&& dcCustomer_id.dataValue!=''&& dcCustomer_id.dataValue!=null)
	{
		var callbacksSetupItem:IResponder	=	new mx.rpc.Responder(addDefaultRushSetupItemHandler, null);
		
		getDefaultSetupEvent				=	new GetInformationEvent('fetch_default_rush_setup_item', callbacksSetupItem, dcCustomer_id.dataValue);
		getDefaultSetupEvent.dispatch();
	}
	else
	{
		cbRushOrder.dataValue   = 'N';
	}
}

private function addDefaultRushSetupItemHandler(resultXml:XML):void
{					
	var xml:XML   				= dtlSetup.dgDtl.rows;
	xml.appendChild(resultXml.children().copy());
	
	dtlSetup.dgDtl.rows  		= xml.copy();
	__localModel.setupXml       = xml.copy();
}
private function removeDefaultRushSetupItem():void
{
	var index:int = -1;
	var dgXml:XMLList  = dtlSetup.dgDtl.rows.(trans_flag='A');
	
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
		if(catalog_item_code=='RUSHDAY1')
		{
			index = i;
			break;
		}
	}
	
	if(index>=0)
	{
		dtlSetup.deleteRow(index);	
	}
}
private function isExistDefaultRushCharge():Boolean
{
	var returnValue:Boolean 	= false;
	var dgXml:XMLList  			= dtlSetup.dgDtl.rows.(trans_flag='A');
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
		if(catalog_item_code=='RUSHDAY1')
		{
			returnValue = true;
			break;
		}
	}
	return returnValue;
}

private function changeRushOrderType():void
{
	/*if(String(cbReorderType.dataValue).toUpperCase()=='CHANGE WITH PROOF')
	{
		addDefaultRushChangeWithProofCharge();
	}
	else
	{
		removeDefaultRushChangeWithProofSetupItem();
	}*/
	
	if(String(cbReorderType.dataValue).toUpperCase()==ApplicationConstant.REORDER_TYPE_CHANGEWITHARTWORK)
	{
		addDefaultRushChangeWithProofCharge();
	}
	else
	{
		removeDefaultRushChangeWithProofSetupItem();
	}
	
}

private function isExistDefaultRushChnageWithProofCharge():Boolean
{
	var returnValue:Boolean 	= false;
	var dgXml:XMLList  			= dtlSetup.dgDtl.rows.(trans_flag='A');
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
		if(catalog_item_code==ApplicationConstant.DEFAULT_CHANGE_WITH_PROOF)
		{
			returnValue = true;
			break;
		}
	}
	return returnValue;
}
private function addDefaultRushChangeWithProofCharge():void
{
	if(!isExistDefaultRushChnageWithProofCharge() && dcCustomer_id.dataValue!='')
	{
		var callbacksSetupItem:IResponder	=	new mx.rpc.Responder(addDefaultRushChnageWithProofSetupItemHandler, null);
		
		//getDefaultSetupEvent				=	new GetInformationEvent('fetch_default_change_with_proof_setup_item', callbacksSetupItem, dcCustomer_id.dataValue);
		getDefaultSetupEvent				=	new GetInformationEvent('fetch_default_setup_item', callbacksSetupItem, dcCustomer_id.dataValue);
		getDefaultSetupEvent.dispatch();
	}
}
private function addDefaultRushChnageWithProofSetupItemHandler(resultXml:XML):void
{					
	var xml:XML   				= dtlSetup.dgDtl.rows;
	xml.appendChild(resultXml.children().copy());
	
	dtlSetup.dgDtl.rows  		= xml.copy();
	dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));
	__localModel.setupXml       = xml.copy();
}
private function removeDefaultRushChangeWithProofSetupItem():void
{
	var index:int = -1;
	var dgXml:XMLList  = dtlSetup.dgDtl.rows.(trans_flag='A');
	
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
		if(catalog_item_code==ApplicationConstant.DEFAULT_CHANGE_WITH_PROOF)
		{
			index = i;
			break;
		}
	}
	
	if(index>=0)
	{
		dtlSetup.deleteRow(index);	
	}
}
private function isItemExist(code:String,xml:XML):Boolean
{
	var return_value:Boolean = false;
	for(var i:int=0;i<xml.children().length();i++)
	{
		if(code ==xml.children()[i].catalog_item_code.toString())
		{
			return_value = true;
			break;
		}
	}
	return return_value;
}

private function setCustomerContactvalueSave():void
{
	//tiCustomer_conatctsavevalue.dataValue  = dcCustomerContact.dataValue;
}
private function setCustomerContact():void
{
	if(dcCustomer_id.dataValue != '' && dcCustomer_id.dataValue != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(setCustomerContactDetailHandler, null);
		customer_contact		 =	new GetInformationEvent('fetch_customer_contact', callbacks, dcCustomer_id.dataValue);
		customer_contact.dispatch(); 
	}
	isCustomerChnage=true;
}
private function setCustomerContactDetailHandler(resultXml:XML):void
{
	//dcCustomerContact.dataProvider	= resultXml.children();
	
	if(isCustomerChnage==true)
	{
		//setDefaultContact(dcCustomerContact);
	}
}
public  function setDefaultContact(cb:GenDynamicComboBox):void
{
	var index:int  = -1;
	for(var i:int =0; i<XMLList(cb.dataProvider).length();i++)
	{
		var contact:String		= XMLList(cb.dataProvider)[i].contact_name.toString();
		var defaultValue:String = XMLList(cb.dataProvider)[i].default_contact_flag.toString();
		if(defaultValue.toUpperCase()=='Y')
		{
			index = i;
			break;
		}
	}
	if(index>=0)
	{
		cb.dataValue	 						= contact;
	}
	isCustomerChnage  = false;
	
}
private function showItemDetail():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.openItemDetail(resultXmlFromItem,DataEntry(this.parentDocument),getMainImageName());
}
private function setMissingInfo():void
{
	var missing_info:String = '';
	if(isOptionSet()!='')
	{
		missing_info = missing_info.concat("Following Options are not selected ;\n");
		missing_info = missing_info.concat(isOptionSet()+"\n\n");
	}
	if(isShippingSet()!='')
	{
		missing_info = missing_info.concat( isShippingSet()+ "\n\n");
	}
	if(!isArtworkSet())
	{
		missing_info = missing_info.concat("Customer Artwork Missing ;\n\n");
	}
	if(!isPaymentInfoSet())
	{
		missing_info = missing_info.concat("Payment Info Missing ;\n\n");
	}
	if(!isLogoSet())
	{
		missing_info = missing_info.concat("Logo Missing ;\n\n");
	}
	taMissingInfo.text  = missing_info;
	
}
private function isLogoSet():Boolean
{
	var returnStr:Boolean = false;
	if(tiLogoField.dataValue=='')
	{
		returnStr  = false;
	}
	else
	{
		returnStr  = true;
	}
	return returnStr;
}
private function isPaymentInfoSet():Boolean
{
	if(cbPaymentAuthorize_flag.dataValue=='Y')
	{
		return true;
	}
	else
	{
		var returnStr:Boolean = false;
		if(dcTerm_code.dataValue.toUpperCase()=='CC' && dcPaymentProfle_code.dataValue =='' && cbPaymentAuthorize_flag.dataValue=='N'  && Number(tiNetAmount.dataValue)>0)
		{
			returnStr  = false;
		}
		else
		{
			returnStr  = true;
		}
		return returnStr;
	}
	
}
private function isOptionSet():String
{
	var resultXml:XML			= resultXmlFromItem;
	var attributeXml:XMLList	= XMLList(resultXml.attributes);
	
	var returnStr:String = '';
	for(var i:int=0;i<vbMain.getChildren().length;i++)
	{
		var hbox:HBox 						   = HBox(vbMain.getChildByName('hb'+i));
		var cb:ComboBox  					   = ComboBox(hbox.getChildAt(1));
		var missing_info_required_flag:String  = attributeXml.children()[i].missing_info_required_flag.toString();
		
		if(missing_info_required_flag.toUpperCase()=='Y')
		{
			if(cb.selectedIndex<0 && hbox.visible)
			{
				returnStr    = returnStr.concat(Label(hbox.getChildAt(0)).text+';'+'  ');
			}
			else if(hbox.visible && cb.selectedItem.code.toString() =='')
			{
				returnStr    = returnStr.concat(Label(hbox.getChildAt(0)).text+';'+'  ');
			}
		}
	}
	return returnStr;
}
private function isShippingSet():String
{
	var returnValue:String = '';
	var dgXml:XMLList  = dtlShippings.dgDtl.rows.(trans_flag='A');
	
	var total_qty:Number = 0;
	var remainQty:int	 = Number(tiQty.dataValue);
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		total_qty = total_qty + Number(dgXml.children()[i]['ship_qty'].toString());
	}
	
	remainQty   		=  Number(tiQty.dataValue)-total_qty;
	
	if(dgXml.children().length()<=0 || remainQty >0 )
	{
		returnValue  = "Shipping info missing for "+remainQty+" Quantity\n\n";
	}
	
	
	//ship date, ship_method, inhand_date logic
	var ship_date_missing:String = '';
	var ship_method_missing:String='';
	var inhand_date_missing:String = '';
	for(var j:int = 0 ; j < dgXml.children().length(); j++)
	{
		if(dgXml.children()[j]['ship_date'].toString()=='' && dgXml.children()[j]['inhand_date'].toString()=='' && dgXml.children()[j]['estimated_ship_date'].toString()=='' && dgXml.children()[j]['estimated_arrival_date'].toString()=='' )
		{
			ship_date_missing 			= ship_date_missing+"Ship Date or Inhand Missing in "+(j+1)+" Line Of Shipping\n";
		}
		if(dgXml.children()[j]['shipping_code'].toString()=='UPS' ||  dgXml.children()[j]['shipping_code'].toString()=='FEDEX')
		{
			if(dgXml.children()[j]['ship_method'].toString()=='')
			{
				ship_method_missing 	  	= ship_method_missing+"Ship Method Missing in "+(j+1)+" Line Of Shipping\n";
			}
		}
		else if(dgXml.children()[j]['shipping_code'].toString()=='THIRDPARTY')
		{
			if(dgXml.children()[j]['shipvia_accountnumber'].toString()=='')
			{
				ship_method_missing 	  	= ship_method_missing+"Account # Missing in "+(j+1)+" Line Of Shipping\n";
			}
		}
		else
		{
			
		}
		
		/*if(dgXml.children()[j]['inhand_date'].toString()=='')
		{
		inhand_date_missing 	  	= inhand_date_missing+"Inhand Date Missing in "+(j+1)+" Line Of Shipping\n";
		}*/
	}
	
	if(ship_date_missing!='')
	{
		returnValue  = returnValue + ship_date_missing+"\n";
	}
	if(ship_method_missing!='')
	{
		returnValue  = returnValue + ship_method_missing+"\n";
	}
	if(inhand_date_missing!='')
	{
		returnValue  = returnValue + inhand_date_missing+"\n";
	}
	
	return returnValue;
	
}
private function isArtworkSet():Boolean
{
	var dgXml:XMLList  = dtlArtwork.dgDtl.rows.(trans_flag='A');
	var returnValue:Boolean = false;
	/*for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var artwotkVersion:String  = dgXml.children()[i]['artwork_version'].toString();
		if(artwotkVersion.toUpperCase()=='CUSTOMER ART')
		{
			returnValue = true;
			break;
		}
	}*/
	if(dgXml.children().length()>0)
	{
		returnValue  = true;
	}
	return returnValue;
	
}
private  function openShippingAddress():void
{
	//dtlShippings.bcdp.dispatchEvent(new ButtonControlDetailEvent('editRowEvent'));
	__localModel.ext_ref_no			= tiCustomer_po_id.text;
}
private function isItUnique(value:String,column_name:String,table_name:String,customer_id:String):void
{
	var unique:HTTPService = dataService(__service.getHTTPService("validateUniqueness"));
	__responderPick = new mx.rpc.Responder(uniqueCheckResultHandler,uniqueCheckFaultHandler);
	
	var token:AsyncToken = unique.send(new XML(	<params>
													<value>{value}</value>
													<column_name>{column_name}</column_name>
													<table_name>{table_name}</table_name>
													<customer_id>{customer_id}</customer_id>
												</params>));
	token.addResponder(__responderPick);	
	
}
public function uniqueCheckResultHandler(event:ResultEvent):void
{
	
	var result:XML = XML(event.result);
	
	if(result.toString()=='NotExist')
	{
		dtlShippings.bcdp.dispatchEvent(new ButtonControlDetailEvent('editRowEvent'));
	}
	else
	{
		Alert.show("Customer PO #"+tiCustomer_po_id.dataValue+" already Exist");
		tiCustomer_po_id.dataValue  = '';
	}
	
}
public function uniqueCheckFaultHandler(event:FaultEvent):void
{
	Alert.show("UniqueNess"+event.fault.faultDetail);
	
	tiCustomer_po_id.dataValue  = '';
}

private function openCustomerScreen():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.drilldownToCustomerScreen(dcCustomer_id);
}
private function openCustomerCouponScreen():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.drilldownToCustomerCouponScreen(tiCustomer_coupons_id);
}
private function openCustomerContact():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.drilldownToCustomerContact(dcCustomer_Contact_id,dcCustomer_id);
}
private function setPaymentTerm(msg_flag:Boolean):void
{
	if(dcTerm_code.dataValue.toUpperCase()=="CC")
	{
		isTermCreditCard		= true;
	}
	else
	{
		isTermCreditCard		= false;
	}
}
private function getContactDetails():void
{
	if(dcCustomer_Contact_id.text != "" && dcCustomer_Contact_id.text != null && dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(contactDetailsHandler, null);
		
		getInformationEvent			=	new GetInformationEvent('fetch_customer_contact_detail', callbacks,dcCustomer_id.dataValue, dcCustomer_Contact_id.dataValue);
		getInformationEvent.dispatch();
	}
	else
	{
		Alert.show("Please Select Customer and Contact");
	}
}
private function contactDetailsHandler(resultXml:XML):void
{
	if(resultXml.children().length()>0 && resultXml.children()[0].child('business_phone').toString()!='')
	{
		tiCustomer_phone.dataValue			= resultXml.children()[0].child('business_phone').toString();
	}
	else
	{
		tiCustomer_phone.dataValue			= customer_phone;
	}
}
private function authenticateCardNo():void
{
	//var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	//commonMooduleFunctions.authenticateCreditCardNoAndCardType(tiCardNO,cbCard_type);
}
private function openPaymentGatway():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.openPaymentGatwayPage();
}
private function setMainItemAmount():void
{
	var oldMianItemAmount:Number					= Number(tiMainItem_amt.dataValue);
	
	var item_amount:Number							= Number(tiQty.dataValue)*Number(tiPrice.dataValue);
	tiMainItem_amt.dataValue	  					= numericFormatter.format(item_amount);
	
	var diffamount:Number							= Number(tiMainItem_amt.dataValue) - oldMianItemAmount;
	tiItem_amt.dataValue							= numericFormatter.format(Number(tiItem_amt.dataValue)+diffamount);
	
	setNetAmount();
	
	updateRushItemPrice();
	
}
private function updateRushItemPrice():void
{
	var dgXml:XMLList  					= dtlSetup.dgDtl.rows.(trans_flag='A');
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String 	= dgXml.children()[i].catalog_item_code.toString(); 
		for(var j:int=0;j<XMLList(cbRushType.dataProvider).length();j++)
		{
			if(catalog_item_code==XMLList(cbRushType.dataProvider)[j].value.toString())
			{
				setDefaultSetupItemPrice(dgXml.children()[i]);
			}
		}
	}
	
	var tempXml:XML		    			= 		XML(dgXml).copy();
	dtlSetup.dgDtl.rows			  		=    	tempXml;                // for show update value
	setItemAmount(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));
	
}
private function discount_perChange():void
{
	var _gross_amt:Number = Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _dis_per:Number = parseFloat(tiDiscount_per.text);
		var _dis_amt:Number;
		
		if (_dis_per == 0 || String(_dis_per) == 'NaN' || String(_dis_per) == '')
		{
			_dis_amt = 0;
			tiDiscount_per.text = numericFormatter.format(String(0.00));
		}
		else
		{
			_dis_amt = Number(numericFormatter.format(_gross_amt * _dis_per / 100));
		} 
		tiDiscount_amt.text = numericFormatter.format(String(_dis_amt));
		tiDiscount_per.text = numericFormatter.format(tiDiscount_per.text);				
		setNetAmount(); 
	}
}
private function discount_amtChange():void
{
	var _gross_amt:Number = Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _dis_amt:Number = parseFloat(tiDiscount_amt.text);
		if (_dis_amt == 0 || String(_dis_amt) == 'NaN')
		{
			tiDiscount_per.text = String(0.00);
		}
		else
		{
			tiDiscount_per.text = numericFormatter.format(String(Number(_dis_amt / _gross_amt * 100)));
		} 
		tiDiscount_amt.text	 = numericFormatter.format(tiDiscount_amt.text);
		setNetAmount(); 
	}
}
private function tax_perChange():void
{
	//numericFormatter.precision = 4;
	//var _gross_amt:Number 	= Number(tiTaxable_amt.text);
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _tax_per:Number = parseFloat(tiTax_per.text);
		var _tax_amt:Number;
		if (_tax_per == 0 || String(_tax_per) == 'NaN' || String(_tax_per) == '')
		{
			_tax_amt = 0;
			tiTax_per.text = numericFormatterFourPrecesion.format(String(0));
		}
		else
		{
			_tax_amt = Number(numericFormatterFourPrecesion.format(_gross_amt *_tax_per / 100));
		} 
		tiTax_amt.text = numericFormatterFourPrecesion.format(String(_tax_amt));
		//numericFormatter.precision = 3;
		tiTax_per.text = numericFormatterThreePrecesion.format(tiTax_per.text);
		setNetAmount(); 
		
	}
}

private function tax_amtChange():void
{
	var _tax_amt:Number 	= parseFloat(tiTax_amt.text);
	//var _gross_amt:Number 	= Number(tiTaxable_amt.text);
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	if (_tax_amt == 0 || String(_tax_amt) == 'NaN')
	{
		tiTax_per.text = String(0.000);
	}
	else
	{
		tiTax_per.text = numericFormatterThreePrecesion.format(String(Number(_tax_amt / _gross_amt * 100)));
	}
	//numericFormatter.precision = 4;
	tiTax_amt.text = numericFormatterFourPrecesion.format(tiTax_amt.text);
	//numericFormatter.precision = 2;
	setNetAmount(); 
}

private function ship_amtChange():void
{
	var dgXml:XMLList  = dtlShippings.dgDtl.rows.(trans_flag='A');
	
	var total_ship_amt:Number = 0.00;
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var temp:Number	= Number(numericFormatter.format(dgXml.children()[i]['ship_amt'].toString()));
		total_ship_amt = total_ship_amt + temp;
	}
	tiShipAmount.dataValue	= total_ship_amt.toString();
	setNetAmount(); 
}

private function other_amtChange():void
{
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _other_amt:Number 	= parseFloat(tiOther_amt.text);
		if (String(_other_amt) == 'NaN' || String(_other_amt) == '') 
		{
			tiOther_amt.text = numericFormatter.format(String(0.00));
		}
		tiOther_amt.text = numericFormatter.format(tiOther_amt.text);
		setNetAmount(); 
	}
}
private function setNetAmount():void
{
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	
	if (_gross_amt >= 0)
	{
		var _dis_amt:Number  = Number(numericFormatter.format(tiDiscount_amt.text));
		var _ship_amt:Number = Number(numericFormatter.format(tiShipAmount.text));
		//var _ins_amt:Number  = Number(numericFormatter.format(tiInsurance_amt.text));
		var _sal_tax:Number  = Number(numericFormatter.format(tiTax_amt.text));
		var _other_amt:Number = parseFloat(numericFormatter.format(tiOther_amt.text));
		
		if (String(_other_amt) == 'NaN' || String(_other_amt) == '') 
		{
			tiOther_amt.text = String(0.00);
		} 
		/*tiNet_amt.text = numericFormatterThreePrecesion.format(String(_gross_amt + _ship_amt - _dis_amt + _ins_amt + _sal_tax + _other_amt)); */
		tiNetAmount.text = numericFormatter.format(String(_gross_amt + _ship_amt - _dis_amt  + _sal_tax + _other_amt));
	} 
	
}
private function setItemAmount(event:DetailEvent):void
{
	// for setup Item
	var dgSetupXml:XMLList  = dtlSetup.dgDtl.rows.(trans_flag='A');
	var total_setup_amt:Number = 0.00;
	for(var i:int = 0 ; i < dgSetupXml.children().length(); i++)
	{
		var temp:Number	= Number(dgSetupXml.children()[i]['item_amt'].toString());
		total_setup_amt = total_setup_amt + temp;
	}
	
	// for accessories item
	var dgAccessoriesXml:XMLList  = dtlAssessories.dgDtl.rows.(trans_flag='A');
	var total_accessories_amt:Number = 0.00;
	for(var i:int = 0 ; i < dgAccessoriesXml.children().length(); i++)
	{
		var temp:Number	= Number(dgAccessoriesXml.children()[i]['item_amt'].toString());
		total_accessories_amt = total_accessories_amt + temp;
	}
	
	var total_amount:Number  = Number(tiMainItem_amt.dataValue) + total_accessories_amt + total_setup_amt;
	
	tiItem_amt.dataValue     = numericFormatter.format(total_amount);
	
	
	discount_perChange();
	tax_perChange();
	
	
}
private function setMainItemAmountAfterSave():void
{
	var item_amount:Number							= Number(tiQty.dataValue)*Number(tiPrice.dataValue);
	tiMainItem_amt.dataValue	  					= numericFormatter.format(item_amount);
}
private function rushTypeChnagehandler():void
{
	if(dcCustomer_id.dataValue!='')
	{
		removeDefaultRushSetupItemFromSetupGrid();
		
		if(cbRushType.dataValue !='')
		{
			addDefaultRushChargeToSetupGrid();
			cbRushOrder.dataValue	= 'Y';
		}
		else
		{
			cbRushOrder.dataValue	= 'N';
		}
	}
	else
	{
		cbRushType.dataValue =''
		Alert.show("Please Select Customer");
	}
	
}
private function removeDefaultRushSetupItemFromSetupGrid():void
{
	var dgXml:XMLList  = dtlSetup.dgDtl.rows.(trans_flag='A');
	
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
		for(var j:int=0;j<XMLList(cbRushType.dataProvider).length();j++)
		{
			if(catalog_item_code==XMLList(cbRushType.dataProvider)[j].value.toString())
			{
				dtlSetup.deleteRow(i);
			}
		}
		
	}
	setItemAmount(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));
}
private function addDefaultRushChargeToSetupGrid():void
{
	if(!isExistDefaultRushChargeInSetupGrid())
	{
		var tempXml:XML			= dtlSetup.dgDtl.rows;
		var selectedItem:XML 	= cbRushType.selectedItem.copy();
		
		tempXml.appendChild(setDefaultSetupItemPrice(selectedItem).copy());
		dtlSetup.dgDtl.rows	= tempXml;
	}
	setItemAmount(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));
}
private function isExistDefaultRushChargeInSetupGrid():Boolean
{
	var returnValue:Boolean 	= false;
	var dgXml:XMLList  			= dtlSetup.dgDtl.rows.(trans_flag='A');
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
		for(var j:int=0;j<XMLList(cbRushType.dataProvider).length();j++)
		{
			if(catalog_item_code==XMLList(cbRushType.dataProvider)[j].value.toString())
			{
				returnValue		= true;
				break;
			}
		}
	}
	return returnValue;
}
private function setDefaultSetupItemPrice(xml:XML):XML
{
	var main_item_amount:String		= 	tiMainItem_amt.dataValue;
	
	
	if(main_item_amount!='')
	{
		xml.item_qty		=	tiQty.dataValue;
		
		if(xml.catalog_item_code.toString()==DEFAULTRUSHITEM1)
		{
			xml.item_price	= (Number(tiPrice.dataValue)*35)/100;
		}	
		else if(xml.catalog_item_code.toString()==DEFAULTRUSHITEM2)
		{
			xml.item_price	= (Number(tiPrice.dataValue)*30)/100; 
		}
	}
	xml.item_amt			= (Number(xml.item_price.toString())* Number(xml.item_qty.toString())).toString();
	return xml;
	
}
private function isExistItemInGivenXml(xml:XML,catalog_item_code:String):Boolean
{
	var returnValue:Boolean 	= false;
	var dgXml:XML  				= xml;
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code_temp:String = dgXml.children()[i].catalog_item_code.toString(); 
		if(catalog_item_code_temp==catalog_item_code)
		{
			returnValue = true;
			break;
		}
	}
	return returnValue;
}

private function authenticateCreditCardFromAthorizeNet():void
{
	var record:XML													= __localModel.addEditObj.record;
	
	if(record!=null)
	{
		var sales_order_id:String									= __localModel.addEditObj.record.children()[0].id.toString();
		var customer_payment_profile_code:String					= dcPaymentProfle_code.dataValue;
		var customer_profile_code:String							= tiCustomer_profile_code.dataValue;
		var amount:Number											= Number(numericFormatter.format(tiNetAmount.dataValue));
		
		if(amount>0 && sales_order_id!='' && customer_payment_profile_code!='' && customer_profile_code!='')
		{
			var callbacks:IResponder	=	new mx.rpc.Responder(athenticateResultHandler, null);
			getInformationEvent			=	new GetInformationEvent('authorize_customer_payment', callbacks,sales_order_id,customer_payment_profile_code,customer_profile_code,amount,__genModel.user.userID);
			getInformationEvent.dispatch();
		}
		else
		{
			Alert.show("Please Fill Information for authorize payment Or Select Payment Profile");
		}
		
	}
	else
	{
		Alert.show("Please Save Record Before Authorize Payment");
	}

}

private function athenticateResultHandler(resultXml:XML):void
{
	var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__localModel.addEditObj.record.children()[0].id.toString()),null,false);
	getRecordEvent.dispatch();
	
	Alert.show(resultXml.toString());
	dcPaymentProfle_code.dataValue  = '';
	dcPaymentProfle_code.labelValue = '';
	paymentProfileCardNumber        = '';
	paymentProfileCode              = '';
	
}
private function athenticateFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.faultDetail.toString());
}

private function setExteRefDate():void
{
	__localModel.ext_ref_date   = dfCustomer_po_date.dataValue;
}
private function setShippingBalanceQty():void
{
	var total_qty:Number 	= 0;
	var remainQty:int	 	= Number(tiQty.dataValue);
	
	var dgXml:XMLList  		= dtlShippings.dgDtl.rows.(trans_flag='A');
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		total_qty = total_qty + Number(dgXml.children()[i]['ship_qty'].toString());
	}
	
	remainQty   			=  Number(tiQty.dataValue)-total_qty;
	
	if(remainQty<0)
	{
		remainQty			= 0;
	}
	
	__localModel.main_item_qty	= remainQty.toString();
	__localModel.main_item_qty_total = tiQty.dataValue;
}
private function changeNextDayFlag():void
{
	if(cbNext_Day_Flag.dataValue.toUpperCase() 		== 'N')
		__localModel.next_day_flag	= false;
	else if(cbNext_Day_Flag.dataValue.toUpperCase()	== 'Y')
		__localModel.next_day_flag	= true;
	
	setParamforEstimate();
	//setEstimatedDateByIncrement(cbNext_Day_Flag.dataValue.toUpperCase());
	
}
private function setEstimatedDateByIncrement(flag:String):void
{
	var dgXml:XMLList  = dtlShippings.dgDtl.rows.(trans_flag='A');
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var estimated_ship_date:String  	=  dgXml.children()[i]['estimated_ship_date'].toString();
		var estimated_Inhand_date:String  	=  dgXml.children()[i]['estimated_arrival_date'].toString();
		
		var noofDays:Number					= getNoOfdays(estimated_ship_date,estimated_Inhand_date);
		
		var requested_ship_date:String  	=  dgXml.children()[i]['ship_date'].toString();
		if(estimated_ship_date!='' && estimated_ship_date!=null)
		{
			if(flag=='Y')
			{
				dgXml.children()[i]['estimated_ship_date']  		= addDaysToDate(estimated_ship_date,1);
				if(requested_ship_date=='')
				{
					dgXml.children()[i]['internal_ship_date'] 	 	= dgXml.children()[i]['estimated_ship_date'].toString();
				}
				else
				{
					dgXml.children()[i]['internal_ship_date'] 	 	= dgXml.children()[i]['ship_date'].toString();
				}
			}
			else
			{
				dgXml.children()[i]['estimated_ship_date']  		= addDaysToDate(estimated_ship_date,-1);
				if(requested_ship_date=='')
				{
					dgXml.children()[i]['internal_ship_date'] 	 	= dgXml.children()[i]['estimated_ship_date'].toString();
				}
				else
				{
					dgXml.children()[i]['internal_ship_date'] 	 	= dgXml.children()[i]['ship_date'].toString();
				}
			}
		}
		
		if(noofDays.toString()!='NaN')
		{
			var estimated_ship_date_now:String  						=  dgXml.children()[i]['estimated_ship_date'].toString();
			dgXml.children()[i]['estimated_arrival_date'] 	 			=  addDaysToDate(estimated_ship_date_now,noofDays);
			
			var requested_inhand_date:String  							=  dgXml.children()[i]['inhand_date'].toString();
			if(requested_inhand_date=='')
			{
				dgXml.children()[i]['internal_inhand_date'] 	 		= dgXml.children()[i]['estimated_arrival_date'].toString();
			}
			else
			{
				dgXml.children()[i]['internal_inhand_date'] 	 		= dgXml.children()[i]['inhand_date'].toString();
			}
		}
		
	}
	dtlShippings.dgDtl.rows  		= XML(dgXml).copy();
	dtlShippingsHeader.dgDtl.rows	= XML(dgXml).copy();
}
private function addDaysToDate(date:String,days:Number):String
{
	var now:Date 						 = new Date(date);
	now.date 							+= days;
	
	var df:GenDateField					= new GenDateField();
	return DateField.dateToString(now,df.databaseDateFormat);
	
}
private function getNoOfdays(date1:String, date2:String):Number
{
	var dateFirst:Date 						 		= new Date(date1);
	var dateSecond:Date 						 	= new Date(date2);
	var one_day:Number = 1000 * 60 * 60 * 24;	
	var date1_ms:Number = dateFirst.getTime();
	var date2_ms:Number = dateSecond.getTime();
	var difference_ms:Number = Math.abs(date1_ms - date2_ms)
	return Math.round(difference_ms/one_day);
}
private function setBillingAddressIntoShipping():void
{
	__localModel.billing_address.bill_name 	= tiName.dataValue;
	__localModel.billing_address.address1 	= tiBill_address1.dataValue;
	__localModel.billing_address.address2	= tiBill_address2.dataValue;
	__localModel.billing_address.city		= tiBill_city.dataValue;
	__localModel.billing_address.state		= tiBill_state.dataValue;
	__localModel.billing_address.zip		= tiBill_zip.dataValue;
	__localModel.billing_address.country	= tiBill_country.dataValue;
	__localModel.billing_address.phone1		= tiBill_phone1.dataValue;
	__localModel.billing_address.phone2		= tiBill_phone1.dataValue;
	__localModel.billing_address.fax		= tiBill_fax1.dataValue;
}
private function givemsgBeforeAthorizeAmount():void
{
	if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly)
	{
		paymentProfileCode  		= dcPaymentProfle_code.dataValue;
		paymentProfileCardNumber	= dcPaymentProfle_code.labelValue
		
		var record:XML				= __localModel.addEditObj.record;
		
		if(dcPaymentProfle_code.dataValue!='')
		{
			if(record!=null && !__genModel.activeModelLocator.addEditObj.editStatus)
			{
				Alert.show("Amount authorization is about to be done. Are you sure?","Authorize Order Amount",Alert.YES | Alert.NO,this,alertListener,null,Alert.OK)
			}
			else
			{
				Alert.show("Please Save Record Before Authorize Payment");
			}
		}
		else
		{
			Alert.show("Please select payment profile");
		}
	}
}

private function alertListener(event:CloseEvent):void
{
	switch (event.detail)
	{
		case Alert.YES:
			authenticateCreditCardFromAthorizeNet();
			break;
		case Alert.NO:
			
			break;
	}
}

private function setartworkFinalFlag():void
{
	if(cbOrder_type.dataValue.toUpperCase()=='E' && cbReorderType.dataValue.toUpperCase()==ApplicationConstant.REORDER_TYPE_NORMAL)
	{
		var xml:XMLList  = dtlArtwork.dgDtl.rows.(trans_flag='A');
		for(var i:int=0;i<xml.children().length();i++)
		{
			xml.children()[i].final_artwork_flag = 'Y';
		}
	}
	else
	{
		var xml:XMLList  = dtlArtwork.dgDtl.rows.(trans_flag='A');
		for(var i:int=0;i<xml.children().length();i++)
		{
			xml.children()[i].final_artwork_flag = 'N';
		}
	}
}

private function genratePO():void
{
	if(__localModel.addEditObj.record!=null)
	{
		if(__localModel.addEditObj.editStatus==false)
		{
			var generatePOPopUp:GeneratePoPopUp			= GeneratePoPopUp(PopUpManager.createPopUp(this,GeneratePoPopUp,true));
			generatePOPopUp.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,poMissingInfoEventListner);
			generatePOPopUp.x							= ((Application.application.width/2)-(generatePOPopUp.width/2));
			generatePOPopUp.y							= ((Application.application.height/2)-(generatePOPopUp.height/2));
		}
		else
		{
			Alert.show("Please Save Order");
		}
		
		
	}
	else
	{
		Alert.show("Please Save Order");
	}
}
private function poMissingInfoEventListner(event:MissingInfoEvent):void
{
	var resultXml:XML   = event.xml.copy();
	if(resultXml.name() == "errors")
	{
		
	}
	else
	{
		var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__localModel.addEditObj.record.children()[0].id.toString()),null,false);
		getRecordEvent.dispatch();
	}
}
private function resendAcknowledgment():void
{
	commonLinksServices.resendAcknowledgment();
}
private function sendArtworkForStitchEstimation():void
{
	commonLinksServices.sendArtworkForStitchEstimation();
}
private function isAllQueryAnswered():Boolean
{
	var tempXml:XMLList  = XMLList(dtlQueries.dgDtl.rows.children().(answer_flag=="N"));
	var dgXml:XML		 = new XML("<" + dtlQueries.rootNode + "/>")
	dgXml.appendChild(tempXml);
	
	var returnValue:Boolean = true;
	
	if(dgXml.children().length()>0)
	{
		returnValue         = false;
	}
	else
	{
		returnValue			= true;
	}
	return returnValue;
}
private function setQueryDateLavelFunction():void
{
	while(true)
	{
		if(dtlQueries.dgDtl.columns.length>0)
		{
			DataGridColumn(dtlQueries.dgDtl.columns[2]).labelFunction = dateFunc;
			break;
		}
	}
	
}
private function setPaymentprofileCode():void
{
	paymentProfileCode  		= dcPaymentProfle_code.dataValue;
	paymentProfileCardNumber	= dcPaymentProfle_code.labelValue
}

private function viewThreads():void
{
	if(tiTrans_no.dataValue!='')
	{
		var threadList:ThreadList 			= ThreadList(PopUpManager.createPopUp(this,ThreadList,true));
		threadList.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoEventListner);
		threadList.x						= ((Application.application.width/2)-(threadList.width/2));
		threadList.y						= ((Application.application.height/2)-(threadList.height/2));
		threadList.xml 						= new XML(<rows><row><trans_no>{tiTrans_no.dataValue}</trans_no></row></rows>);
	}
	else
	{
		Alert.show("Please Save Order");
	}
}
public function  missingInfoEventListner(event:MissingInfoEvent):void
{
	
}
private function setSendArtworkForEsttimationVisiblity(xml:XML):void
{
	var vendor_id:String   = xml.children()[0].vendor_id.toString();
	if(vendor_id!='')
	{
		lbtnSendForEsttimation.visible  = true;
	}
	else
	{
		lbtnSendForEsttimation.visible  = false;
	}
}

private function checkForPOStatus():void
{
	if(PUOI01.label=='View PO #')
	{
		__genModel.drillObj.drillrow							=	new XML(<rows><trans_no>{tiRefPurchaseOrder.dataValue}</trans_no></rows>);
		__localModel.listObj.drilldown_component_code 			= 	"puoi/purchaseorder/components/PurchaseOrder.swf";
		
		var tabpage:TabPage										=	new TabPage();
		tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
	}
	else
	{
		genratePO();
	}
}
private function visiblityOfGenratePo(workflow:String):void
{
	if(((cbQualityCheckOff_flag.dataValue=='Y' && cbQualityCheckCompleted.dataValue=='N')||(cbQualityCheckOff_flag.dataValue=='N'&& cbQualityCheckCompleted.dataValue=='Y')) && (workflow.toUpperCase()==ApplicationConstant.ITEM_WORKFLOW_EMBROIDERY || workflow.toUpperCase()==ApplicationConstant.ITEM_WORKFLOW_WATER) )
	{
		PUOI01.visible		= true;
		if(PUOI01.label=='View PO #')
		{
			tiRefPurchaseOrder.visible = true;
		}
		else
		{
			tiRefPurchaseOrder.visible = false;
		}
	}
	else
	{
		tiRefPurchaseOrder.visible = false;
		PUOI01.visible			   = false;
	}
}
private function isItemQtyOk(columnXml:XMLList,qty:Number):Boolean
{
	var returnValue:Boolean  = true;
	if(qty<Number((columnXml.column1.toString())/2)) 
	{
		returnValue  = false;
	}
	return returnValue;
}
private function setReAssignFlagVisiblity(xml:XML):void
{
	var orderqcstatus_flag:String   	 = xml.children()[0].orderqcstatus_flag.toString();
	var orderentrycomplete_flag:String   = xml.children()[0].orderentrycomplete_flag.toString();
	
	if(orderqcstatus_flag =='Y')
	{
		cbReassignedToOrderEntry.visible         = false;
		cbReassignedToOrderEntry.includeInLayout = false;
		dcAssignUser.visible					 = false;
	}
}		
private function cancelAthorizeAmount():void
{
	if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly)
	{
		commonMooduleFunctions.givemsgBeforeCancelAthorizeAmount();
	}
	
}		
private function setVisiblityOfAthorizeButton(xml:XML):void
{
	var payment_authorize_flag:String = xml.children()[0].payment_authorize_flag.toString();
	var payment_release_flag:String   = xml.children()[0].payment_release_flag.toString();
	
	if(payment_authorize_flag =='Y')
	{
		btnAthorizePayment.visible		 		= false;
		dcTerm_code.enabled				  		= false;
		dcPaymentProfle_code.enabled	  		= false;
		dcPaymentProfle_code.includeInLayout	= false;
		btnCancelAthorizePayment.visible  		= true;
	}
	else if(payment_authorize_flag=='N')
	{
		btnAthorizePayment.visible		  		= true;
		dcTerm_code.enabled				  		= true;
		dcPaymentProfle_code.enabled	  		= true;
		dcPaymentProfle_code.includeInLayout	= true;
		btnCancelAthorizePayment.visible  		= false;
	}
	else
	{
		btnAthorizePayment.visible		 		= true;
		dcTerm_code.enabled				  		= true;
		dcPaymentProfle_code.enabled	  		= true;
		dcPaymentProfle_code.includeInLayout	= true;
		btnCancelAthorizePayment.visible  		= false;
	}
	setMissingInfo();
}
private function updateEstimateShipAndInhandDate():void
{
	var updateEstimateShipAndInhandDateFunctions:UpdateEstimateShipAndInhandDateFunctions  = new UpdateEstimateShipAndInhandDateFunctions();
	updateEstimateShipAndInhandDateFunctions.updateShippingInfo(cbOrder_type,dcCustomer_id,dfCustomer_po_date,cbNext_Day_Flag,cbRushType,cbPPRequired_flag,dcItemId,tiQty.dataValue,dtlShippings,'N');
}		
private function setIsShipInfoBaseChange():void
{
	if(dtlShippings.dgDtl.rows.children().length()>0)
	{
		__localModel.isShipInfoBaseChange	= true;
	}
}		
private function setParamforEstimate():void
{
	__localModel.ext_ref_date	= dfCustomer_po_date.dataValue;
	__localModel.cbRushType 	= cbRushType.dataValue;
	__localModel.cbNextDayFlag	= cbNext_Day_Flag.dataValue;
	__localModel.cbPaperProof	= cbPPRequired_flag.dataValue;
	__localModel.cbBlankOrderFlag= 'N';
}
private function checkForThirdPartyShippingCharge(dtlShipping:Detail,dtlSetup:Detail,thirdPartyShippingCharge:XML):void
{
	new ThirdPartyShippingChargeCalculation().checkForThirdPartyShippingCharge(dtlShipping,dtlSetup,thirdPartyShippingCharge);
}
public function getMainImageName():String
{
	return commonMooduleFunctions.getMainImageName(dcItemId,vbMain,resultXmlFromItem.image_thumnail.toString());
}

////////////
// make component enable or disable according to reorder type

private function setHeaderPartEnableOrDisable():void
{
	if(cbReorderType.dataValue.toUpperCase()==ApplicationConstant.REORDER_TYPE_NORMAL)
	{
		if(saveXml.children().length()>0 && dcCustomer_id.dataValue!='' && tiTrans_no.dataValue=='')
		{
			getOrderDetailHandler(saveXml);
		}
		//header2.enabled  		= false;
		//header2.setStyle('disabledOverlayAlpha',0);
		vbheader21.enabled	 				= false;
		vbheader21.styleName 				= 'disableSameEnable';
		vbheader22.enabled   				= false;
		vbheader22.styleName 				= 'disableSameEnable';
		//vbheader24.enabled	 				= false;
		//vbheader24.styleName 				= 'disableSameEnable';
		
		cbPPRequired_flag.enabled  			= false;
		cbPPRequired_flag.styleName 		= 'disableSameEnable';
		cbFlagged_flag.enabled	   			= false;
		cbFlagged_flag.styleName 			= 'disableSameEnable';
		cbDo_not_change_ship_date.enabled 	= false;
		cbDo_not_change_ship_date.styleName = 'disableSameEnable';
		
		
		
		
		vbMain.enabled	 					= false;
		vbMain.styleName 					= 'disableSameEnable';
		dtlSetup.enabled 					= false;
		dtlSetup.styleName 					= 'disableSameEnable';
		dtlAssessories.enabled				= false;
		dtlAssessories.styleName 			= 'disableSameEnable';
		vbEmail.enabled						= false;
		vbEmail.styleName 					= 'disableSameEnable';
		
		//vbheader2.enabled		= false;
		//vbheader3.enabled		= false;
		//vbheader4.enabled		= false;
	}
	else
	{
		//header2.enabled  		= true;
		//header2.setStyle('disabledOverlayAlpha',0.5);
		
		vbheader21.enabled	 		= true;
		vbheader21.styleName 		= 'disableAsEnable';
		vbheader22.enabled   		= true;
		vbheader22.styleName 		= 'disableAsEnable';
		//vbheader24.enabled	 		= true;
		//vbheader24.styleName 		= 'disableAsEnable';
		
		
		cbPPRequired_flag.enabled  					= true;
		cbPPRequired_flag.styleName 				= 'disableAsEnable';
		cbFlagged_flag.enabled	   					= true;
		cbFlagged_flag.styleName 					= 'disableAsEnable';
		cbDo_not_change_ship_date.enabled 			= true;
		cbDo_not_change_ship_date.styleName 		= 'disableAsEnable';
		
		vbMain.enabled	 			= true;
		vbMain.styleName 			= 'disableAsEnable';
		dtlSetup.enabled 			= true;
		dtlSetup.styleName 			= 'disableAsEnable';
		dtlAssessories.enabled		= true;
		dtlAssessories.styleName 	= 'disableAsEnable';
		vbEmail.enabled				= true;
		vbEmail.styleName 			= 'disableAsEnable';
		
		//vbheader2.enabled		= true;
		//vbheader3.enabled		= true;
		//vbheader4.enabled		= true;
	}
	
}

// PASSWORD VALIDATION

private function validatePassword():void
{
	if(cbRushType.dataValue ==ApplicationConstant.RUSH_TYPE1 || cbRushType.dataValue ==ApplicationConstant.RUSH_TYPE2)
	{
		rushTypeChnagehandler();
	}
	else
	{
		var validatePoPopUp:ValidatePoPopUp			= ValidatePoPopUp(PopUpManager.createPopUp(this,ValidatePoPopUp,true));
		validatePoPopUp.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,validatePasswordMissingInfoEventListner);
		validatePoPopUp.x							= ((Application.application.width/2)-(validatePoPopUp.width/2));
		validatePoPopUp.y							= ((Application.application.height/2)-(validatePoPopUp.height/2));
	}
	
}
private function validatePasswordMissingInfoEventListner(event:MissingInfoEvent):void
{
	var resultXml:XML   = event.xml.copy();
	if(resultXml.children()[0].toString()=='VALID')
	{
		rushTypeChnagehandler();
	}
	else
	{
		cbRushType.dataValue  = cbRushType.oldValue;
	}
}
//////////////////coupon code 31 aug 2012 
private var getCouponsDetail:GetInformationEvent;

private function validateCoupon():void
{
	if(dcCustomer_id.dataValue!='' && dcCustomer_id.dataValue!=null)
	{
		if(tiCustomer_coupons_id.dataValue!='' && tiCustomer_coupons_id.dataValue!=null)
		{
			var callbacks:IResponder 	= 	new mx.rpc.Responder(getCouponsDetailsHandler, null);
			getCouponsDetail			=	new GetInformationEvent('get_coupons_details', callbacks, dcCustomer_id.dataValue, tiCustomer_coupons_id.dataValue,dcItemId.dataValue);
			getCouponsDetail.dispatch();
		}
		else
		{
			__localModel.discount_item_xml  = new XML(<discount_coupons></discount_coupons>);
			// remove effect of coupon if applied 
			// remove item price effect
			// remove service charge discount
			removeDiscountServiceCharge(dtlSetup);
			removeDiscountShippingServiceCharge(dtlSetup);
			setItemCost();
			// remove shipping charge effect 
		}
	}
	else
	{
		Alert.show("Please Select Customer");
		// call reset handler
	}
}

private function removeDiscountShippingServiceCharge(dtlSetup:Detail):void
{
	var dgXml:XML 			= dtlSetup.dgDtl.rows.copy();
	var newTempXml:XML		= new XML('<'+dtlSetup.rootNode+'/>');
	var deleteChild:XML		= new XML('<'+dtlSetup.rootNode+'/>');
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String	= dgXml.children()[i].catalog_item_code.toString();
		
		if(Number(dgXml.children()[i].item_price.toString())<=0 && catalog_item_code.toUpperCase()==ApplicationConstant.SHIPPING_CHARGE_DISCOUNT_CODE)
		{
			if(Number(dgXml.children()[i].id.toString())>0)
			{
				dgXml.children()[i].trans_flag ='D';
				deleteChild.appendChild(dgXml.children()[i]);
			}
			else
			{
				
			}
		}
		else
		{
			newTempXml.appendChild(dgXml.children()[i]);
		} 
	}
	dtlSetup.dgDtl.rows   = newTempXml.copy();
	dtlSetup.dgDtl.deletedRows.appendChild(deleteChild.children());
	dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));  // for amount total
}
private function removeGivanDiscountServiceCharge(dtlSetup:Detail,discount_catalog_item_code:String):void
{
	var dgXml:XML 			= dtlSetup.dgDtl.rows.copy();
	var newTempXml:XML		= new XML('<'+dtlSetup.rootNode+'/>');
	var deleteChild:XML		= new XML('<'+dtlSetup.rootNode+'/>');
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String	= dgXml.children()[i].catalog_item_code.toString();
		if(catalog_item_code==discount_catalog_item_code && Number(dgXml.children()[i].item_price.toString())<0)
		{
			if(Number(dgXml.children()[i].id.toString())>0)
			{
				dgXml.children()[i].trans_flag ='D';
				deleteChild.appendChild(dgXml.children()[i]);
			}
			else
			{
				
			}
		}
		else
		{
			newTempXml.appendChild(dgXml.children()[i]);
		} 
	}
	dtlSetup.dgDtl.rows   = newTempXml.copy();
	dtlSetup.dgDtl.deletedRows.appendChild(deleteChild.children());
	dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));  // for amount total
	
	//setItemCost();
}
private function removeDiscountServiceCharge(dtlSetup:Detail):void
{
	var dgXml:XML 			= dtlSetup.dgDtl.rows.copy();
	var newTempXml:XML		= new XML('<'+dtlSetup.rootNode+'/>');
	var deleteChild:XML		= new XML('<'+dtlSetup.rootNode+'/>');
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String	= dgXml.children()[i].catalog_item_code.toString();
		if(Number(dgXml.children()[i].item_price.toString())<0 && catalog_item_code.toUpperCase()!=ApplicationConstant.SHIPPING_CHARGE_DISCOUNT_CODE)
		{
			if(Number(dgXml.children()[i].id.toString())>0)
			{
				dgXml.children()[i].trans_flag ='D';
				deleteChild.appendChild(dgXml.children()[i]);
			}
			else
			{
				
			}
		}
		else
		{
			newTempXml.appendChild(dgXml.children()[i]);
		} 
	}
	dtlSetup.dgDtl.rows   = newTempXml.copy();
	dtlSetup.dgDtl.deletedRows.appendChild(deleteChild.children());
	dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));  // for amount total
	
	//setItemCost();
}
private function getCouponsDetailsHandler(resultXml:XML):void
{
	if(resultXml.name() == "errors")
	{
		if(resultXml.children().length() > 0) 
		{
			var message:String = '';
			
			for(var i:uint = 0; i < resultXml.children().length(); i++) 
			{
				message += resultXml.children()[i] + "\n";
			}
			Alert.show(message);
			resetCouponDiscount();
			// remove effect of coupon code
		} 
	}
	else  // means valid coupons
	{
		__localModel.discount_item_xml   		= resultXml.copy();
		updateDiscountCharges();
	}	
}
private function updateDiscountCharges():void
{
	if(__localModel.discount_item_xml.children().length()>0)
	{
		if(__localModel.discount_item_xml.children()[0].catalog_item_id.toString()!='')
		{
			setItemCost();
		}
		
		var discount_charge_xml:XML	  = XML(__localModel.discount_item_xml.children()[0].discount_coupon_charges);
		if(discount_charge_xml.children().length()>0)
		{
			var tempXml:XML	  = new XML('<'+dtlSetup.rootNode+'/>');
			for(var j:int=0;j<discount_charge_xml.children().length();j++)
			{
				var discount_service_code:String  = discount_charge_xml.children()[j].catalog_item_code.toString();
				var index:int					  = getExistSetupItemChargeIndex(discount_service_code,dtlSetup);
				var indexDiscount:int			  = getExistSetupItemDiscountChargeIndex(discount_service_code,dtlSetup);
				
				if(index>=0 || discount_service_code.toUpperCase()==ApplicationConstant.SHIPPING_CHARGE_DISCOUNT_CODE)
				{
					if(indexDiscount<0)   // no discount charge apply simply add
					{
						var xml:XML	  				= new XML('<'+dtlSetup.rootNode.substr(0,dtlSetup.rootNode.length-1)+'/>');
						xml.item_description		= 'Discount Coupon';
						xml.image_thumnail			= 'image_thumnail';
						xml.item_type				= 'S';
						xml.line_type				= 'S';
						xml.unit					= '';
						xml.cost					= '0.00';
						xml.name					= discount_charge_xml.children()[j].catalog_item_code.toString();
						xml.catalog_item_code		= discount_charge_xml.children()[j].catalog_item_code.toString();
						xml.setup_item_id			= discount_charge_xml.children()[j].catalog_item_id.toString();
						xml.catalog_item_id			= discount_charge_xml.children()[j].catalog_item_id.toString();
						xml.scope_flag				= 'I';
						xml.workflow				= '';
						xml.qty_dependable_flag		= 'N';
						xml.id						= '';
						if(discount_service_code.toUpperCase()==ApplicationConstant.SHIPPING_CHARGE_DISCOUNT_CODE)
						{
							xml.item_price				= '-'+(Number(discount_charge_xml.children()[j].discount_per.toString())*Number(tiShipAmount.dataValue))/100;
							xml.item_qty				= '1';
						}
						else
						{
							xml.item_price				= '-'+(Number(discount_charge_xml.children()[j].discount_per.toString())*Number(dtlSetup.dgDtl.rows.children()[index].item_price.toString()))/100;
							xml.item_qty				= dtlSetup.dgDtl.rows.children()[index].item_qty.toString();
						}
						xml.item_amt				= Number(xml.item_price)*Number(xml.item_qty);
						if(discount_service_code.toUpperCase()!=ApplicationConstant.SHIPPING_CHARGE_DISCOUNT_CODE || Number(tiShipAmount.dataValue)!=Number(tiShipAmount.defaultValue))
						{
							tempXml.appendChild(xml);
						}
					}
					else  // alredy applied simply update discount charge 
					{
						if(discount_service_code.toUpperCase()==ApplicationConstant.SHIPPING_CHARGE_DISCOUNT_CODE)
						{
							dtlSetup.dgDtl.rows.children()[indexDiscount].item_price				= '-'+(Number(discount_charge_xml.children()[j].discount_per.toString())*Number(tiShipAmount.dataValue))/100;
							dtlSetup.dgDtl.rows.children()[indexDiscount].item_qty					= '1';
						}
						else
						{
							dtlSetup.dgDtl.rows.children()[indexDiscount].item_price				= '-'+(Number(discount_charge_xml.children()[j].discount_per.toString())*Number(dtlSetup.dgDtl.rows.children()[index].item_price.toString()))/100;
							dtlSetup.dgDtl.rows.children()[indexDiscount].item_qty					= dtlSetup.dgDtl.rows.children()[index].item_qty.toString();
						}
						if(discount_service_code.toUpperCase()==ApplicationConstant.SHIPPING_CHARGE_DISCOUNT_CODE && Number(tiShipAmount.dataValue)==Number(tiShipAmount.defaultValue))
						{
							removeDiscountShippingServiceCharge(dtlSetup);
						}
						dtlSetup.dgDtl.rows.children()[indexDiscount].item_amt						= Number(dtlSetup.dgDtl.rows.children()[indexDiscount].item_price)*Number(dtlSetup.dgDtl.rows.children()[indexDiscount].item_qty);
					}
					
				}
				else
				{
					//removeDiscountServiceCharge(dtlSetup);
					removeGivanDiscountServiceCharge(dtlSetup,discount_service_code);
				}
			}
			
			var setupGridRows:XML				= dtlSetup.dgDtl.rows;
			setupGridRows.appendChild(tempXml.children());
			dtlSetup.dgDtl.rows					= setupGridRows.copy();
		}
		else
		{
			removeDiscountServiceCharge(dtlSetup);
			removeDiscountShippingServiceCharge(dtlSetup);
		}
		dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));  // for amount total
	}
	else
	{
		removeDiscountServiceCharge(dtlSetup);
		removeDiscountShippingServiceCharge(dtlSetup);
	}
	__localModel.isDiscountCouponBaseChange  = false;
}
private function getExistSetupItemChargeIndex(discount_catalog_item_code:String,dtlSetup:Detail):int
{
	var returnValue:int 		= -1;
	var dgXml:XML				= dtlSetup.dgDtl.rows;
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString();
		var item_price:String 		 = dgXml.children()[i].item_price.toString(); 
		if(catalog_item_code==discount_catalog_item_code && Number(item_price)>0)
		{
			returnValue = i;
			break;
		}
	}
	return returnValue;
}
private function getExistSetupItemDiscountChargeIndex(discount_catalog_item_code:String,dtlSetup:Detail):int
{
	var returnValue:int 		= -1;
	var dgXml:XML	  			= dtlSetup.dgDtl.rows;
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString();
		var item_price:String 		 = dgXml.children()[i].item_price.toString(); 
		if(catalog_item_code==discount_catalog_item_code && Number(item_price)<0)
		{
			returnValue = i;
			break;
		}
	}
	return returnValue;
}
private function resetCouponDiscount():void
{
	__localModel.discount_item_xml  = new XML(<discount_coupons></discount_coupons>);
	tiCustomer_coupons_id.dataValue  = '';
	tiCustomer_coupons_id.labelValue = '';
	tiCouponsCode.dataValue	= '';
	removeDiscountServiceCharge(dtlSetup);
	removeDiscountShippingServiceCharge(dtlSetup);
	setCustomerSpecificPricing();
}
private function optionsComboboxHandler(event:Event):void
{
	updateDiscountCharges();
}
private function setIsDiscountCouponBaseChange():void
{
	if(tiCustomer_coupons_id.dataValue!='')
	{
		__localModel.isDiscountCouponBaseChange	= true;
	}
}
private function setCustomerSpecificPricing():void
{
	if(isItemQtyMinimum(resultXmlFromItem.columns,Number(tiQty.dataValue)))
	{
		blank_good_price  				=  resultXmlFromItem.ltm_price.catalog_item_prices.catalog_item_price.blank_good_price.toString();
	}
	else
	{
		blank_good_price  		 		=  resultXmlFromItem.catalog_item_prices.catalog_item_price.blank_good_price.toString();
	}
	
	var index:int 					    = new TierPricingFunctions().getColumnSize(resultXmlFromItem.columns,Number(tiQty.dataValue));
	
	if(isItemQtyMinimum(resultXmlFromItem.columns,Number(tiQty.dataValue)))
	{
		tiPrice.dataValue  				= new TierPricingFunctions().returnColumnPrice(resultXmlFromItem.ltm_price.catalog_item_prices.catalog_item_price,index);
	}
	else
	{
		tiPrice.dataValue  				= new TierPricingFunctions().returnColumnPrice(resultXmlFromItem.catalog_item_prices.catalog_item_price,index);
	}
	
	if(tiPrice.dataValue=='')
	{
		tiPrice.dataValue			= tiPrice.defaultValue;
	}
	setMainItemAmount();
	setShippingBalanceQty();
	
	if(isInLots(int(tiQty.dataValue),lot_size))
	{
		
	}
	else
	{
		Alert.show("Item Quantity should be in the lots of "+lot_size);
	}
	
	updateImprintColorCharges();
	if(resultXmlFromItem.children().length()>0)
	{
		optionsSetupChargeCalculation.updateEmbroideryStichCharges(dtlSetup,XML(resultXmlFromItem.stitch_charges.sales_order_lines),vbMain,tiQty.dataValue);
		optionsSetupChargeCalculation.updateLTMCharges(dtlSetup,resultXmlFromItem,tiQty.dataValue);
	}
}
private function setDiscountSpecificPricing():void
{
	var columns:XMLList	  = new XMLList(<columns/>);
	columns.blank_price	  = __localModel.discount_item_xml.children()[0].blank_price.toString();
	columns.column1		  = __localModel.discount_item_xml.children()[0].column1.toString();
	columns.column2		  = __localModel.discount_item_xml.children()[0].column2.toString();
	columns.column3		  = __localModel.discount_item_xml.children()[0].column3.toString();
	columns.column4	 	  = __localModel.discount_item_xml.children()[0].column4.toString();
	columns.column5	 	  = __localModel.discount_item_xml.children()[0].column5.toString();
	columns.column6	  	  = __localModel.discount_item_xml.children()[0].column6.toString();
	columns.column7		  = __localModel.discount_item_xml.children()[0].column7.toString();
	columns.column8		  = __localModel.discount_item_xml.children()[0].column8.toString();
	columns.column9	  	  = __localModel.discount_item_xml.children()[0].column9.toString();
	columns.column10	  = __localModel.discount_item_xml.children()[0].column10.toString();
	columns.column11	  = __localModel.discount_item_xml.children()[0].column11.toString();
	columns.column12	  = __localModel.discount_item_xml.children()[0].column12.toString();
	columns.column13	  = __localModel.discount_item_xml.children()[0].column13.toString();
	columns.column14	  = __localModel.discount_item_xml.children()[0].column14.toString();
	columns.column15	  = __localModel.discount_item_xml.children()[0].column15.toString();
	
	
	
	
	
	if(isItemQtyMinimum(resultXmlFromItem.columns,Number(tiQty.dataValue)))
	{
		blank_good_price  				=  columns.blank_price.toString();
	}
	else
	{
		blank_good_price  		 		= columns.blank_price.toString();
	}
	
	var index:int 					    = new TierPricingFunctions().getColumnSize(resultXmlFromItem.columns,Number(tiQty.dataValue));
	
	if(isItemQtyMinimum(resultXmlFromItem.columns,Number(tiQty.dataValue)))
	{
		tiPrice.dataValue  				= new TierPricingFunctions().returnColumnPrice(columns,index);
	}
	else
	{
		tiPrice.dataValue  				= new TierPricingFunctions().returnColumnPrice(columns,index);
	}
	
	if(tiPrice.dataValue=='')
	{
		tiPrice.dataValue			= tiPrice.defaultValue;
	}
	
	var oldMianItemAmount:Number					= Number(tiMainItem_amt.dataValue);
	
	var item_amount:Number							= Number(tiQty.dataValue)*Number(tiPrice.dataValue);
	tiMainItem_amt.dataValue	  					= numericFormatter.format(item_amount);
	
	var diffamount:Number							= Number(tiMainItem_amt.dataValue) - oldMianItemAmount;
	tiItem_amt.dataValue							= numericFormatter.format(Number(tiItem_amt.dataValue)+diffamount);
	
	//setNetAmount();
	//setMainitemAmountForDiscountPrice();
	setMainItemAmount();
	if(isInLots(int(tiQty.dataValue),lot_size))
	{
		
	}
	else
	{
		Alert.show("Item Quantity should be in the lots of "+lot_size);
	}
	
	//updateImprintColorCharges();
	if(resultXmlFromItem.children().length()>0)
	{
		//optionsSetupChargeCalculation.updateEmbroideryStichCharges(dtlSetup,XML(resultXmlFromItem.stitch_charges.sales_order_lines),vbMain,tiQty.dataValue);
		optionsSetupChargeCalculation.updateLTMCharges(dtlSetup,resultXmlFromItem,tiQty.dataValue);
	}
}


// multiple artwork

private const SUBRECORDGRIDFORMATURL:String   	= 'subRecordGridFormatService';
private var isSubRecordOpen:Boolean				=	false;
private function handleSubRecord():void
{
	if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly && dcItemId.dataValue!='')
	{
		var record:XML								= __localModel.addEditObj.record;
		if(record!=null && !__genModel.activeModelLocator.addEditObj.editStatus)
		{
			if(isSubRecordOpen)
			{
				return;	
			}
			isSubRecordOpen							=	true;
			__localModel.objectToQuickAdd			= 	new XML(<rows>
																	<row></row>
																	<row></row>
															   </rows>);
			__localModel.objectToQuickAdd.order_xml	=   record.copy();
			var subRecordObj:SubRecordList;
			subRecordObj							= 	SubRecordList(PopUpManager.createPopUp(this , SubRecordList ,true));
			subRecordObj.searchValue				=	'';
			subRecordObj.labelField					= 	'trans_no';
			subRecordObj.targetObj					=   new GenTextInput();
			subRecordObj.lookupName					=	'SubOrders';
			subRecordObj.lookupFormatUrl			=	SUBRECORDGRIDFORMATURL;
			subRecordObj.filterKeyName				=	'sub_ref_no';
			subRecordObj.filterKeyValue				=	tiTrans_no.dataValue;
			subRecordObj.addEventListener(LookupRecordSearchEvent.LOOKUPCLOSE_EVENT,subRecordCloseEventHandler);
		}
		else
		{
			Alert.show("please save record before create sub record");
		}
	}
}
private function subRecordCloseEventHandler(event:Event):void
{
	isSubRecordOpen		= false;
	
	var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__localModel.addEditObj.record.children()[0].id.toString()),null,false);
	getRecordEvent.dispatch();
}