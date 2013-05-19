package rept.saoi.memoregister
{
	import valueObjects.DocumentVO;
	import valueObjects.LayoutVO;
	import valueObjects.ReportVO;
	import valueObjects.ViewVO;

	[Bindable]
	public class MemoRegisterModelLocator
	{
	    public var reportObj:ReportVO 		=	new ReportVO();
	    public var documentObj:DocumentVO	=	new DocumentVO();
	    public var viewObj:ViewVO			=	new ViewVO();
	    public var layoutObj:LayoutVO		=	new LayoutVO();
	}
}
