package saoi.muduleclasses
{
	import business.commands.GetMenuCommand;
	import business.events.GetInformationEvent;
	import business.events.GetRecordEvent;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.components.DataEntry;
	import com.generic.components.Detail;
	import com.generic.customcomponents.GenDateField;
	import com.generic.customcomponents.GenTextInput;
	import com.generic.events.DetailEvent;
	import com.generic.events.GenTextInputEvent;
	import com.generic.genclass.GenNumberFormatter;
	import com.generic.genclass.TabPage;
	import com.generic.genclass.URL;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getQualifiedClassName;
	
	import model.GenModelLocator;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
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
	
	public class OptionsVisiblityFunctions
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		
		
		private var optionsSetupChargeCalculation:OptionsSetupChargeCalculation	= 	new OptionsSetupChargeCalculation();
		private var numericFormatter:GenNumberFormatter 						= 	new GenNumberFormatter();
		
		private var vbMain:VBox;
		private var selectedId:Number;
		private var resultXmlFromItem:XML;
		private var tiQty:Object;
		private var dtlSetup:Object;
		
		public function OptionsVisiblityFunctions()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
			
			numericFormatter.precision = 2;
			numericFormatter.rounding = "nearest";
		}
		public function getImprintTypeOptionsIndex(vbMain:VBox):int
		{
			var returnValue:int = 0;
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
				var catalog_attribute_code:String	 	= Label(hbox.getChildAt(0)).text;
				if(catalog_attribute_code=='IMPRINTTYPE')
				{
					returnValue  = i;
					break;
				}
			}
			return returnValue;
		}
		public function changeVisibilityOfOtheroptions(vbMain:VBox,selectedId:Number,resultXmlFromItem:XML=null,tiQty:Object=null,dtlSetup:Object=null,order_type:String=''):void   
		{
			this.vbMain									= vbMain;
			this.selectedId								= selectedId;
			this.tiQty									= tiQty;
			this.resultXmlFromItem						= resultXmlFromItem;
			this.dtlSetup								= dtlSetup;
			
			var imprintOptionsIndex:int					= getImprintTypeOptionsIndex(vbMain);
			
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
						//hbox.visible								= false;
						//hbox.includeInLayout						= false;
						//ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
						
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
						
						if(catalog_attribute_code	=='DECAL' || catalog_attribute_code	=='IMPRINTCOLOR1' || catalog_attribute_code	=='IMPRINTCOLOR2' || catalog_attribute_code	=='IMPRINTCOLOR3')
						{
							hbox.visible   								= false;
							hbox.includeInLayout						= false;
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
			if(selectedId>=0 && dtlSetup!=null)
			{
				updateSetupCharges(selectedId);
				optionsSetupChargeCalculation.updateEmbroideryStichCharges(dtlSetup,XML(resultXmlFromItem.stitch_charges.sales_order_lines),vbMain,tiQty.dataValue);
			}
			/*if(selectedId==0 && dtlSetup!=null)
			{
				
			}*/
			if(__localModel.order_type=='S' || __localModel.order_type=='E' || __localModel.order_type=='F')
			{
				new DrawItemsOptionsFunctions().setDisableEnableMultiOptionsRemarks(vbMain);
			}
			
		
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
		
		
		
		// for disable options (xml structure diff from enable options)
		public function changeVisibilityOfOtherDisableoptions(vbMain:VBox):void
		{
			var imprintOptionsIndex:int					= getImprintTypeOptionsIndex(vbMain);
			
			var hboxFirst:HBox 							= HBox(vbMain.getChildByName('hb'+imprintOptionsIndex));      // IMPRINT OPTIONS SHOULD BE FIRST OPTIONS
			
			//var hboxFirst:HBox 							= HBox(vbMain.getChildByName('hb'+0));      // IMPRINT OPTIONS SHOULD BE FIRST OPTIONS
			var catalog_attribute_code:String	 		= Label(hboxFirst.getChildAt(0)).text;
			var comboBoxValue:ComboBox  				= ComboBox(hboxFirst.getChildAt(1));
			
			
			if(catalog_attribute_code=='IMPRINTTYPE')
			{
				if(comboBoxValue.selectedIndex<0 || comboBoxValue.selectedItem.toString()=='' )
				{
					for(var i:int=1;i<vbMain.getChildren().length;i++)
					{
						var hbox:HBox 								= HBox(vbMain.getChildByName('hb'+i));
						//hbox.visible								= false;
						//hbox.includeInLayout						= false;
						//ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
						
						var catalog_attribute_code:String	 		= Label(hbox.getChildAt(0)).text;
						if(catalog_attribute_code =='DECAL' || catalog_attribute_code	=='IMPRINTCOLOR1' || catalog_attribute_code	=='IMPRINTCOLOR2' || catalog_attribute_code	=='IMPRINTCOLOR3')
						{
							hbox.visible   							= false;
							hbox.includeInLayout					= false;
							ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
						}
						
					}
				}
				else if(comboBoxValue.selectedItem.toString()=='DECAL')
				{
					for(var i:int=1;i<vbMain.getChildren().length;i++)
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
				else if(comboBoxValue.selectedItem.toString()=='DIRECT')
				{
					for(var i:int=1;i<vbMain.getChildren().length;i++)
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
				else if(comboBoxValue.selectedItem.toString()=='DIGITEK')
				{
					for(var i:int=1;i<vbMain.getChildren().length;i++)
					{
						var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
						hbox.visible							= true;
						hbox.includeInLayout					= true;
						
						var catalog_attribute_code:String	 	= Label(hbox.getChildAt(0)).text;
						
						if(catalog_attribute_code	=='DECAL' || catalog_attribute_code	=='IMPRINTCOLOR1' || catalog_attribute_code	=='IMPRINTCOLOR2' || catalog_attribute_code	=='IMPRINTCOLOR3')
						{
							hbox.visible   								= false;
							hbox.includeInLayout						= false;
							ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
						}
					}
				}
				else
				{
					for(var i:int=1;i<vbMain.getChildren().length;i++)
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
			
		}
		
		
	}  // end of class
}  // end of package