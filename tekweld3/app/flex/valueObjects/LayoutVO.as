package valueObjects
{
	[Bindable]
	public class LayoutVO
	{
		public var layout:XML;
		public var selectedLayout:XML;//use to filter columns and set selected columns
		public var listFormat:XML;
		public var changeInLayout:XML;
	
		public function getLayout():XML
		{
			return 		new XML(<report_layouts>
									<report_layout>
										<id>105</id>
										<report_id>11</report_id>
										<name>Default</name>
										<user_id></user_id>
										<document_id></document_id>
										<default_yn>Y</default_yn>
										<layout_type>U</layout_type>
										<report_layout_columns>
											<report_layout_column>
												<report_column_id>2</report_column_id>
												<column_name>trans_no</column_name>
												<column_label>Trans No</column_label> 	
											  	<column_width>100</column_width> 			
											  	<column_textalign>left</column_textalign>
											  	<column_datatype>S</column_datatype>
											 	<sortdatatype>N</sortdatatype>  		
											 	<isgroup>N</isgroup> 	
											 	<group_level></group_level>		
											 	<istotal>N</istotal> 		
											 	<isdrilldowncolumn>N</isdrilldowncolumn>	
											 	<isvisible>Y</isvisible>
											</report_layout_column>
											
											<report_layout_column>
												<report_column_id>1</report_column_id>
												<column_name>trans_bk</column_name>
												<column_label>Trans BK</column_label> 	
											  	<column_width>100</column_width> 			
											  	<column_textalign>left</column_textalign>
											  	<column_datatype>S</column_datatype>
											 	<sortdatatype>S</sortdatatype>  		
											 	<isgroup>Y</isgroup> 	
											 	<group_level>1</group_level>		
											 	<istotal>N</istotal> 		
											 	<isdrilldowncolumn>N</isdrilldowncolumn>	
											 	<isvisible>Y</isvisible>
											</report_layout_column>
											
											<report_layout_column>
												<report_column_id>4</report_column_id>
												<column_name>customer_code</column_name>
												<column_label>Customer Code BK</column_label> 	
											  	<column_width>100</column_width> 			
											  	<column_textalign>left</column_textalign>
											  	<column_datatype>S</column_datatype>
											 	<sortdatatype>S</sortdatatype>  		
											 	<isgroup>N</isgroup> 	
											 	<group_level></group_level>		
											 	<istotal>N</istotal> 		
											 	<isdrilldowncolumn>N</isdrilldowncolumn>	
											 	<isvisible>Y</isvisible>
											</report_layout_column>
											
											
											<report_layout_column>
												<report_column_id>7</report_column_id>
												<column_name>applied_amt</column_name>
												<column_label>Applied Amt</column_label> 	
											  	<column_width>100</column_width> 			
											  	<column_textalign>right</column_textalign>
											  	<column_datatype>N</column_datatype>
											 	<sortdatatype>N</sortdatatype>  		
											 	<isgroup>N</isgroup> 	
											 	<group_level></group_level>		
											 	<istotal>N</istotal> 		
											 	<isdrilldowncolumn>N</isdrilldowncolumn>	
											 	<isvisible>Y</isvisible>
											</report_layout_column>
																
										</report_layout_columns>
											  	
									</report_layout>	
								</report_layouts>)
		}
		
	}
}

