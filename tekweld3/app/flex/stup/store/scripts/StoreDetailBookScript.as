// ActionScript file
import com.generic.events.DetailAddEditEvent;

override protected function resetObjectEventHandler():void
{
	tiBook_cd.enabled = true;
	tiBook_name.enabled = true;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	tiBook_cd.enabled = false;
	tiBook_name.enabled = false;

}