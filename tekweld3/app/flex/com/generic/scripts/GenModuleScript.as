import com.generic.events.GenModuleEvent;
import mx.controls.Alert;

private function onPreinitialize():void
{
	this.addEventListener(GenModuleEvent.ACTIVE_EVENT, handleActiveEvent);
} 

public function handleActiveEvent(event:GenModuleEvent):void
{
}
