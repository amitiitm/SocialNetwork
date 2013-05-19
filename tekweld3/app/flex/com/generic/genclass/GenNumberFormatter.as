package com.generic.genclass
{
	import mx.formatters.NumberFormatter;

	public class GenNumberFormatter extends NumberFormatter
	{
		public function GenNumberFormatter()
		{
			super();
			useThousandsSeparator = false;
		}
	}
}