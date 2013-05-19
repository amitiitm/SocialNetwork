package valueObjects
{
	import mx.controls.Alert;
	
	[Bindable]
	public class ApplicationVO
	{
		private var _selectedModule:XML;
		private var _module:XML;
		private var _menu:XML;
		private var _selectedMenuItem:XML;
		private var _filteredMenu:XML;

		public function set selectedModule(aXML:XML):void
		{
			_selectedModule	= aXML;
		}
	
		public function get selectedModule():XML
		{
			return _selectedModule;
		}

		public function set module(aXML:XML):void
		{
			_module	= aXML;
		}
	
		public function get module():XML
		{
			return _module;
		}
	
		public function set menu(aXML:XML):void
		{
			_menu = aXML
		}
		
		public function get menu():XML
		{
			return _menu;
		}

		public function set filteredMenu(aXML:XML):void
		{
			_filteredMenu = aXML
		}
		
		public function get filteredMenu():XML
		{
			return _filteredMenu;
		}
		
		public function set selectedMenuItem(aXML:XML):void
		{
			_selectedMenuItem = aXML
		}
		
		public function get selectedMenuItem():XML
		{
			return _selectedMenuItem;
		}
	}
}
