package melt.calculateoffer
{
	import business.EditableListController;
	
	import melt.calculateoffer.business.command.CalculateOfferCommand;
	import melt.calculateoffer.business.events.CalculateOfferEvent;

	public class CalculateOfferController extends EditableListController
	{
		public function CalculateOfferController()
		{
			super();
			addCommand(CalculateOfferEvent.EVENT_ID,CalculateOfferCommand);
		}
	}
}
