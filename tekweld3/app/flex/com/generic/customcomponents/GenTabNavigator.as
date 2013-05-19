package com.generic.customcomponents
{
	import com.generic.events.GenModuleLoaderEvent;
	
	import flash.display.DisplayObject;
	
	import model.GenModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	import mx.containers.BoxDirection;
	import mx.containers.Canvas;
	import mx.containers.TabNavigator;
	import mx.controls.Menu;
	import mx.controls.PopUpButton;
	import mx.controls.Spacer;
	import mx.controls.tabBarClasses.Tab;
	import mx.core.EdgeMetrics;
	import mx.effects.Tween;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.MenuEvent;
	
	[Style(name="popupButtonStyleName", type="String", inherit="no")]
	public class GenTabNavigator extends TabNavigator
	{
	   	protected var holder:Box;
	    protected var canvas:Canvas;
	    protected var popupButton:PopUpButton;
	    protected var menu:Menu;
	    protected var spacer:Spacer;
	 
		private var forcedTabWidth:Number = -1;
		private var originalTabWidthStyle:Number = -1;
		private var _minTabWidth:Number = 60;
		
		public static var POPUPPOLICY_AUTO:String = "auto";
		public static var POPUPPOLICY_ON:String = "on";
		public static var POPUPPOLICY_OFF:String = "off";
	
		private var _popUpButtonPolicy:String;
		
		public function get popUpButtonPolicy():String
		{
			return _popUpButtonPolicy;	
		}
		
		public function set popUpButtonPolicy(value:String):void
		{
			var old:String = this._popUpButtonPolicy;
			this._popUpButtonPolicy = value;
			
			if(old != value) 
			{
				this.invalidateDisplayList();
			}
		}

		public function get minTabWidth():Number
	    {
			return _minTabWidth;
		}
		
		public function set minTabWidth(value:Number):void 
		{
			this._minTabWidth = value;
			this.invalidateDisplayList();
		}
		
		override protected function createChildren():void
	    {
	    	if(!tabBar)
	    	{
				tabBar = new GenTabBar();
				tabBar.name = "tabBar";
				tabBar.focusEnabled = false;
				tabBar.styleName = this;
				tabBar.setStyle("borderStyle", "none");
				tabBar.setStyle("paddingTop", 0);
				tabBar.setStyle("paddingBottom", 0);
				
				(tabBar as GenTabBar).closePolicy = GenTab.CLOSE_ROLLOVER;
			}

	        super.createChildren();
	     	
	        if(!holder)
			{
	        	holder = new Box();
	        	holder.direction = BoxDirection.HORIZONTAL;
	        	holder.setStyle("horizontalGap", 0);
	        	holder.setStyle("borderStyle", "none");
	        	holder.setStyle("paddingTop", 0);
				holder.setStyle("paddingBottom", 0);
	        	
	        	holder.horizontalScrollPolicy = "off";
	        	
	        	rawChildren.addChild(holder);
	        }

			if(!canvas) 
	        {
	       		canvas = new Canvas();
	        	canvas.styleName = this;
	        	canvas.setStyle("borderStyle", "none");
	        	canvas.setStyle("backgroundAlpha", 0);
	        	canvas.setStyle("paddingTop", 0);
				canvas.setStyle("paddingBottom", 0);
	            canvas.horizontalScrollPolicy = "off"
	        	canvas.addChild(tabBar);
	        	holder.addChild(canvas);
			}

	        spacer = new Spacer();
	        spacer.percentWidth = 100;
	        holder.addChild(spacer);
	     
	        if(!menu) 
	        {
	        	menu = new Menu();
	            menu.addEventListener(MenuEvent.ITEM_CLICK, changeTabs);
	        }
	        
			if(!popupButton)
	        {
	        	popupButton = new PopUpButton();
	        	popupButton.popUp = menu;
	        	popupButton.width = 18;
	        	popupButton.setStyle("paddingLeft" , 0);
	        	popupButton.styleName = getStyle("popupButtonStyleName");
	        	holder.addChild(popupButton);
	        }
	        
	        tabBar.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, tabsChanged);
	        tabBar.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, tabsChanged);
	      	this.addEventListener(IndexChangedEvent.CHANGE,tabChangedEvent); 
	      	addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete)
	        invalidateSize();
	    }
	    
	    public function handleCreationComplete(event:FlexEvent):void
		{
			(GenModuleLoader)(selectedChild).dispatchEvent(new GenModuleLoaderEvent("genModuleLoaderActive"))
		}
		
	    public function get closePolicy():String 
	    {
			return (tabBar as GenTabBar).closePolicy;
	    }
	    
	    public function set closePolicy(value:String):void 
	    {
	    	var old:String = (tabBar as GenTabBar).closePolicy;
	    	(tabBar as GenTabBar).closePolicy = value;

	    	if(old != value) 
	    	{
	    		invalidateDisplayList();
	    	}
	    }

		protected function get tabBarHeight():Number
	    {
	        var tabHeight:Number = getStyle("tabHeight");
	
	        if (isNaN(tabHeight))
	        {
				tabHeight = tabBar.getExplicitOrMeasuredHeight();
	        }
	
	        return tabHeight - 1;
	    }
	    
	    override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
	    {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	    
	        if(_popUpButtonPolicy == GenTabNavigator.POPUPPOLICY_AUTO) 
	        {
	        	popupButton.includeInLayout = popupButton.visible = this.numChildren > 1;
	        }
	        else if(_popUpButtonPolicy == GenTabNavigator.POPUPPOLICY_ON) 
	        {
	        	popupButton.includeInLayout = popupButton.visible = true;
	        }
	        else if(_popUpButtonPolicy == GenTabNavigator.POPUPPOLICY_OFF) 
	        {
	        	popupButton.includeInLayout = popupButton.visible = false;
	        }
	        
	        spacer.includeInLayout = popupButton.includeInLayout;
	        
	        var vm:EdgeMetrics = viewMetrics;
	        var w:Number = unscaledWidth - vm.left - vm.right;
	
	        var th:Number = tabBarHeight + 1;
	        var pw:Number = tabBar.getExplicitOrMeasuredWidth();
	        
	        // tabBarSpace is used tot ry to figure out how much space we 
	        // need for the tabs, to figure out if we need to scroll them
	        var tabBarSpace:Number = w;
	        
	        if(popupButton.includeInLayout) 
	        {
				tabBarSpace -= popupButton.width;
			}
			
	        if(pw > tabBarSpace) 
	        {
	       		var numTabs:Number = tabBar.numChildren;
	       		var tabSizeNeeded:Number = Math.max((tabBarSpace - this.getStyle("horizontalGap")*(numTabs - 1))/numTabs, _minTabWidth);
	       		
				if(forcedTabWidth != tabSizeNeeded) 
				{
					if(originalTabWidthStyle == -1) 
					{
						originalTabWidthStyle = this.getStyle("tabWidth");
					}
					
       				forcedTabWidth = tabSizeNeeded;
       				this.setStyle("tabWidth", forcedTabWidth);
					callLater(invalidateDisplayList);
					return;
	   			}
	       	}
	       	else 
	       	{
	       		if(forcedTabWidth == -1 && this.getStyle("tabWidth") != originalTabWidthStyle && originalTabWidthStyle != -1) 
	       		{
	       			if(this.getStyle("tabWidth") != undefined) 
	       			{
						if(isNaN(originalTabWidthStyle)) 
						{
							this.clearStyle("tabWidth");
							tabBar.validateNow();
						}
						else 
						{
							this.setStyle("tabWidth", originalTabWidthStyle);
		    			}
		    			
		    			callLater(invalidateDisplayList);
	       			}
	       		}
	       		forcedTabWidth = -1;
	       	}
	        
	        if(forcedTabWidth != -1) 
	        {
				pw = (forcedTabWidth * tabBar.numChildren) + (this.getStyle("horizontalGap") * (tabBar.numChildren-1));
			}
	        
	        holder.move(0, 1);
	        holder.setActualSize(unscaledWidth, th);
           
           	var canvasWidth:Number = unscaledWidth;
			
			if(popupButton.includeInLayout) 
			{
				canvasWidth -= popupButton.width;
			}
			
			canvas.width = canvasWidth;
			canvas.height = th;
						
			if(pw <= canvasWidth) 
			{
				canvas.horizontalScrollPosition = 0;
			} 
			
			tabBar.setActualSize(pw, th);
			tabBar.move(0, 0);
			
			/* we only care about horizontalAlign if we're not taking up too
			   much space already */
			if(pw < canvasWidth) 
			{
				switch (getStyle("horizontalAlign"))
		        {
			        case "left":
			            tabBar.move(0, tabBar.y);
			            break;
			        case "right":
			            tabBar.move(unscaledWidth - tabBar.width, tabBar.y);
			            break;
			        case "center":
			            tabBar.move((unscaledWidth - tabBar.width) / 2, tabBar.y);
		        }
			}        
	    }

		private function changeTabs(event:MenuEvent):void 
		{
			if(this.selectedIndex == event.index) 
			{
	    		ensureTabIsVisible();
	    	}
	    	
	    	this.selectedIndex = event.index;
	    }
	    
	    private function tabChangedEvent(event:IndexChangedEvent):void 
	    {
			callLater(ensureTabIsVisible);
			(GenModuleLoader)(selectedChild).dispatchEvent(new GenModuleLoaderEvent("genModuleLoaderActive"))
		}

		private function ensureTabIsVisible():void 
		{
			var tab:DisplayObject = this.tabBar.getChildAt(this.selectedIndex);
	    	var newHorizontalPosition:Number;
	    	
	    	if(tab.x + tab.width > this.canvas.horizontalScrollPosition + this.canvas.width) 
	    	{
	    		newHorizontalPosition = tab.x  - canvas.width + tab.width + canvas.getStyle("buttonWidth")+10;	
	    	}
	    	else if(this.canvas.horizontalScrollPosition > tab.x) 
	    	{
	    		newHorizontalPosition = tab.x - canvas.getStyle("buttonWidth");
	    	}
	    	else 
	    	{
	    		newHorizontalPosition = canvas.horizontalScrollPosition;
	    	}
	    	
	    	if(newHorizontalPosition) 
	    	{
				var tween:Tween = new Tween(this, canvas.horizontalScrollPosition, newHorizontalPosition, 500);
	    	}
	    }
	    
	    public function onTweenUpdate(val:Object):void 
	    {
            canvas.horizontalScrollPosition = val as Number;
        }
        
        public function onTweenEnd(val:Object):void 
        {
           canvas.horizontalScrollPosition = val as Number;
		}

		private function tabsChanged(event:ChildExistenceChangedEvent):void 
		{
	    	callLater(reorderTabList);
	    	//(GenModuleLoader)(selectedChild).dispatchEvent(new GenModuleLoaderEvent("genModuleLoaderActive"))
			//Alert.show("tabsChanged")
	    }
	    
		public function reorderTabList():void 
		{
	    	var popupMenuDP:ArrayCollection = new ArrayCollection();
			
			for(var i:int=0; i<tabBar.numChildren; i++) 
			{
				var child:DisplayObject = tabBar.getChildAt(i);
				var label:String = "Untitled Tab";
				
				if(child is Tab && (child as Tab).label != "") 
				{
					label = (child as Tab).label;
				}
				popupMenuDP.addItem(label);
			}
			menu.dataProvider = popupMenuDP;	
	    }
	}
}