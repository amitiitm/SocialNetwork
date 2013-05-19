package saoi.muduleclasses
{
	import business.commands.GetMenuCommand;
	import business.events.GetInformationEvent;
	import business.events.GetRecordEvent;
	import business.events.RecordStatusEvent;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.components.DataEntry;
	import com.generic.components.Detail;
	import com.generic.customcomponents.GenDataGrid;
	import com.generic.customcomponents.GenDateField;
	import com.generic.customcomponents.GenTextInput;
	import com.generic.events.DetailEvent;
	import com.generic.events.GenTextInputEvent;
	import com.generic.genclass.GenNumberFormatter;
	import com.generic.genclass.TabPage;
	import com.generic.genclass.URL;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	
	import model.GenModelLocator;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.messaging.channels.HTTPChannel;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import saoi.muduleclasses.event.MissingInfoEvent;
	
	import valueObjects.ApplicationVO;
	
	public class DrawItemsOptionsFunctions
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		
		
		private var optionsSetupChargeCalculation:OptionsSetupChargeCalculation	= 	new OptionsSetupChargeCalculation();
		private var numericFormatter:GenNumberFormatter 						= 	new GenNumberFormatter();
		
		private var vbMain:VBox;
		private var resultXmlFromItem:XML;
		private var tiQty:Object;
		private var dtlSetup:Object;
		private var dgOptions:GenDataGrid;
		private var attributeXml:XMLList;
		private var resultXml:XML;
		private var order_type:String;
		
		public function DrawItemsOptionsFunctions()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
			
			numericFormatter.precision = 2;
			numericFormatter.rounding = "nearest";
		}
		
		public function drawItemOptions(dgOptions:GenDataGrid,attributeXml:XMLList,vbMain:VBox,resultXml:XML=null,resultXmlFromItem:XML=null,tiQty:Object=null,dtlSetup:Object=null):void
		{
			this.attributeXml							= attributeXml;
			this.resultXml								= resultXml;
			this.dgOptions								= dgOptions;
			this.vbMain									= vbMain;
			this.tiQty									= tiQty;
			this.resultXmlFromItem						= resultXmlFromItem;
			this.dtlSetup								= dtlSetup;
			this.order_type								= order_type;
			
			vbMain.removeAllChildren();
			
			var xml:XMLList								= attributeXml.copy();
			
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
				setOptionValue(resultXml,vbMain);
			}
			else
			{
				dgOptions.rows		= saveOptions(vbMain,dgOptions.rootNode,getItemId(resultXmlFromItem)).copy();
			}
			if(vbMain.numChildren>0)                 // in this case no options r exist 
			{
				if(resultXml==null)
				{
					visibilityOfOtheroptions(vbMain,0);
				}
				else
				{
					visibilityOfOtheroptions(vbMain,-1);
				}
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
		public function saveOptions(vbMain:VBox,rootNode:String,catalog_item_id:String):XML
		{
			var __saveOption:XML = new XML('<'+rootNode+'/>');
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var attribute:XMLList 				= new XMLList('<'+rootNode.substr(0,rootNode.length-1)+'/>');
				var hbox:HBox 						= HBox(vbMain.getChildByName('hb'+i));
				attribute.catalog_attribute_code 	= Label(hbox.getChildAt(0)).text;
				var comboBoxValue:ComboBox 	 		= ComboBox(hbox.getChildAt(1));
				
				var remarksValue:GenTextInput  		= GenTextInput(hbox.getChildAt(2));
				attribute.remarks 			   		= remarksValue.dataValue;
				
				if(comboBoxValue.selectedIndex<0 || comboBoxValue.selectedItem==null)
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
				attribute.catalog_item_id 	= catalog_item_id;
				attribute.sales_order_attributes_multiple_values 	= '';
				__saveOption.appendChild(attribute);
			}
			return __saveOption;
		}			
		public function isMultiValueOptions(comboBoxValue:ComboBox):Boolean
		{
			var returnValue:Boolean  = false;
			
			for(var i:int=0;i<XMLList(comboBoxValue.dataProvider).length();i++)
			{
				var value:String     =  XMLList(comboBoxValue.dataProvider)[i].code.toString();
				if(value==ApplicationConstant.MULTIOPTION)
				{
					returnValue =  true;
					break;
				}
			}
			return returnValue;
		}
		public function setDisableEnableMultiOptionsRemarks(vbMain:VBox):void
		{
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var hbox:HBox 								= HBox(vbMain.getChildByName('hb'+i));
				var comboBoxValue:ComboBox  				= ComboBox(hbox.getChildAt(1));
				var remarksTextInput:GenTextInput 			= GenTextInput(hbox.getChildAt(2))
				
				if(comboBoxValue.selectedIndex>=0 && comboBoxValue.selectedItem.code.toString().toUpperCase()==ApplicationConstant.MULTIOPTION)
				{
					remarksTextInput.enabled				= false;
				}
				else
				{
					remarksTextInput.enabled				= true;
				}
			}
		}
		
		public function openMultioptionPopUpWindow(vbMain:VBox,selectedId:int,dgOptions:GenDataGrid):void
		{
			for(var j:int=0;j<vbMain.getChildren().length;j++)
			{
				var hbox:HBox 								= HBox(vbMain.getChildByName('hb'+j));
				var comboBoxValue:ComboBox  				= ComboBox(hbox.getChildAt(1));
				var remarksTextInput:GenTextInput 			= GenTextInput(hbox.getChildAt(2))
				
				if(j== selectedId && isMultiValueOptions(comboBoxValue))
				{
					remarksTextInput.text					= '';
					remarksTextInput.dispatchEvent(new GenTextInputEvent(GenTextInputEvent.ITEMCHANGED_EVENT));
				}
				if(j== selectedId && isMultiValueOptions(comboBoxValue) && comboBoxValue.selectedItem.code.toString().toUpperCase()!=ApplicationConstant.MULTIOPTION)
				{
					deleteMultiValue(hbox,dgOptions);
				}
				if(j== selectedId && isMultiValueOptions(comboBoxValue) && comboBoxValue.selectedItem.code.toString().toUpperCase()==ApplicationConstant.MULTIOPTION)
				{
					openMultiOptionsPopup(vbMain,hbox,false,dgOptions);
					break;
				}
			}
		}
		private function deleteMultiValue(hbox:HBox,dgOptions:GenDataGrid):void
		{
			for(var i:int= 0; i<dgOptions.rows.children().length();i++)
			{
				var optionsId:String	= dgOptions.rows.children()[i].id.toString();
				var code:String			= dgOptions.rows.children()[i].catalog_attribute_code.toString();
				
				var optionsIdhbox:String	= GenTextInput(hbox.getChildAt(4)).dataValue;
				var optionsCodehbox:String	= Label(hbox.getChildAt(0)).text;
				if(optionsId==optionsIdhbox && optionsCodehbox==code)
				{
					dgOptions.selectedRow	= 	dgOptions.rows.children()[i];
					dgOptions.selectedIndex	=   i;
					break;
				}
			}
			
			var tempXml:XML								= XML(dgOptions.selectedRow.child('sales_order_attributes_multiple_values'));
			var tempLength:int							= tempXml.children().length();
			for(var i:int=0;i<tempLength;i++)
			{
				var childXml:XML						= tempXml.children()[i];
				var id:int								= int(childXml.id.toString());
				childXml.trans_flag  					= 'D';
				if(id>0)
				{
					
				}
				else
				{
					delete tempXml.child('sales_order_attributes_multiple_value')[i];	
				}
			}
		}
		public function openMultiOptionsPopup(vbMain:VBox,hbox:HBox,isEdit:Boolean,dgOptions:GenDataGrid):void
		{
			var multiOptionsFunction:MultiOptionsFunctions = new MultiOptionsFunctions();
			var multiOptionsPopUp:MultiOptionsPoPopUp = MultiOptionsPoPopUp(PopUpManager.createPopUp(vbMain,MultiOptionsPoPopUp,true));
			multiOptionsPopUp.x= ((Application.application.width/2)-(multiOptionsPopUp.width/2));
			multiOptionsPopUp.y= ((Application.application.height/2)-(multiOptionsPopUp.height/2));
			multiOptionsPopUp.hbMultiOptions = hbox;
			multiOptionsPopUp.isEdit		 = isEdit;
			multiOptionsPopUp.dgOptions		 = dgOptions;
			multiOptionsPopUp.title			 = multiOptionsFunction.getMultiOptionsCode(multiOptionsFunction.getMultiOptionsHbox(vbMain));
			
		}
		public function comboboxChangeHandler(event:ListEvent):void
		{
			var recordStatusEvent:RecordStatusEvent  = new RecordStatusEvent('MODIFY');
			recordStatusEvent.dispatch();
			
			var selectedId:Number			  = Number(ComboBox(event.target).id);
			visibilityOfOtheroptions(vbMain,selectedId);
			//setDisableEnableMultiOptionsRemarks(vbMain,selectedId);
			if(__localModel.order_type=='S' || __localModel.order_type=='E' || __localModel.order_type=='F')
			{
				openMultioptionPopUpWindow(vbMain,selectedId,this.dgOptions);
			}
			
			var imprintTypeIndex:int	 	  		= new OptionsVisiblityFunctions().getImprintTypeOptionsIndex(vbMain); 
			
			if(selectedId==imprintTypeIndex)
			{
				for(var j:int=0;j<vbMain.getChildren().length;j++)                    // reset remarks when no options save in database
				{
					var hbox:HBox 					  							  = HBox(vbMain.getChildByName('hb'+j));
					var remarksTextInput:GenTextInput 							  = GenTextInput(hbox.getChildAt(2))
					var comboBoxValue:ComboBox									  = ComboBox(hbox.getChildAt(1));
					if(isMultiValueOptions(comboBoxValue)&& comboBoxValue.selectedIndex>=0 && comboBoxValue.selectedItem.code.toString()==ApplicationConstant.MULTIOPTION)
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
					var optionsIndex:int				= getOptionCodeIndex(dgOptions,optionsCode);
					dgOptions.rows.children()[i].catalog_attribute_value_code = attribute_value;
				}
			}
		}
		public function getOptionCodeIndex(dgItemOptions:GenDataGrid,optionCode:String):int
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
		}
		public function remarksItemDoubleClickHandler(event:Event):void
		{
			if(__localModel.order_type=='S' || __localModel.order_type=='E'|| __localModel.order_type=='F')
			{
				var hbox:HBox					= HBox(GenTextInput(event.currentTarget).parent);
				var comboBoxValue:ComboBox		= ComboBox(hbox.getChildAt(1));
				var code:String					= Label(hbox.getChildAt(0)).text;
				var remarks:String				= GenTextInput(hbox.getChildAt(2)).dataValue;
				if(isMultiValueOptions(comboBoxValue) && comboBoxValue.selectedIndex>=0 && comboBoxValue.selectedItem.code.toString()==ApplicationConstant.MULTIOPTION)
				{
					openMultiOptionsPopup(VBox(hbox.parent),hbox,true,this.dgOptions);
				}
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
		public  function setComboBoxValueBlank(cb:ComboBox):void
		{
			var index:int  = 0;
			cb.selectedIndex = index;
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
		public function getOptionsValueFromCode(optionXml:XMLList,optionCode:String):String
		{
			return optionXml.children().(catalog_attribute_code==optionCode).catalog_attribute_value_code.toString();
		}
		public function setOptionValue(recordXml:XML,vbMain:VBox):void
		{
			var parentXml:XML	   = new XML(<params/>);   // for diff in heirarchy for sample and regular
			parentXml.appendChild(recordXml.copy());
			
			var optionXml:XMLList  = parentXml..sales_order_attributes_values;
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
					
					GenTextInput(hbox.getChildAt(4)).dataValue	= '';
				}
				else
				{
					var optionCode:Label    	= Label(hbox.getChildAt(0));
					
					var remarksValue:TextInput  = TextInput(hbox.getChildAt(2));
					remarksValue.text			= optionXml.children()[i].remarks.toString();
					
					
					GenTextInput(hbox.getChildAt(4)).dataValue	= optionXml.children()[i].id.toString();
						
					var cb:ComboBox  			= ComboBox(hbox.getChildAt(1));
					//var value_code:String   	= optionXml.children()[i].catalog_attribute_value_code.toString();
					var value_code:String   	= getOptionsValueFromCode(optionXml,optionCode.text);
					
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
			
			
		}
		private function visibilityOfOtheroptions(vbMain:VBox,selectedId:Number):void
		{
			var optionsVisiblityFunctions:OptionsVisiblityFunctions				= new OptionsVisiblityFunctions();
			optionsVisiblityFunctions.changeVisibilityOfOtheroptions(vbMain,selectedId,resultXmlFromItem,tiQty,dtlSetup);
		}
		
		public function drawItemOptionsForDisableOptions(vbMain:VBox,optionXml:XML):void
		{
			vbMain.removeAllChildren();
			
			for(var i:int=0;i<optionXml.children().length();i++)
			{
				var hbox:HBox 									= new HBox();
				hbox.percentWidth	  							= 100;
				hbox.height 		 							= 22;
				hbox.name         								= 'hb'+i;	
				hbox.setStyle('verticalAlign','middle');
				
				
				// attribute code
				var tiAttributeName:Label						= new Label();
				tiAttributeName.text 							= optionXml.children()[i].catalog_attribute_code.toString();
				tiAttributeName.width							= 100;
				tiAttributeName.tabEnabled						= false;
				tiAttributeName.setStyle('textAlign','right');
				tiAttributeName.setStyle('borderStyle','none');
				
				// for attribute code values
				var gcbAttributeValue:ComboBox					= new ComboBox();
				gcbAttributeValue.id							=	 i.toString();
				gcbAttributeValue.tabEnabled					= true;
				//gcbAttributeValue.addEventListener(ListEvent.CHANGE , comboboxChangeHandler);
				gcbAttributeValue.width     					= 150;
				gcbAttributeValue.height						= 20;
				//gcbAttributeValue.enabled						= !dcCustomer_id.viewOnlyFlag
				
				gcbAttributeValue.dataProvider					= optionXml.children()[i].catalog_attribute_value_code.toString();
				gcbAttributeValue.labelField					= 'catalog_attribute_value_code';
				
				var tiRemarksValue:GenTextInput					= new GenTextInput();
				tiRemarksValue.id								= i.toString()
				tiRemarksValue.text 							= optionXml.children()[i].remarks.toString();;
				tiRemarksValue.width							= 200;
				tiRemarksValue.tabEnabled						= true;
				//tiRemarksValue.addEventListener(GenTextInputEvent.ITEMCHANGED_EVENT,remarksItemChnageHandler);
				
				hbox.addChildAt(tiAttributeName,0);
				hbox.addChildAt(gcbAttributeValue,1);
				hbox.addChildAt(tiRemarksValue,2);
				
				vbMain.addChildAt(hbox,i);
			}
			if(vbMain.numChildren>0)                 // in this case no options r exist 
			{
				new OptionsVisiblityFunctions().changeVisibilityOfOtherDisableoptions(vbMain);
			}
		}
		
		
	}  // end of class
}  // end of package