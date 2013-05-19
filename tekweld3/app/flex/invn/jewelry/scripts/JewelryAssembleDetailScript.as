import model.GenModelLocator;
import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function AssambleIdChangeHandler():void
{
	if(dcAssemble_item_id.text != '' && dcAssemble_item_id.text != null)
	{
		var name:String = dcAssemble_item_id.labelValue.toString()
		var code:String = dcAssemble_item_id.labelValue.toString()

		tiCatalog_item_name.text = name
		tiCatalog_item_code.text = code
	} 
	else
	{
		tiCatalog_item_name.text = ''
		tiCatalog_item_code.text = '' 
	}
}
