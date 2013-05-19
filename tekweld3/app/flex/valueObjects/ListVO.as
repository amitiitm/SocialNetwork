package valueObjects
{
	import com.generic.customcomponents.GenDataGrid;
	import com.generic.genclass.IDrillDown;
	
	[Bindable]
	public class ListVO
	{
		public var rows:XML;
		public var filteredList:XML;
		public var listFormat:XML;
		public var selectedRow:XML	=	null;
		public var listGrid:GenDataGrid;
		
		//forrow level drill from dataentry,inbox
		public var isfixedurl:String			=   "N";
		public var isdrilldownrow:String		=	"N";
		public var isObjectFromDrillDown:String	=   "N";		
		public var idrilldown:IDrillDown;
		public var drilldown_component_code:String;
		public var print_orientation:String		=	"L"			

		
		
	}
}