$('#dialog-new-trunk-link').click(function(){
	$('#dialog-new-trunk').dialog('open');
	return false;
});

$('#dialog-new-trunk').dialog({
	autoOpen: false,
	width: 600,
	bgiframe: false,
	modal: true,
	buttons: {
		"Save": function() {
			var form = $("#new_trunk");
			$.post(form.attr("action"), $(form).serialize(), null, "script");
    	return false;
		},
		"Cancel": function() { 
			$(this).dialog("close"); 
		} 
	}
});

function show_edit_trunk_dialog(trunk_id) {
	$('#dialog-edit-trunk').dialog({
		autoOpen: false,
		width: 600,
		bgiframe: false,
		modal: true,
		buttons: {
			"Save": function() {
				var form = $("#edit_trunk_" + trunk_id);
				$.post(form.attr("action"), $(form).serialize(), null, "script");
	    	return false;
			},
			"Cancel": function() { 
				$("#dialog-edit-trunk").remove();
				$(this).dialog("close"); 
			} 
		}
	});
	$('#dialog-edit-trunk').dialog('open');	
}