// ActionScript file
import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;

import stup.applicationsetting.ApplicationSettingModelLocator;

[Bindable]
private var __localModel:ApplicationSettingModelLocator = (ApplicationSettingModelLocator)(GenModelLocator.getInstance().activeModelLocator);

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();


override protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	var value:String = tiValue.dataValue;
	var description:String	=	tiDescription.dataValue;
		
	 for(var i:int=0; i < __localModel.tempGrid.dataProvider.length; i++)
		{
			if(value == __localModel.tempGrid.dataProvider[i]["value"] && i != __genModel.activeModelLocator.tempGrid.selectedIndex)  
			{
				Alert.show("Value already exist !");
				return -1;
				break;
			}
			else if(description == __localModel.tempGrid.dataProvider[i]["description"] && i != __genModel.activeModelLocator.tempGrid.selectedIndex)
			{
				Alert.show("Description already exist !");
				return -1;
				break;
			
			}
		}
		
	return 0;
}