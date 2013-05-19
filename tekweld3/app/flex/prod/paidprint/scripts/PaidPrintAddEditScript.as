import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.URL;
import com.generic.customcomponents.GenButton;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Spacer;

import prod.paidprint.PaidPrintModelLocator;
import prod.paidprint.components.PaidPrint;



[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:PaidPrintModelLocator =  PaidPrintModelLocator(__genModel.activeModelLocator);
public  var fileRefDown:FileReference = new FileReference();

[Embed("com/generic/assets/btn_view_film.png")]
private const viewFilmButtonIcon:Class;
[Embed("com/generic/assets/btn_download_film.png")]
private const downloadFilmButtonIcon:Class;


private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var oldValue:String = event.oldValues["print_flag"].toString();
	
	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["accept_yn"] = 'Y';
		if(event.object.id == 'accept_yn')
		{
			if(event.newValues["accept_yn"] == 'Y')
			{
				inbox.focusedRow["print_flag"] = 'Y';
				inbox.focusedRow["reject_yn"] = "";
				setAccept();
				
			}
			else
			{
				inbox.focusedRow["print_flag"] = 'N';
				inbox.focusedRow["reject_yn"] = "Y";
				inbox.focusedRow["accept_yn"] = "N";
				setReject();
				
			} 
		}
		else if(event.object.id == 'reject_yn')
		{
			if(event.newValues["reject_yn"] == 'Y')
			{
				inbox.focusedRow["print_flag"] = 'N';
				inbox.focusedRow["accept_yn"] = "";
				setReject();
			}
			else
			{
				inbox.focusedRow["print_flag"] = 'Y';
				inbox.focusedRow["accept_yn"] = "Y";
				inbox.focusedRow["reject_yn"] = "N";
				setAccept();
			} 
		}
		else if(event.object.id == 'select_yn')
		{
			inbox.focusedRow["reject_yn"] = "";
		}
		
	}
	else
	{
		inbox.focusedRow["accept_yn"] = "";
		inbox.focusedRow["reject_yn"] = "";
		inbox.focusedRow["print_flag"] = oldValue;
	}  	
}
private function setRecord(indigo_code:String,value:String):void
{
	for(var i:int=0; i<inbox.dgDtl.rows.children().length(); i++)
	{
		if(inbox.dgDtl.rows.children()[i]["indigo_code"].toString() == indigo_code)
		{
			inbox.dgDtl.rows.children()[i].select_yn  = value;
			inbox.dgDtl.rows.children()[i].accept_yn  = value;
		}	
	}
}
private function setAccept():void
{
	for(var i:int=0; i<inbox.dgDtl.rows.children().length(); i++)
	{
		if(inbox.dgDtl.rows.children()[i]["select_yn"].toString() == 'Y')
		{
			inbox.dgDtl.rows.children()[i].accept_yn  = "Y";
			inbox.dgDtl.rows.children()[i].reject_yn  = "N";
		}	
	}
}
private function setReject():void
{
	for(var i:int=0; i<inbox.dgDtl.rows.children().length(); i++)
	{
		if(inbox.dgDtl.rows.children()[i]["select_yn"].toString() == 'Y')
		{
			inbox.dgDtl.rows.children()[i].reject_yn  = "Y";
			inbox.dgDtl.rows.children()[i].accept_yn  = "N";
		}	
	}
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["reason"] == '' && inbox.dgDtl.dataProvider[i].reject_yn.toString() == "Y")
			{
				retValue = -1;
				Alert.show("Enter Job rejection reason.");
				break
			}						
		}	
	}
	
	return retValue;
}
private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	hb.setStyle('horizontalGap' , 10);
	
	var sp:Spacer  = new Spacer();
	sp.width     =   2;
	
	var btnView:Button        				= new Button();
	btnView.height							= 20;
	btnView.label							= "VIEW FILM FILE";
	//btnView.setStyle('icon' , viewFilmButtonIcon);
	btnView.styleName						= "promoButton";
	btnView.addEventListener(MouseEvent.CLICK,viewClickHandler);
	
	var btnDownload:Button        			= new Button();
	btnDownload.height						= 20;
	btnDownload.label						= "DOWNLOAD FILM FILE";
	//btnDownload.setStyle('icon' , downloadFilmButtonIcon);
	btnDownload.styleName					= "promoButton";
	btnDownload.addEventListener(MouseEvent.CLICK,downloadFileClickHandler);
	
	hb.addChild(btnView);
	//hb.addChild(btnDownload);
	
	
	PaidPrint(this.parentDocument).bcp.addChildAt(hb,7);
}
private function getFileName():String
{
	var returnValue:String  = '';
	if(inbox.selectedRows.children().length()>0)
	{
		returnValue		= inbox.selectedRows.children()[0].artwork_file_name.toString();
		return returnValue;
	}
	else
	{
		return returnValue;
	}
}
private function viewClickHandler(event:MouseEvent):void
{
	if(getFileName()=='')
	{
		Alert.show("Please Select Job");
	}
	else
	{
		var url:String  =	__genModel.path.attachment+getFileName();
		var _requestViewUrl:URLRequest = new URLRequest(url);
		navigateToURL(_requestViewUrl); 
	}
}
private function downloadFileClickHandler(event:MouseEvent):void
{
	if(getFileName()=='')
	{
		Alert.show("Please Select Job");
	}
	else
	{
		var urlObj:URL	=	new URL();
		var url:String  =	__genModel.path.attachment+getFileName();
		var _request:URLRequest = new URLRequest(url);             
		_request.method = URLRequestMethod.GET;
		fileRefDown.addEventListener(Event.OPEN,openHandler);
		fileRefDown.addEventListener(Event.COMPLETE,downloadCompletehandler);
		try
		{
			fileRefDown.download(_request);
		}
		catch (error:Error)
		{
			Alert.show("Unable to download file.");
		}
	}
}
private function openHandler(event:Event):void
{
	//Alert.show("downlaod start");
}

private function downloadCompletehandler(event:Event):void
{
	Alert.show("Download Complete");
}