$(".observe-publish").live("change", function(event){
	var id = $(this).attr("record-id");
	publish = $(this).attr("checked");
	var params = "v2_country[publish]=" + publish
	$.put("/v2_countries/" + id, params, null, "script");
});