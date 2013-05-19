package saoi.specorderapproved
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class SpecOrderApprovedDrilldown implements IDrillDown
	{
		public static const REGULERORDER:String		=	'saoi/salesorder/components/SalesOrder.swf';
		public static const REORDER:String			=	'saoi/reorder/components/ReOrder.swf';
		public static const SAMPLEORDR:String		=	'saoi/sampleorder/components/SampleOrder.swf';
		public static const VIRTUALORDER:String		=	'saoi/virtualorder/components/VirtualOrder.swf';
		
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
			var __genModel:GenModelLocator			= GenModelLocator.getInstance();
			var __localModel:SpecOrderApprovedModelLocator  = SpecOrderApprovedModelLocator(__genModel.activeModelLocator);
			var tabpage:TabPage	=	new TabPage();
			if(__genModel.drillObj.drillrow.trans_type.toString()=='S')
			{
				tabpage.openDrillDownPage(REGULERORDER); 
			}
			else if(__genModel.drillObj.drillrow.trans_type.toString()=='E')
			{
				tabpage.openDrillDownPage(REORDER); 
			}
			else if(__genModel.drillObj.drillrow.trans_type.toString()=='P')
			{
				tabpage.openDrillDownPage(SAMPLEORDR); 
			}
			else if(__genModel.drillObj.drillrow.trans_type.toString()=='V')
			{
				tabpage.openDrillDownPage(VIRTUALORDER); 
			}			 
			
		}
	}
}