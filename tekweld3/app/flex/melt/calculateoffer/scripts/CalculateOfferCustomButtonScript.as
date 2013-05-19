// ActionScript file
import business.events.PreSaveEvent;

import flash.events.MouseEvent;

import melt.calculateoffer.business.events.CalculateOfferEvent;

import model.GenModelLocator;

private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function handleCustomClick(event:MouseEvent):void
{
	var calculateOfferEvent:CalculateOfferEvent = new CalculateOfferEvent();
	calculateOfferEvent.dispatch();
}

public function btnSaveClickHandler():void
{
	var preSaveEvent:PreSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}	