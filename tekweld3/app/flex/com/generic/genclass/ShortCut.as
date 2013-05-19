package com.generic.genclass
{
	import com.generic.customcomponents.GenButton;
	
	import flash.events.KeyboardEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Button;
	
	public class ShortCut
	{
		public static const SHORTCUT_QUERY_CHAR:String 				= 'Q'
		public static const SHORTCUT_ADD_CHAR:String 				= 'I'
		public static const SHORTCUT_EDIT_CHAR:String 				= 'E'
		public static const SHORTCUT_IMPORT_CHAR:String 			= 'M'
		public static const SHORTCUT_FIRST_CHAR:String 				= '<'
		public static const SHORTCUT_PREVIOUS_CHAR:String 			= '-'
		public static const SHORTCUT_NEXT_CHAR:String 				= '+'
		public static const SHORTCUT_LAST_CHAR:String 				= '>'
		public static const SHORTCUT_PRINT_CHAR:String 				= 'P'
		public static const SHORTCUT_NOTE_CHAR:String 				= 'N'
		public static const SHORTCUT_ATTACHMENT_CHAR:String 		= 'H'
		public static const SHORTCUT_REFERESH_CHAR:String 			= 'R'  //WITH SHIFT
		public static const SHORTCUT_FILTER_CHAR:String 			= 'T'
		public static const SHORTCUT_RESET_FILTER_CHAR:String 		= 'T' //WITH SHIFT
		public static const SHORTCUT_SAVE_CHAR:String 				= 'S'
		public static const SHORTCUT_RESET_CHAR:String 				= 'D'
		public static const SHORTCUT_COPY_RECORD_CHAR:String 		= 'C' //WITH SHIFT
		public static const SHORTCUT_LIST_CHAR:String 				= 'L'
		public static const SHORTCUT_EXPORT_CHAR:String 			= 'P'//WITH SHIFT
		public static const SHORTCUT_EXPAND_ALL_CHAR:String 		= '^'
		public static const SHORTCUT_COLLAPSE_ALL_CHAR:String 		= '&'
		public static const SHORTCUT_CONFIGURE_COLUMN_CHAR:String 	= 'G'
		public static const SHORTCUT_BROWSE_CHAR:String 	= 'B'
		
		public function ShortCut()
		{
		}
		public static function isQuery(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_QUERY_CHAR &&	!__genModel.activeModelLocator.viewObj.isViewOpen  && btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isADD(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_ADD_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
/*****************************************************************************************************/
		public static function isEdit(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_EDIT_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isImport(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_IMPORT_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isFirst(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_FIRST_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isNext(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_NEXT_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isPrevious(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_PREVIOUS_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isLast(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_LAST_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isPrint(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_PRINT_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isNote(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_NOTE_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isAttachment(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_ATTACHMENT_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isReferesh(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(isShiftKey && char == SHORTCUT_REFERESH_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isFilter(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_FILTER_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isResetFilter(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(isShiftKey && char == SHORTCUT_RESET_FILTER_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isSave(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_SAVE_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isReset(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_RESET_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isCopyRecord(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(isShiftKey && char == SHORTCUT_COPY_RECORD_CHAR && btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isListMode(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_LIST_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isExport(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(isShiftKey && char == SHORTCUT_EXPORT_CHAR  &&	btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isExpandAll(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_EXPAND_ALL_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isCollapsAll(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_COLLAPSE_ALL_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isConfigureColumn(event:KeyboardEvent , btn:GenButton):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_CONFIGURE_COLUMN_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}
		public static function isBrowse(event:KeyboardEvent , btn:Button):Boolean
		{
			var __genModel:GenModelLocator = GenModelLocator.getInstance();
			var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();
			var keyCode:int 		= 	event.keyCode;
			var isShiftKey:Boolean	=	event.shiftKey;
			
			if(char == SHORTCUT_BROWSE_CHAR &&	 btn.visible)// 81 //ctrl + q query
			{
				return true
			}
			else
			{
				return false;
			}
			return false;
		}

	}
}