package rept.saoi.cancellationregister
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import mx.controls.Alert;
	
	public class DrilldownSalesCancellationRegisterReport implements IDrillDown
	{
		public static const GLDETAILDOCCD:String		=	'rept/acct/gl/generalledgerdetail/components/GeneralLedgerDetail.swf';
		
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
			/* var tabpage:TabPage	=	new TabPage();
			tabpage.openDrillDownPage(GLDETAILDOCCD); */
		}
	}
}