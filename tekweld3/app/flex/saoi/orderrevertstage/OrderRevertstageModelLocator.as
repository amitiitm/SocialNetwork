package saoi.orderrevertstage
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
	public class OrderRevertstageModelLocator
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
	    public var trans_no:String;
	    public var artwork_dept_email:String;
		public var ext_ref_no:String;
		
		/*called from GenTabBar */
		public function setNull():void
		{
		  if(this.hasOwnProperty('addEditObj'))
		  {
		  	addEditObj.setNull();
		  	addEditObj		=	null;
		  }
		  if(this.hasOwnProperty('noteAttachObj'))
		  {
		  	noteAttachObj	=	null;
		  }
		  if(this.hasOwnProperty('detailEditObj'))
		  {
		  	detailEditObj	=	null;
		  }
		  if(this.hasOwnProperty('treeObj'))
		  {
		  	 treeObj			=	null;
		  }
		  if(this.hasOwnProperty('listObj'))
		  {
		  	listObj			=	null;
		  }
		  if(this.hasOwnProperty('documentObj'))
		  {
		  	documentObj		=	null;
		  }
		  if(this.hasOwnProperty('sortOrderSelectionObj'))
		  {
		  	 sortOrderSelectionObj	=	null;
		  }
		  if(this.hasOwnProperty('ViewVO'))
		  {
		  	  viewObj			=	null;
		  }
		 
		 }
	}
	
}
