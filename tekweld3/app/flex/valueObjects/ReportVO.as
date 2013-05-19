package valueObjects
{
	import com.generic.customcomponents.GenCustomReportDataGrid;
	import com.generic.genclass.IDrillDown;
	
	[Bindable]
	public class ReportVO
	{
		public var rows:XML;
		public var filteredReport:XML;
		public var customReportDataGrid:GenCustomReportDataGrid;
	
		//forrow level drill 
		public var isdrilldownrow:String		=	"N";
		public var isfixedurl:String			=	"N"	;
		public var drilldown_component_code:String;
		
		//for variable row or column level class
		public var idrilldown:IDrillDown;	
	}
}
