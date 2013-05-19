import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.INavigatorContent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();


protected override function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	tiCartonSize.dataValue  = tiCartonLength.dataValue + 'x'+ tiCartonWidth.dataValue + 'x'+ tiCartonHeight.dataValue;
	return 0;
}