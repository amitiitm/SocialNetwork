var search_items = [];
var result_pos;
function close_sirch_box() {
	$("#sirch #gleeSearchField").blur();
	$("#sirch").fadeOut();
	$("#sirch #gleeSearchField").val("");
	$("#gleeSubText").html("");
}
$(function(){	
	$("#sirch #gleeSearchField").keyup(function(e){
		if(e.keyCode == 40) {
			result_pos = 0;
			search_items = $("#gleeSubText").find("li");
			$("#sirch #gleeSearchField").blur();
			$(search_items[result_pos]).addClass("result-selected");			
			return false;
		}
		
		if (e.keyCode == 27) {
			close_sirch_box();
			return false;
		}
		
		var q = $("#gleeSearchField").val();
		if(q.length == 0) {$("#gleeSubText").html(""); return;}
		if (q.length > 3) {
			$.get("/service/live", ("q=" + q), function(resp){
				$("#gleeSubText").html(resp);
			});
		}		
	});

    $("#ssirch #gleeSearchField").keyup(function(e){
        if(e.keyCode == 40) {
            result_pos = 0;
            search_items = $("#gleeSubText").find("li");
            $("#sirch #gleeSearchField").blur();
            $(search_items[result_pos]).addClass("result-selected");
            return false;
        }

        if (e.keyCode == 27) {
            close_sirch_box();
            return false;
        }

        var q = $("#gleeSearchField").val();
        if(q.length == 0) {$("#gleeSubText").html(""); return;}
        if (q.length > 3) {
            $.get("/service/live", ("q=" + q), function(resp){
                $("#gleeSubText").html(resp);
            });
        }
    });
});