package saoi.muduleclasses
{
    import mx.controls.Alert;
    import mx.controls.Label;
    import mx.controls.TextInput;
    import mx.controls.listClasses.*;
    import mx.core.UITextField;
 
    public class CellRenderer extends Label 
    {
 
        private const POSITIVE_COLOR:uint = 0x000000; // Black
        private const NEGATIVE_COLOR:uint = 0xFF0000; // Red
 		
		public function CellRenderer()
		{
			super();	
		}
		
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if(XML(data).children().length()>1)   // for advanced datagrid group where some row contains only one columns 
            {
            	var rushorder_flag:String = data.rushorder_flag.toString();
				var order_flagged:String = data.order_flagged.toString();
				
           		setStyle("color", ((rushorder_flag == 'Y' || order_flagged =='Y') ? NEGATIVE_COLOR : POSITIVE_COLOR));
				
				/*if((rushorder_flag == 'Y' || order_flagged =='Y'))
				{
					UITextField(this.getTextField()).background = true;
					UITextField(this.getTextField()).backgroundColor = NEGATIVE_COLOR;
				}
				else
				{
					UITextField(this.getTextField()).background = false;
					UITextField(this.getTextField()).backgroundColor = POSITIVE_COLOR;
				}*/
				
				//UITextField(this.getTextField()).setStyle("backgroundColor", ((rushorder_flag == 'Y' || order_flagged =='Y') ? NEGATIVE_COLOR : POSITIVE_COLOR));
				setStyle("fontWeight", ((rushorder_flag == 'Y' || order_flagged =='Y') ? 'bold' : 'normal'));
            }
        }
		
		public function set setTextAlignment(align:String):void
		{
			this.setStyle('textAlign',align);
		}
		
		public function getTextField():* 
		{
			return textField;
		}
    }
}