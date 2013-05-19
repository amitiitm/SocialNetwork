function dialog_width() {
	var width = $(".dialog").attr("dialog-width");
	if (!width || width == "") {
		width = 500;
	};

	return parseInt(width);
}

$('.dialog').dialog({
	autoOpen: true,
	width: dialog_width,
	bgiframe: false,
	modal: false,
	buttons: {
		"Close": function() { 
			$(this).dialog("close");
			$(this).remove();
		} 
	}
});