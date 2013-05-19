// ActionScript file
import com.generic.events.GenUploadButtonEvent;

import mx.controls.TextInput;
import mx.managers.PopUpManager;

[Bindable]
public var treeXML:XML;
[Bindable]
public var tiImageName:TextInput;
[Bindable]
public var tiImageLink:TextInput;


private function init():void
{
	this.x = (this.screen.width - this.width) / 3
	this.y =  (this.screen.height - this.height) / 3
}

public function set itemCatagories(aXML:XML):void
{
	//since we need blank row also in combobox at the time of edit
	treeXML	=	new XML(<element element_name="All" element_id="All">
  							<element element_id="" element_name="">
    							<element element_id="" element_name=""/>
   							</element>
						</element>)
						
	if(aXML	== XML(undefined) || aXML	== null)
	{
		//Alert.show('catagories are not available please edit again');
		return;
	}
	for(var i:int=0	;	i < aXML.children().length(); i++)
	{
		XML(aXML.children()[i]).prependChild(new XML(<element element_id="" element_name=""/>));
	}
						
	treeXML.appendChild(aXML.children());	
	
	cbGroup1.dataProvider	=	treeXML.children();

}
public function setRow():void
{
	if(cbGroup1.dataProvider != null && cbGroup1.dataProvider !=  XMLList(undefined) )
	{
		var arr:Array				=		String(tiImageLink.text).split(',' ,String(tiImageLink.text).length)
		
		if(arr.length > 0 )
		{
			for(var i:int=0 ; i < XMLList(cbGroup1.dataProvider).length() ;i++)
			{
				if(XMLList(cbGroup1.dataProvider[i]).@element_id.toString() == arr[0].toString())
				{
					cbGroup1.selectedIndex	=	i;
				}
			}
			
		}	
		
		
		if(arr.length > 1)
		{
			for(var i:int=0 ; i < XMLList(cbGroup2.dataProvider).length() ;i++)
			{
				if(XMLList(cbGroup2.dataProvider[i]).@element_id.toString() == arr[1].toString())
				{
					cbGroup2.selectedIndex	=	i;
				}
			}
		}
	}
	
	tiImage.text	=	tiImageName.text;
} 
public function get itemCatagories():XML
{
	return treeXML;
}
private function handleUploadFileNameSetEvent(event:GenUploadButtonEvent):void
{
	tiImage.text = event.fileName;
	btnUpdate.enabled = false;
}

private function handleCompleteEvent(event:GenUploadButtonEvent):void
{
	btnUpdate.enabled = true;
	tiImageName.text	=	tiImage.text;
}

private function btnCancelClickHandler():void
{
	PopUpManager.removePopUp(this);
}
private function btnUpdateClickHandler():void
{
	/* if(tiImage.text != '')
	{ */
		tiImageName.text	=	tiImage.text;
		
		if(cbGroup1.selectedItem.@element_id.toString() != '')
		{
			tiImageLink.text	= 	cbGroup1.selectedItem.@element_id.toString()
			if(cbGroup2.selectedItem.@element_id.toString() != '')
			{
				tiImageLink.text	=	tiImageLink.text + ',' +  cbGroup2.selectedItem.@element_id.toString()
			}
		}
		else
		{
			tiImageLink.text	=	'';
		}
		PopUpManager.removePopUp(this);
	/*}
	 else
	{
		Alert.show('please upload an image');
	} */
	
	
}
