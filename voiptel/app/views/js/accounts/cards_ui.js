$('#dialog-link-new-credit-card').click(function(){
	$("#loading-authorize").hide();
	$('#dialog-new-credit-card').dialog('open');
	return false;
});

$('#dialog-new-credit-card').dialog({
	autoOpen: false,
	width: 600,
	bgiframe: false,
	modal: false,
	buttons: {
		"Save": function() {
			reset_errors("authorize");
			var form = $("#new-credit-card");
			$.post(form.attr("action"), $(form).serialize(), null, "script");
    	return false;
		},
		"Cancel": function() {
			reset_errors("authorize");
			$(this).dialog("close");
		} 
	}
});