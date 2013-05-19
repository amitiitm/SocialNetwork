function calculate_cost(buy, did, value, comission) {
  var balance = value - (value * comission);
  var termination_cost = (buy + did);
  var minutes_for_balance = parseInt((balance / termination_cost));
  var sell_price = (parseFloat(value) / minutes_for_balance);
  return sell_price;
}

function margin_for_cc(sell, buy, did, value, comission){
	var cost = calculate_cost(buy, did, value, comission);
	var margin = (sell - cost) / cost;
	return margin;
}

function save_all_with_routes(){
	var params = [];
	var id;
	$("#loading").fadeIn();
	zones = $("#zones").find("tr");
	for (var i=1; i < zones.length; i++) {
		var zone_params = [];
		var route_params = [];
		zone = zones[i];
		id = $(zone).attr("record_id");
		$(zone).find(".route").each(function(i,dom){
			var priority = $(dom).attr("priority");
			route_params.push(param("routes["+ id +"]["+priority+"][carrier]", $(dom).val()));
			route_params.push(param("routes["+ id +"]["+priority+"][try]", $(dom).attr("try")));
		});
		
		zone_params.push(param("zones[" + id + "][name]", find_html_value(zone, "#name")));
		zone_params.push(param("zones[" + id + "][prefix]", find_html_value(zone, "#prefix")));
		var buy = find_html_value(zone, "#buy");
		buy = parseFloat(buy) / 100;
		var sell = find_html_value(zone, "#sell");
		sell = parseFloat(sell) / 100;
		
		var cc_sell = find_html_value(zone, "#cc_sell");
		cc_sell = parseFloat(cc_sell) / 100;
		
		
		zone_params.push(param("zones[" + id + "][buy_rate]", buy));
		zone_params.push(param("zones[" + id + "][sell_rate]", sell));
		zone_params.push(param("zones[" + id + "][cc_sell_rate]", cc_sell));
		var published = 0;
		if ($(zone).find("#publish").attr("checked")) {
			published = 1;
		};
		zone_params.push(param("zones[" + id + "][publish]", published));
		params.push(zone_params.join("&"));
		params.push(route_params.join("&"));
	};
	
	params = params.join("&");
	$.post("/zones/save_all", params);
	
}

function save(obj){
	$("#loading").fadeIn();
	dom = obj;
	var zone = $(obj).parent().parent();
	var params = [];
	var id = $(zone).attr("record_id");
	params.push(param("zone[name]", find_html_value(zone, "#name")));
	params.push(param("zone[prefix]", find_html_value(zone, "#prefix")));
	var buy = find_html_value(zone, "#buy");
	buy = parseFloat(buy) / 100;
	var sell = find_html_value(zone, "#sell");
	sell = parseFloat(sell) / 100;
	
	var cc_sell = find_html_value(zone, "#cc_sell");
	cc_sell = parseFloat(cc_sell) / 100;
	
	params.push(param("zone[buy_rate]", buy));
	params.push(param("zone[sell_rate]", sell));
	params.push(param("zone[cc_sell_rate]", cc_sell));
	
	var published = 0;
	if ($(zone).find("#publish").attr("checked")) {
		published = 1;
	};
	params.push(param("zone[publish]", published));
	params = params.join("&");
	
	$.put("/zones/" + id, params);
}
function save_all() {
	var params = [];
	$("#loading").fadeIn();
	zones = $("#zones").find("tr");
	for (var i=1; i < zones.length; i++) {
		var zone_params = [];
		zone = zones[i];
		var id = $(zone).attr("record_id");
		zone_params.push(param("zones[" + id + "][name]", find_html_value(zone, "#name")));
		zone_params.push(param("zones[" + id + "][prefix]", find_html_value(zone, "#prefix")));
		var buy = find_html_value(zone, "#buy");
		buy = parseFloat(buy) / 100;
		var sell = find_html_value(zone, "#sell");
		sell = parseFloat(sell) / 100;
		
		var cc_sell = find_html_value(zone, "#cc_sell");
		cc_sell = parseFloat(cc_sell) / 100;
		
		zone_params.push(param("zones[" + id + "][buy_rate]", buy));
		zone_params.push(param("zones[" + id + "][sell_rate]", sell));
		zone_params.push(param("zones[" + id + "][cc_sell_rate]", cc_sell));
		var published = 0;
		if ($(zone).find("#publish").attr("checked")) {
			published = 1;
		};
		zone_params.push(param("zones[" + id + "][publish]", published));
		params.push(zone_params.join("&"));
	};
	
	params = params.join("&");
	
	$.post("/zones/save_all", params);
}

function delete_all() {
	if (confirm("Are you sure you want to delete selected zones?")) {
		$("#loading").fadeIn();
		ids = selected_rows("#zones");
		ids = "ids=" + ids.join(",");
		$.post("/zones/delete_all", ids, function(resp){
			eval(resp);
		})
	};
}

function buy_updated(id) {
	var zone = $("#zone-" + id);

	var buy_dom = zone.find("#buy");
	var buy = parseFloat(buy_dom.html());

	var margin_dom = zone.find("#margin");
	var sell_dom = zone.find("#sell");
	var sell = parseFloat(sell_dom.html());
	var margin = parseFloat(margin_dom.html());
	sell = (buy * (margin / 100)) + buy;
		
	var cc_margin_dom = zone.find("#cc_margin");
	var cc_sell_dom = zone.find("#cc_sell");
	var cc_sell = parseFloat(cc_sell_dom.html());
	var cc_margin = parseFloat(cc_margin_dom.html());
	var cost = (calculate_cost((buy / 100) , 0.002, 5, 0.4) * 100);
	cc_sell = (cost * (cc_margin / 100)) + cost;
	
	sell_dom.html(sell.toFixed(2));
	sell_dom.addClass("changed");
	
	cc_sell_dom.html(cc_sell.toFixed(2));
	cc_sell_dom.addClass("changed");
}

function sell_updated(id) {
	var zone = $("#zone-" + id);
	var buy_dom = zone.find("#buy");
	var margin_dom = zone.find("#margin");
	var sell_dom = zone.find("#sell");
	var sell = parseFloat(sell_dom.html());
	var margin = parseFloat(margin_dom.html());
	var buy = parseFloat(buy_dom.html());
	
	margin = ((sell - buy) / buy) * 100;
	
	margin_dom.html(margin.toFixed(2));
	margin_dom.addClass("changed");
}

function margin_updated(id) {
	var zone = $("#zone-" + id);
	var buy_dom = zone.find("#buy");
	var margin_dom = zone.find("#margin");
	var sell_dom = zone.find("#sell");
	//var old_sell = parseFloat(sell_dom.html());
	var margin = parseFloat(margin_dom.html());
	var buy = parseFloat(buy_dom.html());
	
	sell = (buy * (margin / 100)) + buy;
	
	sell_dom.html(sell.toFixed(2));
	sell_dom.addClass("changed");		
}

function cc_sell_updated(id) {
	var zone = $("#zone-" + id);
	var buy_dom = zone.find("#buy");
	var margin_dom = zone.find("#cc_margin");
	var sell_dom = zone.find("#cc_sell");
	
	var sell = parseFloat(sell_dom.html());
	var margin = parseFloat(margin_dom.html());
	var buy = parseFloat(buy_dom.html());
	
	margin = (margin_for_cc((sell / 100), (buy / 100), 0.002, 5, 0.4)) * 100;
	
	margin_dom.html(margin.toFixed(2));
	margin_dom.addClass("changed");
}

function cc_margin_updated(id) {
	var zone = $("#zone-" + id);
	var buy_dom = zone.find("#buy");
	var margin_dom = zone.find("#cc_margin");
	var sell_dom = zone.find("#cc_sell");

	var margin = parseFloat(margin_dom.html());
	var buy = parseFloat(buy_dom.html());
	
	//sell = (buy * (margin / 100)) + buy;
	var cost = (calculate_cost((buy / 100) , 0.002, 5, 0.4) * 100);
	var sell = (cost * (margin / 100)) + cost;
	
	sell_dom.html(sell.toFixed(2));
	sell_dom.addClass("changed");
}
