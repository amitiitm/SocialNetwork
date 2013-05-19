package  rept.dinvn.activityreport
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class DrilldownDinvnActivityRegisterReport implements IDrillDown
	{
		public static const SALESCREDITINVOICE:String		=	'dsaoi/creditinvoice/components/DiamondCreditInvoice.swf';
		public static const SALESMEMO:String            	= 	'dsaoi/memo/components/DiamondMemo.swf';
		public static const SALESINVOICE:String         	 = 	'dsaoi/invoice/components/DiamondInvoice.swf';
		public static const SALESMEMORETURN:String      	 = 	'dsaoi/memoreturn/components/DiamondMemoReturn.swf';
		public static const PURCHASEMEMORETURN:String   	 = 	'dpuoi/memoreturn/components/DiamPurchaseMemoReturn.swf';
		public static const PURCHASEMEMO:String       		= 	'dpuoi/memo/components/DiamPurchaseMemo.swf';
		public static const PURCHASEINVOICE:String     		 = 'dpuoi/invoice/components/DiamPurchaseInvoice.swf';
		public static const PURCHASECREDITINVOICE:String     = 	'dpuoi/creditinvoice/components/DiamPurchaseCreditInvoice.swf';
		public static const RECEIVE:String     				= 	'dinvn/receive/components/Receive.swf';
		
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
			var __local:ActivityReportModelLocator = new ActivityReportModelLocator();
			__local = ActivityReportModelLocator(GenModelLocator.getInstance().activeModelLocator);
			var trans_bk:String = XML(__local.reportObj.customReportDataGrid.selectedItem).trans_bk;
			var sub_transbk:String  = trans_bk.substr(0,2);
			 var tabpage:TabPage	=	new TabPage();
			 if(sub_transbk.toUpperCase()== 'SM')
			{
				tabpage.openDrillDownPage(SALESMEMO); 
			}
			else if(sub_transbk.toUpperCase()== 'SI')
			{
				tabpage.openDrillDownPage(SALESINVOICE); 
			}
			else if(sub_transbk.toUpperCase()== 'SI')
			{
				tabpage.openDrillDownPage(SALESINVOICE); 
			} 
			else if(sub_transbk.toUpperCase()== 'SC')
			{
				tabpage.openDrillDownPage(SALESCREDITINVOICE); 
			} 
			else if(sub_transbk.toUpperCase()== 'SE')
			{
				tabpage.openDrillDownPage(SALESMEMORETURN); 
			} 
			else if(sub_transbk.toUpperCase()== 'PM')
			{
				tabpage.openDrillDownPage(PURCHASEMEMO); 
			} 
			else if(sub_transbk.toUpperCase()== 'PI')
			{
				tabpage.openDrillDownPage(PURCHASEINVOICE); 
			} 
			else if(sub_transbk.toUpperCase()== 'PE')
			{
				tabpage.openDrillDownPage(PURCHASEMEMORETURN); 
			} 
			else if(sub_transbk.toUpperCase()== 'PC')
			{
				tabpage.openDrillDownPage(PURCHASECREDITINVOICE); 
			} 
			else if(sub_transbk.toUpperCase()== 'RE')
			{
				tabpage.openDrillDownPage(RECEIVE); 
			} 
			 
		}
	}
}