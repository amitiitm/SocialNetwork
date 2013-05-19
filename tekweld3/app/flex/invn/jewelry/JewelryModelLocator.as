package invn.jewelry
{
	import com.generic.customcomponents.GenDataGrid;
	
	import valueObjects.AddEditVO;
	import valueObjects.DetailEditVO;
	import valueObjects.DocumentVO;
	import valueObjects.ListVO;
	import valueObjects.NoteAttachmentVO;
	import valueObjects.SortOrderSelectionVO;
	import valueObjects.TreeVO;
	import valueObjects.ViewVO;

	[Bindable]
	public class JewelryModelLocator
	{
	    public var addEditObj:AddEditVO							=	new AddEditVO();
	    public var noteAttachObj:NoteAttachmentVO					=	new NoteAttachmentVO();
	    public var detailEditObj:DetailEditVO					=	new DetailEditVO();
	    public var treeObj:TreeVO								=	new TreeVO();
	    public var listObj:ListVO		   						=	new ListVO();
	    public var documentObj:DocumentVO						=	new DocumentVO();
	    public var sortOrderSelectionObj:SortOrderSelectionVO	=	new SortOrderSelectionVO();
	    public var viewObj:ViewVO								=	new ViewVO();
	    public var trans_date:String;

	    // For casting
		public var jewelry_unit_conversion:XML;
	    public var vendor_fixed_cost:Number;

		public var margin_calculation_flag:String;
		public var change_component_price:String;
		public var diamond_loss_percentage:Number;
		public var stone_loss_percentage:Number;
		public var wholesale_markup:Number;
		public var retail_markup:Number;		

	    public var gold_total_rate:Number;
	    public var gold_base_rate:Number;
	    public var gold_mu:Number;
	    public var silver_total_rate:Number;
	    public var silver_mu:Number;
	    public var platinum_total_rate:Number;
	    public var platinum_mu:Number;
	    public var palladium_total_rate:Number;
	    public var palladium_mu:Number; 
	    
	    public var tempGrid:GenDataGrid;
	    public var item_code:String;
	    public var size:String;
	}
}
