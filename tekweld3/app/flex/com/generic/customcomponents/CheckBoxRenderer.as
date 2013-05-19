package com.generic.customcomponents
{
	import mx.controls.CheckBox;
    import flash.events.Event;
    import mx.core.IFactory;
    import mx.controls.Alert;
    
    public class CheckBoxRenderer extends CheckBox implements IFactory
    {
        public  var _xmlItem:XML;
        public function CheckBoxRenderer()
        {
            super();
        }
        
		public function newInstance():*
		{
			return new CheckBoxRenderer()
		}
        
        // Override the set method for the data property.
        override public function set data(value:Object):void 
        {
             _xmlItem = XML(value);
              super.data = value;
            // => Make sure there is data
            if (value != null) {
                // => Set the selected property
                if(value.ack_flag == 'Y' || value.ack_flag == true)
                {
	                this.selected = true
                }
                else if(value.ack_flag == 'N' || value.ack_flag == false)
                {
	                this.selected = false
                }
            }   
        }
    }
}