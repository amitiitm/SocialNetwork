import com.generic.customcomponents.GenModule;
import com.generic.events.*;

import mx.controls.Alert;

private function onPreinitialize():void
{
	this.addEventListener(GenModuleLoaderEvent.ACTIVE_EVENT, handleActiveEvent);
	this.addEventListener(GenModuleLoaderEvent.SHORTCUTKEY_EVENT, handleShortCutCriteriaEvent);
} 
 
public function handleActiveEvent(event:GenModuleLoaderEvent):void
{
	var gm:GenModule = (GenModule)(this.getChildAt(0))
	gm.dispatchEvent(new GenModuleEvent("genModuleActive"))
}
public function handleShortCutCriteriaEvent(event:GenModuleLoaderEvent):void
{
	var gm:GenModule = (GenModule)(this.getChildAt(0))
	gm.dispatchEvent(new GenModuleEvent("genModuleShortcutKey",event.keyBoardEvent))
}