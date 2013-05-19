package rept.puoi.orderregister
{
	//import com.generic.genclass.ICriteria;
	
	import valueObjects.DocumentVO;
	import valueObjects.LayoutVO;
	import valueObjects.ReportVO;
	import valueObjects.ViewVO;

	[Bindable]
	public class OrderRegisterModelLocator
	{
	    public var reportObj:ReportVO 					=	new ReportVO();
	    public var documentObj:DocumentVO				=	new DocumentVO();
	    public var viewObj:ViewVO						=	new ViewVO();
	    public var layoutObj:LayoutVO					=	new LayoutVO();
	 	//public var iCriteria:ICriteria					=	new OrderRegisterCriteria();			
	}
}
