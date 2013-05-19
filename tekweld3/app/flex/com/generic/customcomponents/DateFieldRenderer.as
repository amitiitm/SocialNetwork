package com.generic.customcomponents
{
	import mx.controls.DateField;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.core.IFactory;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.formatters.DateFormatter;
	
    public class DateFieldRenderer extends DateField implements IFactory
    {
        private var rowData:Object; 
        public  var _xmlItem:XML;
    	private var colName:DataGridListData;   
        public function DateFieldRenderer()
        {
            super();
            this.yearNavigationEnabled = true;
            // => Add listener to detect change in selected
            this.addEventListener(CalendarLayoutChangeEvent.CHANGE, onChangeHandler);
        }
        
        public function newInstance():*
		{
			return new DateFieldRenderer()
		}
       
        override public function set data(value:Object):void 
        { 
            _xmlItem = XML(value);
            var _dateFormatter:DateFormatter = new DateFormatter();
            _dateFormatter.formatString = "MM/DD/YYYY"
            if(listData)
            { 
            	colName = DataGridListData(listData); 
                var ds:Date = this.selectedDate; 
				//Display Current Date initially.
				if (ds == null)
				{
		        	var _date:Date = new Date();
        			ds =_date;
				}
				//Set Date to XML Column.
				_xmlItem[0][colName.dataField] = _dateFormatter.format(ds.toDateString());               
                this.selectedDate = ds; 
            } 
        } 

        override public function get data():Object 
        { 
		   if(listData)
            { 
                var col:DataGridListData = DataGridListData(listData); 
            }
             return _xmlItem; 
        }
        
        private function onChangeHandler(event:CalendarLayoutChangeEvent):void
		{
			_xmlItem[0][colName.dataField] = event.newDate.toString(); 
		} 
    }
}