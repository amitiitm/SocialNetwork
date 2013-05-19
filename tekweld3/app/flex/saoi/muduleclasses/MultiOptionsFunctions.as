package saoi.muduleclasses
{
	import com.generic.customcomponents.GenTextInput;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.core.Application;

	public class MultiOptionsFunctions
	{
		public function MultiOptionsFunctions()
		{
		}
		
		public function  getMultiOptionsHbox(vbMain:VBox):HBox
		{
			var hbox:HBox						= new HBox(); 
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				hbox 							= HBox(vbMain.getChildByName('hb'+i));
				var cb:ComboBox  				= ComboBox(hbox.getChildAt(1));
				if(new DrawItemsOptionsFunctions().isMultiValueOptions(cb) && cb.selectedIndex>0 && cb.selectedItem.code.toString()==ApplicationConstant.MULTIOPTION)
				{
					break;
				}
			}
			return hbox;
		}
		public function getMultiDescription(hbox:HBox):String
		{
			
			if(hbox.numChildren>0)
			{
				var comboBox:ComboBox	= ComboBox(hbox.getChildAt(1));
				if(new DrawItemsOptionsFunctions().isMultiValueOptions(comboBox) && comboBox.selectedIndex>=0 && comboBox.selectedItem.code.toString()==ApplicationConstant.MULTIOPTION)
				{
					return GenTextInput(hbox.getChildAt(2)).dataValue;
				}
				else
				{
					return 'VALID';  // FOR multi option but not selected
				}
					
			}
			else
			{
				return ''
			}
		}
		public function getMultiOptionsCode(hbox:HBox):String
		{
			return (hbox.numChildren>0)?Label(hbox.getChildAt(0)).text:'';
		}
		
		public function isMultiOptionsQtyValid(main_item_qty:String,multiDescriptions:String):int
		{
			/*if(multiDescriptions==null || multiDescriptions=='' || main_item_qty=='' || main_item_qty==null)
			{
				return 0;
			}*/
			if(multiDescriptions=='VALID')
			{
				return 0;
			}
			var item_qty:Number 	   = Number(main_item_qty);
			var total_multi_qty:Number = Number(0);
			
			var returnValue:int = 0;
			var params:Array = multiDescriptions.split(";");
			
			for (var i:int=0;i<params.length-1;i++)
			{
				var paramElement:String  	= params[i].toString();
				var colonIndex:int			= paramElement.indexOf("=");
				var code:String 			= paramElement.substr(0,colonIndex);
				var code_value:String 		= paramElement.substr(colonIndex+1,paramElement.length);
				total_multi_qty  			= total_multi_qty + Number(code_value);
			}
			if(item_qty==total_multi_qty)
			{
				returnValue  = 0;
			}
			else if(total_multi_qty>item_qty)
			{
				returnValue  = 1;  
			}
			else
			{
				returnValue	 = -1;
			}
			
			return returnValue;
		}
	}
}