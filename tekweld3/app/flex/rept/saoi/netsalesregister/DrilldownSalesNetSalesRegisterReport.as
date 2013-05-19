package rept.saoi.netsalesregister
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class DrilldownSalesNetSalesRegisterReport implements IDrillDown
	{
		private var tabpage:TabPage								=	new TabPage();
		public static const SALESCREDITINVOICE:String			=	'saoi/salescreditinvoice/components/SalesCreditInvoice.swf';
		public static const SALESINVOICE:String    			    =  	'saoi/salesinvoice/components/SalesInvoice.swf';
		public function variableDrillDown(obj:String):void
		{
			switch(String(obj).toUpperCase())
			{
				case 'C':
					handleVariableColumnDrillDown();
				break;
				
				case 'R':
					handleVariableRowDrillDown()
				break;
				default : Alert.show('wrong drill_type in class');
			}
		}
		private function handleVariableColumnDrillDown():void
		{
			
			/* var tabpage:TabPage	=	new TabPage();
			tabpage.openDrillDownPage(GLDETAILDOCCD); */
		}
		private function handleVariableRowDrillDown():void
		{
			var __local:NetSalesRegisterModelLocator = new NetSalesRegisterModelLocator();
			__local = NetSalesRegisterModelLocator(GenModelLocator.getInstance().activeModelLocator);
			var trans_bk:String = XML(__local.reportObj.customReportDataGrid.selectedItem).trans_bk;
			if(trans_bk.toUpperCase()== 'SC01')
			{
				 
				tabpage.openDrillDownPage(SALESCREDITINVOICE); 
				
			}
			else if(trans_bk.toUpperCase()== 'SI01')
			{
				tabpage.openDrillDownPage(SALESINVOICE); 
			}
			
			
		}
	}
}