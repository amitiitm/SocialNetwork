package com.generic.genclass
{
	import model.GenModelLocator;

	public class URL
	{
		
		public function URL()
		{
		}
		public function getURL(url:String):String
		{
			
			if(GenModelLocator.main_url == "")
			{
				//dealing with web 
				
			}
			else
			{
				//dealing with desktop
				if(url.search(GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString()) == -1)
				{
					url = GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() + url;
				}
			}
			
			
			return url;
		}
	}
}