package saoi.muduleclasses
{
	import com.generic.components.DataEntry;
	
	import mx.core.FlexGlobals;
	
	public class GenNotesAttachmentIcon
	{
		private var _activeModelLocator:Object;
		private var _screencomponent:DataEntry;
		
		[Embed("com/generic/assets/notes_dot.png")]
		private const notesButtonIcon:Class;
		
		[Embed("com/generic/assets/note.PNG")]
		private const noNotesButtonIcon:Class;
		
		[Embed("com/generic/assets/attachment_blue.png")]
		private const attachmentButtonIcon:Class;
		
		[Embed("com/generic/assets/attachment.png")]
		private const noAttachmentButtonIcon:Class;
		
		public function set activeModelLocator(activeModelLocator:Object):void
		{
			_activeModelLocator = activeModelLocator;
		}
		public function get activeModelLocator():Object
		{
			return _activeModelLocator;
		}
		public function set screenComponent(screenComponent:DataEntry):void
		{
			_screencomponent = screenComponent;
		}
		public function get screenComponent():DataEntry
		{
			return _screencomponent;
		}
		
		public static function enableApplication():void
		{
			FlexGlobals.topLevelApplication.enabled = true;
		}
		public static function disableApplication():void
		{
			FlexGlobals.topLevelApplication.enabled = false;
		}
		
		public  function changeIcon(activeModelLocator:Object,screenComponent:DataEntry):void
		{
			if(activeModelLocator.addEditObj.record != null)
			{
				var resultXml:XML           = activeModelLocator.addEditObj.record.copy();
				var noteCount:String  		=  resultXml.sales_order.notes.note.count.toString();
				var attachmentCount:String  =  resultXml.sales_order.attachments.attachment.count.toString();
				
				if(Number(noteCount)>0)
				{
					screenComponent.bcpDataEntry.btnNote.setStyle("icon", notesButtonIcon);
					screenComponent.bcpList.btnNote.setStyle("icon", notesButtonIcon);
				}
				else
				{
					screenComponent.bcpDataEntry.btnNote.setStyle("icon", noNotesButtonIcon);
					screenComponent.bcpList.btnNote.setStyle("icon", noNotesButtonIcon);
				}
				if(Number(attachmentCount)>0)
				{
					screenComponent.bcpDataEntry.btnAttachment.setStyle("icon", attachmentButtonIcon);
					screenComponent.bcpList.btnAttachment.setStyle("icon", attachmentButtonIcon);
				}
				else
				{
					screenComponent.bcpDataEntry.btnAttachment.setStyle("icon", noAttachmentButtonIcon);
					screenComponent.bcpList.btnAttachment.setStyle("icon", noAttachmentButtonIcon);
				}
			}
			else
			{
				screenComponent.bcpDataEntry.btnNote.setStyle("icon", noNotesButtonIcon);
				screenComponent.bcpList.btnNote.setStyle("icon", noNotesButtonIcon);
				screenComponent.bcpDataEntry.btnAttachment.setStyle("icon", noAttachmentButtonIcon);
				screenComponent.bcpList.btnAttachment.setStyle("icon", noAttachmentButtonIcon);
			}
			
		}
		

	}
}