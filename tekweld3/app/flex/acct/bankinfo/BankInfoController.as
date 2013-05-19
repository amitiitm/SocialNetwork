package acct.bankinfo
{
	import business.CommonController;
	import business.commands.PopulateListCommand;
	import business.events.PopulateListEvent;

	public class BankInfoController extends CommonController
	{
		public function BankInfoController()
		{
			super();
			addCommand(PopulateListEvent.EVENT_ID, PopulateListCommand);
		}
	}
}