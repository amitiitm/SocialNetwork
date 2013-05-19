var height_updated = false;
function update_cm() {
	$.get("/service/calls_monitor", {}, function(response){
		$("#cm").html(response);
	});
}

$(document).ready(function(){
	setInterval(update_cm, 1000);
});
