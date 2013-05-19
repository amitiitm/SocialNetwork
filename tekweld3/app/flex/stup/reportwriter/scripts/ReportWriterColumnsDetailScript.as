import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance()
private function changeHandler():void
{
	
	if(cbDrillDownColumn.selected && cbFixedUrl.selected)
	{
		lblDoc_id.visible = true;
		dcDoc_id.visible = true;
	}
	else
	{
		dcDoc_id.visible  = false;
		lblDoc_id.visible = false;
	}
}