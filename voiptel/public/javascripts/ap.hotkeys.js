function sirch_box() {
	$("#sirch").fadeIn('fast', function(){
		$("#sirch #gleeSearchField").focus();
	});
	return false;
}

function bind_hot_keys(){
	$(document).bind('keyup', function(e){
		if (e.keyCode == 83) {
			sirch_box();
			return false;
		} else if(e.keyCode == 77) {
			toggle_panel();
		} else if(e.keyCode == 40) {
			if ($(".result-selected").exists()) {
				result_pos++;
				$(".result-selected").removeClass("result-selected");
				$(search_items[result_pos]).addClass("result-selected");
				$("#sirch").scrollTop($(search_items[result_pos]).position().top - $(search_items[result_pos]).height());
				return false;
			}
		} else if(e.keyCode == 38) {
			result_pos--;
			if (result_pos == 0) {
				$("#sirch #gleeSearchField").focus();
				var val = $("#sirch #gleeSearchField").val();				
				$("#sirch #gleeSearchField").get(0).setSelectionRange(val.length, val.length);
			};			
			$(".result-selected").removeClass("result-selected");
			$(search_items[result_pos]).addClass("result-selected");
			$("#sirch").scrollTop($(search_items[result_pos]).position().top - $(search_items[result_pos]).height());
			return false;
		} else if (e.keyCode == 27) {
			$("#sirch #gleeSearchField").blur();
			$("#sirch").fadeOut();
			$("#sirch #gleeSearchField").val("");
			$("#gleeSubText").html("");
			return false;
		} else if(e.keyCode == 13) {
			if ($(".result-selected").exists()) {
				var a = $(".result-selected").find("a");				
				$(a).trigger('click');
				$("#sirch #gleeSearchField").blur();
				$("#sirch").fadeOut();
				$("#sirch #gleeSearchField").val("");
				$("#gleeSubText").html("");
			};
		}
		
		console.log("key: " + e.keyCode);
	});
}

function unbind_hot_keys() {
	$(document).unbind('keyup');
}

$(function(){
	bind_hot_keys();
	$("input").live('focus', function(){
		unbind_hot_keys();
	});
	
	$("input").live('blur', function(){
		bind_hot_keys();
	});
	
	bind_hot_keys();
	$("textarea").live('focus', function(){
		unbind_hot_keys();
	});
	
	$("textarea").live('blur', function(){
		bind_hot_keys();
	});
	
})