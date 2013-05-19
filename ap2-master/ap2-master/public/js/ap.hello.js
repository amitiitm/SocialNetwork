$(function(){
  $(window).bind( 'hashchange', function(e) {
    var url = e.fragment;
		//console.log("url: " + url);
		if (!url) {
			url = "/accounts";
		};
		//console.log("Index of hello:" + window.location.href.indexOf("Hello"));
		if (window.location.href.indexOf("Hello") >= 0) {
			block_ui();
			$.get(url, function(resp){
				//$("#main-loading").fadeOut();
				$.unblockUI();
				$("#response").html(resp);
			});
		};
  })
  $(window).trigger( 'hashchange' );
	$(".hash").live('click', function(e){
		e.preventDefault();
		var link = this;
		if (window.location.href.indexOf("Hello") >= 0) {			
			window.location.href = "#" + $(link).attr("href");
		} else {
			window.location.href = $(link).attr("href");
		}
	});
});