import com.generic.events.*;
import mx.rpc.events.ResultEvent;

public function btnAddClickHandler():void
{
	dispatchEvent(new ButtonControlEvent('addRowEvent'));
}			

public function btnSaveClickHandler():void
{
	dispatchEvent(new ButtonControlEvent('saveRowEvent'));
}

public function btnFirstClickHandler():void
{
	dispatchEvent(new ButtonControlEvent('firstRowEvent'));
}			

public function btnPreviousClickHandler():void
{
	dispatchEvent(new ButtonControlEvent('previousRowEvent'));
}			

public function btnNextClickHandler():void
{
	dispatchEvent(new ButtonControlEvent('nextRowEvent')); 
}			

public function btnLastClickHandler():void
{
	dispatchEvent(new ButtonControlEvent('lastRowEvent'));
}			
//End
