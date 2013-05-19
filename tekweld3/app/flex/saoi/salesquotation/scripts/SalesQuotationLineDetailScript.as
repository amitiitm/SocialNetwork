import business.commands.PreSaveRowCommand;
import business.commands.RecordStatusCommand;
import business.events.GetInformationEvent;
import business.events.PreSaveRowEvent;
import business.events.RecordStatusEvent;

import com.generic.components.Detail;
import com.generic.customcomponents.GenCheckBox;
import com.generic.customcomponents.GenDataGrid;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.DetailAddEditEvent;
import com.generic.events.GenCheckBoxEvent;
import com.generic.events.GenDataGridEvent;
import com.generic.events.GenDateFieldEvent;
import com.generic.events.GenTextInputEvent;
import com.generic.genclass.URL;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.core.Application;
import mx.core.FlexGlobals;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.muduleclasses.ApplicationConstant;
import saoi.muduleclasses.CommonMooduleFunctions;
import saoi.muduleclasses.DrawItemsOptionsFunctions;
import saoi.muduleclasses.OptionsSetupChargeCalculationForQuotations;
import saoi.muduleclasses.OptionsVisiblityFunctions;
import saoi.muduleclasses.event.MissingInfoEvent;
import saoi.salesquotation.SalesQuotationModelLocator;
import saoi.salesquotation.components.ItemAccessoriesPopWindow;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:SalesQuotationModelLocator = (SalesQuotationModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var item_detail:GetInformationEvent;
private var optionDescription:String = new String();
private var resultXmlFromItem:XML = new XML();
private var lot_size:int = 1;
private var isOkToSSave:Boolean	=	false;
private var preSaveRowEvent:PreSaveRowEvent;
private var blank_good_price:String ;
private var oldOptionValue:String = '';
private var newOptionValue:String = '';	
private var columnArray:ArrayCollection = new ArrayCollection();
private var columnIndex:int=0;

private var selected_price_column:String

private var optionsSetupChargeCalculationForQuotations:OptionsSetupChargeCalculationForQuotations	= 	new OptionsSetupChargeCalculationForQuotations();
[Embed("com/generic/assets/add.png")]
private const addButtonIcon:Class;

[Embed("com/generic/assets/add_disabled.png")]
private const add_disabledButtonIcon:Class;

[Embed("com/generic/assets/delete.png")]
private const deleteButtonIcon:Class;

[Embed("com/generic/assets/delete_disabled.png")]
private const delete_disabledButtonIcon:Class;
private var itemAccessoriesPopWindow:ItemAccessoriesPopWindow
[Bindable]
private var eventTarget:Object = btnEdit;

private function editRowEventHandler(event:Event):void
{
	eventTarget  = event.target;
	
	if(dcItemId.dataValue!='')
	{
		itemAccessoriesPopWindow 			 = ItemAccessoriesPopWindow(PopUpManager.createPopUp(this,ItemAccessoriesPopWindow,true));
		itemAccessoriesPopWindow.x			 = ((Application.application.width/2)-(itemAccessoriesPopWindow.width/2));
		itemAccessoriesPopWindow.y			 = ((Application.application.height/2)-(itemAccessoriesPopWindow.height/2));
		itemAccessoriesPopWindow.xml		 = new XML(<rows>
															<row>{dcItemId.dataValue}</row>
															<row>{eventTarget.id.toString()}</row>
															<row>{dgItemAccessories.selectedRow}</row>
														</rows>);
		
		itemAccessoriesPopWindow.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoSave);
	}
	else
	{
		Alert.show("please select Item");
	}
}
private function missingInfoSave(event:MissingInfoEvent):void
{
	var xmlMissingInfo:XML						= event.xml;
	
	var append_flag:String						= xmlMissingInfo.children()[0].toString();
	var rowXml:XML								= XML(XML(xmlMissingInfo.children()[1]).children()[0]);
	if(append_flag.toUpperCase()=='TRUE')
	{
		var tempXml:XML							= dgItemAccessories.rows.copy();
		tempXml.appendChild(rowXml);
		dgItemAccessories.rows					= tempXml;
	}
	else
	{
		dgItemAccessories.selectedRow.setChildren(rowXml.children());
		dgItemAccessories.rows					= dgItemAccessories.rows;
	}
	setAccessoryAmount(new GenDataGridEvent(GenDataGridEvent.ITEM_DOUBLE_CLICK_EVENT));
}
private function removeRowEventHandler():void
{
	if(dgItemAccessories.selectedIndex>=0)
	{
		dgItemAccessories.deleteRow(dgItemAccessories.selectedIndex);
		
		var recordStatusEvent:RecordStatusEvent	 = new	RecordStatusEvent("MODIFY");
		recordStatusEvent.dispatch();
		
		setAccessoryAmount(new GenDataGridEvent(GenDataGridEvent.ITEM_DOUBLE_CLICK_EVENT));
	}
}

public function creationCompleteHandler():void 
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	numericFormatter.useThousandsSeparator = false;
	
	dfTrans_date.dataValue = __localModel.trans_date;
}

private function getItemDetailAfterSave():void
{
		if(__localModel.customer_id!='' && __localModel.customer_id!=null)
		{
			if(dcItemId.text!='' && dcItemId.text!=null)
			{
				CursorManager.setBusyCursor();
				this.parentDocument.enabled  = false;
				
				var callbacks:IResponder = new mx.rpc.Responder(getItemDetailAfterSaveHandler, null);
				item_detail	=	new GetInformationEvent('item_detail_sales_quotation', callbacks, dcItemId.dataValue,__localModel.customer_id);
				item_detail.dispatch(); 
			}
		}
		else
		{
		 Alert.show("Please Select Customer");
		}

}
private function getItemDetailAfterSaveHandler(resultXml:XML):void
{
	initOrderOption(resultXml.attributes,dgItemOptions.rows);
	resultXmlFromItem				= resultXml
	//blank_good_price				= resultXml.blank_good_price.toString();
    lot_size						= int(resultXml.lot_size.toString());
	setTiersFromRetrieve(resultXml);
	getDefaultSetupItemAfterSaveHandler(changeOrderToQuotationTag(__localModel.defaultSetupChargeXml.copy()));
}

private function getItemDetails():void
{
	if(__localModel.customer_id!='' && __localModel.customer_id!=null)
	{
		if(dcItemId.text!='' && dcItemId.text!=null)
		{
			CursorManager.setBusyCursor();
			this.parentDocument.enabled  = false;
			
			var callbacks:IResponder = new mx.rpc.Responder(getItemDetailHandler, null);
			item_detail	=	new GetInformationEvent('item_detail_sales_quotation', callbacks, dcItemId.dataValue,__localModel.customer_id);
			item_detail.dispatch(); 
		}
		else
		{
			var accLength:int			= dgItemAccessories.rows.children().length();
			for(var i:int=0;i<accLength;i++)
			{
				dgItemAccessories.deleteRow(0);	
			}
			
			var setupLength:int			= dgItemServiceCharges.rows.children().length();
			for(var j:int=0;j<setupLength;j++)
			{
				dgItemServiceCharges.deleteRow(0);	
			}
			
			var optionLength:int		= dgItemOptions.rows.children().length();
			for(var k:int=0;k<optionLength;k++)
			{
				dgItemOptions.deleteRow(0);	
			}
			
			vbMain.removeAllChildren();
			taItemDescription.dataValue = taItemDescription.defaultValue;
			tiImage_thumnail.text		= tiImage_thumnail.defaultValue;
			
		}
	}
	else
	{
	 	Alert.show("Please Select Customer");
	}
}

private function getItemDetailHandler(resultXml:XML):void
{
	var accLength:int			= dgItemAccessories.rows.children().length();
	for(var i:int=0;i<accLength;i++)
	{
		dgItemAccessories.deleteRow(0);	
	}
	var setupLength:int			= dgItemServiceCharges.rows.children().length();
	for(var j:int=0;j<setupLength;j++)
	{
		dgItemServiceCharges.deleteRow(0);	
	}
	var optionLength:int		= dgItemOptions.rows.children().length();
	for(var k:int=0;k<optionLength;k++)
	{
		dgItemOptions.deleteRow(0);	
	}
	resetShippingPrice();
		
	
	cbUnit.dataValue	 			= resultXml.unit;
	taItemDescription.dataValue 	= resultXml.description;
	tiImage_thumnail.text 			= resultXml.image_thumnail;
	tiType.dataValue				= resultXml.item_type;
	//blank_good_price				= resultXml.blank_good_price;
	lot_size						= int(resultXml.lot_size.toString());
	resultXmlFromItem				= resultXml
	initOrderOption(resultXml.attributes);
	setTiers(resultXml);
	setTierPrice(resultXml);
	getDefaultSetupItemHandler(changeOrderToQuotationTag(__localModel.defaultSetupChargeXml.copy()));
}
private function resetShippingPrice():void
{
	chkShippingSelect1.dataValue  = chkShippingSelect1.defaultValue
	chkShippingSelect2.dataValue  = chkShippingSelect2.defaultValue
	chkShippingSelect3.dataValue  = chkShippingSelect3.defaultValue
	chkShippingSelect4.dataValue  = chkShippingSelect4.defaultValue
	chkShippingSelect5.dataValue  = chkShippingSelect5.defaultValue
	chkShippingSelect6.dataValue  = chkShippingSelect6.defaultValue
	chkShippingSelect7.dataValue  = chkShippingSelect7.defaultValue
	chkShippingSelect8.dataValue  = chkShippingSelect8.defaultValue
	chkShippingSelect9.dataValue  = chkShippingSelect9.defaultValue
	chkShippingSelect10.dataValue  = chkShippingSelect10.defaultValue
	chkShippingSelect11.dataValue  = chkShippingSelect11.defaultValue
	chkShippingSelect12.dataValue  = chkShippingSelect12.defaultValue
	chkShippingSelect13.dataValue  = chkShippingSelect13.defaultValue
	chkShippingSelect14.dataValue  = chkShippingSelect14.defaultValue
	chkShippingSelect15.dataValue  = chkShippingSelect15.defaultValue
		
	tiShippingAmount1.dataValue    = tiShippingAmount1.defaultValue;
	tiShippingAmount2.dataValue    = tiShippingAmount2.defaultValue;
	tiShippingAmount3.dataValue    = tiShippingAmount3.defaultValue;
	tiShippingAmount4.dataValue    = tiShippingAmount4.defaultValue;
	tiShippingAmount5.dataValue    = tiShippingAmount5.defaultValue;
	tiShippingAmount6.dataValue    = tiShippingAmount6.defaultValue;
	tiShippingAmount7.dataValue    = tiShippingAmount7.defaultValue;
	tiShippingAmount8.dataValue    = tiShippingAmount8.defaultValue;
	tiShippingAmount9.dataValue    = tiShippingAmount9.defaultValue;
	tiShippingAmount10.dataValue    = tiShippingAmount10.defaultValue;
	tiShippingAmount11.dataValue    = tiShippingAmount11.defaultValue;
	tiShippingAmount12.dataValue    = tiShippingAmount12.defaultValue;
	tiShippingAmount13.dataValue    = tiShippingAmount13.defaultValue;
	tiShippingAmount14.dataValue    = tiShippingAmount14.defaultValue;
	tiShippingAmount15.dataValue    = tiShippingAmount15.defaultValue;
		
}
private function setTiersFromRetrieve(xml:XML):void
{
	var columns:XMLList = XMLList(xml.columns);
	
	lblColumn1.text					= columns.column1.toString();
	lblColumn2.text					= columns.column2.toString();
	lblColumn3.text					= columns.column3.toString();
	lblColumn4.text					= columns.column4.toString();
	lblColumn5.text					= columns.column5.toString();
	lblColumn6.text					= columns.column6.toString();
	lblColumn7.text					= columns.column7.toString();
	lblColumn8.text					= columns.column8.toString();
	lblColumn9.text					= columns.column9.toString();
	lblColumn10.text				= columns.column10.toString();
	lblColumn11.text				= columns.column11.toString();
	lblColumn12.text				= columns.column12.toString();
	lblColumn13.text				= columns.column13.toString();
	lblColumn14.text				= columns.column14.toString();
	lblColumn15.text				= columns.column15.toString();
	
	//setItemAmount();
}
private function setTiers(xml:XML):void
{
	var columns:XMLList = XMLList(xml.columns);
	
	lblColumn1.text					= columns.column1.toString();
	lblColumn2.text					= columns.column2.toString();
	lblColumn3.text					= columns.column3.toString();
	lblColumn4.text					= columns.column4.toString();
	lblColumn5.text					= columns.column5.toString();
	lblColumn6.text					= columns.column6.toString();
	lblColumn7.text					= columns.column7.toString();
	lblColumn8.text					= columns.column8.toString();
	lblColumn9.text					= columns.column9.toString();
	lblColumn10.text				= columns.column10.toString();
	lblColumn11.text				= columns.column11.toString();
	lblColumn12.text				= columns.column12.toString();
	lblColumn13.text				= columns.column13.toString();
	lblColumn14.text				= columns.column14.toString();
	lblColumn15.text				= columns.column15.toString();
	
	setItemAmount();
}
private function setTierPrice(xml:XML):void
{
	var catalog_item_prices:XMLList = XMLList(xml.catalog_item_prices);
	
	tiColumn1Price.text				= catalog_item_prices.catalog_item_price.column1.toString();
	tiColumn2Price.text				= catalog_item_prices.catalog_item_price.column2.toString();
	tiColumn3Price.text				= catalog_item_prices.catalog_item_price.column3.toString();
	tiColumn4Price.text				= catalog_item_prices.catalog_item_price.column4.toString();
	tiColumn5Price.text				= catalog_item_prices.catalog_item_price.column5.toString();
	tiColumn6Price.text				= catalog_item_prices.catalog_item_price.column6.toString();
	tiColumn7Price.text				= catalog_item_prices.catalog_item_price.column7.toString();
	tiColumn8Price.text				= catalog_item_prices.catalog_item_price.column8.toString();
	tiColumn9Price.text				= catalog_item_prices.catalog_item_price.column9.toString();
	tiColumn10Price.text			= catalog_item_prices.catalog_item_price.column10.toString();
	tiColumn11Price.text			= catalog_item_prices.catalog_item_price.column11.toString();
	tiColumn12Price.text			= catalog_item_prices.catalog_item_price.column12.toString();
	tiColumn13Price.text			= catalog_item_prices.catalog_item_price.column13.toString();
	tiColumn14Price.text			= catalog_item_prices.catalog_item_price.column14.toString();
	tiColumn15Price.text			= catalog_item_prices.catalog_item_price.column15.toString();
	tiBlankPrice.text				= catalog_item_prices.catalog_item_price.blank_good_price.toString();
	
	setItemAmount();
}
private function setColumnsOrder():void
{
	if(!isColumnsCorrectOrder())
	{
		var lastColumnValue:Number = columnArray.getItemAt(columnIndex).dataValue ;
		for(var i:int=columnIndex;i<columnArray.length;i++)
		{
			columnArray.getItemAt(i).dataValue = lastColumnValue.toString();
		}
	}
}


private function isColumnsCorrectOrder():Boolean
{
	columnArray.removeAll();
	columnArray.addItem(tiColumn1Price);
	columnArray.addItem(tiColumn2Price);
	columnArray.addItem(tiColumn3Price);
	columnArray.addItem(tiColumn4Price);
	columnArray.addItem(tiColumn5Price);
	columnArray.addItem(tiColumn6Price);
	columnArray.addItem(tiColumn7Price);
	columnArray.addItem(tiColumn8Price);
	columnArray.addItem(tiColumn9Price);
	columnArray.addItem(tiColumn10Price);
	columnArray.addItem(tiColumn11Price);
	columnArray.addItem(tiColumn12Price);
	columnArray.addItem(tiColumn13Price);
	columnArray.addItem(tiColumn14Price);
	columnArray.addItem(tiColumn15Price);
	
	var returnValue:Boolean = true;
	for(var i:int=0;i<columnArray.length-1;i++)
	{
		if(Number(columnArray.getItemAt(i).dataValue) < Number(columnArray.getItemAt(i+1).dataValue))
		{
			returnValue = false;
			columnIndex	= i;
			break;
		}
	}
	return returnValue;
}
private function initOrderOption(xml:XMLList,resultXml:XML=null):void
{
	//new DrawItemsOptionsFunctions().drawItemOptions(dgItemOptions,xml,vbMain,resultXml,resultXmlFromItem);
	
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
		tiRemarksValue.tabIndex							= (startTabIndex+2);
		tiRemarksValue.addEventListener(GenTextInputEvent.ITEMCHANGED_EVENT,remarksItemChnageHandler);
		//
		////
		
		
		
		
		if(resultXml==null)
		{
			setComboBoxValueBlank(gcbAttributeValue);
		}
		gcbAttributeValue.width     				= 150;
		gcbAttributeValue.height					= 20;
		gcbAttributeValue.enabled					= !dcItemId.viewOnlyFlag
			
		hbox.addChildAt(tiAttributeName,0);
		hbox.addChildAt(gcbAttributeValue,1);
		hbox.addChildAt(tiRemarksValue,2);
		hbox.addChildAt(tiDafultValue,3);
		
		
		
		vbMain.addChildAt(hbox,i);
		startTabIndex   = startTabIndex +2;
		
		setDefaultLabel(xml.attribute[i].values,i);
	
	}
	if(resultXml!=null)
	{
		setOptionValue(resultXml);
	}
	
	if(vbMain.numChildren>0)                 // in this case no options r exist 
	{
		if(resultXml==null)
		{
			changeVisibilityOfOtheroptions(vbMain,0);
		}
		else
		{
			changeVisibilityOfOtheroptions(vbMain,-1);
		}
	}
	
	CursorManager.removeBusyCursor();
	this.parentDocument.enabled  = true;
}

private function changeVisibilityOfOtheroptions(vbMain:VBox,selectedId:Number):void
{
	var imprintOptionsIndex:int					= new OptionsVisiblityFunctions().getImprintTypeOptionsIndex(vbMain);
	
	var hboxFirst:HBox 							= HBox(vbMain.getChildByName('hb'+imprintOptionsIndex));      // IMPRINT OPTIONS SHOULD BE FIRST OPTIONS

	var catalog_attribute_code:String	 		= Label(hboxFirst.getChildAt(0)).text;
	var comboBoxValue:ComboBox  				= ComboBox(hboxFirst.getChildAt(1));
	
	
	if(catalog_attribute_code=='IMPRINTTYPE')
	{
		if(comboBoxValue.selectedIndex<0 || comboBoxValue.selectedItem.code.toString()=='' )
		{
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var hbox:HBox 								= HBox(vbMain.getChildByName('hb'+i));
				
				var catalog_attribute_code:String	 		= Label(hbox.getChildAt(0)).text;
				if(catalog_attribute_code =='DECAL' || catalog_attribute_code	=='IMPRINTCOLOR1' || catalog_attribute_code	=='IMPRINTCOLOR2' || catalog_attribute_code	=='IMPRINTCOLOR3')
				{
					hbox.visible   							= false;
					hbox.includeInLayout					= false;
					ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
				}
				
			}
		}
		else if(comboBoxValue.selectedItem.code.toString()=='DECAL')
		{
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
				hbox.visible							= true;
				hbox.includeInLayout					= true;
				
				var catalog_attribute_code:String	 	= Label(hbox.getChildAt(0)).text;
				
				if(catalog_attribute_code	=='IMPRINTCOLOR1' || catalog_attribute_code	=='IMPRINTCOLOR2' || catalog_attribute_code	=='IMPRINTCOLOR3')
				{
					hbox.visible   								= false;
					hbox.includeInLayout						= false;
					ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
				}
			}
		}
		else if(comboBoxValue.selectedItem.code.toString()=='DIRECT')
		{
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
				hbox.visible							= true;
				hbox.includeInLayout					= true;
				
				var catalog_attribute_code:String	 	= Label(hbox.getChildAt(0)).text;
				if(catalog_attribute_code =='DECAL')
				{
					hbox.visible   						= false;
					hbox.includeInLayout				= false;
					ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
				}
			}
		}
		else if(comboBoxValue.selectedItem.code.toString()=='DIGITEK')
		{
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
				hbox.visible							= true;
				hbox.includeInLayout					= true;
				
				var catalog_attribute_code:String	 	= Label(hbox.getChildAt(0)).text;
				if(catalog_attribute_code =='DECAL' || catalog_attribute_code	=='IMPRINTCOLOR1' || catalog_attribute_code	=='IMPRINTCOLOR2' || catalog_attribute_code	=='IMPRINTCOLOR3')
				{
					hbox.visible   						= false;
					hbox.includeInLayout				= false;
					ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
				}
			}
		}
		else
		{
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
				hbox.visible							= true;
				hbox.includeInLayout					= true;
				
				var catalog_attribute_code:String	 	= Label(hbox.getChildAt(0)).text;
				if(catalog_attribute_code =='DECAL' || catalog_attribute_code	=='IMPRINTCOLOR1' || catalog_attribute_code	=='IMPRINTCOLOR2' || catalog_attribute_code	=='IMPRINTCOLOR3')
				{
					hbox.visible   						= false;
					hbox.includeInLayout				= false;
					ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
				}
			}
		}
	}
	else
	{
		// normal flow
		for(var i:int=0;i<vbMain.getChildren().length;i++)
		{
			var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
			hbox.visible							= true;
			hbox.includeInLayout					= true;
		}
	}
	if(selectedId>=0)
	{
		updateSetupCharges(selectedId);
		optionsSetupChargeCalculationForQuotations.updateEmbroideryStichCharges(dgItemServiceCharges,XML(resultXmlFromItem.stitch_charges.sales_quotation_line_charges),vbMain,"1");  //lblColumn1.text = "1" initially we calculate for one quantity and after calculation we multiple with tier qty in case item dependable charge
	}
	/*if(selectedId==0)
	{
		
	}*/
	
	
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
	optionsSetupChargeCalculationForQuotations.checkForOptionsCharge(dgItemServiceCharges,"1",XML(resultXmlFromItem.catalog_attribute_values),XML(resultXmlFromItem.catalog_attribute_codes),vbMain,resultXmlFromItem);
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
private function remarksItemChnageHandler(event:Event):void
{
	if(dgItemOptions.rows.children().length()>0)
	{
		for(var i:int = 0 ; i < dgItemOptions.rows.children().length(); i++)
		{
			dgItemOptions.rows.children()[Number(GenTextInput(event.target).id)].remarks = GenTextInput(event.target).dataValue;
		}
	}
}
public  function setComboBoxValueBlank(cb:ComboBox):void
{
	var index:int  = 0;
	cb.selectedIndex = index;
} 
public  function setDefault(cb:ComboBox):void
{
		var index:int  = -1;
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
private function focusInEventhandler(event:FocusEvent):void
{
	oldOptionValue	  = '';
	if(ComboBox(event.target).selectedIndex>=0)
	{
		oldOptionValue  = ComboBox(event.target).selectedItem.code.toString();
	}
	
}

private function comboboxChangeHandler(event:ListEvent):void
{
	var recordStatusEvent:RecordStatusEvent  = new RecordStatusEvent('MODIFY');
	recordStatusEvent.dispatch();
	
	var selectedId:Number			  		= Number(ComboBox(event.target).id);
	changeVisibilityOfOtheroptions(vbMain,selectedId);
	
	var imprintTypeIndex:int	 	  		= new OptionsVisiblityFunctions().getImprintTypeOptionsIndex(vbMain);
	
	if(selectedId==imprintTypeIndex)
	{
		for(var j:int=0;j<vbMain.getChildren().length;j++)                    // reset remarks when no options save in database
		{
			var hbox:HBox 					  							  = HBox(vbMain.getChildByName('hb'+j));
			var remarksTextInput:GenTextInput 							  = GenTextInput(hbox.getChildAt(2))
			remarksTextInput.dataValue									  = '';
		}
	}
	
	if(dgItemOptions.rows.children().length()>0)
	{
		for(var i:int=0;i<vbMain.getChildren().length;i++)
		{
			var hbox:HBox 					  							  = HBox(vbMain.getChildByName('hb'+i));
			var comboBoxValue:ComboBox									  = ComboBox(hbox.getChildAt(1));
			var optionsCode:String									  	  = Label(hbox.getChildAt(0)).text;
			
			var attribute_value:String									  = '';
			if(comboBoxValue.selectedIndex>=0)
			{
				attribute_value	 									  	  = ComboBox(hbox.getChildAt(1)).selectedItem.code.toString();
			}
			if(selectedId==imprintTypeIndex)  // means imprint options r changes than we have to reset remarks text
			{		
				dgItemOptions.rows.children()[i].remarks 					  = '';
			}
			var optionsIndex:int				= new DrawItemsOptionsFunctions().getOptionCodeIndex(dgItemOptions,optionsCode);
			dgItemOptions.rows.children()[optionsIndex].catalog_attribute_value_code = attribute_value;
		}
	}
}
/*private function getOptionCodeIndex(dgItemOptions:GenDataGrid,optionCode:String):int
{
	var returnValue:int  = -1;
	
	var tempXml:XML   = dgItemOptions.rows.copy();
	for(var i:int=0;i<tempXml.children().length();i++)
	{
		var optionCodeFromGrid:String  = tempXml.children()[i].catalog_attribute_code.toString();
		if(optionCodeFromGrid==optionCode)
		{
			returnValue  = i;
			break;
		}
	}
	return returnValue;
}*/
private function getOptionsValueFromCode(optionXml:XML,optionCode:String):String
{
	return optionXml.children().(catalog_attribute_code==optionCode).catalog_attribute_value_code.toString();
}
private function setOptionValue(recordXml:XML):void
{
	//var optionXml:XML  = dgItemOptions.rows;
 	for(var i:int=0;i<vbMain.getChildren().length;i++)
 	{
 		var hbox:HBox = HBox(vbMain.getChildByName('hb'+i));
 		//Label(hbox.getChildAt(0)).text  	   = recordXml.children()[i].catalog_attribute_code;
 		
		var optionCode:Label    			    = Label(hbox.getChildAt(0));
		
		var remarksValue:TextInput  			= TextInput(hbox.getChildAt(2));
		remarksValue.text						= recordXml.children()[i].remarks.toString();
		
 		var cb:ComboBox  						= ComboBox(hbox.getChildAt(1));
 		//var value_code:String   				= optionXml.children()[i].catalog_attribute_value_code.toString();
		var value_code:String   				= getOptionsValueFromCode(recordXml,optionCode.text);
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
 	
	
}
private function saveOptions():XML
 {
 	var __saveOption:XML = new XML(<sales_quotation_attributes_values/>);
 	for(var i:int=0;i<vbMain.getChildren().length;i++)
 	{
 		var attribute:XMLList = new XMLList(<sales_quotation_attributes_value/>);
 		var hbox:HBox = HBox(vbMain.getChildByName('hb'+i));
 		attribute.catalog_attribute_code = Label(hbox.getChildAt(0)).text;
		
		var remarksValue:GenTextInput  	= GenTextInput(hbox.getChildAt(2));
		attribute.remarks 			   	= remarksValue.dataValue;
 		//optionDescription
		var comboBoxValue:ComboBox  = ComboBox(hbox.getChildAt(1));
		if(comboBoxValue.selectedIndex<0)
		{
			attribute.catalog_attribute_value_code  = '';
		}
		else
		{
			attribute.catalog_attribute_value_code = comboBoxValue.selectedItem.code.toString();
		}
 		//attribute.catalog_attribute_value_code = ComboBox(hbox.getChildAt(1)).selectedItem.code.toString();
 		attribute.company_id 		=	__genModel.user.default_company_id;
        attribute.updated_by 		= 	__genModel.user.userID;
        attribute.created_by		= 	__genModel.user.userID;
		attribute.trans_flag		=   'A';
        attribute.id				= '';
      	attribute.lock_version		= 0
      	attribute.catalog_item_id 	= dcItemId.dataValue.toString();
 		__saveOption.appendChild(attribute);
 	}
 	return __saveOption;
 }

private function saveOptionDescription():String
{
	var __OptionDesc:String = new String();
	for(var i:int=0;i<vbMain.getChildren().length;i++)
	{
		var hbox:HBox 					= HBox(vbMain.getChildByName('hb'+i));
		var attribute_String:String  	= Label(hbox.getChildAt(0)).text +":";
		var comboBoxValue:ComboBox  	= ComboBox(hbox.getChildAt(1));
		var attributeXml:XMLList		= XMLList(resultXmlFromItem.attributes);
		
		if(hbox.visible)
		{
			if(comboBoxValue.selectedIndex<0)
			{
				attribute_String 		= attribute_String.concat('');
				__OptionDesc 			= __OptionDesc.concat(attribute_String,';');
			}
			else if(comboBoxValue.selectedItem.code.toString() =='')
			{
				attribute_String 		= attribute_String.concat(comboBoxValue.selectedItem.code.toString());
				__OptionDesc 			= __OptionDesc.concat(attribute_String,';');
			}
			else
			{
				attribute_String 		= attribute_String.concat(comboBoxValue.selectedItem.code.toString());
				__OptionDesc 			= __OptionDesc.concat(attribute_String,';');
			}
			
		}
	}
	return __OptionDesc;
}
private function saveMissingInfoDescription():String
{
	var resultXml:XML							= resultXmlFromItem;
	var attributeXml:XMLList					= XMLList(resultXml.attributes);
	
	var missInfo:String 						= new String();
	for(var i:int=0;i<vbMain.getChildren().length;i++)
	{
		var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
		var attribute_String:String  			= Label(hbox.getChildAt(0)).text +":";
		var comboBoxValue:ComboBox  			= ComboBox(hbox.getChildAt(1));
		var missing_info_required_flag:String  	= attributeXml.children()[i].missing_info_required_flag.toString();
		
		if(hbox.visible && missing_info_required_flag.toUpperCase()=='Y')
		{
			if(comboBoxValue.selectedIndex<0)
			{
				attribute_String 		= attribute_String.concat('');
				missInfo 				= missInfo.concat(attribute_String,';');
			}
			else if(comboBoxValue.selectedItem.code.toString() =='')
			{
				attribute_String 		= attribute_String.concat(comboBoxValue.selectedItem.code.toString());
				missInfo 				= missInfo.concat(attribute_String,';');
			}
			
		}
	}
	return missInfo;
} 
 	
override protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	var returnValue:int 			= 0;

	var saveXml:XML	   				= new XML("<"+dgItemCharges.rootNode+"/>");
	
	saveXml.appendChild(XML(dgItemAccessories.mergedRows).children().copy());
	saveXml.appendChild(XML(dgItemServiceCharges.mergedRows).children().copy());	
	
	dgItemCharges.rows				= new XML("<"+dgItemCharges.rootNode+"/>");
	dgItemCharges.rows				= saveXml.copy();
	
	if(dgItemOptions.rows.children().length()<=0)
	{
		dgItemOptions.rows.appendChild(saveOptions().children());
	}
	taOptionsDescription.dataValue	= '';
	taOptionsDescription.dataValue	= saveOptionDescription();
	taMissingInfoDescription.dataValue	= '';
	taMissingInfoDescription.dataValue	= saveMissingInfoDescription();
	return returnValue;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	var rowXml:XML		= event.rowXml.copy();
	dgItemOptions.seprateRows();                             // it seprate rows and deleteRows becouse grid all rows deleted rows as well as rows  
	//dgItemOptions.rows	= XML(rowXml.sales_quotation_attributes_values);

	getItemDetailAfterSave();
	
	dgItemCharges.seprateRows();
	var xml:XML  						= dgItemCharges.rows;
	
	dgItemAccessories.rows 				= new XML("<"+dgItemAccessories.rootNode+"/>");
	dgItemServiceCharges.rows 			= new XML("<"+dgItemServiceCharges.rootNode+"/>");
	
	
	var setupXml:XML  					= new XML("<"+dgItemServiceCharges.rootNode+"/>");
	var accessoriesXml:XML  			= new XML("<"+dgItemAccessories.rootNode+"/>");
	
	for(var i:int=0;i<xml.children().length();i++)
	{
	 	var itemType:String = xml.children()[i].item_type.toString();
		if(itemType=='S')
		{
			setupXml.appendChild(xml.children()[i]);
		}
		else if(itemType=='C')
		{
			accessoriesXml.appendChild(xml.children()[i]);
		}
	}
	
	dgItemServiceCharges.rows 			= setupXml;
	dgItemAccessories.rows 				= accessoriesXml;
	
	setCheckBoxes();
}

override protected function resetObjectEventHandler():void
{
	vbMain.removeAllChildren();
}

/*private function  getColumnSize(columnXml:XMLList,size:int):int
{
	
	var index:int=10;
	if(size<=Number(columnXml.column1.toString()))
	{
		index = 1;
	}
	else if(size<=Number(columnXml.column2.toString()) && size>Number(columnXml.column1.toString()))
	{
		index = 2;
	}
	else if(size<=Number(columnXml.column3.toString()) && size>Number(columnXml.column2.toString()))
	{
		index = 3;
	}
	else if(size<=Number(columnXml.column4.toString()) && size>Number(columnXml.column3.toString()))
	{
		index = 4;
	}
	else if(size<=Number(columnXml.column5.toString()) && size>Number(columnXml.column4.toString()))
	{
		index = 5;
	}
	else if(size<=Number(columnXml.column6.toString()) && size>Number(columnXml.column5.toString()))
	{
		index = 6;
	}
	else if(size<=Number(columnXml.column7.toString()) && size>Number(columnXml.column6.toString()))
	{
		index = 7;
	}
	else if(size<=Number(columnXml.column8.toString()) && size>Number(columnXml.column7.toString()))
	{
		index = 8;
	}
	else if(size<=Number(columnXml.column9.toString()) && size>Number(columnXml.column8.toString()))
	{
		index = 9;
	}
	else if(size<=Number(columnXml.column10.toString()) && size>Number(columnXml.column9.toString()))
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
private function setItemAmount():void
{
	tiBlankAmount.dataValue		= numericFormatter.format(Number(tiBlankPrice.dataValue)*Number(1));          // for blank price
	tiColumn1Amount.dataValue	= numericFormatter.format(Number(tiColumn1Price.dataValue)*Number(lblColumn1.text));
	tiColumn2Amount.dataValue	= numericFormatter.format(Number(tiColumn2Price.dataValue)*Number(lblColumn2.text));
	tiColumn3Amount.dataValue	= numericFormatter.format(Number(tiColumn3Price.dataValue)*Number(lblColumn3.text));
	tiColumn4Amount.dataValue	= numericFormatter.format(Number(tiColumn4Price.dataValue)*Number(lblColumn4.text));
	tiColumn5Amount.dataValue	= numericFormatter.format(Number(tiColumn5Price.dataValue)*Number(lblColumn5.text));
	tiColumn6Amount.dataValue	= numericFormatter.format(Number(tiColumn6Price.dataValue)*Number(lblColumn6.text));
	tiColumn7Amount.dataValue	= numericFormatter.format(Number(tiColumn7Price.dataValue)*Number(lblColumn7.text));
	tiColumn8Amount.dataValue	= numericFormatter.format(Number(tiColumn8Price.dataValue)*Number(lblColumn8.text));
	tiColumn9Amount.dataValue	= numericFormatter.format(Number(tiColumn9Price.dataValue)*Number(lblColumn9.text));
	tiColumn10Amount.dataValue	= numericFormatter.format(Number(tiColumn10Price.dataValue)*Number(lblColumn10.text));
	tiColumn11Amount.dataValue	= numericFormatter.format(Number(tiColumn11Price.dataValue)*Number(lblColumn11.text));
	tiColumn12Amount.dataValue	= numericFormatter.format(Number(tiColumn12Price.dataValue)*Number(lblColumn12.text));
	tiColumn13Amount.dataValue	= numericFormatter.format(Number(tiColumn13Price.dataValue)*Number(lblColumn13.text));
	tiColumn14Amount.dataValue	= numericFormatter.format(Number(tiColumn14Price.dataValue)*Number(lblColumn14.text));
	tiColumn15Amount.dataValue	= numericFormatter.format(Number(tiColumn15Price.dataValue)*Number(lblColumn15.text));
	
	setSetUpAmount(new GenDataGridEvent(GenDataGridEvent.ITEM_DOUBLE_CLICK_EVENT));
	setAccessoryAmount(new GenDataGridEvent(GenDataGridEvent.ITEM_DOUBLE_CLICK_EVENT));
}
private function setSetUpAmount(event:GenDataGridEvent):void
{	
	var dgXml:XML		= dgItemServiceCharges.rows.copy();
	
	var tempXmlForIISetup:XML			= new XML('<'+dgXml.localName()+'/>');
	var tempXmlForIDSetup:XML			= new XML('<'+dgXml.localName()+'/>');
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var qty_dependable_flag:String	= dgXml.children()[i].qty_dependable_flag.toString();
		if(qty_dependable_flag=='Y')
		{
			tempXmlForIDSetup.appendChild(XML(dgXml.children()[i]).copy());
		}
		else if(qty_dependable_flag=='N')
		{
			tempXmlForIISetup.appendChild(XML(dgXml.children()[i]).copy());
		}
		else
		{
			
		}
	}
	
	if(dgXml.children().length()>0)
	{
		// for II setup Item
		
		var total_setup_amt:Number = 0.000;
		for(var i:int = 0 ; i < tempXmlForIISetup.children().length(); i++)
		{
			var temp:Number	= Number(tempXmlForIISetup.children()[i]['item_amt'].toString());
			total_setup_amt = total_setup_amt + temp;
		}
		
		var total_setup_amount:String   = numericFormatter.format(total_setup_amt);
		tiSetupAmountBlank.dataValue  	= total_setup_amount;
		tiSetupAmount1.dataValue  		= total_setup_amount;
		tiSetupAmount2.dataValue  		= total_setup_amount;
		tiSetupAmount3.dataValue  		= total_setup_amount;
		tiSetupAmount4.dataValue  		= total_setup_amount;
		tiSetupAmount5.dataValue  		= total_setup_amount;
		tiSetupAmount6.dataValue  		= total_setup_amount;
		tiSetupAmount7.dataValue  		= total_setup_amount;
		tiSetupAmount8.dataValue  		= total_setup_amount;
		tiSetupAmount9.dataValue  		= total_setup_amount;
		tiSetupAmount10.dataValue  		= total_setup_amount;
		tiSetupAmount11.dataValue  		= total_setup_amount;
		tiSetupAmount12.dataValue  		= total_setup_amount;
		tiSetupAmount13.dataValue  		= total_setup_amount;
		tiSetupAmount14.dataValue  		= total_setup_amount;
		tiSetupAmount15.dataValue  		= total_setup_amount;
		
		
		// for ID setup Item
		
		var total_setup_amt:Number = 0.000;
		for(var i:int = 0 ; i < tempXmlForIDSetup.children().length(); i++)
		{
			var temp:Number	= Number(tempXmlForIDSetup.children()[i]['item_amt'].toString());
			total_setup_amt = total_setup_amt + temp;
		}
		
		var   total_setup_amountblank:Number									= total_setup_amt		* (1);   // for blank price tier =1
		var   total_setup_amount1:Number				  						= total_setup_amt   	* Number(lblColumn1.text)
		var   total_setup_amount2:Number  										= total_setup_amt		* Number(lblColumn2.text);
		var   total_setup_amount3:Number  										= total_setup_amt   	* Number(lblColumn3.text);
		var   total_setup_amount4:Number  										= total_setup_amt		* Number(lblColumn4.text);
		var   total_setup_amount5:Number  										= total_setup_amt		* Number(lblColumn5.text);
		var   total_setup_amount6:Number  										= total_setup_amt		* Number(lblColumn6.text);
		var   total_setup_amount7:Number  										= total_setup_amt		* Number(lblColumn7.text);
		var   total_setup_amount8:Number  										= total_setup_amt		* Number(lblColumn8.text);
		var   total_setup_amount9:Number  										= total_setup_amt		* Number(lblColumn9.text);
		var   total_setup_amount10:Number  										= total_setup_amt		* Number(lblColumn10.text);
		var   total_setup_amount11:Number  										= total_setup_amt		* Number(lblColumn11.text);
		var   total_setup_amount12:Number  										= total_setup_amt		* Number(lblColumn12.text);
		var   total_setup_amount13:Number  										= total_setup_amt		* Number(lblColumn13.text);
		var   total_setup_amount14:Number  										= total_setup_amt		* Number(lblColumn14.text);
		var   total_setup_amount15:Number  										= total_setup_amt		* Number(lblColumn15.text);
		
		
		tiSetupAmountItemDepenedableBlank.dataValue  							= numericFormatter.format(total_setup_amountblank);
		tiSetupAmountItemDepenedable1.dataValue  								= numericFormatter.format(total_setup_amount1);
		tiSetupAmountItemDepenedable2.dataValue  								= numericFormatter.format(total_setup_amount2);
		tiSetupAmountItemDepenedable3.dataValue  								= numericFormatter.format(total_setup_amount3);
		tiSetupAmountItemDepenedable4.dataValue  								= numericFormatter.format(total_setup_amount4);
		tiSetupAmountItemDepenedable5.dataValue  								= numericFormatter.format(total_setup_amount5);
		tiSetupAmountItemDepenedable6.dataValue  								= numericFormatter.format(total_setup_amount6);
		tiSetupAmountItemDepenedable7.dataValue  								= numericFormatter.format(total_setup_amount7);
		tiSetupAmountItemDepenedable8.dataValue  								= numericFormatter.format(total_setup_amount8);
		tiSetupAmountItemDepenedable9.dataValue  								= numericFormatter.format(total_setup_amount9);
		tiSetupAmountItemDepenedable10.dataValue  								= numericFormatter.format(total_setup_amount10);
		tiSetupAmountItemDepenedable11.dataValue  								= numericFormatter.format(total_setup_amount11);
		tiSetupAmountItemDepenedable12.dataValue  								= numericFormatter.format(total_setup_amount12);
		tiSetupAmountItemDepenedable13.dataValue  								= numericFormatter.format(total_setup_amount13);
		tiSetupAmountItemDepenedable14.dataValue  								= numericFormatter.format(total_setup_amount14);
		tiSetupAmountItemDepenedable15.dataValue  								= numericFormatter.format(total_setup_amount15);

	}
	// for net amount 
	
	setItemNetAmount();
	
}
private function setAccessoryAmount(event:GenDataGridEvent):void
{	
	var dgXml:XML		= dgItemAccessories.rows.copy();
	
	// for for accessory Item
	var total_accessory_amt:Number = 0.000;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var temp:Number					= Number(dgXml.children()[i]['item_amt'].toString());
		total_accessory_amt 			= total_accessory_amt + temp;
	}
	
	var total_accessories_amount:String = numericFormatter.format(total_accessory_amt);
	
	tiAccessoryAmountBlank.dataValue  	= total_accessories_amount;
	tiAccessoryAmount1.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn1.text));
	tiAccessoryAmount2.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn2.text));
	tiAccessoryAmount3.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn3.text));
	tiAccessoryAmount4.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn4.text));
	tiAccessoryAmount5.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn5.text));
	tiAccessoryAmount6.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn6.text));
	tiAccessoryAmount7.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn7.text));
	tiAccessoryAmount8.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn8.text));
	tiAccessoryAmount9.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn9.text));
	tiAccessoryAmount10.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn10.text));
	tiAccessoryAmount11.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn11.text));
	tiAccessoryAmount12.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn12.text));
	tiAccessoryAmount13.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn13.text));
	tiAccessoryAmount14.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn14.text));
	tiAccessoryAmount15.dataValue  		= numericFormatter.format(Number(total_accessories_amount) * Number(lblColumn15.text));
	
	setItemNetAmount();
	
}

private function setItemNetAmount():void
{
	tiNetAmountBlank.dataValue		= numericFormatter.format(Number(tiBlankAmount.dataValue)+Number(tiSetupAmountBlank.dataValue)+Number(tiSetupAmountItemDepenedableBlank.dataValue)+Number(tiAccessoryAmountBlank.dataValue));
	tiNetAmount1.dataValue			= numericFormatter.format(Number(tiColumn1Amount.dataValue)+Number(tiSetupAmount1.dataValue)+Number(tiSetupAmountItemDepenedable1.dataValue)+Number(tiAccessoryAmount1.dataValue)+Number(tiShippingAmount1.dataValue));
	tiNetAmount2.dataValue			= numericFormatter.format(Number(tiColumn2Amount.dataValue)+Number(tiSetupAmount2.dataValue)+Number(tiSetupAmountItemDepenedable2.dataValue)+Number(tiAccessoryAmount2.dataValue)+Number(tiShippingAmount2.dataValue));
	tiNetAmount3.dataValue			= numericFormatter.format(Number(tiColumn3Amount.dataValue)+Number(tiSetupAmount3.dataValue)+Number(tiSetupAmountItemDepenedable3.dataValue)+Number(tiAccessoryAmount3.dataValue)+Number(tiShippingAmount3.dataValue));
	tiNetAmount4.dataValue			= numericFormatter.format(Number(tiColumn4Amount.dataValue)+Number(tiSetupAmount4.dataValue)+Number(tiSetupAmountItemDepenedable4.dataValue)+Number(tiAccessoryAmount4.dataValue)+Number(tiShippingAmount4.dataValue));
	tiNetAmount5.dataValue			= numericFormatter.format(Number(tiColumn5Amount.dataValue)+Number(tiSetupAmount5.dataValue)+Number(tiSetupAmountItemDepenedable5.dataValue)+Number(tiAccessoryAmount5.dataValue)+Number(tiShippingAmount5.dataValue));
	tiNetAmount6.dataValue			= numericFormatter.format(Number(tiColumn6Amount.dataValue)+Number(tiSetupAmount6.dataValue)+Number(tiSetupAmountItemDepenedable6.dataValue)+Number(tiAccessoryAmount6.dataValue)+Number(tiShippingAmount6.dataValue));
	tiNetAmount7.dataValue			= numericFormatter.format(Number(tiColumn7Amount.dataValue)+Number(tiSetupAmount7.dataValue)+Number(tiSetupAmountItemDepenedable7.dataValue)+Number(tiAccessoryAmount7.dataValue)+Number(tiShippingAmount7.dataValue));
	tiNetAmount8.dataValue			= numericFormatter.format(Number(tiColumn8Amount.dataValue)+Number(tiSetupAmount8.dataValue)+Number(tiSetupAmountItemDepenedable8.dataValue)+Number(tiAccessoryAmount8.dataValue)+Number(tiShippingAmount8.dataValue));
	tiNetAmount9.dataValue			= numericFormatter.format(Number(tiColumn9Amount.dataValue)+Number(tiSetupAmount9.dataValue)+Number(tiSetupAmountItemDepenedable9.dataValue)+Number(tiAccessoryAmount9.dataValue)+Number(tiShippingAmount9.dataValue));
	tiNetAmount10.dataValue			= numericFormatter.format(Number(tiColumn10Amount.dataValue)+Number(tiSetupAmount10.dataValue)+Number(tiSetupAmountItemDepenedable10.dataValue)+Number(tiAccessoryAmount10.dataValue)+Number(tiShippingAmount10.dataValue));
	tiNetAmount11.dataValue			= numericFormatter.format(Number(tiColumn11Amount.dataValue)+Number(tiSetupAmount11.dataValue)+Number(tiSetupAmountItemDepenedable11.dataValue)+Number(tiAccessoryAmount11.dataValue)+Number(tiShippingAmount11.dataValue));
	tiNetAmount12.dataValue			= numericFormatter.format(Number(tiColumn12Amount.dataValue)+Number(tiSetupAmount12.dataValue)+Number(tiSetupAmountItemDepenedable12.dataValue)+Number(tiAccessoryAmount12.dataValue)+Number(tiShippingAmount12.dataValue));
	tiNetAmount13.dataValue			= numericFormatter.format(Number(tiColumn13Amount.dataValue)+Number(tiSetupAmount13.dataValue)+Number(tiSetupAmountItemDepenedable13.dataValue)+Number(tiAccessoryAmount13.dataValue)+Number(tiShippingAmount13.dataValue));
	tiNetAmount14.dataValue			= numericFormatter.format(Number(tiColumn14Amount.dataValue)+Number(tiSetupAmount14.dataValue)+Number(tiSetupAmountItemDepenedable14.dataValue)+Number(tiAccessoryAmount14.dataValue)+Number(tiShippingAmount14.dataValue));
	tiNetAmount15.dataValue			= numericFormatter.format(Number(tiColumn15Amount.dataValue)+Number(tiSetupAmount15.dataValue)+Number(tiSetupAmountItemDepenedable15.dataValue)+Number(tiAccessoryAmount15.dataValue)+Number(tiShippingAmount15.dataValue));
}

private function checkBoxSelectHandler(event:GenCheckBoxEvent):void
{
	if(GenCheckBox(event.target).dataValue == 'Y')
	{
		GenCheckBox(GenCheckBox(event.target).parent.getChildAt(7)).enabled = true;
	}
	else
	{
		GenCheckBox(GenCheckBox(event.target).parent.getChildAt(7)).enabled = false;
		GenCheckBox(GenCheckBox(event.target).parent.getChildAt(7)).dataValue = 'N';
		GenTextInput(GenCheckBox(event.target).parent.getChildAt(8)).dataValue = GenTextInput(GenCheckBox(event.target).parent.getChildAt(8)).defaultValue;
	}
	
	GenCheckBox(GenCheckBox(event.target).parent.getChildAt(7)).dispatchEvent(new GenCheckBoxEvent(GenCheckBoxEvent.ITEMCHANGED_EVENT));
}

private function shippingCheckBoxSelectHandler(event:GenCheckBoxEvent):void
{
	selected_price_column = String(event.target.id).slice(17);
	
	if(GenCheckBox(event.target).dataValue == 'Y')
	{
		//GenTextInput(GenCheckBox(event.target).parent.getChildAt(7)).enabled = true;
		
		var send:HTTPService  		= dataService(__genModel.services.getHTTPService("shippingQuotationAmount"));
		var __responder:IResponder	= new mx.rpc.Responder(getShippingAmountResultHandler,getShippingAmountFaultHandler);
		var tier_qty:String			= Label(GenCheckBox(event.target).parent.getChildAt(1)).text; 	
		
		
		var shippingAmountXml:XML = new XML(<params>
												<ship_method_code>{__localModel.shippingObject.ship_method_code}</ship_method_code>
												<shipping_code>{__localModel.shippingObject.shipping_code}</shipping_code>
												<ship_method>{__localModel.shippingObject.ship_method}</ship_method>
												<country>{__localModel.shippingObject.ship_country}</country>
												<zip_code>{__localModel.shippingObject.ship_zip}</zip_code>
												<state>{__localModel.shippingObject.ship_state}</state>
												<qty>{tier_qty}</qty>
												<catalog_item_id>{dcItemId.dataValue}</catalog_item_id>
												<company_id>{__genModel.user.id}</company_id>
											</params>);
		
		
		CursorManager.setBusyCursor();
		this.parentDocument.enabled  = false;
		
		var token:AsyncToken 	= send.send(shippingAmountXml);
		token.addResponder(__responder);
	}
	else
	{
		GenTextInput(GenCheckBox(event.target).parent.getChildAt(8)).enabled = false;
		GenTextInput(GenCheckBox(event.target).parent.getChildAt(8)).dataValue = GenTextInput(GenCheckBox(event.target).parent.getChildAt(8)).defaultValue;
		
		setItemNetAmount();
	}
	
}

public function dataService(service:HTTPService):HTTPService
{
	var urlObj:URL				=	new URL();
	service.url					=	urlObj.getURL(service.url);
	service.resultFormat 		= "e4x";					
	service.method 				= "POST";
	service.useProxy			= false;
	service.contentType			="application/xml";
	service.requestTimeout	 	= 1800
	
	return service;
}

private function getShippingAmountResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor()
	this.parentDocument.enabled  = true;
	
	var resultXml:XML				 = XML(event.result);
	
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
		} 
	}
	else
	{
		for(var j:int=0;j<resultXml.children().length();j++)
		{
			var xmllist:XMLList	= XMLList(resultXml.children()[j]).copy();
			if(xmllist.child('service_code').toString() ==	__localModel.shippingObject.ship_method_code)
			{
				GenTextInput(HBox(vbPrice.getChildByName('hbox'+selected_price_column)).getChildAt(8)).dataValue = xmllist.price.toString();
			}
		}
	}
	
	setItemNetAmount();
	
}

private function getShippingAmountFaultHandler(event:FaultEvent):void
{
	CursorManager.removeBusyCursor()
	this.parentDocument.enabled  = true;
	
	Alert.show(event.fault.toString())
}
	
private function setCheckBoxes():void
{
	for(var i:int= 1; i <= 15; i++)
	{ 
		if(GenCheckBox(HBox(vbPrice.getChildByName('hbox'+i)).getChildAt(0)).dataValue == 'Y')
		{
			GenCheckBox(HBox(vbPrice.getChildByName('hbox'+i)).getChildAt(7)).enabled = true
		}
		else
		{
			GenCheckBox(HBox(vbPrice.getChildByName('hbox'+i)).getChildAt(7)).enabled = false
		}
	}
}
private function isDefaultSetupExist():int
{
	var returnValue:int 		= -1;
	var dgXml:XML  			    = dgItemServiceCharges.rows.copy();
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
		if(catalog_item_code==ApplicationConstant.DEFAULT_SETUP)
		{
			returnValue = i;
			break;
		}
	}
	return returnValue;
}
private function getDefaultSetupItemAfterSaveHandler(resultXml:XML):void
{					
		// write code here
	var index:int  			= isDefaultSetupExist();
	var tempXml:XML			= dgItemServiceCharges.rows;
	if(index<0)
	{
		tempXml.appendChild(resultXml.children());
	}
	else
	{
		tempXml.children()[index].qty_dependable_flag = resultXml..qty_dependable_flag.toString();
	}
	dgItemServiceCharges.rows     = tempXml;
}
private function getDefaultSetupItemHandler(resultXml:XML):void
{					
	var index:int  			= isDefaultSetupExist();
	var tempXml:XML			= dgItemServiceCharges.rows;
	if(index<0)
	{
		tempXml.appendChild(resultXml.children());
	}
	else
	{
		tempXml.children()[index].qty_dependable_flag = resultXml..qty_dependable_flag.toString();
	}
	dgItemServiceCharges.rows     = tempXml;
	setItemAmount();
}

private function changeOrderToQuotationTag(inputXml:XML):XML
{
	var outputXml:XML  = new XML("<"+dgItemServiceCharges.rootNode+"/>");
	var childXml:XML   = new XML("<"+"sales_quotation_line_charge"+"/>");
	
	for(var i:int=0;i<inputXml.children().length();i++)
	{
		childXml.appendChild(XMLList(inputXml.children()[i]).children());
	}
	
	outputXml.appendChild(childXml);
	return outputXml.copy();
}