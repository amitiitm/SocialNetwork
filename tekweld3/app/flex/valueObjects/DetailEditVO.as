package valueObjects
{
	import com.generic.components.DetailAddEdit;
	import com.generic.customcomponents.GenDataGrid;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;

	[Bindable]
	public class DetailEditVO
	{
		public var detailEditContainer:Container;
		public var genObjects:ArrayCollection;
		public var validators:Array;
		
		public var selectedRow:XML	=	null;
		//public var rows:XML;  not needed yet
		public var deletedRows:XML;
		public var genDataGrid:GenDataGrid;
		public var title:String;
		public var editStatus:Boolean = false;
		public var rowStatus:String;
		public var isActive:Boolean	=	false;
		
		public var isCopy:Boolean;
		public var copiedRow:XML	=	null;
		
		//for fetch record
		public var id:String	=	"";
		public var fetchDetailFormatServiceID:String = "";
		public var fetchMapingArrCol:ArrayCollection	=	null;
		public var fetchGetSelectedDetailServiceID:String = "";
		public var fetchDetailDataServiceID:String = "";
		
		//for fetch Record With Detail, we call a service to get bom detail when user click on fetched data.
		public var transactionDetailServiceID:String = "";
		public var rows:XML	=null;// we will put each selected row with bom(transactionDetail) in it.
		
		
		public var isFetchFromCriteria:Boolean			=	false;//if fetch records on the basis of criteria.
		public var fetchCriteriaXML:XML;					
		
		public var isFetchSingleSelected:Boolean		=	false;
		public var isFetchMultipalSelected:Boolean		=	true;
		public var isDetailRequired:Boolean				=	false;
		public var isOverrideDetail:Boolean				=	false;
	
		//for import 
		public var uploadServiceID:String				=	"";
		public var downloadedRootNode:String			=	"";
		public var saveImportedXML:XML					=	null;
		public var tableName:String;
		public var tablenames:Array	=	null;
		public var isCallServiceOnSave:Boolean	=	true;
		
		/*called from DetailEditCloseCommand only*/	
		public var isDobleClickOnGrid:Boolean	 		= false;     // tekweld specific(sarvesh)
		public function setNull():void
		{
			removeEventListners()
			
			detailEditContainer						=	null
			genObjects								=	null
			validators								=	null
			
			selectedRow								=	null
			//public var rows:XML;  not needed yet
			deletedRows								=	null
			genDataGrid								=	null
			title									=	null
			//editStatus								=	null
			rowStatus								=	null
		//	isActive								=	null
			
			isCopy									=	null;
			
			//for fetch record
			id										=	null
			fetchDetailFormatServiceID				=	null
			fetchMapingArrCol						=	null
			fetchGetSelectedDetailServiceID			=	null
			fetchDetailDataServiceID				=	null
			
			rows									=	null;
		//	isFetchSingleSelected					=	null		
		//	isFetchMultipalSelected					=	null
		//	isDetailRequired						=	null
		//	isOverrideDetail						=	null
			
			/*imported functionality*/
			uploadServiceID							=	null;
			downloadedRootNode						=	null;
			saveImportedXML							=	null;
			tablenames								=	null;
			isCallServiceOnSave						=	null;
		}
		private function removeEventListners():void
		{
			DetailAddEdit(detailEditContainer).removeEventListnerFromComponent()
			
		}
	}
}



