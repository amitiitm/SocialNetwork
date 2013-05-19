package valueObjects
{
	import valueObjects.ModeVO;
	
	[Bindable]
	public class DocumentVO
	{
		public var documentID:int;
		public var create_permission:String;
		public var modify_permission:String;
		public var view_permission:String;
		public var upload_permission:String;
		public var selectedMode:int		=	ModeVO.EDIT_MODE;
		
		public var printFormatXML:XML;
	}
}