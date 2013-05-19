$(function(){
	var cs = new Juggernaut({host: window.location.host });	

	cs.subscribe("cs", function(data){
	  call_comming(data)
	});
	window.cs = cs;
});

function call_comming(data) {
	var type;
	var url;
	if (data.type == "ac") {
		type = "AC Customer:";
		url = "accounts";
	} else if(data.type == "hc") {
		type = "HC Customer:";
		url = "accounts";
	} else {
		type = "CC Customer:";
		url = "cards";
	};
	
	var msg = 'Somebody pickup!<br>' + type + '<br><a style="color:white;font-weight:bold;text-decoration: underline" href="/' + url + '/' + data.id + '">' + data.info + '</a><br>Phone: ' + data.phone;
	
	var unique_id = $.gritter.add({		
		title: 'Incoming Call!',
		text: msg,
		image: '/images/tree.png',
		sticky: false,
		time: 15000
	});
}