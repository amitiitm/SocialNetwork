package business.commands                                                                                                          
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	
	import valueObjects.ListVO;
	
	public class InboxDrillDownCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var viewHandlers  : IResponder = null; 
		
		public function execute(event:CairngormEvent):void
		{		
			var __listObj:ListVO	=	__genModel.activeModelLocator.listObj;
			
			//__listObj.drilldown_component_code	=	"rept/acct/gl/generalledgerdetail/components/GeneralLedgerDetail.swf";
			//for fixed url
			
			if(__listObj.isObjectFromDrillDown=='Y')
			{
				var objectFromDrillDown:XML		 	= 	XML(__genModel.activeModelLocator.drillObjXml).copy();
				__genModel.objectFromDrilldown		= objectFromDrillDown;
			}
			if(__listObj.isdrilldownrow	==	"Y")
			{
				//row drill
				if(__listObj.isfixedurl	==	"Y")
				{
					//for fixed url
					var tabpage:TabPage	=	new TabPage();
					tabpage.openDrillDownPage(__listObj.drilldown_component_code);
					
				}
				else
				{
					var drillTypeObjct:Object	=	new Object();
					drillTypeObjct.drill_type	=	'R'
						
					__listObj.idrilldown.variableDrillDown('R');
				}
			}

		}
	}
	
}

