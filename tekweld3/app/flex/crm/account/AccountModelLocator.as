package crm.account
{
	import valueObjects.AddEditVO;
	import valueObjects.DetailEditVO;
	import valueObjects.DocumentVO;
	import valueObjects.ListVO;
	import valueObjects.NoteAttachmentVO;
	import valueObjects.SortOrderSelectionVO;
	import valueObjects.TreeVO;
	import valueObjects.ViewVO;

	[Bindable]
	public class AccountModelLocator
	{
	    public var addEditObj:AddEditVO							=	new AddEditVO();
	    public var noteAttachObj:NoteAttachmentVO				=	new NoteAttachmentVO();
	    public var treeObj:TreeVO								=	new TreeVO();
	    public var detailEditObj:DetailEditVO					=	new DetailEditVO();
	    public var listObj:ListVO		   						=	new ListVO();
	    public var documentObj:DocumentVO						=	new DocumentVO();
	    public var sortOrderSelectionObj:SortOrderSelectionVO	=	new SortOrderSelectionVO();
	    public var viewObj:ViewVO								=	new ViewVO();
	    public var address_for:String							=	'A';
	    public var account_id:String ; 
	}
}
