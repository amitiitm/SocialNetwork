package melt.calculateoffer.business.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class CalculateOfferEvent extends CairngormEvent
	{
		static public var EVENT_ID:String = "calculateOfferEvent";
		
		public function CalculateOfferEvent()
		{
			super(EVENT_ID);
		}
		
	}
}