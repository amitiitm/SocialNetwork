package com.generic.genclass
{
	public class SortLevel
	{
		public function SortLevel()
		{
		}
		public function getSortFields(aListFormat:XML):XML
		{
			var child:XML;
			var	sortField:XML = new XML(<root></root>)
	
			for(var i:int=0; i < aListFormat.children().length(); i++)
			{
				if(aListFormat.children()[i].@forLevel == 'true')
				{
					child = new XML(<child>
										<data>{aListFormat.children()[i].@data}</data>
										<label>{aListFormat.children()[i].@label}</label>
										<dataType>{aListFormat.children()[i].@sortDataType}</dataType>
									</child>)
					
					sortField.appendChild(child)
				}
			}
			return sortField;
		}

	}
}