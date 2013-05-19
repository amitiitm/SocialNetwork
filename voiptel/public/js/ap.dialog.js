/*$('.dialog-link').click(function(){
	var dialog = $(this).attr("dialog");
	$("#" + dialog).dialog('open');
	return false;
});*/

$('.dialog').dialog({
	autoOpen: true,
	//width: false,
	bgiframe: false,
	modal: true,
	buttons: {
		"Save": function() {
			var form = $($(this).find(".forms")[0]);
			$.post(form.attr("action"), $(form).serialize(), null, "script");
			$(this).dialog("close");
			$(this).remove();
    	return false;
		},
		"Cancel": function() { 
			$(this).dialog("close");
			$(this).remove();
		} 
	}
});

function dialog_width(el) {
	var width = $(el).attr("dialog-width");
	alert(width);
	if (!width) {
		width = "600";
	};
	return width;
}