$(".observe-publish").live("change", function(event){
	var id = $(this).attr("record-id");
	publish = $(this).attr("checked");
	var params = "testimonial[publish]=" + publish
	$.put("/testimonials/" + id, params, null, "script");
});