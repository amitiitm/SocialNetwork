import com.generic.events.GenModuleEvent;

import dashboard.DashboardModelLocator;
import dashboard.DashboardServices;

import model.GenModelLocator;

import mx.events.ListEvent;

private var __genModel:GenModelLocator  = GenModelLocator.getInstance();

protected function module1_creationCompleteHandler(event:GenModuleEvent):void
{
	__genModel.activeModelLocator   = new DashboardModelLocator();
}


