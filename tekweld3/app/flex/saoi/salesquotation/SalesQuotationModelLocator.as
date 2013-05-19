package saoi.salesquotation
{
	import com.generic.components.Detail;
	
	import valueObjects.AddEditVO;
	import valueObjects.DetailEditVO;
	import valueObjects.DocumentVO;
	import valueObjects.ListVO;
	import valueObjects.NoteAttachmentVO;
	import valueObjects.SortOrderSelectionVO;
	import valueObjects.TreeVO;
	import valueObjects.ViewVO;

	[Bindable]
	public class SalesQuotationModelLocator
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
	    public var ext_ref_no:String;
		public var customer_id:String;
		public var customer_code:String;
		public var catalotg_item_id:String='';
		public var ext_ref_date:String;
		public var paper_proof_flag:Boolean 						= 	true;
		public var main_item_qty:String;
		public var main_item_qty_total
		public var next_day_flag:Boolean							= false;
		public var resultXmlFromItem:XML							= new XML();
		public var order_type:String	 							= 	'';
		public var billing_address:XML								= 	new XML(<address>
																										<bill_name></bill_name>
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
		public var default_customer_third_party_account_number:String				= '';
		public var default_customer_bill_transportation_to:String					= '';
		public var default_customer_shipping_code:String							= '';
		
		
		public var cbRushType:String;
		public var cbPaperProof:String;
		public var cbNextDayFlag:String;
		public var isShipInfoBaseChange:Boolean  				    = false;
		
		public var shippingObject:Object = new Object();
		public var defaultSetupChargeXml:XML						= new XML();
		public var thirdPartyShippingCharge:XML						= new XML();
		public var dtlShipping:Detail								= new Detail();
		
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
