package ctlg.imageupload
{
	import valueObjects.AddEditVO;
	import valueObjects.DocumentVO;

	[Bindable]
	public class ImageUploadModelLocator
	{
	    public var documentObj:DocumentVO = new DocumentVO();
	    public var addEditObj:AddEditVO = new AddEditVO();
	}
}
