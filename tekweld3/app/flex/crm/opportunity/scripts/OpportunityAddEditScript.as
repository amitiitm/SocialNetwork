import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function init():void
{
	dfClose_date.dataValue = ""
}

override protected function resetObjectEventHandler():void
{
	dfClose_date.dataValue = ""
}