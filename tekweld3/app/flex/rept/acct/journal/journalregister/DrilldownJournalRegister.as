package rept.acct.journal.journalregister
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class DrilldownJournalRegister implements IDrillDown
	{
		public static const PURCHASEINVOICE:String      	 	 = 	'puoi/purchaseinvoice/components/PurchaseInvoice.swf';
		public static const PURCHASECREDITINVOICE:String      	 = 	'puoi/purchasecreditinvoice/components/PurchaseCreditInvoice.swf';
		public static const SALESINVOICE:String      	 	 	 = 	'saoi/salesinvoice/components/SalesInvoice.swf';
		public static const SALESCREDITINVOICE:String      	     = 	'saoi/salescreditinvoice/components/SalesCreditInvoice.swf';
		public static const DIAMPURCHASEINVOICE:String      	 = 	'dpuoi/invoice/components/DiamPurchaseInvoice.swf';
		public static const DIAMPURCHASECREDITINVOICE:String     = 	'dpuoi/creditinvoice/components/DiamPurchaseCreditInvoice.swf';
		public static const DIAMSALESINVOICE:String      	 	 = 	'dsaoi/invoice/components/DiamondInvoice.swf';
		public static const DIAMSALESCREDITINVOICE:String     	 = 	'dsaoi/creditinvoice/components/DiamondCreditInvoice.swf';
		public static const GOLDPURCHASEINVOICE:String      	 = 	'gpuoi/invoice/components/GoldPurchaseInvoice.swf';
		public static const GOLDPURCHASECREDITINVOICE:String     = 	'gpuoi/creditinvoice/components/GoldPurchaseCreditInvoice.swf';
		public static const GOLDSALESINVOICE:String      	 	 = 	'gsaoi/invoice/components/GoldSalesInvoice.swf';
		public static const GOLDSALESCREDITINVOICE:String     	 =	'gsaoi/creditinvoice/components/GoldSalesCreditInvoice.swf';
		public static const VENDORINVOICE:String     		 	 =  'acct/vendinvoice/components/VendorInvoice.swf';
		public static const VENDORPAYMENT:String     		 	 =  'acct/vendpayment/components/VendorPayment.swf';
		public static const CUSTOMERRECEIPT:String     		 	 =  'acct/custreceipt/components/CustomerReceipt.swf';
		public static const BANKDEPOSIT:String     		 	 	 =  'acct/bankdeposit/components/BankDeposit.swf';
		public static const BANKPAYMENT:String     		 	 	 =  'acct/bankpayment/components/BankPayment.swf';
		public static const BANKTRANSFER:String     		 	 =  'acct/banktransfer/components/BankTransfer.swf';
		public static const ENTERJOURNAL:String     		 	 =  'acct/journal/components/Journal.swf';
		public static const CONTRACTORMEMO:String     		 	 =  'prod/contractormemo/components/ContractMemo.swf';
		public static const POSRECEIPT:String     		 		 =  'pos/salesreceipt/components/SalesReceipt.swf';
		public static const CUSTOMERINVOICE:String     		 	 =  'acct/custinvoice/components/CustomerInvoice.swf';
		
		
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
			var __local:JournalRegisterModelLocator = new JournalRegisterModelLocator();
			__local = JournalRegisterModelLocator(GenModelLocator.getInstance().activeModelLocator);
			var trans_bk:String = XML(__local.reportObj.customReportDataGrid.selectedItem).trans_bk;
			var trans_type:String = XML(__local.reportObj.customReportDataGrid.selectedItem).trans_type;
			
			 var tabpage:TabPage	=	new TabPage();
			
			if(trans_bk.toUpperCase()== 'PI01')
			{
				tabpage.openDrillDownPage(PURCHASEINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'PC01')
			{
				tabpage.openDrillDownPage(PURCHASECREDITINVOICE); 
			} 
			if(trans_bk.toUpperCase()== 'SI01')
			{
				tabpage.openDrillDownPage(SALESINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'SC01')
			{
				tabpage.openDrillDownPage(SALESCREDITINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'PI02')
			{
				tabpage.openDrillDownPage(DIAMPURCHASEINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'PC02')
			{
				tabpage.openDrillDownPage(DIAMPURCHASECREDITINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'SI02')
			{
				tabpage.openDrillDownPage(DIAMSALESINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'SC02')
			{
				tabpage.openDrillDownPage(DIAMSALESCREDITINVOICE); 
			} 
			else if(trans_bk.toUpperCase()== 'PI03')
			{
				tabpage.openDrillDownPage(GOLDPURCHASEINVOICE); 
			}
			else if(trans_bk.toUpperCase()== 'PC03')
			{
				tabpage.openDrillDownPage(GOLDPURCHASECREDITINVOICE); 
			}  
			else if(trans_bk.toUpperCase()== 'SI03')
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
			else if(trans_bk.toUpperCase()== 'IN02')
			{
				tabpage.openDrillDownPage(VENDORINVOICE); 
			}
			else if(trans_bk.toUpperCase()== 'PA01'&& trans_type.toUpperCase()== 'PAYM')
			{
				tabpage.openDrillDownPage(BANKPAYMENT); 
			}
			else if(trans_bk.toUpperCase()== 'PA01'&& trans_type.toUpperCase()== 'I')
			{
				tabpage.openDrillDownPage(VENDORPAYMENT); 
			} 
			else if(trans_bk.toUpperCase()== 'RE01'&& trans_type.toUpperCase()== 'I')
			{
				tabpage.openDrillDownPage(CUSTOMERRECEIPT); 
			} 
			else if(trans_bk.toUpperCase()== 'RE01'&& trans_type.toUpperCase()== 'DEPS')
			{
				tabpage.openDrillDownPage(BANKDEPOSIT); 
			} 
			else if(trans_bk.toUpperCase()== 'JD01')
			{
				tabpage.openDrillDownPage(ENTERJOURNAL); 
			}
			else if(trans_bk.toUpperCase()== 'BT01')
			{
				tabpage.openDrillDownPage(BANKTRANSFER); 
			}
			else if(trans_bk.toUpperCase()== 'CM01')
			{
				tabpage.openDrillDownPage(CONTRACTORMEMO); 
			}
			else if(trans_bk.toUpperCase()== 'PS01')
			{
				tabpage.openDrillDownPage(POSRECEIPT); 
			}
		}
	}
}