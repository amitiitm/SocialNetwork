package puoi.purchaseorder
{
	//import com.generic.genclass.ICriteria;
	
	import valueObjects.AddEditVO;
	import valueObjects.DetailEditVO;
	import valueObjects.DocumentVO;
	import valueObjects.ImportVO;
	import valueObjects.ListVO;
	import valueObjects.NoteAttachmentVO;
	import valueObjects.SortOrderSelectionVO;
	import valueObjects.TreeVO;
	import valueObjects.ViewVO;

	[Bindable]
	public class PurchaseOrderModelLocator
	{
	    public var addEditObj:AddEditVO								=	new AddEditVO();
	    public var noteAttachObj:NoteAttachmentVO					=	new NoteAttachmentVO();
	    public var detailEditObj:DetailEditVO						=	new DetailEditVO();
	    public var treeObj:TreeVO									=	new TreeVO();
	    public var listObj:ListVO		   							=	new ListVO();
	    public var documentObj:DocumentVO							=	new DocumentVO();
	    public var sortOrderSelectionObj:SortOrderSelectionVO		=	new SortOrderSelectionVO();
	    public var viewObj:ViewVO									=	new ViewVO();
	    public var trans_date:String;
	    public var importObj:ImportVO								=	new ImportVO();
		public var account_id:String; 
		
		public var print_subtype_cd:String							=	'porder'
		//public var iCriteria:ICriteria								=	new PurchaseOrderCriteria();	
	}
}
