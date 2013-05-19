override public function set visible(value:Boolean):void
{
	super.visible = value;

	if(visible)
	{
		width = 20
	}
	else
	{
		width = 0
	}	
}
