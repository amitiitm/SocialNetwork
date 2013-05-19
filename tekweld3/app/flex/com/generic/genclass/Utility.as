package com.generic.genclass
{
	import flash.utils.ByteArray;
	
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	import mx.utils.ObjectUtil;
	
	public class Utility
	{
		private var lsFieldName:String;
		
		public function Utility()
		{
		}
		public function getSortedXmlList(sourceXmlList:XMLList , fieldName:String	,	dataType:String= 'N'):XMLList
		{
			var xlcChildren:XMLListCollection	=	new XMLListCollection(sourceXmlList);
			var sort:Sort = new Sort();			// Create the Sort instance.
			var sortField:SortField	=	new SortField()
			var xlcSorted:XMLListCollection = new XMLListCollection();
			var xlChildren:XMLList;
			
			lsFieldName				=	fieldName
			sortField.name			=	fieldName
			
			if(dataType	==	'N')
			{
				sortField.numeric			=	true;
				sortField.caseInsensitive 	= true
				sortField.descending 		= false
			}
			else if(dataType	==	'S')
			{
				sortField.caseInsensitive 	= true
				sortField.descending 		= false
				sortField.numeric 			= false
			}
			else if(dataType	==	'D')
			{
				sortField.caseInsensitive = false
				sortField.descending = false
				sortField.numeric = false 
				sortField.compareFunction = date_sortCompare
			}
			
			sort.fields	=	[sortField];
			xlcChildren.sort	=	sort
			xlcChildren.refresh();
			
			for (var i:int=0; i<xlcChildren.length; i++)  
			{      
				// loop over the children in index order
				xlcSorted.addItemAt(xlcChildren.getItemAt(i),i); //add the node to the new collection
			}
	
		
			xlChildren = xlcSorted.source;		// get the XMLlist from the source property
			return xlChildren
		}
		private function date_sortCompare(itemA:Object, itemB:Object, field:Array = null):int 
		{
			var retVal:int;
			
			var dateA:Date = new Date(Date.parse(itemA[lsFieldName]));
			var dateB:Date = new Date(Date.parse(itemB[lsFieldName]));

			return ObjectUtil.dateCompare(dateA, dateB);
		}
		public function convertElementXmlToAttributeXml(sourceXml:XML):XML
		{
			var rootTag:String		=	sourceXml.localName().toString()
			var localName:String	=	XML(sourceXml.children()[0]).localName().toString()
			
			var targetXml:XML	=	new XML('<' + rootTag + '/>')
			
			for(var i:int	=	0	;	i < sourceXml.children().length()	;	i++)
			{
				var targetChildXml:XML	=	new XML('<' + localName + '/>')
				
				var sourceChildXml:XML	=	XML(sourceXml.children()[i])
				
				var attributeString:String	=	''
				
				
				 for(var j:int	=	0	;	j<	sourceChildXml.children().length()	;	j++)
				 {
				 	var elementName:String	=	XML(sourceChildXml.children()[j]).localName().toString();
				 	attributeString	=	attributeString	+ ' ' + elementName + '=' + '\'' + sourceChildXml.children()[j].toString() + '\''
				 	
				 }
				targetChildXml	=	new XML('<' + localName + ' ' + attributeString +  '/>')
				 
				targetXml.appendChild(targetChildXml);
			}
			
			return targetXml;
		}
		public function getDecodedXML(aXML:XML):XML
		{
			var base64Obj:Base64Decoder = new Base64Decoder();
			var byteArray:ByteArray;
			var xml:XML;
						
			try
			{
				base64Obj.decode(aXML.toString());
				byteArray = base64Obj.toByteArray()
				byteArray.uncompress();
				xml = XML(byteArray) 	
			}
			catch (e:Error) 
			{
				xml = aXML; 	
			}			
	
			return xml;
		}
		public function getEncodedXML(aXML:XML):XML
		{
		
			var byteArray:ByteArray			=	new ByteArray();
			
		    byteArray.writeObject(aXML);
			byteArray.position	=	0;
			byteArray.compress();
		   
		 
		    var base64Encoder:Base64Encoder	=	new Base64Encoder();
		    base64Encoder.encodeBytes(byteArray);
		 	
		 	var str:String	=	base64Encoder.toString();
		 	var _encodedXML:XML	=	new XML(<encoded>{str}</encoded>)
		 
			return 	_encodedXML;
		}		
	}
}