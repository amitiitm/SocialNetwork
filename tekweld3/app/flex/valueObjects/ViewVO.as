package valueObjects
{
	import model.GenModelLocator;
	
	[Bindable]
	public class ViewVO
	{
		public var view:XML;
		public var viewFormat:XML;
		public var selectedView:XML;//use to fill cricteria values , and default selected levels in sorting
		public var _criteria:XML
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		public var isViewOpen:Boolean = false;
		
		public function ViewVO() {}
		
		public function get criteria():XML
		{
			// GenModelLocator to remove from ViewVO;
			_criteria =	<criteria>
							<id/><default_yn>N</default_yn><company_id>{GenModelLocator.getInstance().user.default_company_id}</company_id><created_by/><updated_by/><created_at/><updated_at/><update_flag/>
							<trans_flag/><lock_version/><name/><criteria_type/><user_id/><document_id/>
							<str1/><str2/><str3/><str4/><str5/><str6/><str7/><str8/><str9/><str10/>
							<str11/><str12/><str13/><str14/><str15/><str16/><str17/><str18/><str19/><str20/>
							<str21/><str22/><str23/><str24/><str25/>
							<str26/><str27/><str28/><str29/><str30/>
							<dt1/><dt2/><dt3/><dt4/><dt5/><dt6/><dt7/><dt8/><dt9/><dt10/>
							<dec1/><dec2/><dec3/><dec4/><dec5/><dec6/><dec7/><dec8/><dec9/><dec10/>
							<list1/><list2/><list3/><list4/><list5/><list6/><list7/><list8/><list9/><list10/>
							<all1/><all2/><all3/><all4/><all5/><all6/><all7/><all8/><all9/><all10/>
							<multiselect1/><multiselect2/><multiselect3/><multiselect4/><multiselect5/>
							<multiselect6/><multiselect7/><multiselect8/><multiselect9/><multiselect10/>
							<multiselect11/><multiselect12/><multiselect13/><multiselect14/><multiselect15/>
							<default_request>Y</default_request>
						</criteria>
			
			return _criteria
		}
	}
}

