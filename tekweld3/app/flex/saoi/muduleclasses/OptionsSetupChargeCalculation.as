package saoi.muduleclasses
{
	import business.events.GetInformationEvent;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.components.DataEntry;
	import com.generic.components.Detail;
	import com.generic.events.DetailEvent;
	import com.generic.events.GenTextInputEvent;
	import com.generic.genclass.TabPage;
	import com.generic.genclass.URL;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import flashx.textLayout.elements.BreakElement;
	
	import model.GenModelLocator;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.INavigatorContent;
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import saoi.muduleclasses.event.MissingInfoEvent;

	public class OptionsSetupChargeCalculation extends EventDispatcher
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		
		private var getInformationEvent:GetInformationEvent;
		private var dtlSetup:Object;
		private var selectedOptionsCode:String;
		private var selectedOptionsValue:String;
		private var main_item_qty:String;
		private var vbMain:VBox	;
		private var isAdd:Boolean;
		
		private var catalog_attribute_values:XML;
		private var catalog_attribute_codes:XML;
		
		public function OptionsSetupChargeCalculation()
		{
			__genModel		= 	GenModelLocator.getInstance();
			__localModel	= 	__genModel.activeModelLocator;
			__services		= 	__genModel.services;
		}
	
		public function checkForOptionsCharge(dtlSetup:Object,main_item_qty:String,catalog_attribute_values:XML,catalog_attribute_codes:XML,vbMain:VBox,itemXml:XML=null):void
		{
			var stitch_xml:XML		= XML(itemXml.stitch_charges.sales_order_lines);
			var ltm_xml:XML			= XML(itemXml.ltm_charges.sales_order_lines);
			
			if(catalog_attribute_values.children().length()>0 || catalog_attribute_codes.children().length()>0)
			{
				this.dtlSetup   						= dtlSetup;
				this.main_item_qty						= main_item_qty;
				this.catalog_attribute_values			= catalog_attribute_values;
				this.catalog_attribute_codes			= catalog_attribute_codes;
				this.vbMain								= vbMain;
				
				var selected_options_value_charges:XML	= findOptionsValuesSetupCharges(this.catalog_attribute_values,this.vbMain);
				
				var selected_options_code_charges:XML	= findLatestOptionsCodeSetupCharges(this.catalog_attribute_codes,this.vbMain);
				
				var total_setup_charges:XML				= new XML(<sales_order_lines></sales_order_lines>);
				total_setup_charges.appendChild(selected_options_code_charges.children().copy());
				total_setup_charges.appendChild(selected_options_value_charges.children().copy());				
				
				var setupGridXml:XML   					= getSetupGridSetupCharges();
				
				// if setupGridXml xml contain any xml which din;t contin selected options xml then delete it
				for(var i:int=0;i<setupGridXml.children().length();i++)
				{
					var code:String						= setupGridXml.children()[i].catalog_item_code.toString();
					var index:int						= getItemIndexinGivenXml(total_setup_charges,code);
					if(index>=0) // means present
					{
						
					}
					else if(!(isItEmbroideryStitchCharge(code,stitch_xml) || isItChangeWithProofCharge(code,dtlSetup) ||isItLTMCharge(code,ltm_xml)))//remove it   // sarvesh date 16 apr 2012 add condition for EMBROIDERY-STITCH
					{
						removeSetupItemNew(this.dtlSetup,setupGridXml.children()[i]);
					}
				}
				for(var i:int=0;i<total_setup_charges.children().length();i++)
				{
					var code:String						= total_setup_charges.children()[i].catalog_item_code.toString();
					addSetupItem(this.dtlSetup,total_setup_charges.children()[i]);
				}
				
				
				//OptionsDetailsHandler(selected_options_value_charges);
			}
			else
			{
				//Alert.show("Please Select Option");
			}
			vbMain.dispatchEvent(new Event('optionsComboboxChange'));
		}
		
		private function getSetupGridSetupCharges():XML
		{
			var returnXml:XML						= new XML(<sales_order_lines></sales_order_lines>);
			
			var setupGridXml:XML   					= XML(this.dtlSetup.dgDtl.rows).copy();
			for(var i:int=0;i<setupGridXml.children().length();i++)
			{
				var code:String						= setupGridXml.children()[i].catalog_item_code.toString();
				if(isItDefaultRushSetupItem(code)||isItDefaultSetupItem(code) || isItThirdPartyShippingChrageItem(code))
				{
					
				}
				else
				{
					returnXml.appendChild(setupGridXml.children()[i]);
				}
			}
			return returnXml; 
			
		}
		private function isItDefaultSetupItem(code:String):Boolean
		{
			var return_value:Boolean = false;
			if(code =='SETUP')
			{
				return_value = true;
			}
			return return_value;
		}
		private function isItThirdPartyShippingChrageItem(code:String):Boolean
		{
			var return_value:Boolean = false;
			if(code =='THIRDPARTYSHIPPINGCHARGE')
			{
				return_value = true;
			}
			return return_value;
		}
		private function isItEmbroideryStitchCharge(code:String,stitch_xml:XML):Boolean
		{
			var return_value:Boolean = false;
			for(var i:int=0;i<stitch_xml.children().length();i++)
			{
				if(code ==	stitch_xml.children()[i].catalog_item_code.toString())
				{
					return_value = true;
					break;
				}
			}
			return return_value;
		}
		private function isItChangeWithProofCharge(code:String,dtlSetup:Object):Boolean
		{
			var returnValue:Boolean 	= false;
			if(code.toUpperCase()==ApplicationConstant.DEFAULT_CHANGE_WITH_PROOF)
			{
				returnValue = true;
			}
			/*var dgXml:XMLList  			= this.dtlSetup.dgDtl.rows.(trans_flag='A');
			
			for(var i:int=0;i<dgXml.children().length();i++)
			{
				var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
				if(catalog_item_code.toUpperCase()=="CHANGEWITHPROOF")
				{
					returnValue = true;
					break;
				}
			}*/
			return returnValue;
		}
		private function isItLTMCharge(code:String,ltm_xml:XML):Boolean
		{
			var return_value:Boolean = false;
			for(var i:int=0;i<ltm_xml.children().length();i++)
			{
				if(code ==	ltm_xml.children()[i].catalog_item_code.toString())
				{
					return_value = true;
					break;
				}
			}
			return return_value;
		}
		
		private function isItDefaultRushSetupItem(code:String):Boolean
		{
			var return_value:Boolean = false;
			for(var i:int=0;i<__genModel.defaultSetupXml.children().length();i++)
			{
				if(code ==	__genModel.defaultSetupXml.children()[i].value.toString())
				{
					return_value = true;
					break;
				}
			}
			return return_value;
		}
		private function findLatestOptionsCodeSetupCharges(catalog_attribute_codes:XML,vbMain:VBox):XML
		{
			var returnXml:XML			= new XML(<sales_order_lines></sales_order_lines>);
			
			for(var i:int=0;i<catalog_attribute_codes.children().length();i++)
			{
				for(var j:int=0;j<this.vbMain.getChildren().length;j++)
				{
					var hbox:HBox 						= HBox(vbMain.getChildByName('hb'+j));
					var selected_option_code:String 	= Label(hbox.getChildAt(0)).text;
					var comboBoxValue:ComboBox  		= ComboBox(hbox.getChildAt(1));
					
					var selected_option_value:String	= '';
					
					if(comboBoxValue.selectedIndex<0)
					{
						selected_option_value 			= '';
					}
					else
					{
						selected_option_value 			= comboBoxValue.selectedItem.code.toString();
					}
					
					if(selected_option_code!='' && selected_option_value!='' && hbox.visible && catalog_attribute_codes.children()[i].option_code.toString()==selected_option_code)
					{
						var sale_order_line:XML						= XML(catalog_attribute_codes.children()[i]).copy();
						var qty_dependable_flag:String				= sale_order_line.qty_dependable_flag.toString();
						
						if(qty_dependable_flag=='Y')
						{
							sale_order_line.item_qty				=  Number(this.main_item_qty) * Number(sale_order_line.item_qty.toString());
							sale_order_line.item_amt				= (Number(sale_order_line.item_price.toString())* Number(sale_order_line.item_qty.toString())).toString();
						}
						returnXml.appendChild(sale_order_line);
					}
				}
				
			}
			
			var uniquXml:XML		= getUniqueSetupLines(returnXml.copy());
			return uniquXml;
		}
		private function findOptionsValuesSetupCharges(catalog_attribute_values:XML,vbMain:VBox):XML
		{
			var returnXml:XML			= new XML(<sales_order_lines></sales_order_lines>);
			
			for(var i:int=0;i<catalog_attribute_values.children().length();i++)
			{
				for(var j:int=0;j<this.vbMain.getChildren().length;j++)
				{
					var hbox:HBox 						= HBox(vbMain.getChildByName('hb'+j));
					var selected_option_code:String 	= Label(hbox.getChildAt(0)).text;
					var comboBoxValue:ComboBox  		= ComboBox(hbox.getChildAt(1));
					
					var selected_option_value:String	= '';
					
					if(comboBoxValue.selectedIndex<0)
					{
						selected_option_value = '';
					}
					else
					{
						selected_option_value = comboBoxValue.selectedItem.code.toString();
					}
					
					if(selected_option_value!='' && catalog_attribute_values.children()[i].option_value.toString()==selected_option_value && catalog_attribute_values.children()[i].option_code.toString()==selected_option_code)
					{
						var sale_order_line:XML						= XML(catalog_attribute_values.children()[i]).copy();
						var qty_dependable_flag:String				= sale_order_line.qty_dependable_flag.toString();
						
						if(qty_dependable_flag=='Y')
						{
							sale_order_line.item_qty				=  Number(this.main_item_qty) * Number(sale_order_line.item_qty.toString());
							sale_order_line.item_amt				= (Number(sale_order_line.item_price.toString())* Number(sale_order_line.item_qty.toString())).toString();
						}
						returnXml.appendChild(sale_order_line);
						
					}
				}
			}
			
			var uniquXml:XML		= getUniqueSetupLines(returnXml.copy());
			return uniquXml;
		}
		private function getUniqueSetupLines(xml:XML):XML
		{
			var returnXml:XML		= new XML(<sales_order_lines></sales_order_lines>);
			for(var i:int=0;i<xml.children().length();i++)
			{
				if(!isExistItemInGivenXml(returnXml.copy(),xml.children()[i].catalog_item_code.toString()))
				{
					returnXml.appendChild(xml.children()[i]);
				}
				else
				{
					var item_qty:Number						= Number(xml.children()[i].item_qty.toString());
					var item_price:Number					= Number(xml.children()[i].item_price.toString());
					var index:int							= getItemIndexinGivenXml(returnXml.copy(),xml.children()[i].catalog_item_code.toString());
					returnXml.children()[index].item_qty	= Number(returnXml.children()[index].item_qty.toString()) +item_qty;
					returnXml.children()[index].item_price	= Number(returnXml.children()[index].item_price.toString()) +item_price;
					returnXml.children()[index].item_amt	= Number(returnXml.children()[index].item_qty.toString()) * Number(returnXml.children()[index].item_price.toString());
				}
			}
			return returnXml;
		}
		private function getItemIndexinGivenXml(xml:XML,options_catalog_item_code:String):Number
		{
			var index:int=-1;
			
			for(var i:int=0;i<xml.children().length();i++)
			{
				if(xml.children()[i].catalog_item_code.toString()== options_catalog_item_code)
				{
					index    = i;
					break;
				}
			}
			return  index;
		}
		private function isExistItemInGivenXml(xml:XML,options_catalog_item_code:String):Boolean
		{
			var returnValue:Boolean 	= false;
			var dgXml:XML  				= xml;
			for(var i:int=0;i<dgXml.children().length();i++)
			{
				var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
				if(catalog_item_code==options_catalog_item_code)
				{
					returnValue = true;
					break;
				}
			}
			return returnValue;
		}
		
		public function addSetupItem(dtlSetup:Object,xml:XML):void
		{
			var index:int=-1;
			
			for(var i:int=0;i<dtlSetup.dgDtl.rows.children().length();i++)
			{
				if(dtlSetup.dgDtl.rows.children()[i].catalog_item_code.toString()==xml.catalog_item_code.toString())
				{
					index    = i;
					break;
				}
			}
			
			if(index>=0)// already exist then update
			{
				dtlSetup.dgDtl.rows.children()[index].item_qty  = Number(xml.item_qty.toString());
				dtlSetup.dgDtl.rows.children()[index].item_amt  = Number(dtlSetup.dgDtl.rows.children()[index].item_qty.toString()) * Number(dtlSetup.dgDtl.rows.children()[index].item_price.toString());
				var tempXml:XML									= XML(dtlSetup.dgDtl.rows).copy();
				dtlSetup.dgDtl.rows								= tempXml;
			}
			else // not exist then simple add
			{
				var tempXml:XML		= XML(dtlSetup.dgDtl.rows).copy();
				tempXml.appendChild(xml);
				dtlSetup.dgDtl.rows		= tempXml;
			}
			dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));
		}
		public function removeSetupItemNew(dtlSetup:Object,xml:XML):void
		{
			var index:int=-1;
			
			for(var i:int=0;i<dtlSetup.dgDtl.rows.children().length();i++)
			{
				if(dtlSetup.dgDtl.rows.children()[i].catalog_item_code.toString()==xml.catalog_item_code.toString())
				{
					index    = i;
					break;
				}
			}
			
			if(index>=0)// already exist then update
			{
				var setup_item_qty:Number		= Number(dtlSetup.dgDtl.rows.children()[index].item_qty.toString());
				var item_qty:Number				= Number(xml.item_qty.toString());
				var setup_item_price:Number		= Number(dtlSetup.dgDtl.rows.children()[index].item_price.toString());
				if(setup_item_price>=0)   // means other r discount charge 
				{
					if(setup_item_qty>item_qty)   // means update 
					{
						dtlSetup.dgDtl.rows.children()[index].item_qty  = setup_item_qty - item_qty;
						dtlSetup.dgDtl.rows.children()[index].item_amt  = Number(dtlSetup.dgDtl.rows.children()[index].item_qty.toString()) * Number(dtlSetup.dgDtl.rows.children()[index].item_price.toString());
						
						var tempXml:XML			= XML(dtlSetup.dgDtl.rows).copy();
						dtlSetup.dgDtl.rows		= tempXml;
					}
					else   // means remove
					{
						dtlSetup.deleteRow(index);
					}
				}
			}
			dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));
		}
		
		public function updateEmbroideryStichCharges(dtlSetup:Object,stitch_charges:XML,vbMain:VBox,main_item_qty:String):void
		{
			if(vbMain.getChildren().length>0)
			{
				var imprintOptionsIndex:int					= new OptionsVisiblityFunctions().getImprintTypeOptionsIndex(vbMain);
				/*for(var j:int=0;j<1;j++)         // only for first options embroidery or not 
				{*/
					if(imprintOptionsIndex>=0)
					{
						var hbox:HBox 						= HBox(vbMain.getChildByName('hb'+imprintOptionsIndex));
						var selected_option_code:String 	= Label(hbox.getChildAt(0)).text;
						var comboBoxValue:ComboBox  		= ComboBox(hbox.getChildAt(1));
						
						var selected_option_value:String	= '';
						
						if(comboBoxValue.selectedIndex<0)
						{
							selected_option_value = '';
						}
						else
						{
							selected_option_value = comboBoxValue.selectedItem.code.toString();
						}
						
						var getStichChargeIndex:int	= isExistStitchCharge(dtlSetup,stitch_charges)
						if(selected_option_code.toUpperCase()=='IMPRINTTYPE' && selected_option_value.toUpperCase()=='EMBROIDERY' && stitch_charges.children().length()>0)
						{
							if(Number(main_item_qty)<144 && getStichChargeIndex<0)
							{
								var tempXml:XML		= XML(dtlSetup.dgDtl.rows).copy();
								tempXml.appendChild(stitch_charges.children());
								dtlSetup.dgDtl.rows		= tempXml.copy();
							}
							else if(Number(main_item_qty)>=144 && getStichChargeIndex>=0)
							{
								var stitch_charge:String  = stitch_charges.children()[0].catalog_item_code.toString();
								dtlSetup.deleteRow(getStichChargeIndex);
								dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));
							}
						}
						else if(getStichChargeIndex>=0)
						{
							var stitch_charge:String  = stitch_charges.children()[0].catalog_item_code.toString();
							dtlSetup.deleteRow(getStichChargeIndex);
							dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));
							
						}
					}
					
				}
			/*}*/
			dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));
		}
		
		private function isExistStitchCharge(dtlSetup:Object,stitch_charges:XML):int
		{
			var index:int=-1;
				
			var stitch_charge:String  = stitch_charges.children()[0].catalog_item_code.toString();    
			var xml:XML  			   = XML(dtlSetup.dgDtl.rows).copy();
			
			for(var i:int=0;i<xml.children().length();i++)
			{
				if(xml.children()[i].catalog_item_code.toString()== stitch_charge && Number(xml.children()[i].item_price.toString()))
				{
					index    = i;
					break;
				}
			}
			return  index;
		}
		public function updateLTMCharges(dtlSetup:Object,resultXmlFromItem:XML,main_item_qty:String):void
		{
			var ltm_charges:XML			= XML(resultXmlFromItem.ltm_charges.sales_order_lines)
			var getLtmChargeIndex:int	= isExistStitchCharge(dtlSetup,ltm_charges) 	
			
			if(ltm_charges.children().length()>0)
			{
				if(isItemQtyMinimum(resultXmlFromItem.columns,Number(main_item_qty)) && getLtmChargeIndex<0)
				{
					var tempXml:XML			= XML(dtlSetup.dgDtl.rows).copy();
					tempXml.appendChild(ltm_charges.children());
					dtlSetup.dgDtl.rows		= tempXml;
				}
				else if(!isItemQtyMinimum(resultXmlFromItem.columns,Number(main_item_qty)) && getLtmChargeIndex>=0)
				{
					var stitch_charge:String  = ltm_charges.children()[0].catalog_item_code.toString();
					dtlSetup.deleteRow(getLtmChargeIndex);
					dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));
				}
			}
			else
			{
				if(getLtmChargeIndex>=0)
				{
					var stitch_charge:String  = ltm_charges.children()[0].catalog_item_code.toString();
					dtlSetup.deleteRow(getLtmChargeIndex);
					dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));
				}
			}
			dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));
		}
		private function isItemQtyMinimum(columnXml:XMLList,qty:Number):Boolean
		{
			var returnValue:Boolean  = false;
			if(qty<Number(columnXml.column1.toString()))
			{
				returnValue  = true;
			}
			return returnValue;
		}
		private function isExistLTMCharge(dtlSetup:Object,ltm_charges:XML):int
		{
			var index:int=-1;
			
			var lym_charge:String   	= ltm_charges.children()[0].catalog_item_code.toString();    
			var xml:XML  			    = XML(dtlSetup.dgDtl.rows).copy();
			
			for(var i:int=0;i<xml.children().length();i++)
			{
				if(xml.children()[i].catalog_item_code.toString()== ltm_charges)
				{
					index    = i;
					break;
				}
			}
			return  index;
		}
		
	}           // end of class
}  // end of package