var domainUrl = "https://www.anzstadium.com.au";

$(document).ready(function ()
{	
//	RenderMainNav(4092);
//	RenderFooter("4092");
});

function RenderUtilityNav()
{
    $.ajax(
    {
        cache: false,
        type: "GET",
        url: domainUrl + "/Web_Services/iEbmsService.asmx/RenderUtilityNav",
        crossDomain: true,
        dataType: "jsonp",
        success: function (data, textStatus) {
        },
        error: function (xhr, ajaxOptions, thrownError) {
        },
        jsonp: "callback",
        jsonpCallback: "RenderUtilityCallback"
    });
}

function RenderMainNav(nodeId)
{
    $.ajax(
    {
        cache: false,
        type: "GET",
        url: domainUrl + "/Web_Services/iEbmsService.asmx/RenderMainNav",
        crossDomain: true,
        dataType: "jsonp",
        data: { pageId: nodeId },
        success: function (data, textStatus) {
        },
        error: function (xhr, ajaxOptions, thrownError) {
        },
        jsonp: "callback",
        jsonpCallback: "RenderMainCallback"
    });
}

function RenderSecondaryNav(nodeId)
{
    $.ajax(
    {
        cache: false,
        type: "GET",
        url: domainUrl + "/Web_Services/iEbmsService.asmx/RenderSecondaryNav",
        crossDomain: true,
        dataType: "jsonp",
        data: { pageId: nodeId },
        success: function (data, textStatus) {
        },
        error: function (xhr, ajaxOptions, thrownError) {
        },
        jsonp: "callback",
        jsonpCallback: "RenderSecondaryCallback"
    });
}

function RenderSideNav(nodeId)
{
    $.ajax(
    {
        cache: false,
        type: "GET",
        url: domainUrl + "/Web_Services/iEbmsService.asmx/RenderSideNav",
        crossDomain: true,
        dataType: "jsonp",
        data: { pageId: nodeId },
        success: function (data, textStatus) {
        },
        error: function (xhr, ajaxOptions, thrownError) {
        },
        jsonp: "callback",
        jsonpCallback: "RenderSideCallback"
    });
}

function RenderFooter(nodeId)
{
    $.ajax(
    {
        cache: false,
        type: "GET",
        url: domainUrl + "/Web_Services/iEbmsService.asmx/RenderFooter",
        crossDomain: true,
        dataType: "jsonp",
        data: { pageId: nodeId },
        success: function (data, textStatus) {
        },
        error: function (xhr, ajaxOptions, thrownError) {
        },
        jsonp: "callback",
        jsonpCallback: "RenderFooterCallback"
    });
}

function RenderQuicklinks()
{
    $.ajax(
    {
        cache: false,
        type: "GET",
        url: domainUrl + "/Web_Services/iEbmsService.asmx/RenderMobileQuicklinks",
        crossDomain: true,
        dataType: "jsonp",
        success: function (data, textStatus) {
        },
        error: function (xhr, ajaxOptions, thrownError) {
        },
        jsonp: "callback",
        jsonpCallback: "RenderQuicklinksCallback"
    });
}

function RenderUtilityCallback(data)
{
    $('.utility-nav-placeholder').replaceWith(data.htmlString);
    
    // Search
    var $searchBar = $('.search-bar');
    var $overlay = $('<div class="overlay"></div>');

    $('.search').on('click', function (e) {
        e.preventDefault();
        if ($searchBar.parent().hasClass('search-active')) {
            $searchBar.parent().removeClass('search-active');
            // $searchBar.slideUp('fast');
            $('.overlay').fadeOut('fast', function () {
                $(this).remove();
            });
        } else {
            $searchBar.parent().addClass('search-active');
            // $searchBar.slideDown('fast');
            $('.site-main').append($overlay);
            $('.overlay').fadeIn('fast');
            $('input[type="search"]').focus();
        }
    });
}

function RenderMainCallback(data)
{
    $('.main-nav-placeholder').replaceWith(data.htmlString);
}

function RenderSecondaryCallback(data)
{
    $('.secondary-nav-placeholder').replaceWith(data.htmlString);
}

function RenderSideCallback(data)
{
    $('.side-nav-placeholder').replaceWith(data.htmlString);
}

function RenderFooterCallback(data)
{
    $('.footer-placeholder').replaceWith(data.htmlString);
}

function RenderQuicklinksCallback(data)
{
    $('.mobile-quicklinks-placeholder').replaceWith(data.htmlString);
}


function RenderAll(nodeId)
{
    RenderUtilityNav();
    RenderMainNav(nodeId);
    RenderSecondaryNav(nodeId);
    RenderSideNav(nodeId);
    RenderFooter(nodeId);
    RenderQuicklinks();
}




