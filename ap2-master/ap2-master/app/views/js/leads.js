function leads() {
	var checked = [];
	$('.lead-check').each(function(index, val){
		if ($(val).attr('checked')) {
			str = $(val).attr('name') + "=1";
			checked.push(str);
		};
	});
	return checked.join("&");
}
$(function(){
	$('#check_all').change(function(){
		var check = $(this).attr('checked');
		$('.lead-check').attr('checked', check);
	});
});