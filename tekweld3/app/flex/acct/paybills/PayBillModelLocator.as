package acct.paybills
{
	import valueObjects.AddEditVO;
	import valueObjects.DocumentVO;

	[Bindable]
	public class PayBillModelLocator
	{
	    public var documentObj:DocumentVO = new DocumentVO();
	    public var addEditObj:AddEditVO = new AddEditVO();
	    
	    public var print_subtype_cd:String					   		=	'avwritecheck'
	}
}
