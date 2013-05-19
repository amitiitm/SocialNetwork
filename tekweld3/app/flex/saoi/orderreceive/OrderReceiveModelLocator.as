package saoi.orderreceive
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
	public class OrderReceiveModelLocator
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
	    public var itemXml:XMLList									= new XMLList();
    	public var customerShipping:XML								= new XML() ;
	    public var trans_no:String;
	    public var ext_ref_no:String;
	    public var artwork_dept_email:String;
	    public var artwork_view:Boolean = true;
	    public var paper_proof_flag:Boolean = true;
		private var _customer_id:String;
		private var _customer_code:String;
		public var selectedButtonLabel:String;
		public var objectToQuickAdd:XML								= new XML(<rows>
																							<row>{customer_id}</row>
																							<row>{customer_code}</row>
																					   </rows>);
		
		public function set customer_id(customer_id_param:String):void
		{
			_customer_id   					 = customer_id_param;
			objectToQuickAdd.children()[0]   = customer_id;
		}
		public function set customer_code(customer_code_param:String):void
		{
			_customer_code   				= customer_code_param;
			objectToQuickAdd.children()[1]  = customer_code;
		}
		public function get customer_id():String
		{
			return _customer_id
		}
		public function get customer_code():String
		{
			return _customer_code;
		}
		
		public var setupXml:XML = new XML();
		
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
