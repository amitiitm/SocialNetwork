package com.generic.genclass
{
	import mx.controls.Alert;
	
	public class TreeFormatter
	{  
		private var decodedTreeXml:XML;
		private var encodedXml:XML;
		private var listDP:XML;
		
		public function TreeFormatter() {}
		
		
        public function encode(treeXml:XML):XML
        {
        	encodedXml = new XML(<elements></elements>);
        	var parentCode:String;

        	for(var i:int=0;i < treeXml.children().length();i++)//to add all childs of tree.
		    {
		    	parentCode = treeXml.children()[i].@element_id.toString() + '#'
		    	encodedXml.appendChild(new XML(<element><hierarchy>{parentCode}</hierarchy></element>));
		    	if(treeXml.child(i).children() != undefined)
		    	{
		    		encodeAllChildren(XML(treeXml.child(i)),parentCode);
		    	}
		    } 
        
        	return encodedXml;
        }
        
        private function encodeAllChildren(treeXml:XML,parentCode:String):void //for all children of a node
        {
           var id:String = new String(parentCode.toString());
        	for(var i:int = 0;i < treeXml.children().length();i++)//to add all childs of node.
		    {
		    	parentCode = id + treeXml.children()[i].@element_id.toString() + '#'
		    	encodedXml.appendChild(new XML(<element><hierarchy>{parentCode}</hierarchy></element>));

		    	if(treeXml.child(i).children() != undefined)
		    	{
		    		encodeAllChildren(XML(treeXml.child(i)),parentCode);
		    	}
		    } 
        }

        public function decode(encodedTreeXml:XML,listXML:XML):XML
        {
        	decodedTreeXml = new XML(<element element_name="All" element_id="All"/>);
        	listDP=listXML.copy();
        	var id:String;
        	var codeArr:Array;
        	for(var i:int=0;i < encodedTreeXml.children().length();i++)
        	{ 
        	 
				id = XMLList(encodedTreeXml.children()[i]).children()[0].toString();
				codeArr = id.split('#');// the last element of arr will be having ''.
        		codeArr = codeArr.slice(0,codeArr.length-1);//get array which dont have last element.since last element is ''.
        	    decodeInTreeFormat(decodedTreeXml,codeArr);
        	} 
        
        	return decodedTreeXml;
        }
        
        private function decodeInTreeFormat(treeXml:XML,codeArr:Array):void
        {
        	if(codeArr.length == 1)
        	{
        		treeXml.appendChild(new XML(<element element_id={codeArr[0].toString()} element_name={getLabelForCodeFromListDP(codeArr[0].toString())}></element>));
        	}
        	else
        	{
        		for(var k:int = 0;k < treeXml.children().length();k++)
        		{
        			if(treeXml.children()[k].@element_id.toString() == codeArr[0].toString())
        			{
        				codeArr = codeArr.slice(1,codeArr.length);
        				decodeInTreeFormat(XML(treeXml.children()[k]),codeArr);
        			}
        		}
        	}
        }
        
        private function getLabelForCodeFromListDP(itemCode:String):String
        {
          	var searchedgroup:XMLList = listDP.children().(element_id.toString() == itemCode.toString())
       		return searchedgroup.element_name.toString();
        }
	}
}
