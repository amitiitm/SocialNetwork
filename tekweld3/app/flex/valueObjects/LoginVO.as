package valueObjects
{
	[Bindable]
	public class LoginVO
	{
		private var _code:String;
		private var _login:String;
		private var _password:String;

		public function set code(_code:String):void
		{
			this._code	=	_code;
		}
		public function get code():String
		{
			return _code;
		}
		public function set login(_login:String):void
		{
			this._login	=	_login;
		}
		public function get login():String
		{
			return _login;
		}
		public function set password(_password:String):void
		{
			this._password	=	_password;
		}
		public function get password():String
		{
			return _password;
		}

	}
}