package business.commands                                                                                                          
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenCustomReportDataGrid;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	
	import valueObjects.ReportVO;
	
	public class DrillDownCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var viewHandlers  : IResponder = null; 
		
		public function execute(event:CairngormEvent):void
		{
			var isColumnDrill:Boolean				=	false;
			var __reportObj:ReportVO				=	__genModel.activeModelLocator.reportObj;
			var reportGrid:GenCustomReportDataGrid	=	__reportObj.customReportDataGrid;
			var drillcolumn:String					=	__genModel.drillObj.drillcolumn;
			
			/* reportGrid.arrDrilldownColumns	=	new Array();
			var obj:Object					=	new Object();
			obj.isFixedColumnURL			=	"Y";
			obj.drilldown_component_code	=	'rept/acct/gl/generalledgerdetail/components/GeneralLedgerDetail.swf'
			obj.column_name					=	'account_period_code'
			reportGrid.arrDrilldownColumns.push(obj);   */
				
			
			for(var i:int=0;	i< reportGrid.arrDrilldownColumns.length ; i++)
			{
				if(reportGrid.arrDrilldownColumns[i].column_name	==	drillcolumn)
				{
					
					isColumnDrill	=	true
					
					if(reportGrid.arrDrilldownColumns[i].isFixedColumnURL	==	"Y")
					{
						//for fixed url
						var tabpage:TabPage	=	new TabPage();
						tabpage.openDrillDownPage(reportGrid.arrDrilldownColumns[i].drilldown_component_code);
						break;
					}
					else
					{
						var drillTypeObj:Object	=	new Object();
						drillTypeObj.drill_type	=	'C'
						 __reportObj.idrilldown.variableDrillDown('C');
						break;
					}
				}
			}

	
			if(!isColumnDrill && __reportObj.isdrilldownrow	==	"Y")
			{
				//row drill
				if(__reportObj.isfixedurl	==	"Y")
				{
					//for fixed url
					var tabpages:TabPage	=	new TabPage();
					tabpages.openDrillDownPage(__reportObj.drilldown_component_code);
					
				}
				else
				{
					var drillTypeObjct:Object	=	new Object();
					drillTypeObjct.drill_type	=	'R'
						
					__reportObj.idrilldown.variableDrillDown('R');
				}
			}
		}
	}
}
