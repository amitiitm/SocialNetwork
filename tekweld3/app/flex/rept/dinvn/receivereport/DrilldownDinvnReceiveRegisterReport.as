package rept.dinvn.receivereport
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class DrilldownDinvnReceiveRegisterReport implements IDrillDown
	{	
		public static const SALESCREDITINVOICE:String      	 = 	'dsaoi/creditinvoice/components/DiamondCreditInvoice.swf';
		public static const SALESMEMORETURN:String      	 = 	'dsaoi/memoreturn/components/DiamondMemoReturn.swf';
		public static const PURCHASEMEMORETURN:String   	 = 	'dpuoi/memoreturn/components/DiamPurchaseMemoReturn.swf';
		public static const PURCHASEMEMO:String       		= 	'dpuoi/memo/components/DiamPurchaseMemo.swf';
		public static const RECEIVE:String     				= 	'dinvn/receive/components/Receive.swf';
		public static const LOTTRANSFER:String              =   'dinvn/lottransfer/components/LotTransfer.swf';
		public static const PURCHASEINVOICE:String     		 = 'dpuoi/invoice/components/DiamPurchaseInvoice.swf';
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
			var __local:ReceiveReportModelLocator = new ReceiveReportModelLocator();
			__local = ReceiveReportModelLocator(GenModelLocator.getInstance().activeModelLocator);
			var trans_bk:String = XML(__local.reportObj.customReportDataGrid.selectedItem).trans_bk;
			var sub_transbk:String  = trans_bk.substr(0,2);
			 var tabpage:TabPage	=	new TabPage();
	
			if(sub_transbk.toUpperCase()== 'SE')
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
			else if(sub_transbk.toUpperCase()== 'RE')
			{
				tabpage.openDrillDownPage(RECEIVE); 
			} 
			else if(sub_transbk.toUpperCase()== 'TR')
			{
				tabpage.openDrillDownPage(LOTTRANSFER); 
			} 
			else if(sub_transbk.toUpperCase()== 'SC')
			{
				tabpage.openDrillDownPage(SALESCREDITINVOICE); 
			} 
		}
	}
}