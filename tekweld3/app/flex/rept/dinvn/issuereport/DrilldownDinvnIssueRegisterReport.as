package rept.dinvn.issuereport
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class DrilldownDinvnIssueRegisterReport implements IDrillDown
	{
		public static const DIAMISSUE:String				=	'dinvn/issue/components/Issue.swf';
		public static const DIAMPURCHASECREDITINVOICE:String=	'dpuoi/creditinvoice/components/DiamPurchaseCreditInvoice.swf';
		public static const DIAMLOTTRANSFER:String			=	'dinvn/lottransfer/components/LotTransfer.swf';
		public static const DIAMSALESINVOICE:String			=	'dsaoi/invoice/components/DiamondInvoice.swf';
		public static const DIAMSALESMEMO:String			=	'dsaoi/memo/components/DiamondMemo.swf';
		public static const DIAMPURCHASEMEMORETURN:String	=	'dpuoi/memoreturn/components/DiamPurchaseMemoReturn.swf';
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
				tabpage.openDrillDownPage(DIAMISSUE); 
			} 
			else if(sub_transbk.toUpperCase()== 'PC')
			{
				tabpage.openDrillDownPage(DIAMPURCHASECREDITINVOICE); 
			} 
			else if(sub_transbk.toUpperCase()== 'TR')
			{
				tabpage.openDrillDownPage(DIAMLOTTRANSFER); 
			} 
			else if(sub_transbk.toUpperCase()== 'SI')
			{
				tabpage.openDrillDownPage(DIAMSALESINVOICE); 
			} 
			else if(sub_transbk.toUpperCase()== 'SM')
			{
				tabpage.openDrillDownPage(DIAMSALESMEMO); 
			} 
			else if(sub_transbk.toUpperCase()== 'PE')
			{
				tabpage.openDrillDownPage(DIAMPURCHASEMEMORETURN); 
			} 
		}
	}
}