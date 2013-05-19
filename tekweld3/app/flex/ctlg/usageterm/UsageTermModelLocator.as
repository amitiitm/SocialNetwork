package ctlg.usageterm
{
	import valueObjects.AddEditVO;
	import valueObjects.DocumentVO;

	[Bindable]
	public class UsageTermModelLocator
	{
	    public var documentObj:DocumentVO = new DocumentVO();
	    public var addEditObj:AddEditVO = new AddEditVO();
	}
}
