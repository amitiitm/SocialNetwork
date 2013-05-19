package rept.invn.issuereport
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import invn.issue.IssueModelLocator;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class DrilldownInvnIssueRegisterReport implements IDrillDown
	{
		public static const GLDETAILDOCCD:String		=	'rept/acct/gl/generalledgerdetail/components/GeneralLedgerDetail.swf';
		public static const ISSUE:String				=	'invn/issue/components/Issue.swf';
		public static const PURCHASECREDITINVOICE:String=	'puoi/purchasecreditinvoice/components/PurchaseCreditInvoice.swf';
		public static const ITEMTRANSFER:String			=	'invn/itemtransfer/components/ItemTransfer.swf';
		public static const SALESINVOICE:String			=	'saoi/salesinvoice/components/SalesInvoice.swf';
		public static const SALESMEMO:String			=	'saoi/salesmemo/components/SalesMemo.swf';
		public static const PURCHASEMEMORETURN:String	=	'puoi/purchasememoreturn/components/PurchaseMemoReturn.swf';
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
			var __local:IssueReportModelLocator = new IssueReportModelLocator();
			__local = IssueReportModelLocator(GenModelLocator.getInstance().activeModelLocator);
			var trans_bk:String = XML(__local.reportObj.customReportDataGrid.selectedItem).trans_bk;
			var sub_transbk:String  = trans_bk.substr(0,2);
			 var tabpage:TabPage	=	new TabPage();
	
			if(sub_transbk.toUpperCase()== 'IS')
			{
				tabpage.openDrillDownPage(ISSUE); 
			} 
			else if(sub_transbk.toUpperCase()== 'PC')
			{
				tabpage.openDrillDownPage(PURCHASECREDITINVOICE); 
			} 
			else if(sub_transbk.toUpperCase()== 'TR')
			{
				tabpage.openDrillDownPage(ITEMTRANSFER); 
			} 
			else if(sub_transbk.toUpperCase()== 'SI')
			{
				tabpage.openDrillDownPage(SALESINVOICE); 
			} 
			else if(sub_transbk.toUpperCase()== 'SM')
			{
				tabpage.openDrillDownPage(SALESMEMO); 
			} 
			else if(sub_transbk.toUpperCase()== 'PE')
			{
				tabpage.openDrillDownPage(PURCHASEMEMORETURN); 
			} 
		}
	}
}