// ActionScript file
override public function set visible(value:Boolean):void
{
	super.visible = value;

	if(visible)
	{
		width = 15
	}
	else
	{
		width = 0
	}	
}