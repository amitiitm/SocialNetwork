import com.generic.events.GenComponentEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

protected function handlePreinitialize(event:FlexEvent):void 
{
	this.addEventListener(GenComponentEvent.VALUE_UPDATE_EVENT, handleValueUpdateEvent)
	this.addEventListener(GenComponentEvent.RESET_EVENT, handleResetEvent)
	this.addEventListener(GenComponentEvent.RETRIEVE_END_EVENT, handleRetrieveEndEvent)
	this.addEventListener(GenComponentEvent.MAKE_DISABLE_EVENT, handleMakeDisableEvent)
}

// Reset Object
private function handleResetEvent(event:GenComponentEvent):void
{
	resetHandler(event);
}

protected function resetHandler(event:GenComponentEvent):void
{
	// Override in Decendents.
}

// Retrieve
private function handleRetrieveEndEvent(event:GenComponentEvent):void
{
	retrieveEndHandler(event);
}

protected function retrieveEndHandler(event:GenComponentEvent):void
{
	// Override in Decendents.
}

// Value Update
private function handleValueUpdateEvent(event:GenComponentEvent):void
{
	valueUpdateHandler(event);
	this.dispatchEvent(new GenComponentEvent(GenComponentEvent.VALUE_UPDATE_COMPLETE_EVENT, event.value))
}

protected function valueUpdateHandler(event:GenComponentEvent):void
{
	// Override in Decendents.
}
// Retrieve
private function handleMakeDisableEvent(event:GenComponentEvent):void
{
	makeDisableEventHandler(event);
}

protected function makeDisableEventHandler(event:GenComponentEvent):void
{
	// Override in Decendents.
}