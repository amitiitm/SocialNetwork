$('#dialog-new-endpoint-link').click(function(){
	$('#dialog-new-endpoint').dialog('open');
	return false;
});

$('#dialog-new-endpoint').dialog({
	autoOpen: false,
	width: 600,
	bgiframe: false,
	modal: false,
	buttons: {
		"Save": function() {
			var form = $("#new_endpoint");
			$.post(form.attr("action"), $(form).serialize(), null, "script");
    	return false;
		},
		"Cancel": function() { 
			$(this).dialog("close"); 
		} 
	}
});

function show_edit_endpoint_dialog(endpoint_id) {
	$('#dialog-edit-endpoint').dialog({
		autoOpen: false,
		width: 600,
		bgiframe: false,
		modal: true,
		buttons: {
			"Save": function() {
				var form = $("#edit_endpoint_" + endpoint_id);
				$.post(form.attr("action"), $(form).serialize(), null, "script");
	    	return false;
			},
			"Cancel": function() { 
				$("#dialog-edit-endpoint").remove();
				$(this).dialog("close"); 
			} 
		}
	});
	$('#dialog-edit-endpoint').dialog('open');	
}