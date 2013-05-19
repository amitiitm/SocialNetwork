package business
{
	import business.commands.*;
	import business.events.*;
	
	import com.adobe.cairngorm.control.FrontController;

	public class ApplicationController extends FrontController
	{
		public function ApplicationController()
		{
			super();

			addCommand(UserLoginEvent.EVENT_ID, UserLoginCommand);							
			addCommand(LoginPwdChangeEvent.EVENT_ID, LoginPwdChangeCommand);
			addCommand(ForgotPasswordEvent.EVENT_ID, ForgotPasswordCommand)				
			addCommand(CreateUserEvent.EVENT_ID, CreateUserCommand);						
			addCommand(CreateCompanyEvent.EVENT_ID, CreateCompanyCommand);					
			addCommand(InitializeApplicationEvent.EVENT_ID, InitializeApplicationCommand);	
			addCommand(InitializeLookupEvent.EVENT_ID, InitializeLookupCommand);			
		    addCommand(GetLookupDataEvent.EVENT_ID, GetLookupDataCommand);					
			addCommand(GetMenuEvent.EVENT_ID, GetMenuCommand);								
			addCommand(LogoutEvent.EVENT_ID, LogoutCommand);								
		    addCommand(SaveViewEvent.EVENT_ID, SaveViewCommand);	
		    addCommand(SaveLayoutEvent.EVENT_ID, SaveLayoutCommand);
			addCommand(UpdateUserLastModuleEvent.EVENT_ID, UpdateUserLastModuleCommand);		
			addCommand(GetInformationEvent.EVENT_ID, GetInformationCommand);
			addCommand(GetGenDataGridFormatEvent.EVENT_ID, GetGenDataGridFormatCommand);
		}
	}
}
