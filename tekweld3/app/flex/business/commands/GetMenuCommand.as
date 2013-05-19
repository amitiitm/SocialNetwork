package business.commands
{
	import business.events.GetMenuEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	import valueObjects.ApplicationVO;
	
	public class GetMenuCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __applicationObject:ApplicationVO;
		
		public function execute(event:CairngormEvent):void
		{
			__applicationObject = __genModel.applicationObject;

			var module_id:int =	(event as GetMenuEvent).module_id;
			var selectedModule:String = 'moodule_id == "' + module_id.toString() + '"' 		
			var menuItems:XMLList = __applicationObject.menu.rolepermission.(moodule_id == module_id.toString())

			__applicationObject.filteredMenu = changeMenuXMLFormat(menuItems)
			
		}
		
		public function changeMenuXMLFormat(aMenuItems:XMLList):XML
		{
			var xmlChild:XML
			var xml:XML = new XML(<row></row>)
			var xmlInner:XML
			
			for(var i:int = 0; i < aMenuItems.length(); i++)
			{
				if(aMenuItems.elements('menu_id')[i].toString() == null || aMenuItems.elements('menu_id')[i].toString() == '')
				{
					xmlChild = new XML(<row> </row>)
				
					xmlChild.@['name'] = aMenuItems.elements('name')[i].toString()
					xmlChild.@['menu_id'] = aMenuItems.elements('menu_id')[i].toString()
		
					for(var j:int = 0; j < aMenuItems.length(); j++)
					{
						if((aMenuItems.elements('id')[i].toString() == aMenuItems.elements('menu_id')[j].toString()) && aMenuItems.elements('visible_flag')[j].toString()=='Y' )
						{
							xmlInner = new XML(<row />)
		
							xmlInner.@['name'] = aMenuItems.elements('name')[j].toString()
							xmlInner.@['page_heading'] = aMenuItems.elements('page_heading')[j].toString()
							xmlInner.@['code'] = aMenuItems.elements('code')[j].toString()
							xmlInner.@['document_id'] = aMenuItems.elements('document_id')[j].toString()
							xmlInner.@['component_cd'] = aMenuItems.elements('component_cd')[j].toString()
							xmlInner.@['id'] = aMenuItems.elements('id')[j].toString()
							xmlInner.@['create_permission'] = aMenuItems.elements('create_permission')[j].toString()
							xmlInner.@['modify_permission'] = aMenuItems.elements('modify_permission')[j].toString()
							xmlInner.@['view_permission'] = aMenuItems.elements('view_permission')[j].toString()
							xmlInner.@['menu_id'] = aMenuItems.elements('menu_id')[j].toString()
		
							xmlChild.appendChild(xmlInner)
						}
					}
					xml.appendChild(xmlChild)
				}
			}
			return xml
		}
	}
}
