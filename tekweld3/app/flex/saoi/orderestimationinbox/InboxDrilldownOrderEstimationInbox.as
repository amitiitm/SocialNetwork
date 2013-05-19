package saoi.orderestimationinbox
{
	import com.generic.genclass.IDrillDown;
	import com.generic.genclass.TabPage;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class InboxDrilldownOrderEstimationInbox implements IDrillDown
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
			var __genModel:GenModelLocator						= GenModelLocator.getInstance();
			var __localModel:OrderEstimationInboxModelLocator  	= OrderEstimationInboxModelLocator(__genModel.activeModelLocator);
			
			if(__genModel.drillObj.drillrow.trans_type.toString()=='S')
			{
				var tabpage:TabPage	=	new TabPage();
				tabpage.openDrillDownPage(REGULERORDER); 
			}
			else if(__genModel.drillObj.drillrow.trans_type.toString()=='E')
			{
				var tabpage:TabPage	=	new TabPage();
				tabpage.openDrillDownPage(REORDER); 
			}
			else if(__genModel.drillObj.drillrow.trans_type.toString()=='P')
			{
				var tabpage:TabPage	=	new TabPage();
				tabpage.openDrillDownPage(SAMPLEORDR); 
			}
			else if(__genModel.drillObj.drillrow.trans_type.toString()=='V')
			{
				var tabpage:TabPage	=	new TabPage();
				tabpage.openDrillDownPage(VIRTUALORDER); 
				
			}			 
			
		}
	}
}