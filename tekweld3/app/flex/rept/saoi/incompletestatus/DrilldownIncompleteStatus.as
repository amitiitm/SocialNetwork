package rept.saoi.incompletestatus
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class DrilldownIncompleteStatus implements IDrillDown
	{
		public static const SALESORDER:String		=	'saoi/salesorder/components/SalesOrder.swf';
		public static const REORDER:String			=	'saoi/reorder/components/ReOrder.swf';
		public static const VIRTUALORDER:String		=	'saoi/virtualorder/components/VirtualOrder.swf';
		public static const SAMPLEORDER:String		=	'saoi/sampleorder/components/SampleOrder.swf';
		
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
			var __local:IncompleteStatusModelLocator = new IncompleteStatusModelLocator();
			__local = IncompleteStatusModelLocator(GenModelLocator.getInstance().activeModelLocator);
			var trans_type:String = XML(__local.reportObj.customReportDataGrid.selectedItem).trans_type;
			var tabpage:TabPage	=	new TabPage();
			if(trans_type.toUpperCase()== 'E')
			{
				 
				tabpage.openDrillDownPage(REORDER); 
				
			}
			else if(trans_type.toUpperCase()== 'S')
			{
				tabpage.openDrillDownPage(SALESORDER); 
			}
			else if(trans_type.toUpperCase()== 'P')
			{
				tabpage.openDrillDownPage(SAMPLEORDER); 
			}
			else if(trans_type.toUpperCase()== 'V')
			{
				tabpage.openDrillDownPage(VIRTUALORDER); 
			}
		}
	}
}