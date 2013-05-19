/*$(document).ready(function() {
	$('#table').dataTable( {
		"bProcessing": true,
		 "sAjaxSource": 'accounts/list.json'		
	});
	
	/*link_to_remote = function() {
		alert(this);
		return false;
	}*/

/*	$(".next_action").live("click", function() {
		$.post(this.href);
		return false;
	});	 
});
*/

$(document).ready(function() {
    /* Table Sorter */
		
    /*$("#table")
    .tablesorter({
        widgets: ['zebra'],
        headers: {
            // assign the secound column (we start counting zero)
            0: {
                // disable it by setting the property sorter to false
                sorter: false
            },
            // assign the third column (we start counting zero)
            6: {
                // disable it by setting the property sorter to false
                sorter: false
            }
        }
    })

    .tablesorterPager({
        container: $("#pager")
    });

    $(".header").append('<span class="ui-icon ui-icon-carat-2-n-s"></span>');
});*/

var checkflag = "false";

function check(field) {
    if (checkflag == "false") {
        for (i = 0; i < field.length; i++) {
            field[i].checked = true;
        }
        checkflag = "true";
        return "check_all";
    } else {
        for (i = 0; i < field.length; i++) {
            field[i].checked = false;
        }
        checkflag = "false";
        return "check_none";
    }
}
