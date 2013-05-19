// account type, handling businss name
$("#account_account_type").change(function() {
	var type = $("#account_account_type").val();
	if (type == "1") {
		$("#business_name").fadeOut();
		$("#account_business_name").val("");
	} else{
		$("#business_name").fadeIn();
	};
});

// auto recharge
$("#account_auto_recharge").change(function() {
	var type = $("#account_auto_recharge").val();
	if (type == "true") {
		$("#threshold").fadeIn();
		$("#recharge_amount").fadeIn();		
	} else{
		$("#threshold").fadeOut();
		$("#recharge_amount").fadeOut();
	};
});