package saoi.orderflow
{
	import valueObjects.AddEditVO;
	import valueObjects.DocumentVO;

	[Bindable]
	public class OrderFlowModelLocator
	{
	    public var documentObj:DocumentVO = new DocumentVO();
	    public var addEditObj:AddEditVO = new AddEditVO();
	}
}
