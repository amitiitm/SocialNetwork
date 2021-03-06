package cust.customer
{
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
	public class CustomerMasterModelLocator
	{
	    public var addEditObj:AddEditVO							=	new AddEditVO();
	    public var noteAttachObj:NoteAttachmentVO				=	new NoteAttachmentVO();
	    public var detailEditObj:DetailEditVO					=	new DetailEditVO();
	    public var treeObj:TreeVO								=	new TreeVO();
	    public var listObj:ListVO		   						=	new ListVO();
	    public var documentObj:DocumentVO						=	new DocumentVO();
	    public var sortOrderSelectionObj:SortOrderSelectionVO	=	new SortOrderSelectionVO();
	    public var viewObj:ViewVO								=	new ViewVO();
	    public var importObj:ImportVO							=	new ImportVO();
		public var customer_id:String ;
		public var customer_code:String ;
		public var billing_address:XML							= 	new XML(<address>
																				<address1></address1>
																				<address2></address2>
																				<city></city>
																				<zip></zip>
																				<state></state>
																				<country></country>
																				<phone1></phone1>
																				<phone2></phone2>
																				<fax></fax>
																			</address>); 
	}
}
