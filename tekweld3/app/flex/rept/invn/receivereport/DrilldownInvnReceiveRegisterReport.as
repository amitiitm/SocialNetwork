package rept.invn.receivereport
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class DrilldownInvnReceiveRegisterReport implements IDrillDown
	{
		public static const SALESCREDITINVOICE:String      	 = 	'saoi/salescreditinvoice/components/SalesCreditInvoice.swf';
		public static const SALESMEMORETURN:String      	 = 	'saoi/salesmemoreturn/components/SalesMemoReturn.swf';
		public static const PURCHASEMEMORETURN:String   	 = 	'puoi/purchasememoreturn/components/PurchaseMemoReturn.swf';
		public static const PURCHASEMEMO:String       		 = 	'puoi/purchasememo/components/PurchaseMemo.swf';
		public static const RECEIVE:String     				 = 	'invn/receive/components/Receive.swf';
		public static const ITEMTRANSFER:String               =   'invn/itemtransfer/components/ItemTransfer.swf';
		public static const PURCHASEINVOICE:String     		 = 'puoi/purchaseinvoice/components/PurchaseInvoice.swf';
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
				tabpage.openDrillDownPage(ITEMTRANSFER); 
			}
			else if(sub_transbk.toUpperCase()== 'SC')
			{
				tabpage.openDrillDownPage(SALESCREDITINVOICE); 
			}  
		}
	}
}