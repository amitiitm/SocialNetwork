package ctlg.storelocation
{
	import valueObjects.AddEditVO;
	import valueObjects.DetailEditVO;
	import valueObjects.DocumentVO;

	[Bindable]
	public class StoreLocationModelLocator
	{
	    public var documentObj:DocumentVO		=   new DocumentVO();
	    public var addEditObj:AddEditVO 		=   new AddEditVO();
	    public var detailEditObj:DetailEditVO	=	new DetailEditVO();
	}
}
