var di = 0;

function number_to_phone(number) {
    return "(" + number.substring(1, 4) + ")" + number.substring(4, 7) + "-" + number.substring(7);
}

function convert_to_ac() {
    var container;
    var params;
    if ($("#memoable-container").exists()) {
        container = "#memoable-container";
    } else {
        container = "#response";
    }
    ;

    if ($("#memo_status").exists()) {
        $("#memo_status").val("3");
        $("#memo_tmp_success").val("true");
        $("#status").fadeIn();
    }
    ;

    params = $("#convertable_fields").serialize();

    if ($("#in_memo_page").exists()) {
        params += "&from_memo=yup";
    }
    ;

    $.get("/accounts/new", params, function (resp) {
        $(container).html(resp);
    });
}

function reset_memo_page() {
    if ($("#in_memo_page").exists()) {
        $("#memo-stuff").fadeOut(function () {
            $("#portlet_memos").find(".portlet-content").toggle('slow');
            $("#memo-stuff").html("");
        });
    }
}

function play(url) {
    var a = new Audio(url);
    a.controls = true;
    $("#player").html(a);
    a.play();
}

function call_number(dom) {
    var phone_text
    var number;
    var params = [];

    if ($(dom).is("a")) {
        phone_text = $(dom).text();
    } else if ($(dom).is("select")) {
        phone_text = $(dom + " :selected").text();
    }
    ;
    number = extract_phone(phone_text);

    params.push(param("phone", number));
    params.push(param("ext", $("#ext").val()));
    params.push(param("cid", "19493257005"));
    params.push(param("args", $(dom).attr("args")));
    $.get("http://pbx.voipontel.com:88/service/call", params.join("&"));
}
function toggle_panel() {
    $(".panel").toggle("fast");
}

function top_toggle_panel() {
    $(".toppanel").toggle("fast");
}

function extract_phone(text) {
    return text.replace(/\D*/g, "");
}

function block_ui() {
    $.blockUI({
        message:"<h1>Loading...</h1>",
        fadeIn:0,
        showOverlay:false,
        css:{
            right:'2%',
            top:'17%',
            left:'91%',
            border:'none',
            padding:'15px',
            backgroundColor:'#000',
            '-webkit-border-radius':'10px',
            '-moz-border-radius':'10px',
            opacity:.5,
            color:'#fff',
            width:'5%'
        }
    });
}

function form_error(req, status, err) {
    jQuery(this).find("#loading").fadeOut();
    eval(req.responseText);
    var error_messages_dom = jQuery(this).find("#error-messages");
    var error_dom = jQuery(this).find("#error");
    error_messages_dom.html(errors);
    error_dom.fadeIn();
}

function submit_form(form) {
    jQuery.ajax({
        type:'POST',
        url:form.attr("action"),
        data:form.serialize(),
        context:form,
        success:form_success,
        error:form_error
    });
}

function form_success(data, status, req) {

}

function default_reload(path, selector) {
    if (!selector) {
        if (jQuery("#update-me").exists()) {
            selector = "#update-me"
        } else {
            selector = "#response";
        }
        ;
    }
    ;
    jQuery.get(path, function (resp) {
        jQuery(selector).html(resp);
        hack_hack_hack();
    });
}

function fix_height() {
    var windowHeight = window.innerHeight - 150;
    var sidebarHeight = $("#sidebar").height();
    if (sidebarHeight > windowHeight) {
        height = sidebarHeight;
    } else {
        height = windowHeight;
    }
    ;

    $("#page-content-wrapper").css({"minHeight":window.height });
}

function selected_rows(dom) {
    var selected = [];
    $(dom).find(".select-row").each(function (index, checkbox) {
        if ($(checkbox).attr("checked")) {
            selected.push($(checkbox).attr("record_id"));
        }
        ;
    });
    if (selected.length == 0) {
        return false;
    } else {
        return selected;
    }
    ;
}

function param(key, value) {
    return key + "=" + value;
}

function find_html_value(dom, selector) {
    return $(dom).find(selector).html();
}

function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).closest(".fields").hide();
}

function reload_filter() {
    if ($("#form_filter").exists()) {
        $("#loading-filter").fadeIn(function () {
            var form = $("#ghatogh");
            var url = $("#pager").find("input[name=url]").val();
            var params = form.serialize();
            var form_filter = $("#form_filter");

            if (form_filter) {
                params += "&" + form_filter.serialize();
            }
            ;
            $.get(url, params, function (response) {
                $('.inner-response').html(response);
            });
        });
    } else {
        window.location.reload();
    }
    ;
}

function ajax_delete(em) {
    url = $(em).closest('.forms').attr("action");
    if (confirm("Are you sure you want to delete?")) {
        $.delete_(url, {}, null, "script");
    }
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(link).before(content.replace(regexp, new_id));
}

function reset_errors(id, options) {
    if ($("#loading-" + id).exists()) {
        $("#loading-" + id).fadeIn('slow');
    }
    ;

    if ($("#" + id).exists()) {
        $("#" + id + "-messages").html("");
        $("#" + id).fadeOut('slow');
    }
    ;
}

function errors(messages, id, options) {
    $("#" + id).parent().find("#loading").hide();
    $("#" + id + "-messages").html(messages);
    $("#" + id).fadeIn('slow');
}

jQuery.ajaxSetup({
    'beforeSend':function (xhr) {
        xhr.setRequestHeader("Accept", "text/javascript");
    }
});

function close_sidebar() {

    // $("#sidebar").addClass('closed-sidebar');
    // $(".inner-page-title").addClass("move-right");
    // $("#page_wrapper #page-content #page-content-wrapper").addClass("no-bg-image wrapper-full");
    // $("#open_sidebar").show();
    // $("#close_sidebar, .hide_sidebar").hide();
}

function open_sidebar() {
    $("#sidebar").removeClass('closed-sidebar');
    $(".inner-page-title").removeClass("move-right");
    $("#page_wrapper #page-content #page-content-wrapper").removeClass("no-bg-image wrapper-full");
    $("#open_sidebar").hide();
    $("#close_sidebar, .hide_sidebar").show();
}

$(document).ready(function () {
    $(function () {
        $(".listen").live('click', function (e) {
            e.preventDefault();
            play($(this).attr('href'));
        });
    });

    $(".callable").live("click", function (e) {
        e.preventDefault();
        call_number(this);
        return false;
    });

    $(".callable1").live("click", function (e) {
        e.preventDefault();
        call_number(this);
        var id = $(this).attr('id')
        var url = "/accounts/" + id
        setTimeout(function () {
            if ((id == null) || (id == "") || (id == "#" ))
            {}
            else
            return  window.location.href = url

        }, 3000);
        return false;
    });

    $("#khan-gholi-morad-btn").hide();
    $("#khan-gholi-morad-portlet").hide();

    jQuery.fn.exists = function () {
        return jQuery(this).length > 0;
    }

    //sidebar accordion
    $(".accordion_sidebar").accordion({
        collapsible:true,
        autoHeight:false,
        active:false
    });

    $('.accordion_sidebar').live('accordionchange', function (event, ui) {
        var active = ($(ui.newHeader).attr('order'));
        $.cookie('active_sidebar', active);
    });

    function _ajax_request(url, data, callback, type, method) {
        if (jQuery.isFunction(data)) {
            callback = data;
            data = {};
        }
        return jQuery.ajax({
            type:method,
            url:url,
            data:data,
            success:callback,
            dataType:type
        });
    }

    jQuery.extend({
        put:function (url, data, callback, type) {
            return _ajax_request(url, data, callback, type, 'PUT');
        },
        delete_:function (url, data, callback, type) {
            return _ajax_request(url, data, callback, type, 'DELETE');
        }
    });


    $('.ajax-delete').live('click', function (event) {
        event.preventDefault();
        var callback = $(this).attr("callback");
        if (confirm("Are you sure you want to delete?")) {
            $.delete_(this.href, {}, function (resp) {
                if (callback) {
                    eval(callback + "(resp)");
                } else {
                    eval(resp);
                }
                ;
            }, null);
        }
    });

    $(".fn").live('click', function (event) {
        event.preventDefault();
        eval($(this).attr("function"));
    });

    $('.ajax').live('click', function (event) {
        event.preventDefault();
        var ajax = $(this).attr("ajax");
        var update = $(this).attr("update");
        if (!update) {
            update = "dev_null";
        }
        ;
        $.get($(this).attr("href"), {}, function (response) {
            if (ajax == "eval") {
                eval(response);
                return false;
            } else {
                if (update) {
                    if ($("#" + update).css("display") == "none") {
                        $("#" + update).show();
                    }
                    ;
                    $('#' + update).html(response);
                } else {
                    $('#response').html(response);
                }
                ;
            }
        });
    });

    $(".link").live('click', function (event) {
        event.preventDefault();
        var url = $(this).attr("url");
        window.location.href = url;
    });

    $('.ajax-post').live('click', function (event) {
        event.preventDefault();
        var ajax = $(this).attr("ajax");
        var update = $(this).attr("update");
        $.post($(this).attr("href"), {}, function (response) {
            if (ajax == "eval") {
                eval(response);
                return false;
            } else {
                if (update) {
                    $('#' + update).html(response);
                } else {
                    $('#response').html(response);
                }
                ;
            }
        });
    });


    $('.inner-ajax').live('click', function (event) {
        var indicator = $(this).attr("indicator");
        if (indicator) {
            $("#loading-" + indicator).fadeIn('slow');
        }
        ;
        event.preventDefault();
        $.get(this.href, {}, function (response) {
            $('.inner-response').html(response);
        });
    });

    //////// pager
    $('.pager-limit').live('change', function (event) {

        var limit = $(this).val();
        var form = $(this).siblings("form");

        var current_limit = form.children("#limit").val();
        var current_page = form.children("#page").val();
        var size = form.children("#size").val();

        var start = ((current_page - 1) * current_limit) + 1;
        var end = (current_page * current_limit);

        //alert("start: " + start + " end:" + end);


        form.children("#limit").val(limit);
        var indicator = $($(this).siblings(".pager-link")[0]).attr("indicator");
        if (indicator) {
            $(this).siblings("#loading-" + indicator).fadeIn('slow');
        }
        ;
        var url = $(this).siblings("input[name=url]").val();
        var params = form.serialize();
        var form_filter = $("#form_filter");
        if (form_filter) {
            params += "&" + form_filter.serialize();
        }
        ;

        $.get(url, params, function (response) {
            $('.inner-response').html(response);
        });
    });

    $('.pager-link').live('click', function (event) {
        event.preventDefault();
        var form = $(this).siblings("form");
        var page = $(this).attr("page");
        if (page == "next") {
            var page_num = parseInt(form.children("[name=page]").val()) + 1;
        } else {
            var page_num = parseInt(form.children("[name=page]").val()) - 1;
        }
        ;
        form.children("[name=page]").val(page_num);
        var indicator = $(this).attr("indicator");
        if (indicator) {
            $(this).siblings("#loading-" + indicator).fadeIn('slow');
        }
        ;
        var url = $(this).siblings("input[name=url]").val();
        var params = form.serialize();
        var form_filter = $("#form_filter");
        if (form_filter) {
            params += "&" + form_filter.serialize();
        }
        ;
        $.get(url, params, function (response) {
            $('.inner-response').html(response);
        });
    });

    $("#filter_reload").live('click', function (event) {
        event.preventDefault();
        reload_filter();
    });

    // forms
    $(".forms").live('submit', function () {
        var error_message_dom = jQuery(this).find("#error-messages");
        error_message_dom.html("");
        var error_dom = jQuery(this).find("#error");
        var form = jQuery(this);
        jQuery(this).find("#loading").fadeIn();
        jQuery(this).find(".loading").fadeIn();
        if (error_dom.exists()) {
            error_dom.fadeOut(function () {
                submit_form(form);
            });
        } else {
            submit_form(form);
        }
        ;
        return false;
    });

    // Navigation menu

    // Live Search

    jQuery('#search-bar input[name="q"]').liveSearch({url:'/service/live?q='});

    //Hover states on the static widgets

    $('.ui-state-default').hover(
        function () {
            $(this).addClass('ui-state-hover');
        },
        function () {
            $(this).removeClass('ui-state-hover');
        }
    );

    //Sortable portlets


    //Sidebar only sortable boxes
    $(".side_sort").sortable({
        axis:'y',
        cursor:"move",
        connectWith:'.side_sort'
    });


    //Close/Open portlets
    $(".portlet-header").hover(function () {
            $(this).addClass("ui-portlet-hover");
        },
        function () {
            $(this).removeClass("ui-portlet-hover");
        });

    $(".portlet-header .ui-icon").live('click', function () {
        $(this).toggleClass("ui-icon-circle-arrow-n");
        $(this).parents(".portlet:first").find(".portlet-content").toggle();
    });


    // Sidebar close/open (with cookies)


    $('#close_sidebar').click(function (e) {
        e.preventDefault();
        close_sidebar();
        if ($.browser.safari) {
            //location.reload();
            var width = $('#page-content-wrapper').width();
            //$('#response').width(width);
            $('#response').css({'maxWidth':width});
        }
        $.cookie('sidebar', 'closed');
        $(this).addClass("active");
    });

    $('#open_sidebar').click(function (e) {
        e.preventDefault();
        open_sidebar();
        if ($.browser.safari) {
            //location.reload();
            var width = $('#page-content-wrapper').width();
            //$('#response').width(width);
            $('#response').css({'maxWidth':width});
        }
        $.cookie('sidebar', 'open');
    });

    var sidebar = $.cookie('sidebar');

    if (sidebar == 'closed') {
        close_sidebar();
    }

    if (sidebar == 'open') {
        open_sidebar();
    }

    /* Tooltip */

    /*	$(function() {
     });
     */
    /*		$('.tooltip').tooltip({
     track: true,
     delay: 0,
     showURL: false,
     showBody: " - ",
     fade: 250
     });
     */
    /* Theme changer - set cookie */

    $(function () {

        $('a.set_theme').click(function () {
            var theme_name = $(this).attr("id");
            $('body').append('<div id="theme_switcher" />');
            $('#theme_switcher').fadeIn('fast');

            setTimeout(function () {
                $('#theme_switcher').fadeOut('fast');
            }, 2000);

            setTimeout(function () {
                $("link[title='style']").attr("href", "/css/themes/" + theme_name + "/ui.css");
            }, 500);

            $.cookie('theme', theme_name);

            $('a.set_theme').removeClass("active");
            $(this).addClass("active");

        });

        var theme = $.cookie('theme');

        $("a.set_theme[id=" + theme + "]").addClass("active");

        if (theme == 'black_rose') {
            $("link[title='style']").attr("href", "/css/themes/black_rose/ui.css");

        }

        if (theme == 'gray_standard') {
            $("link[title='style']").attr("href", "/css/themes/gray_standard/ui.css");
        }

        if (theme == 'gray_lightness') {
            $("link[title='style']").attr("href", "/css/themes/gray_lightness/ui.css");
        }

        if (theme == 'blueberry') {
            $("link[title='style']").attr("href", "/css/themes/blueberry/ui.css");
        }

        if (theme == 'apple_pie') {
            $("link[title='style']").attr("href", "/css/themes/apple_pie/ui.css");
        }

    });

    /* Layout option - Change layout from fluid to fixed with set cookie */

    $(function () {

        $('.layout-options a').click(function () {
            var lay_id = $(this).attr("id");
            $('body').attr("class", lay_id);
            $("#page-layout, #page-header-wrapper, #sub-nav").addClass("fixed");
            $.cookie('layout', lay_id);
            $('.layout-options a').removeClass("active");
            $(this).addClass("active");
        });

        var lay_cookie = $.cookie('layout');

        $(".layout-options a[id=" + lay_cookie + "]").addClass("active");

        if (lay_cookie == 'layout100') {
            $('body').attr("class", "");
            $("#page-layout, #page-header-wrapper, #sub-nav").removeClass("fixed");
        }

        if (lay_cookie == 'layout90') {
            $('body').attr("class", "layout90");
            $("#page-layout, #page-header-wrapper, #sub-nav").addClass("fixed");
        }

        if (lay_cookie == 'layout75') {
            $('body').attr("class", "layout75");
            $("#page-layout, #page-header-wrapper, #sub-nav").addClass("fixed");
        }

        if (lay_cookie == 'layout980') {
            $('body').attr("class", "layout980");
            $("#page-layout, #page-header-wrapper, #sub-nav").addClass("fixed");
        }

        if (lay_cookie == 'layout1280') {
            $('body').attr("class", "layout1280");
            $("#page-layout, #page-header-wrapper, #sub-nav").addClass("fixed");
        }

        if (lay_cookie == 'layout1400') {
            $('body').attr("class", "layout1400");
            $("#page-layout, #page-header-wrapper, #sub-nav").addClass("fixed");
        }

        if (lay_cookie == 'layout1600') {
            $('body').attr("class", "layout1600");
            $("#page-layout, #page-header-wrapper, #sub-nav").addClass("fixed");
        }

    });

    // Dialog


    // Modal Confirmation

    $("#modal_confirmation").dialog({
        autoOpen:false,
        bgiframe:true,
        resizable:false,
        width:500,
        modal:true,
        overlay:{
            backgroundColor:'#000',
            opacity:0.5
        },
        buttons:{
            'Delete all items in recycle bin':function () {
                $(this).dialog('close');
            },
            Cancel:function () {
                $(this).dialog('close');
            }
        }
    });

    // Dialog Link


    // Modal Confirmation Link

    $('#modal_confirmation_link').click(function () {
        $('#modal_confirmation').dialog('open');
        return false;
    });

    // Same height

    $("#page-content-wrapper").css({"minHeight":window.height });


    // Simple drop down menu

    var myIndex, myMenu, position, space = 20;

    $("div.sub").each(function () {
        $(this).css('left', $(this).parent().offset().left);
        $(this).slideUp('fast');
    });

    $(".drop-down li").hover(function () {
        $("ul", this).slideDown('fast');

        //get the index, set the selector, add class
        myIndex = $(".main1").index(this);
        myMenu = $(".drop-down a.btn:eq(" + myIndex + ")");
    }, function () {
        $("ul", this).slideUp('fast');
    });

    $(".editable").live('click', function () {
        $(this).removeClass("editable");
        var value = $(this).html();
        var width = $(this).width();
        var callback = $(this).attr("callback");
        $(this).html("<input type='text' id='baghali' value='" + value + "' class='inside-table tftf'>");
        $(this).find("input").focus();
        $(this).width(width);
        $(this).find("input").focusout(function () {
            $(this).parent().addClass("editable");
            $(this).parent().html($(this).val());
            if (callback) {
                if (callback.indexOf("(") == -1) {
                    eval(callback + "()");
                } else {
                    eval(callback);
                }
                ;
            }
            ;
        });
    });

    $(".select-all").live('change', function () {
        var check = $(this).attr("checked");
        $(this).parents().find("tbody").find(".select-row").each(function (index, dom) {
            $(dom).attr("checked", check);
        });
    });

    $(".tftf").live('keydown', function (e) {
        if (e.keyCode == 13) {
            $(this).blur();
        }
        ;
    });
});
