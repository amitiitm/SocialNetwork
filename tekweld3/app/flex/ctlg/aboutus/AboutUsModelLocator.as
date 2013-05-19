package ctlg.aboutus
{
	import valueObjects.AddEditVO;
	import valueObjects.DocumentVO;

	[Bindable]
	public class AboutUsModelLocator
	{
	    public var documentObj:DocumentVO = new DocumentVO();
	    public var addEditObj:AddEditVO = new AddEditVO();
	}
}
