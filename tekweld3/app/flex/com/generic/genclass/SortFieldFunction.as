package com.generic.genclass
{
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	import mx.controls.DateField;
	import mx.utils.ObjectUtil;
		
	public class SortFieldFunction
	{
		public var lsFieldName:String;
		
		public function SortFieldFunction(asField:String=null)
		{
			lsFieldName = asField
		}

		public function numericSortField():SortField
		{
			var sfNumeric:SortField = new SortField()
			
			sfNumeric.name= lsFieldName
			sfNumeric.caseInsensitive = false
			sfNumeric.descending = false
			sfNumeric.numeric = true
			
			return sfNumeric;
		}

		public function stringSortField():SortField
		{
			var sfString:SortField = new SortField()
			
			sfString.name= lsFieldName
			sfString.caseInsensitive = true
			sfString.descending = false
			sfString.numeric = false
			
			return sfString;
		}

		public function dateSortField():SortField
		{
			var sfDate:SortField = new SortField()
			
			sfDate.name= lsFieldName
			sfDate.caseInsensitive = false
			sfDate.descending = false
			sfDate.numeric = false

			sfDate.compareFunction = date_sortCompare
			
			return sfDate;
		}
		
		public function date_sortCompare(itemA:Object, itemB:Object, field:Array = null):int
		{
			// var dateA:Date = new Date(Date.parse(itemA[lsFieldName]));
			// var dateB:Date = new Date(Date.parse(itemB[lsFieldName]));
			
			var dateA:Date = DateField.stringToDate(itemA[lsFieldName].toString().slice(0,10),'YYYY-MM-DD')
			var dateB:Date = DateField.stringToDate(itemB[lsFieldName].toString().slice(0,10),'YYYY-MM-DD')
			
			return ObjectUtil.dateCompare(dateA, dateB);
		}

		public function numeric_sortCompare(itemA:Object, itemB:Object, field:Array = null):int 
		{
			var numA:Number = new Number(itemA[lsFieldName])
			var numB:Number = new Number(itemB[lsFieldName])

			return ObjectUtil.numericCompare(numA, numB);
		}

		public function sortXML(sortColumn1:XML, sortColumn2:XML, sortColumn3:XML, xml:XML):XML
		{
			var xmlReturn:XML;
		
			if (xml != null)  
			{
				xmlReturn = xml.copy();    			// copy to get the root node.  We will replace the children
				xml = xml.copy();          			// copy so we can append the children to the return xml directly
		
				var xlcChildren:XMLListCollection = new XMLListCollection(xml.children());
				var xlChildren:XMLList;
				var xlcSorted:XMLListCollection = new XMLListCollection();
				var sort:Sort = new Sort();			// Create the Sort instance.
		
				sort.fields = [getSortField(sortColumn1), getSortField(sortColumn2), getSortField(sortColumn3)];
		
				xlcChildren.sort = sort;			// Assign the Sort object to the collection.
				xlcChildren.refresh();          	// Apply the sort to the collection.
		
				for (var i:int=0; i<xlcChildren.length; i++)  
				{      
					// loop over the children in index order
					xlcSorted.addItemAt(xlcChildren.getItemAt(i),i); //add the node to the new collection
				}
		
			
				xlChildren = xlcSorted.source;		// get the XMLlist from the source property
				xmlReturn.setChildren(xlChildren); 	// set the return xml children.
			}
		
			return xmlReturn;
		}
		
		private function getSortField(sortColumn:XML):SortField
		{
			var lsFieldName:String
			var lsDataType:String
			var sf:SortField = new SortField()
		
			lsFieldName = sortColumn.data[0]
			lsDataType = sortColumn.dataType[0]
		
			if(lsDataType == 'N')
			{
				sf = new SortFieldFunction(lsFieldName).numericSortField()
			}
			else if(lsDataType == 'D')
			{
				sf = new SortFieldFunction(lsFieldName).dateSortField()
			}
			else if(lsDataType == 'S')
			{
				sf = new SortFieldFunction(lsFieldName).stringSortField()
			}
			
			return sf
		}
	} 
}