var initial_height;

function dialog_opened() {
	var parent = $(".dialog").parent();
	initial_height = parent.height();
	parent.css("bottom", "25%");
	parent.css("top", "");
	parent.css("position", "absolute");
}

function dialog_width() {
	var width = $(".dialog").attr("width");
	if (!width || width == "") {
		width = 500;
	};
	return parseInt(width);
}

function dialog_position(){
	alert("salam");
}

function dialog_error(req, status, err){
	$('.dialog').find("#loading").fadeOut();
	eval(req.responseText);
	$('.dialog').find("#error-messages").html(errors);
	$('.dialog').find("#error").fadeIn();
}

function dialog_success(data, status, req) {
	$(".dialog").remove();
}

// open: function(event, ui) { dialog_opened(); },
// dragStop: function(event, ui) { $(".dialog").parent().height(initial_height); },

$('.dialog').dialog({
	autoOpen: true,
	width: dialog_width,
	bgiframe: false,
	modal: false,
	buttons: {
		"Save": function() {
			$(this).find("#loading").fadeIn();
			var form = $($(this).find(".forms")[0]);
			$.ajax({
				type: 'POST',
				url: form.attr("action"),
				data: $(form).serialize(),
				success: dialog_success,
				error: dialog_error
			});
			//$(this).dialog("close");
			//$(this).remove();
    	return false;
		},
		"Cancel": function() { 
			$(this).dialog("close");
			$(this).remove();
		} 
	}
});