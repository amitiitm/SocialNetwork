package valueObjects
{
	import com.generic.components.AddEdit;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	[Bindable]
	public class AddEditVO
	{
		public var addEditContainer:Container;
		public var genObjects:ArrayCollection;
		public var validators:Array;
		
		public var record:XML	=	null;
		public var isRecordViewOnly:Boolean = false;
		
		public var tableName:String;
		public var editStatus:Boolean = false;
		public var recordStatus:String;
		public var isCopy:Boolean;
		public var copiedRecord:XML	=	null;
	
		/*called from activeModelLocator(like SalesOrderModelLocator) setNull() */	
		public function setNull():void
		{
			removeEventListners()
			
			addEditContainer	=	null
			genObjects			=	null		
			validators			=	null
			
			record				=	null
		//	isRecordViewOnly	=	null
			
			tableName			=	null
		//	editStatus			=	null
			recordStatus		=	null
			isCopy				=	null;
			
		}
		private function removeEventListners():void
		{
			AddEdit(addEditContainer).removeEventListnerFromComponent()
			
		}
		
	}
}