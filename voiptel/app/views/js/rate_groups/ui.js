$('#dialog-new-rate-group-link').click(function(){
	$('#dialog-new-rate-group').dialog('open');
	return false;
});

$('#dialog-new-rate-group').dialog({
	autoOpen: false,
	width: 600,
	bgiframe: false,
	modal: false,
	buttons: {
		"Save": function() {
			var form = $("#new_rate_group");
			$.post(form.attr("action"), $(form).serialize(), null, "script");
    	return false;
		},
		"Cancel": function() { 
			$(this).dialog("close"); 
		} 
	}
});