import business.events.RecordStatusEvent;
import com.generic.events.AddEditEvent;
import com.generic.events.GenTextInputEvent;
import com.generic.events.GenUploadButtonEvent;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function handleThumnailEvent(event:GenUploadButtonEvent):void
{
	tiLogo.text = event.fileName;
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY")
	recordStatusEvent.dispatch();
}

private function handlePaypal_enable_flag():void
{
	if(cbPaypal_enable_flag.selected)
	{
		tiPdt_identity_token.enabled = true
		tiMerchant_id.enabled = true
		tiPaypal_business_email.enabled = true
	}
	else
	{
		tiPdt_identity_token.enabled = false
		tiMerchant_id.enabled = false
		tiPaypal_business_email.enabled = false
	}
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void    
{
	handlePaypal_enable_flag()
}

private function handleMerchant_id(event:GenTextInputEvent):void
{
	tiPaypal_business_email.text = tiMerchant_id.text;
}
