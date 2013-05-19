package acct.vendcreditinvoiceapply
{
	import valueObjects.AddEditVO;
	import valueObjects.NoteAttachmentVO;
	import valueObjects.DetailEditVO;
	import valueObjects.DocumentVO;
	import valueObjects.ListVO;
	import valueObjects.SortOrderSelectionVO;
	import valueObjects.TreeVO;
	import valueObjects.ViewVO;

	[Bindable]
	public class VendorCreditInvoiceApplyModelLocator
	{
	    public var addEditObj:AddEditVO							=	new AddEditVO();
	    public var noteAttachObj:NoteAttachmentVO				=	new NoteAttachmentVO();
	    public var treeObj:TreeVO								=	new TreeVO();
	    public var detailEditObj:DetailEditVO					=	new DetailEditVO();
	    public var listObj:ListVO		   						=	new ListVO();
	    public var documentObj:DocumentVO						=	new DocumentVO();
	    public var sortOrderSelectionObj:SortOrderSelectionVO	=	new SortOrderSelectionVO();
	    public var viewObj:ViewVO								=	new ViewVO();
	    
	    public var print_subtype_cd:String					   	=	'avcreditinvoice'
	}
}
