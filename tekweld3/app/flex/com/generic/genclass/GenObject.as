package com.generic.genclass
{
	import com.generic.customcomponents.GenDataGrid;
	import com.generic.customcomponents.GenTextInput;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.xml.XMLDocument;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Container;
	
	public class GenObject
	{
		protected var genObj:ArrayCollection = new ArrayCollection();
		private var genRadioButtonGroup:ArrayCollection = new ArrayCollection();

		public function getGenObjects(aObj:Container):ArrayCollection
		{
			findGenObjects(aObj)
			addOtherGenObjects();
			addGenControlFields();
			
			return genObj;
		}
				
		private function findGenObjects(aObj:Container):void
		{
			var childComp:Array = aObj.getChildren()
	
			for(var i:int = 0; i < childComp.length; i++)
			{
				var lsClassName:String = getQualifiedClassName(childComp[i])

				//VD 03 Oct 2011 GenComponent added
				var lsSuperClassName:String = getQualifiedSuperclassName(childComp[i])

				if(lsClassName == "mx.containers::HBox" || lsClassName == "mx.containers::VBox" || lsClassName == "mx.containers::ViewStack"
					|| lsClassName == "mx.containers::HDividedBox" || lsClassName == "mx.containers::VDividedBox" || lsClassName == "mx.containers::TabNavigator"
					|| lsSuperClassName == "com.generic.customcomponents::GenComponent") 
				{
					findGenObjects(childComp[i])
				}
				else
				{
					if(lsClassName == "com.generic.customcomponents::GenTextInput"
							|| lsClassName == "com.generic.customcomponents::GenDateField" 
							|| lsClassName == "com.generic.customcomponents::GenTextArea" 
							|| lsClassName == "com.generic.customcomponents::GenComboBox"
							|| lsClassName == "com.generic.customcomponents::GenCheckBox"
							|| lsClassName == "com.generic.customcomponents::GenDataGrid"
							|| lsClassName == "com.generic.customcomponents::GenList"
							|| lsClassName == "com.generic.components::Detail"
							|| lsClassName == "com.generic.components::EditableDetail"
							|| lsClassName == "com.generic.components::NewDetail"
							|| lsClassName == "com.generic.customcomponents::GenDynamicComboBox"
							|| lsClassName == "com.generic.customcomponents::GenUploadButton"
							|| lsClassName == "com.generic.customcomponents::GenDynamicComboBoxWithHelp"
							|| lsClassName == "com.generic.customcomponents::GenTextInputWithHelp"
							)
					{
						genObj.addItem(setInitialEditableFlag(childComp[i]))
					}
				}
			}
		}
		//modified 21/01/2010 jeetu
		private function setInitialEditableFlag(aObject:Object):Object
		{
			aObject.initialEditableFlag	=	true;  // we can pass false also because actual value is set inside the object
			
			return aObject
		}
		
		private function addGenControlFields():void
		{
			
			// Right now we are using only one tablename
			var tiCompany_id:GenTextInput = new GenTextInput();
			var tiUpdated_by:GenTextInput = new GenTextInput();
			var tiUpdated_by_code:GenTextInput = new GenTextInput();
			var tiCreated_by:GenTextInput = new GenTextInput();
			var tiId:GenTextInput = new GenTextInput();
			var tiLock_version:GenTextInput = new GenTextInput();
			 
			tiCompany_id.id = "tiCompany_id" 
			tiCompany_id.xmlTag = "company_id" 
			tiCompany_id.updatableFlag = "true"
			tiCompany_id.defaultValue = ""
			tiCompany_id.tableName = genObj[0].tableName
			tiCompany_id.text = "";
		
			tiUpdated_by.id = "tiUpdated_by" 
			tiUpdated_by.xmlTag = "updated_by" 
			tiUpdated_by.updatableFlag = "true"
			tiUpdated_by.defaultValue = ""
			tiUpdated_by.tableName = genObj[0].tableName
			tiUpdated_by.text = "";


			tiUpdated_by_code.id = "tiUpdated_by_code" 
			tiUpdated_by_code.xmlTag = "updated_by_code" 
			tiUpdated_by_code.updatableFlag = "true"
			tiUpdated_by_code.defaultValue = ""
			tiUpdated_by_code.tableName = genObj[0].tableName
			tiUpdated_by_code.text = "";

			tiCreated_by.id = "tiCreated_by" 
			tiCreated_by.xmlTag = "created_by" 
			tiCreated_by.updatableFlag = "true"
			tiCreated_by.defaultValue = ""
			tiCreated_by.tableName = genObj[0].tableName
			tiCreated_by.text = "";
		
			tiId.id = "tiId" 
			tiId.xmlTag = "id" 
			tiId.updatableFlag = "true"
			tiId.defaultValue = ""
			tiId.tableName = genObj[0].tableName
			tiId.text = "";
			
			// tiLock_version
			tiLock_version.id = "tiLock_version" 
			tiLock_version.xmlTag = "lock_version" 
			tiLock_version.updatableFlag = "true"
			tiLock_version.defaultValue = "0"
			tiLock_version.tableName = genObj[0].tableName
			tiLock_version.text = "";
			//
				
			genObj.addItem(tiCompany_id)
			genObj.addItem(tiUpdated_by)
			genObj.addItem(tiCreated_by)
			genObj.addItem(tiId)
			genObj.addItem(tiLock_version)
			
		}
		
		private function addOtherGenObjects():void
		{
			for(var i:int=0; i < genRadioButtonGroup.length; i++)
			{
				genObj.addItem(genRadioButtonGroup[i])
			}
		}

		//modified jeetu 21/1/2010
		public function setRecord(aGenObjects:ArrayCollection, record:XML):void
		{
			var aObject:Object;
			var update_flag:String = record.children()[0]["update_flag"].toString()
		/*	var viewOnly:Boolean = false;
			
			if(update_flag.toLocaleUpperCase() == "V")
			{
				viewOnly = true 				
			}*/
						
			for(var i:int = 0; i < aGenObjects.length; i++)
			{
				aObject = aGenObjects[i];
				//aObject.viewOnlyFlag = viewOnly;
				
				switch(getQualifiedClassName(aObject))
				{
					case "com.generic.customcomponents::GenDataGrid":
						if(record.children()[0].hasOwnProperty(aObject.rootNode))
						{
							aObject.dataValue = XML(record.children()[0][aObject.rootNode])
						}
						else
						{
							aObject.dataValue = new XML("<" + aObject.rootNode + "/>")
						}
						resetDeletedRowsGenDataGrid(aGenObjects[i]);
						break;
					case "com.generic.components::Detail":
						if(record.children()[0].hasOwnProperty(aObject.rootNode))
						{
							aObject.dataValue = XML(record.children()[0][aObject.rootNode])
						}
						else
						{
							aObject.dataValue = new XML("<" + aObject.rootNode + "/>")
						}
						resetDeletedRows(aObject);

						break;
					case "com.generic.components::EditableDetail":
						if(record.children()[0].hasOwnProperty(aObject.rootNode))
						{
							aObject.dataValue = XML(record.children()[0][aObject.rootNode])
						}
						else
						{
							aObject.dataValue = new XML("<" + aObject.rootNode + "/>")
						}
						resetDeletedRows(aObject);

						break;
					case "com.generic.components::NewDetail":
						if(record.children()[0].hasOwnProperty(aObject.rootNode))
						{
							aObject.dgDtl.rows = XML(record.children()[0][aObject.rootNode])
						}
						else
						{
							aObject.dataValue = new XML("<" + aObject.rootNode + "/>")
						}
						aObject.reset()
						resetDeletedRows(aObject);

					    break;
					case "com.generic.customcomponents::GenList":
					     break;
					case "com.generic.customcomponents::GenUploadButton":
					     break;
					     
					case "com.generic.customcomponents::GenTextInputWithHelp":
					
							aObject.dataValue = record.children()[0].child(aObject.xmlTag).toString();
							aObject.labelValue = record.children()[0].child(aObject.labelTag).toString();
							
					     break;     
					     
				    default:
				    	aObject.dataValue = record.children()[0].child(aObject.xmlTag).toString();
						break
				}
			}
		}
		
		//jeetu 20/1/2010  for ListView
		public function setRecordViewOnly(aGenObjects:ArrayCollection):void
		{
			for(var i:int = 0; i < aGenObjects.length; i++)
			{
				if(aGenObjects[i].hasOwnProperty('viewOnlyFlag'))
				{
					aGenObjects[i].viewOnlyFlag = true;
				}
				else
				{
					Alert.show('please specify viewOnlyFlag for this' + aGenObjects[i].toString());
				}
				
			}
		}
		//jeetu 20/1/2010 For AddEditView
		public function setRecordEditable(aGenObjects:ArrayCollection):void
		{
			for(var i:int = 0; i < aGenObjects.length; i++)
			{
				if(aGenObjects[i].hasOwnProperty('viewOnlyFlag'))
				{
					aGenObjects[i].viewOnlyFlag = false;
				}
				else
				{
					Alert.show('please specify viewOnlyFlag for this' + aGenObjects[i].toString());
				}
			
			}
		}

		// Vivek 2909		//modified jeetu 21/1/2010
		public function resetObjects(aGenObjects:ArrayCollection):void
		{
			for(var i:int = 0; i < aGenObjects.length; i++)
			{
				aGenObjects[i].viewOnlyFlag = false;
				
				if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.customcomponents::GenDataGrid')
				{
					aGenObjects[i].dataValue = new XML("<" + aGenObjects[i].rootNode + "/>") // Later we will check how to reset dataprovider, Later we will
					resetDeletedRowsGenDataGrid(aGenObjects[i]);
				}
				else if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.customcomponents::GenList')
				{
				    aGenObjects[i].dataValue = new XML(aGenObjects[i].rows); //it is ok
				}
				else if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::Detail')
				{
				    aGenObjects[i].dataValue = new XML("<" + aGenObjects[i].rootNode + "/>")
				    resetDeletedRows( aGenObjects[i]);
				}
				else if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::EditableDetail')
				{
				    aGenObjects[i].dataValue = new XML("<" + aGenObjects[i].rootNode + "/>")
				    resetDeletedRows( aGenObjects[i]);
				}
				else if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::NewDetail')
				{
				    aGenObjects[i].dgDtl.rows = new XML("<" + aGenObjects[i].rootNode + "/>")
					aGenObjects[i].reset()
				    resetDeletedRows( aGenObjects[i]);
				}
				else if(getQualifiedClassName(aGenObjects[i]) == "com.generic.customcomponents::GenRadioButtonGroup")
				{
					//donot delete it. we will set it in future
				}
				else if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.customcomponents::GenUploadButton')
				{
					aGenObjects[i].fileName = ""; 
				}
				else if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.customcomponents::GenTextInputWithHelp')
				{
				    aGenObjects[i].dataValue 	= aGenObjects[i].defaultDataValue;
				    aGenObjects[i].labelValue	= aGenObjects[i].defaultLabelValue;
				}
				else
				{
					aGenObjects[i].dataValue = aGenObjects[i].defaultValue;
				}
			}
		}
		
		private function resetDeletedRows(aObject:Object):void
		{
			aObject.dgDtl.deletedRows	= new XML('<' + aObject.rootNode + '/>');	
		}
		private function resetDeletedRowsGenDataGrid(aObject:Object):void
		{
			aObject.deletedRows			= new XML('<' + aObject.rootNode + '/>');	
		}
		
		/////// 20090930
		public function generateRecordXML(aGenObjects:ArrayCollection):XML
		{
			var retValue:int = 0;
			var recordXML:XML;

			removeBlankRowsFromUpdatableGrids(aGenObjects)
			recordXML = getRecordXML(aGenObjects)

			return recordXML;
		}
		
		private function removeBlankRowsFromUpdatableGrids(aGenObjects:ArrayCollection):void
		{
			for(var i:int = 0; i < aGenObjects.length; i++)
			{
				if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.customcomponents::GenDataGrid')
				{
					if (aGenObjects[i].dataProvider != null)
					{
						if(aGenObjects[i].checkBlankRowColumn != "")
						{
							var xml:XML = removeBlankRows(aGenObjects[i]);
		
							if(xml != null)
							{
								aGenObjects[i].dataProvider = xml.children();
							}
						}
					}
				}
				else if (getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::Detail')
				{
					//later
				}
				else if (getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::EditableDetail')
				{
					//later
				}
				else if (getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::NewDetail')
				{
					//later
				}
			}
		}
		
		private function removeBlankRows(_dgDetail:GenDataGrid):XML
		{
			var _xmlTag:String = _dgDetail.checkBlankRowColumn;
			var _rootNode:String = _dgDetail.rootNode;
			var _tempXML:XML = new XML("<" + _rootNode + "/>");

			for(var j:int = 0; j < _dgDetail.dataProvider.length; j++)
			{
				if(!(_dgDetail.dataProvider[j].child(_xmlTag).toString() == ''
					|| _dgDetail.dataProvider[j].child(_xmlTag).toString() == null 
					|| _dgDetail.dataProvider[j].child(_xmlTag).toString() == '0.0'
					|| _dgDetail.dataProvider[j].child(_xmlTag).toString() == '0.00'))
				{
					_tempXML.appendChild(_dgDetail.dataProvider[j]);
				}
			}
			return _tempXML; 
		}

		private function getRecordXML(aGenObjects:ArrayCollection):XML
		{
			var lastElement:XML;
			var doc:XMLDocument;
			
			var hdrXML:XML = getHeaderXML(aGenObjects)
			
			for(var i:int = 0; i < aGenObjects.length; i++)
			{
				if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.customcomponents::GenDataGrid' && aGenObjects[i].updatableFlag.toUpperCase() == "TRUE")
				{
					doc = new XMLDocument(hdrXML.children());
					lastElement = XML(doc.lastChild.toString());
					lastElement.appendChild(aGenObjects[i].mergedRows);
					hdrXML.setChildren(lastElement);
				}
				else if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::Detail' && aGenObjects[i].updatableFlag.toUpperCase() == "TRUE")
				{
					doc = new XMLDocument(hdrXML.children());
					lastElement = XML(doc.lastChild.toString());
					lastElement.appendChild(aGenObjects[i].dgDtl.mergedRows);
					hdrXML.setChildren(lastElement);
				}
				else if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::EditableDetail' && aGenObjects[i].updatableFlag.toUpperCase() == "TRUE")
				{
					doc = new XMLDocument(hdrXML.children());
					lastElement = XML(doc.lastChild.toString());
					lastElement.appendChild(aGenObjects[i].dgDtl.mergedRows);
					hdrXML.setChildren(lastElement);
				}
				else if(getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::NewDetail' && aGenObjects[i].updatableFlag.toUpperCase() == "TRUE")
				{
					doc = new XMLDocument(hdrXML.children());
					lastElement = XML(doc.lastChild.toString());
					lastElement.appendChild(aGenObjects[i].dgDtl.mergedRows);
					hdrXML.setChildren(lastElement);
				}
			}
			return hdrXML;
				
		}

		private function getHeaderXML(aGenObjects:ArrayCollection):XML
		{
			var mainXML:XML = new XML(<mainXML></mainXML>)
			var childXML:XML = new XML(<childXML></childXML>)
			var lsTableName:String;

			for(var i:int = 0; i < aGenObjects.length; i++)
			{
				if(!((getQualifiedClassName(aGenObjects[i]) == 'com.generic.customcomponents::GenDataGrid')
					||
					(getQualifiedClassName(aGenObjects[i]) == 'com.generic.customcomponents::GenList')
					||
					(getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::Detail')
					||
					(getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::EditableDetail')					
					||
					(getQualifiedClassName(aGenObjects[i]) == 'com.generic.components::NewDetail')
					||
					(getQualifiedClassName(aGenObjects[i]) == 'com.generic.customcomponents::GenUploadButton')					
					)
				)
				{
					if((String)(aGenObjects[i].updatableFlag).toUpperCase() == "TRUE")
					{
						var lsValue:String;
						lsValue = aGenObjects[i].dataValue; //jeetu 21/1/2010
						
						var str:String = "<" + aGenObjects[i].xmlTag + ">" + lsValue + "</" + aGenObjects[i].xmlTag + ">"
						var tempXML:XML = new XML(str)
						lsTableName = aGenObjects[i].tableName
						childXML.appendChild(tempXML)
					}
				}
			}
		
			childXML.setName(lsTableName)
			
			mainXML.setName(getParentNode(lsTableName))
			mainXML.appendChild(childXML)
			
			return mainXML
		}
		///////
		
		private function getParentNode(asString:String):String
		{
			var lsTableName:String = asString;
			if(lsTableName.charAt(lsTableName.length-1).toLocaleLowerCase()== 'y')
			{
				lsTableName = lsTableName.slice(0,lsTableName.length-1).concat('ies');
			}
			else
			{
				lsTableName	=	lsTableName + "s"
			}

			return 	lsTableName
		}
	}
}
