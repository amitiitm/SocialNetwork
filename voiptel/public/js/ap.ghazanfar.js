var khan_gholi_morad = new function() {
	this.working = false;
	this.progress_template = '<div id="job-_ID_"><div class="left kgm-progress-bar" id="progress-job-_ID_"></div><div class="left" id="status-job-_ID_"></div></div><br><br>';
}



var jobs = new Hashtable();
var json;

function get_jobs() {
	$.get("/jobs", {}, function(r){
		json = JSON.parse(r);
		for (var i=0; i < json.length; i++) {
			var job_id = json[i].active_jobs.id;
			jobs.put("job-" + job_id, {handler: null, id: job_id});
		};
		start_monitor();
	}, null);
}

function update_job_status(jid){
	$.get("/jobs/" + jid, {}, function(r){
		job = JSON.parse(r).active_jobs;
		var percentage = parseInt((job.progress/job.tasks) * 100);
		if (percentage != 0 && !isNaN(percentage)) {
			$('#progress-job-' + job.id).progressBar(percentage);
			$('#status-job-' + job.id).html(job.status);
		};
		if (job.state >= 2) {
			clearInterval(jobs.get("job-" + job.id).handler);
			//alert("salam");
		};		
		// if ((job.progress != job.tasks) || job.tasks == 0) {
		// 	//return update_job_status(jid);
		// 	return;
		// } else {
		// 	return true;
		// }
	}, null);
}

function start_monitor() {
	jobs.each(function(k, v){
		v.handler = setInterval("update_job_status(" + v.id + ")", 500);
		var template = khan_gholi_morad.progress_template.replace(/_ID_/g, v.id);
		
		$("#khan-gholi-morad").append(template);
		$("#progress-job-" + v.id).progressBar(0, {
			boxImage	: '/images/progressbar.gif',
			barImage	: {
				0:  '/images/progressbg_red.gif',
				30: '/images/progressbg_orange.gif',
				60: '/images/progressbg_green.gif'
			}
		});
		//$('#job-' + v.id).progressBar(0);			
		//update_job_status(v.id);
		//console.log(v.id);
	});
}

function stop_monitor() {
	jobs.each(function(k, v) {
		//alert(v.hanlder);
		clearInterval(v.handler);
	});
}

function show_khan_gholi_morad(){
	window.scrollTo(0, document.body.scrollHeight);
	$("#khan-gholi-morad-portlet").fadeIn('slow', function(){
		$("#khan-gholi-morad").html("").queue(function(){
			get_jobs();
			$("#khan-gholi-morad").dequeue();
		});
	});
	//start_monitor();
}

function hide_khan_gholi_morad() {
	$("#khan-gholi-morad").fadeOut();
	stop_monitor();
}

function is_khan_gholi_morad_working(){	
	$.get("/jobs/has_job", function(resp){
		data = JSON.parse(resp);
		if (data.has_job) {
			khan_gholi_morad.working = true;
			if($("#khan-gholi-morad-btn").css("display") == "none") {
				$("#khan-gholi-morad-btn").fadeIn('slow');
			}
		} else {
			if($("#khan-gholi-morad-btn").css("display") != "none") {
				$("#khan-gholi-morad-btn").fadeOut('slow');
			}
			khan_gholi_morad.working = false;
		};
	});
	return;
}

function sleep(millis)
{
	var date = new Date();
	var curDate = null;

	do { curDate = new Date(); }
	while(curDate-date < millis);
}

function sarekari() {
	return;
}

function highlight_khan_gholi_morad(){
	 $("#khan-gholi-morad-btn").effect("highlight");
}

$(document).ready(function(){
	//is_khan_gholi_morad_working();
	//$.timer(10000, is_khan_gholi_morad_working);
});