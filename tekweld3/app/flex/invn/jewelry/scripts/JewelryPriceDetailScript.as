import com.generic.genclass.GenNumberFormatter;
import model.GenModelLocator;
import mx.formatters.NumberFormatter;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private var priceLevelMarkupXML:XML = new XML(<rows/>);
private var numericFormatter:GenNumberFormatter = 	new GenNumberFormatter();

private function creationCompleteHandler():void
{
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	priceLevelMarkupXML = XML(__genModel.masterData.child('price_level'))
	
	if(priceLevelMarkupXML.children().length() > 0)
	{
		if(priceLevelMarkupXML.child('markup_a').child('value').toString() == '' || priceLevelMarkupXML.child('markup_a').child('value').toString() == null)
		{
			markupa.text	=	'0.00';
		}
		else
		{
			markupa.text	=	priceLevelMarkupXML.child('markup_a').child('value').toString()	
		}
		if(priceLevelMarkupXML.child('markup_b').child('value').toString() == '' || priceLevelMarkupXML.child('markup_b').child('value').toString() == null)
		{
			markupb.text	=	'0.00';
		}
		else
		{
			markupb.text	=	priceLevelMarkupXML.child('markup_b').child('value').toString()	
		}
		if(priceLevelMarkupXML.child('markup_c').child('value').toString() == '' || priceLevelMarkupXML.child('markup_c').child('value').toString() == null)
		{
			markupc.text	=	'0.00';
		}
		else
		{
			markupc.text	=	priceLevelMarkupXML.child('markup_c').child('value').toString()	
		}
		if(priceLevelMarkupXML.child('markup_d').child('value').toString() == '' || priceLevelMarkupXML.child('markup_d').child('value').toString() == null)
		{
			markupd.text	=	'0.00';
		}
		else
		{
			markupd.text	=	priceLevelMarkupXML.child('markup_d').child('value').toString()	
		}
		if(priceLevelMarkupXML.child('markup_e').child('value').toString() == '' || priceLevelMarkupXML.child('markup_e').child('value').toString() == null)
		{
			markupe.text	=	'0.00';
		}
		else
		{
			markupe.text	=	priceLevelMarkupXML.child('markup_e').child('value').toString()	
		}
		if(priceLevelMarkupXML.child('markup_f').child('value').toString() == '' || priceLevelMarkupXML.child('markup_f').child('value').toString() == null)
		{
			markupf.text	=	'0.00';
		}
		else
		{
			markupf.text	=	priceLevelMarkupXML.child('markup_f').child('value').toString()	
		}
		if(priceLevelMarkupXML.child('markup_g').child('value').toString() == '' || priceLevelMarkupXML.child('markup_g').child('value').toString() == null)
		{
			markupg.text	=	'0.00';
		}
		else
		{
			markupg.text	=	priceLevelMarkupXML.child('markup_g').child('value').toString()	
		}
		if(priceLevelMarkupXML.child('markup_h').child('value').toString() == '' || priceLevelMarkupXML.child('markup_h').child('value').toString() == null)
		{
			markuph.text	=	'0.00';
		}
		else
		{
			markuph.text	=	priceLevelMarkupXML.child('markup_h').child('value').toString()	
		}
		if(priceLevelMarkupXML.child('markup_i').child('value').toString() == '' || priceLevelMarkupXML.child('markup_i').child('value').toString() == null)
		{
			markupi.text	=	'0.00';
		}
		else
		{
			markupi.text	=	priceLevelMarkupXML.child('markup_i').child('value').toString()	
		}
		if(priceLevelMarkupXML.child('markup_j').child('value').toString() == '' || priceLevelMarkupXML.child('markup_j').child('value').toString() == null)
		{
			markupj.text	=	'0.00';
		}
		else
		{
			markupj.text	=	priceLevelMarkupXML.child('markup_j').child('value').toString()	
		}
		
	}
	
}
private function calculateOtherPrice():void
{
	if(tiPrice.text == '')
	{
		tiPrice.text = '0.00'
	}
	var price:Number	=	Number(tiPrice.text);
	var markup:Number;
	
	
	markup	= Number(markupa.text);
	tiPrice_a.text = numericFormatter.format(String(price - price*markup/100));
	
	markup	= Number(markupb.text);
	tiPrice_b.text = numericFormatter.format(String(price - price*markup/100));

	markup	= Number(markupc.text);
	tiPrice_c.text = numericFormatter.format(String(price - price*markup/100));

	markup	= Number(markupd.text);
	tiPrice_d.text = numericFormatter.format(String(price - price*markup/100));

	markup	= Number(markupe.text);
	tiPrice_e.text = numericFormatter.format(String(price - price*markup/100));

	markup	= Number(markupf.text);
	tiPrice_f.text = numericFormatter.format(String(price - price*markup/100));

	markup	= Number(markupg.text);
	tiPrice_g.text = numericFormatter.format(String(price - price*markup/100));

	markup	= Number(markuph.text);
	tiPrice_h.text = numericFormatter.format(String(price - price*markup/100));

	markup	= Number(markupi.text);
	tiPrice_i.text = numericFormatter.format(String(price - price*markup/100));

	markup	= Number(markupj.text);
	tiPrice_j.text = numericFormatter.format(String(price - price*markup/100));
	
}
private function dis_perchange():void
{
	var item_amt:Number = Number(tiPrice.text);
	var dis_per:Number  = Number(tiDiscount_per.text);

	if(item_amt > 0)
	{
		if(dis_per > 0)
		{
			tiDiscount_amt.text = numericFormatter.format(Number((item_amt * dis_per) / 100));
		}
		else
		{
			tiDiscount_amt.text = String(0.00);
			tiDiscount_per.text = String(0.00);
		}
	}
}

private function dis_amtchange():void
{
	var item_amt:Number = Number(tiPrice.text);
	var dis_amt:Number  = Number(tiDiscount_amt.text);

	if(item_amt > 0)
	{
		if(dis_amt > 0)
		{
			tiDiscount_per.text = numericFormatter.format(Number((dis_amt / item_amt) * 100));
		}
		else
		{
			tiDiscount_amt.text = String(0.00);
			tiDiscount_per.text = String(0.00);
		}
	}
}
