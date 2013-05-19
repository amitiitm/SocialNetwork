package business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDataGrid;

	public class ExportGridEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "exportGridEvent";
		public var genDataGrid:GenDataGrid = null;
		public var reportName:String;
		public var viewName:String;
		
		public function ExportGridEvent(genDataGrid:GenDataGrid , reportName :String = "" , viewName:String = "")
		{
			super(EVENT_ID);
			this.genDataGrid	=	genDataGrid;
			this.reportName		=	reportName;
			this.viewName		=	viewName;
		}
	}
}
