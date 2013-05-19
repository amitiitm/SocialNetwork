package cust.customerinfo
{
	import business.CommonController;
	import business.commands.PopulateListCommand;
	import business.events.PopulateListEvent;

	public class CustomerInfoController extends CommonController
	{
		public function CustomerInfoController()
		{
			super();
			addCommand(PopulateListEvent.EVENT_ID, PopulateListCommand);
		}
	}
}