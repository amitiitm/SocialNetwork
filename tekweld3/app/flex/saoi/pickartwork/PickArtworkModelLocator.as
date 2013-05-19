package saoi.pickartwork
{
	import valueObjects.AddEditVO;
	import valueObjects.DocumentVO;
	import valueObjects.ListVO;
	import valueObjects.SortOrderSelectionVO;
	import valueObjects.TreeVO;
	import valueObjects.ViewVO;
	import valueObjects.NoteAttachmentVO;

	[Bindable]
	public class PickArtworkModelLocator
	{
		public var addEditObj:AddEditVO							=	new AddEditVO();
	    public var treeObj:TreeVO								=	new TreeVO();
	    public var listObj:ListVO		   						=	new ListVO();
	    public var documentObj:DocumentVO						=	new DocumentVO();
	    public var sortOrderSelectionObj:SortOrderSelectionVO	=	new SortOrderSelectionVO();
	    public var viewObj:ViewVO								=	new ViewVO();
	    public var noteAttachObj:NoteAttachmentVO				=	new NoteAttachmentVO();
	    public var drillObjXml:XML								=  	new XML(<rows>
	    																	</rows>);
		public var isViewVisible:Boolean						=   false;
	}
}