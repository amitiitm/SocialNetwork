package stup.applicationsetting
{
	import com.generic.customcomponents.GenDataGrid;
	
	import valueObjects.AddEditVO;
	import valueObjects.DetailEditVO;
	import valueObjects.DocumentVO;

	[Bindable]
	public class ApplicationSettingModelLocator
	{
	    public var documentObj:DocumentVO = new DocumentVO();
	    public var addEditObj:AddEditVO = new AddEditVO();
	    public var detailEditObj:DetailEditVO	=	new DetailEditVO();
	    public var tempGrid:GenDataGrid;
	}

}
