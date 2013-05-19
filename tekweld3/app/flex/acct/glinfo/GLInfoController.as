package acct.glinfo
{
	import business.CommonController;
	import business.commands.PopulateListCommand;
	import business.events.PopulateListEvent;

	public class GLInfoController extends CommonController
	{
		public function GLInfoController()
		{
			super();
			addCommand(PopulateListEvent.EVENT_ID, PopulateListCommand);
		}
	}
}