package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDataGrid;

	public class PrintGridEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "printGridEvent";
		public var genDataGrid:GenDataGrid = null;
		public var reportName:String;
		public var viewName:String;
		
		public function PrintGridEvent(genDataGrid:GenDataGrid, reportName :String = "" , viewName:String = "")
		{
			super(EVENT_ID);
			this.genDataGrid	=	genDataGrid;
			this.reportName		=	reportName;
			this.viewName		=	viewName;
		}
	}
}

