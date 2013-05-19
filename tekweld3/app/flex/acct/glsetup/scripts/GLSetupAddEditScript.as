import com.generic.events.AddEditEvent;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function handleCreationComplete():void
{
	__genModel.activeModelLocator.tempGrid = dtlLine.dgDtl;
}