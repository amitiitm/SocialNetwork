package com.generic.customcomponents
{
	import mx.skins.halo.HaloBorder;
		
	public class GenTabListToolButtonSkin extends HaloBorder
	{
		private var offset:Number=0;
		
		public function GenTabListToolButtonSkin()
		{
			super();
		}
				
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			var alpha:Number = getStyle("alpha");
			var borderColor:uint = getStyle("borderColor");
			graphics.beginFill(borderColor,alpha);
			graphics.drawRect(0,0,w-offset,h);
		}
	}
}