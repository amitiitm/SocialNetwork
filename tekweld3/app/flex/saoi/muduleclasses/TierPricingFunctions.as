package saoi.muduleclasses
{
	import business.commands.GetMenuCommand;
	import business.events.GetInformationEvent;
	import business.events.GetRecordEvent;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.components.DataEntry;
	import com.generic.components.Detail;
	import com.generic.customcomponents.GenButton;
	import com.generic.customcomponents.GenDateField;
	import com.generic.customcomponents.GenTextInput;
	import com.generic.events.DetailEvent;
	import com.generic.events.GenTextInputEvent;
	import com.generic.genclass.GenNumberFormatter;
	import com.generic.genclass.TabPage;
	import com.generic.genclass.URL;
	
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import saoi.muduleclasses.event.MissingInfoEvent;
	
	import valueObjects.ApplicationVO;
	
	public class TierPricingFunctions
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		
		private var numericFormatter:GenNumberFormatter 						= 	new GenNumberFormatter();
		
		public function TierPricingFunctions()
		{
			__genModel	= GenModelLocator.getInstance();
			__localModel= __genModel.activeModelLocator;
			__services	= __genModel.services;
			
			numericFormatter.precision = 2;
			numericFormatter.rounding = "nearest";
		}
		
		public function  getColumnSize(columnXml:XMLList,size:int):int
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
			else if(size<Number(columnXml.column11.toString()))
			{
				index = 10;
			}
			else if(size<Number(columnXml.column12.toString()))
			{
				index = 11;
			}
			else if(size<Number(columnXml.column13.toString()))
			{
				index = 12;
			}
			else if(size<Number(columnXml.column14.toString()))
			{
				index = 13;
			}
			else if(size<Number(columnXml.column15.toString()))
			{
				index = 14;
			}
			else if(size>=Number(columnXml.column15.toString()))
			{
				index = 15;
			}
			return index;
		}
		
		public function returnColumnPrice(column_pricing:XMLList,index:int):String
		{
			var price:String = column_pricing.column15.toString();
			if(index==1)
			{
				price =  column_pricing.column1.toString();  //+ LTM Price
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
			else if(index==11)
			{
				price =  column_pricing.column11.toString();
			}
			else if(index==12)
			{
				price =  column_pricing.column12.toString();
			}
			else if(index==13)
			{
				price =  column_pricing.column13.toString();
			}
			else if(index==14)
			{
				price =  column_pricing.column14.toString();
			}
			else if(index==15)
			{
				price =  column_pricing.column15.toString();
			}
			return price;
		}
		
	}  // end of class
}  // end of package