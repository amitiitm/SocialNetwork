import business.events.InitializeDataEntryWithNoListEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

protected var initializeEvent:InitializeDataEntryWithNoListEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

protected function handleModuleActive(event:GenModuleEvent):void {}


private function genModuleShortcutKeyHandler(event:GenModuleEvent):void
{
	bcp.shortcutKeyHandler(event);		
}