package acct.glinfo
{
	import valueObjects.DocumentVO;
	import valueObjects.LayoutVO;
	import valueObjects.ListVO;
	import valueObjects.ReportVO;
	import valueObjects.ViewVO;
	
	[Bindable]
	public class GLInfoModelLocator
	{
	   	public var reportObj:ReportVO 		=	new ReportVO();
	    public var documentObj:DocumentVO	=	new DocumentVO();
	    public var viewObj:ViewVO			=	new ViewVO();
	    public var layoutObj:LayoutVO		=	new LayoutVO();
	    public var listObj:ListVO		   	=	new ListVO();
	}
}
