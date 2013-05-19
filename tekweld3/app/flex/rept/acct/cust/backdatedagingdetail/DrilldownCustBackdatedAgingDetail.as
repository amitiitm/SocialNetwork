package rept.acct.cust.backdatedagingdetail
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class DrilldownCustBackdatedAgingDetail implements IDrillDown
	{
		public static const SALESINVOICE:String      	 	 = 	'saoi/salesinvoice/components/SalesInvoice.swf';
		public static const SALESCREDITINVOICE:String      	 = 	'saoi/salescreditinvoice/components/SalesCreditInvoice.swf';
		public static const DIAMSALESINVOICE:String      	 = 	'dsaoi/invoice/components/DiamondInvoice.swf';
		public static const DIAMSALESCREDITINVOICE:String    = 	'dsaoi/creditinvoice/components/DiamondCreditInvoice.swf';
		public static const GOLDSALESINVOICE:String      	 = 	'gsaoi/invoice/components/GoldSalesInvoice.swf';
		public static const GOLDSALESCREDITINVOICE:String    = 	'gsaoi/creditinvoice/components/GoldSalesCreditInvoice.swf';
		public static const CUSTOMERINVOICE:String     		 =  'acct/custinvoice/components/CustomerInvoice.swf';
		public static const CUSTOMERRECEIPT:String     		 =  'acct/custreceipt/components/CustomerReceipt.swf';
		
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
			var __local:BackdatedAgingDetailModelLocator = new BackdatedAgingDetailModelLocator();
			__local = BackdatedAgingDetailModelLocator(GenModelLocator.getInstance().activeModelLocator);
			var trans_bk:String = XML(__local.reportObj.customReportDataGrid.selectedItem).inv_bk;
			
			 var tabpage:TabPage	=	new TabPage();
	
			if(trans_bk.toUpperCase()== 'SI01')
			{
				tabpage.openDrillDownPage(SALESINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'SC01')
			{
				tabpage.openDrillDownPage(SALESCREDITINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'SI02')
			{
				tabpage.openDrillDownPage(DIAMSALESINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'SC02')
			{
				tabpage.openDrillDownPage(DIAMSALESCREDITINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'SIO3')
			{
				tabpage.openDrillDownPage(GOLDSALESINVOICE); 
			}
			else if(trans_bk.toUpperCase()== 'SC03')
			{
				tabpage.openDrillDownPage(GOLDSALESCREDITINVOICE); 
			}  
			else if(trans_bk.toUpperCase()== 'IN01')
			{
				tabpage.openDrillDownPage(CUSTOMERINVOICE); 
			}
			else if(trans_bk.toUpperCase()== 'RE01')
			{
				tabpage.openDrillDownPage(CUSTOMERRECEIPT); 
			}  
		}
	}
}