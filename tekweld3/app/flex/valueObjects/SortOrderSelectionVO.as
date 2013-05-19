package valueObjects
{
	[Bindable]
	public class SortOrderSelectionVO
	{
		public var selectedLevel1:XML; // will have selected item of level comboboxes
		public var selectedLevel2:XML;
		public var selectedLevel3:XML;
		public var isSortOrderSelectionVisible:Boolean=false;
		public var sortField:XMLList; // to populate level comboboxes.
	}
}