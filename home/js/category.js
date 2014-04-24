// Creator  :   Nguyễn Văn An
// Date     :   31/12/2012
// Desc     :   All neccessary javascript(s) for the category page

/*** PRODUCT COMPARING ***/

// Variables
var COMPARE_ARR_PRODUCT_ID = new Array();

// Add a product to comparing list
function AddToCompare(ctrl, id) {
    var data = { CategoryID: GL_CATEGORYID, ProductID: id };
    POSTAjax(
        '/aj/Category/ProductCompare/',
        data,
        BeforeSendAjax,
        function (e) {
            $('#dlding').fadeOut(300);
            if (e == null || e == '' || e.toString() == '[object XMLDocument]') {
                return;
            }
            if (typeof (e) == 'object') {
                alert(e._error);
                return;
            }
            if (ctrl != undefined) {
                $(ctrl).parent('.add-to-compare').replaceWith('<div id="addedtocompare-' + id + '" class="add-to-compare is-added clearfix"><span onclick="RemoveFromCompare(' + id + ')">Đã chọn so sánh</span></div>');
            }
            $('#catprodcmpr').html(e);
            $('body,html').animate({
                scrollTop: 0
            }, 500);
            $('#catprodcmpr .compare-chart-wrapper .compare-chart li.row:last').show();
            RefreshCompareView();
        },
        ErrorAjax,
        true
        );
}

// Remove a product from comparing list
function RemoveFromCompare(id) {
    var data = { CategoryID: GL_CATEGORYID, RemoveProductID: id };
    POSTAjax(
        '/aj/Category/ProductCompare/',
        data,
        BeforeSendAjax,
        function (e) {
            if (e != null) {
                $('#addedtocompare-' + id).replaceWith('<div class="add-to-compare clearfix"><span onclick="AddToCompare(this, ' + id + ')">Thêm vào so sánh</span></div>');
                $('#catprodcmpr').html(e);
            }
            RefreshCompareView();
            $('#dlding').fadeOut(300);
        },
        ErrorAjax,
        true
        );
}

// Remove all comparing product
function RemoveAllCompare() {
    var data = { CategoryID: GL_CATEGORYID };
    $('#catprodcmpr').html('');
    $('div[id^=addedtocompare-]').each(function () {
        var id = $(this).attr('id').replace('addedtocompare-', '');
        $(this).replaceWith('<div class="add-to-compare clearfix"><a href="javascript:void(0)" onclick="AddToCompare(this, ' + id + ')">Thêm vào so sánh</a></div>');
    });
    POSTAjax(
        '/aj/Category/RemoveAllCompare/',
        data,
        BeforeSendAjax,
        function (e) {
            $('#dlding').fadeOut(300);
        },
        ErrorAjax,
        true
        );
    SHOW_COMPARE_CONTENT = true;
    EXPAND_PRODUCT_COMPARE_TABLE = true;
}

var SHOW_COMPARE_CONTENT = true;
function ShowCompareContent() {
    $('.compare-chart-wrapper').slideDown(500);
    SHOW_COMPARE_CONTENT = false;
}


var EXPAND_PRODUCT_COMPARE_TABLE = true;
function ExpandProductCompareTable() {
    if (EXPAND_PRODUCT_COMPARE_TABLE) {
        $('#catprodcmpr .compare-chart-wrapper .compare-chart li.row:gt(5)').slideDown();
        $('#catexpcpr').html('[<b>-</b> Thu gọn]');
        EXPAND_PRODUCT_COMPARE_TABLE = false;
    }
    else {
        $('#catprodcmpr .compare-chart-wrapper .compare-chart li.row:gt(5)').hide();
        $('#catprodcmpr .compare-chart-wrapper .compare-chart li.row:last').show();
        $('#catexpcpr').html('<b>+</b> Mở rộng');
        EXPAND_PRODUCT_COMPARE_TABLE = true;
    }
}

function RefreshCompareView() {
    if (!SHOW_COMPARE_CONTENT) {
        $('.compare-chart-wrapper').show();
    }
    if (!EXPAND_PRODUCT_COMPARE_TABLE) {
        $('#catprodcmpr .compare-chart-wrapper .compare-chart li.row:gt(5)').slideDown();
        $('#catexpcpr').html('[<b>-</b> Thu gọn]');
    }
}

/*** LOAD MORE PRODUCT ***/
function LoadMoreProductCat() {
    if (_CAT_LOADING_FLAG) {
        _CAT_LOADING_FLAG = false;
        if (_CAT_PAGE_INDEX == -1)
            return;
        _CAT_LOADING_FLAG = false;
        _CAT_LOAD_MORE_DATA = $.extend({}, _CAT_LOAD_MORE_DATA, { iPageIndex: _CAT_PAGE_INDEX + 1 });
        POSTAjax(
            '/aj/Category/LoadMoreProduct/',
            _CAT_LOAD_MORE_DATA,
            function () {
            },
            function (e) {
                $('button.btnmorelist').remove();
                CAT_LOADING_FLAG = true;
                if (e == null || e == '') {
                    _CAT_PAGE_INDEX = -1;
                    _CAT_LOADING_FLAG = false;
                }
                else {
                    _CAT_PAGE_INDEX++;
                    var justadd = $(e).find('> li').addClass('justadd');
                    $('.products').append(justadd);
                    $('.products').after($('<div>' + e + '</div>').find('button.btnmorelist'));

                    $('.products li.shock-price.justadd').each(function () {
                        LoadShockPriceInfo($(this), $(this).data('id'));
                    });

                    $('.products li.preorder.justadd').each(function () {
                        LoadPreorderInfo($(this), $(this).data('id'));
                    });

                    $('.products li.price-forcast.justadd').each(function () {
                        LoadPriceForcastInfo($(this), $(this).data('id'));
                    });

                    $('.products li.findout.justadd').each(function () {
                        LoadProductFindOutInfo($(this), $(this).data('id'));
                    });

                    $('.products li.justadd').removeClass('justadd');

                    _CAT_LOADING_FLAG = true;
                }
                StickyLeftSideBar();
            },
            ErrorAjax,
            true
            );
    }
}

function HideCompareContent() {
    SHOW_COMPARE_CONTENT = true;
    $('.compare-chart-wrapper').slideUp();
}

/// DOCUMENT READY ///
$(document).ready(function () {
    $('#site-header #user-zone .user-location a.location').click(function () {
        $('#site-header #user-zone .user-location .select-location-wrapper').css('display', 'block');
    })

    $('#site-header #user-zone .user-location .select-location-wrapper').mouseover(function () {
        $('#site-header #user-zone .user-location .select-location-wrapper').css('display', 'block');
    }).mouseout(function () {
        $('#site-header #user-zone .user-location .select-location-wrapper').css('display', 'none');
    });

    $('#site-header #site-search .form .input-wrapper input').click(function () {
        $('#site-header #site-search .form .search-suggestion-wrapper').css('display', 'block');
    })

    $('#site-header #site-search .form .search-suggestion-wrapper').mouseover(function () {
        $('#site-header #site-search .form .search-suggestion-wrapper').css('display', 'block');
    }).mouseout(function () {
        $('#site-header #site-search .form .search-suggestion-wrapper').css('display', 'none');
    });

    $('.product-body .main .product-wrapper .product-filter-wrapper .title, .product-body .main .product-wrapper .product-filter-wrapper .filter').live('mouseover', (function () {
        $(this).addClass('on-hover');
    })).live('mouseout', (function () {
        $(this).removeClass('on-hover');
    }));

    $.waypoints.settings.scrollThrottle = 1;

    $('#site-wrapper .product-body .main .product-wrapper .product-filter-wrapper').waypoint(function (event, direction) {
        if (direction === 'down') {
            $(this).addClass('product-filter-wrapper-sticky');
            $('#site-wrapper .product-body .main .product-wrapper .product-compare-wrapper').addClass('product-compare-wrapper-sticky');
        } else {
            $(this).removeClass('product-filter-wrapper-sticky');
            $('#site-wrapper .product-body .main .product-wrapper .product-compare-wrapper').removeClass('product-compare-wrapper-sticky');
        }
    });

    $(window).scroll(function () { StickyLeftSideBar(); });

    $('.product-body .main .product-wrapper .compare-chart-wrapper .compare-chart li.expand-button-wrapper').click(function () {
        $('.product-body .main .product-wrapper .compare-chart-wrapper .compare-chart li.hide').toggleClass('show');
    });

    // random first banner position
    var CAT_SLIDE_LENGTH = $('li.double-col.banner .image-wrapper .slides_container .slide').length;

    if (CAT_SLIDE_LENGTH > 1) {
        var nextIndex = Math.floor((Math.random() * CAT_SLIDE_LENGTH) + 1) - 1;
        var nextElement = $('li.double-col.banner .image-wrapper .slides_container .slide').eq(nextIndex);

        $('li.double-col.banner .image-wrapper .slides_container .slide').eq(nextIndex).remove();

        $('li.double-col.banner .image-wrapper .slides_container').prepend(nextElement);
    }

    $('li.double-col.banner .image-wrapper').slides({
        preload: true,
        generateNextPrev: true,
        generatePagination: true,
        preload: true,
        preloadImage: 'Content/images/miscs/loading_03.gif',
        play: 5000,
        pause: 2500,
        slideSpeed: 450,
        hoverPause: true
    });

    $('.products li.shock-price').each(function () {
        LoadShockPriceInfo($(this), $(this).data('id'));
    });

    $('.products li.preorder').each(function () {
        LoadPreorderInfo($(this), $(this).data('id'));
    });

    $('.products li.price-forcast').each(function () {
        LoadPriceForcastInfo($(this), $(this).data('id'));
    });

    $('.products li.findout').each(function () {
        LoadProductFindOutInfo($(this), $(this).data('id'));
    });

    var compareSuggestIndex = 0;
    $('#txtproductcomparesearch').live('keyup', function (e) {
        if (e.keyCode == 40) {
            e.preventDefault();
            if ($('#categorycomparesuggest').length > 0) {
                $('#categorycomparesuggest').focus();
                $('#categorycomparesuggest li').eq(0).addClass('hover');
                compareSuggestIndex = 0;
            }
        }
    });

    $('#categorycomparesuggest').live('keydown', function (e) {
        e.preventDefault();
        debugger;
        var length = $('#categorycomparesuggest li').length;
        if (length > 0) {
            if (e.keyCode == 40) {
                compareSuggestIndex++;
                if (compareSuggestIndex > length - 1)
                    compareSuggestIndex = 0;
                $('#categorycomparesuggest li.hover').removeClass('hover');
                $('#categorycomparesuggest li').eq(compareSuggestIndex).addClass('hover');
            }
            else if (e.keyCode == 38) {
                compareSuggestIndex--;
                if (compareSuggestIndex < 0)
                    compareSuggestIndex = length - 1;
                $('#categorycomparesuggest li.hover').removeClass('hover');
                $('#categorycomparesuggest li').eq(compareSuggestIndex).addClass('hover');
            }
            else if (e.keyCode == 13) {
                var url = $('#categorycomparesuggest li').eq(compareSuggestIndex).find('a').attr('href');
                window.location.href = url;
            }
        }
    });
    LoadMascot();
    LoadHuaweiMascot();
    $('.products li a').live('click', function (e) {
        e.preventDefault();
        if (e.target != $(this).find('span.btncompare')[0]) {
            window.location = $(this).attr('href');
        }
        else {
            return false;
        }
    });
    AddToCompare(undefined, 0);
});

var FLAG_LOADPRICEFORCASTINFO = true;

function LoadPriceForcastInfo(ctrl, id) {
    data = { iProductId: id };
    POSTAjax(
        '/aj/Game/CAT_GetPriceForcastInfo/',
        data,
        function () { },
        function (e) {
            if (e._status == 1) {
                var html1 = '<div class="price-list clearfix"><cite class="price">' + formatNumberValue(e._totalAnswer) + ' người đã tham gia</cite></div>';
                $(ctrl).find('.name.clearfix').append(html1);
                if (FLAG_LOADPRICEFORCASTINFO) {
                    FLAG_LOADPRICEFORCASTINFO = false;
                    var html2 = '<span class="status black clock" id="pf-clock1"></span>';
                    $(ctrl).find('.name.clearfix').prepend(html2);
                    $(ctrl).find('.pf-button').show();
                    if (e._status == 1) {
                        var currentyear = new Date().getFullYear();
                        var target_date = new cdtime("pf-clock1", e._time);
                        target_date.displaycountdown("days", displayCountDown2);
                    }
                    else {
                        $('#pf-clock1').html('Đã hết thời hạn Dự đoán giá');
                    }
                }
            }
        },
            function () { },
            true
        );
}

function LoadPreorderInfo(ctrl, id) {
    data = { iProductId: id };
    POSTAjax(
        '/aj/Game/CAT_GetPreorderInfo/',
        data,
        function () { },
        function (e) {
            if (e._status == 1 && e._totalOrder > 0) {
                var html = 'Đã có ' + formatNumberValue(e._totalOrder) + ' người đặt mua';
                if ($(ctrl).find('h6').length > 0) {
                    $(ctrl).find('h6').text(html);
                }
                else {
                    $('<h6 class="uudailon">Đã có ' + formatNumberValue(e._totalOrder) + ' người đặt mua</h6>').insertAfter($(ctrl).find('a img'));
                }
            }
        },
        function () { },
        true
        );
}


function LoadShockPriceInfo(ctrl, id) {
    data = { iProductId: id };
    POSTAjax(
        '/aj/Game/CAT_GetShockPriceInfo/',
        data,
        function () { },
        function (e) {
            if (e._status == 1 || e._status == 4) {
                var html = '<del class="old-price">';
                html += e._oldPrice + '</del>';
                html += '<cite class="price">';
                html += e._newPrice;
                html += '<span class="discount-note"> giảm <strong>';
                html += 100 - e._percent;
                html += '%</strong></span></cite>';

                $(ctrl).find('.price-list').html(html);
                if (e._left > 0) {
                    var html2 = '<span class="status blue clock">Chỉ còn ' + formatNumberValue(e._left) + ' sản phẩm</span>';
                    $(ctrl).find('.name.clearfix').prepend(html2);
                }
            }
        },
        function () { },
        true
        );
}

function LoadProductFindOutInfo(ctrl, id) {
    data = { iProductId: id };
    POSTAjax(
        '/aj/Game/CAT_GetProductFindOutInfo/',
        data,
        function () { },
        function (e) {
            if (e._status == 1) {
                var html2 = '<span class="clock"></span>';
                $(ctrl).find('.price-list').append(html2);
                var html1 = '<span class="player">' + formatNumberValue(e._totalplayer) + ' người đã tham gia</cite></div>';
                $(ctrl).find('.price-list').append(html1);
                var re = /-?\d+/;
                var m = re.exec(e._enddate);
                var d = new Date(parseInt(m[0]));
                SimpleCountDown($(ctrl).find('.price-list span.clock'), d);
            }
        },
        function () { },
        true
        );
}

function StickyLeftSideBar() {
    var scroll_top = $(window).scrollTop();
    var _height = $('#site-body .product-sidebar').height();
    var _offset_top = $('#site-wrapper .product-body .main').offset().top;
    var _offset_bottom = $('#ftv2').offset().top;

    if (scroll_top < _offset_top) {
        $('#site-body .product-sidebar').removeClass('sticky').removeClass('absolute');
    }
    else {
        if (scroll_top + _height < _offset_bottom) {
            $('#site-body .product-sidebar').addClass('sticky').removeClass('absolute');
        }
        else {
            $('#site-body .product-sidebar').removeClass('sticky').addClass('absolute');
        }
    }
}


function ShowCategoryAddToCompareBox(ctrl) {
    var html = '<div class="search-input-wrapper clearfix">'
                    + '<input placeholder="Nhập tên sản phẩm" type="text" name="product-keyword" class="input product-keyword" value="" onkeyup="CategorySuggestCompare(this, event)" id="txtproductcomparesearch">'
                + '</div>';
    $(ctrl).parent('div').parent('div').append(html);
    $(ctrl).removeAttr('onclick');
    $(ctrl).parent('div').parent('div').find('input').focus();
}


function CategorySuggestCompare(ctrl, e) {
    var kw = $(ctrl).val().replace(/:|;|!|@@|#|\$|%|\^|&|\*|'|"|>|<|,|\.|\?|\/|`|~|\+|=|_|\(|\)|{|}|\[|\]|\\|\|/gi, '');
    var kwt = kw.trim().toLowerCase();
    if (kwt.length < 2) {
        $('.search-suggestion-list').hide();
        return;
    }
    if (e.which == 40) {
        if ($('#categorycomparesuggest li.selected').length == 0) {
            $('#categorycomparesuggest li:first').addClass('selected');
        }
        else {
            var t = $('#categorycomparesuggest li.selected').next();
            $('#categorycomparesuggest li.selected').removeClass('selected');
            t.addClass('selected');
        }
        return;
    }
    else if (e.which == 38) {
        if ($('#categorycomparesuggest li.selected').length == 0) {
            $('#categorycomparesuggest li:last').addClass('selected');
        }
        else {
            var t = $('#categorycomparesuggest li.selected').prev();

            $('#categorycomparesuggest li.selected').removeClass('selected');
            t.addClass('selected');
        }
        return;
    }
    if (e.which == 13) {
        $('.search-suggestion-list li.selected').find("a").click();
    }
    else if (e.which != 40 && e.which != 38) {
        var suggestCategoryID = 0;
        if (GL_CATEGORYID == 42 || GL_CATEGORYID == 44 || GL_CATEGORYID == 522 || GL_CATEGORYID == 49)
            suggestCategoryID = GL_CATEGORYID;
        $.ajax({
            url: '/tim-kiem/aj/SuggestCompare/',
            type: 'GET',

            data: { iCategory: suggestCategoryID, sKeyword: kwt },
            dataType: 'json',
            cache: true,
            success: function (d) {
                if (d == null) {
                    return;
                }
                d = d.i;
                var rl = d.length;
                var html = '';
                var lpros = '';
                var catetrack = {};

                html = '<div class="search-suggestion-wrapper clearfix">'
                         + '<ul class="search-suggestion-list nolist clearfix" id="categorycomparesuggest">';

                for (var j = 0; j < rl; j++) {
                    html += '<li><a href="javascript:void(0)" onclick="AddToCompare(undefined, ';
                    html += d[j][0];
                    html += ')"><strong>';
                    html += d[j][1];
                    html += '</strong></a></li>';
                }
                $(ctrl).parent('div').parent('div').find('.search-suggestion-wrapper').remove();
                $(ctrl).parent('div').parent('div').append(html);

            }
        });
    }
}


var FL_ACCESSORYSUGGESTDEVICE = true;
function AccessorySuggestDevice(ctrl, e) {
    if (!FL_ACCESSORYSUGGESTDEVICE)
        return;
    var kw = $(ctrl).val().replace(/:|;|!|@@|#|\$|%|\^|&|\*|'|"|>|<|,|\.|\?|\/|`|~|\+|=|_|\(|\)|{|}|\[|\]|\\|\|/gi, '');
    var kwt = kw.trim().toLowerCase();
    if (kwt.length < 2) {
        $('.search-suggestion-list').hide();
        return;
    }
    if (e.which == 13) {
        $('.search-suggestion-list li.selected').find("a").click();
    }
    else if (e.which != 40 && e.which != 38) {
        FL_ACCESSORYSUGGESTDEVICE = false;
        $.ajax({
            url: '/tim-kiem/aj/SuggestAccessoryDevice',
            type: 'GET',
            data: { sKeyword: kwt },
            dataType: 'json',
            cache: true,
            beforeSend: function () {
                $('#dlding').show();
            },
            success: function (d) {
                FL_ACCESSORYSUGGESTDEVICE = true;
                $('#dlding').fadeOut();
                if (d == null) {
                    return;
                }
                $('.device-tooltip').remove();
                d = d.i;
                var rl = d.length;
                var html = '';
                var lpros = '';
                var catetrack = {};

                html = '<ul id="deviceaccessory" class="search-suggestion-list nolist clearfix" tabindex="1">';

                for (var j = 0; j < rl; j++) {
                    html += '<li><a href="/phu-kien' + d[j][2] + '">';
                    html += '<strong>';
                    html += d[j][1];
                    html += '</strong></a></li>';
                }
                $(ctrl).parent('div').parent('div').find('.search-suggestion-list').remove();
                $(ctrl).parent('div').parent('div').append(html);
            }
        });
    }
}

function FilterAccessoryByDevice(url) {
    window.location.href = url;
}


function MinimizeAccessoryParadise() {
    CreateCookie('CK_AP_CATEGORY', '1', 7);
    window.location.reload();
}


function MaximizeAccessoryParadise() {
    Delete_Cookie('CK_AP_CATEGORY', '', '.thegioididong.com');
    Delete_Cookie('CK_AP_CATEGORY', '', '.www.thegioididong.com');
    Delete_Cookie('CK_AP_CATEGORY', '', 'www.thegioididong.com');
    window.location.reload();
}


function AccessoryParadizePopup() {
    debugger;
    POSTAjax('/aj/Category/AccessoryParadisePopup', {}, BeforeSendAjax, function (e) {
        if (e != null || e != '') {
            try {
                $('#pu-accessoryparadise').remove();
                $('body').append(e);
            }
            catch (err) { }
            $.fancybox.close();
            $(".listcustomer-predistion").fancybox({
                'width': 830,
                'height': 535,
                'autoScale': false,
                'transitionIn': 'none',
                'transitionOut': 'none',
                'showCloseButton': false,
                'autoScale': false,
                'margin': 0,
                'padding': 0
            });
            $('[id$=prephonenumber]').ForceNumericOnly();
            $("input[name=txtNumber]").live("keypress", function (e) {
                var charCode = e.which || e.keyCode;
                var id = parseInt($(this).attr("id").replace("txtNumber", ""));
                if (charCode > 31 && (charCode < 48 || charCode > 57))
                    return false;
                else {
                    if (charCode != 8 && charCode != 46) {
                        if ($("#txtNumber" + (id + 1)).val() == "") {
                            $("#txtNumber" + (id + 1)).focus();
                        }
                    }
                }
            });

            $('[id$=g-pd-bs]').click(function () {
                page_g_pd = 0;
                total = 0;
                $(".g-pd-total").html("");
                $("#g-pd-sr table tr.tritem").remove();

                $('#g-pd-sr').hide();
                $('.g-pd-loading').show();
                $('.g-pd-control').hide();

                SearchRegisteredPredistion();

                window.setTimeout('PreventMultipleClick()', 1000)
            });
            $(".g-pd-more").click(function () {
                $(".g-pd-more").hide();
                $(".g-pd-loading-more").show();
                SearchRegisteredPredistion();
            });
            /*
                customerwin
            */
            $(".listcustomer-predistion-win").fancybox({
                'width': 830,
                'height': 535,
                'autoScale': false,
                'transitionIn': 'none',
                'transitionOut': 'none',
                'showCloseButton': false,
                'autoScale': false,
                'margin': 0,
                'padding': 0
            });
            $('[id$=g-pd-bs-win]').click(function () {
                page_g_pd = 0;
                total = 0;
                $(".g-pd-total-win").html("");
                $("#g-pd-sr-win table tr.tritem").remove();

                $('#g-pd-sr-win').hide();
                $('.g-pd-loading-win').show();
                $('.g-pd-control-win').hide();

                SearchRegisteredPredistionWin();

                window.setTimeout('PreventMultipleClick()', 1000)
            });
            $(".g-pd-more-win").click(function () {
                debugger;
                $(".g-pd-more-win").hide();
                $(".g-pd-loading-more-win").show();
                SearchRegisteredPredistionWin();
            });
            /*
                end customerwin
            */
            $("#prefullname").blur(function () {
                Predistion_checkInput($(this), 'Vui lòng nhập họ tên.', '', true);
            });
            $("#prephonenumber").blur(function () {
                Predistion_CheckPhoneExist(true);
            });
            $("#preemail").blur(function () {
                Predistion_CheckEmailExist(true);
            });
            //On Click Event
            $("ul.tabs li").click(function () {

                $("ul.tabs li").removeClass("active"); //Remove any "active" class
                $(this).addClass("active"); //Add "active" class to selected tab
                $(".tab_content").fadeOut(0); //Hide all tab content

                var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
                $(activeTab).fadeIn(1000); //Fade in the active ID content
                return false;
            });
            $('input[name="fullname"]').live('keyup', function (e) {
                if (e.keyCode != 32 && e.keyCode != 8) {
                    var string = $(this).val();
                    var arr = string.split(" ");
                    var arrresult = [];
                    var result = "";
                    if (arr.length > 0) {
                        for (var i = 0; i < arr.length; i++) {
                            if (arr[i].trim() != "" && arr[i].trim() != " ") {
                                arrresult.push(arr[i].trim().charAt(0).toUpperCase() + arr[i].trim().slice(1));
                            }
                        }
                        for (var j = 0; j < arrresult.length; j++) {
                            result += arrresult[j] + " ";
                        }
                    }
                    else {
                        result = string.charAt(0).toUpperCase() + string.slice(1);
                    }
                    $(this).val($.trim(result));
                }
            });

            //$("#accessory-paradise .banner").hide();
            $("#box-customer-predistion .close").attr("onclick", "CloseAndShowPopupAccessory();")
            $("#box-customer-predistion-win .close").attr("onclick", "CloseAndShowPopupAccessory();")

            $("#openfancyaccparadise").fancybox({
                'transitionIn': 'none',
                'transitionOut': 'none',
                'showCloseButton': false,
                'margin': 0,
                'padding': 1,
                'modal': true
            });
            $("#openfancyaccparadise").click();
        }
        $('#dlding').fadeOut(1000);
        QUICK_ORDER_BOX_CALLING_FLAG = true;
    }, ErrorAjax, true);
}
function CloseAndShowPopupAccessory() {
    $.fancybox.close();
    $(".paradiseacc .more").click();
}

jQuery.fn.ForceNumericOnly =
function () {
    return this.each(function () {
        $(this).keydown(function (e) {
            if (e.shiftKey || e.ctrlKey || e.altKey) { // if shift, ctrl or alt keys held down
                e.preventDefault();         // Prevent character input
            }
            else {
                var key = e.charCode || e.keyCode || 0;
                return (
                key == 8 ||                     // backspace
                key == 9 ||                     // tab
                key == 46 ||                    // delete        
                (key >= 35 && key <= 40) ||     // arrow keys/home/end
                (key >= 48 && key <= 57) ||
                (key >= 96 && key <= 105));      // number on keypad
            }
        });
    });
};
function FormatPhone(obj, val, event) {
    var pos = doGetCaretPosition(obj);
    val = val.replace(/-/g, '');
    if (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if ((keycode >= '48' && keycode <= '57') || (keycode >= '96' && keycode <= '105')) {
            if (val.length <= 4) {
                obj.value = val;
            }
            else if (val.length > 4 && val.length <= 7) {
                obj.value = val.substr(0, 4) + "-" + val.substr(4);
            }
            else if (val.length > 7) {
                obj.value = val.substr(0, 4) + "-" + val.substr(4, 3) + "-" + val.substr(7);
            }
        }
        else if (keycode == '37' || keycode == '38') {
            if (val.length <= 4) {
                obj.value = val;
                setCaretPosition(obj, pos);
            }
            else if (val.length > 4 && val.length <= 7) {
                obj.value = val.substr(0, 4) + "-" + val.substr(4);
                setCaretPosition(obj, pos);
            }
            else if (val.length > 7) {
                obj.value = val.substr(0, 4) + "-" + val.substr(4, 3) + "-" + val.substr(7);
                setCaretPosition(obj, pos);
            }
        }
    }
    else {
    }
}
function doGetCaretPosition(ctrl) {
    var CaretPos = 0; // IE Support
    if (document.selection) {
        ctrl.focus();
        var Sel = document.selection.createRange();
        Sel.moveStart('character', -ctrl.value.length);
        CaretPos = Sel.text.length;
    }
        // Firefox support
    else if (ctrl.selectionStart || ctrl.selectionStart == '0')
        CaretPos = ctrl.selectionStart;
    return (CaretPos);
}
function setCaretPosition(ctrl, pos) {
    if (ctrl.setSelectionRange) {
        ctrl.focus();
        ctrl.setSelectionRange(pos, pos);
    }
    else if (ctrl.createTextRange) {
        var range = ctrl.createTextRange();
        range.collapse(true);
        range.moveEnd('character', pos);
        range.moveStart('character', pos);
        range.select();
    }
}

function ShowMessage(obj, msg, url) {
    alert(msg);
    $(obj).focus();
}

FormatNumeric = function (val) { if (val != '') { var a = parseInt(val); val = a.toString(); } val += ''; x = val.split('.'); x1 = x[0]; x2 = x.length > 1 ? ',' + x[1] : ''; var rgx = /(\d+)(\d{3})/; while (rgx.test(x1)) { x1 = x1.replace(rgx, '$1' + ',' + '$2'); } return x1 + x2; }

ValidPhoneNumber = function (val) {
    val = val.replace(/-/g, '');
    if (val == '' || val.length < 10 || val.length > 11) {
        return false;
    }
    var strCheck = '';
    if (val.length == 11) {
        strCheck = val.substr(0, 4);
    }
    else {
        strCheck = val.substr(0, 3);
    }
    if (strCheck == '099'
        || strCheck == '0199'
        || strCheck == '091'
        || strCheck == '094'
        || strCheck == '0123'
        || strCheck == '0125'
        || strCheck == '0127'
        || strCheck == '0129'
        || strCheck == '0124'
        || strCheck == '095'
        || strCheck == '092'
        || strCheck == '0188'
        || strCheck == '0186'
        || strCheck == '097'
        || strCheck == '098'
        || strCheck == '096'
        || strCheck == '0162'
        || strCheck == '0163'
        || strCheck == '0164'
        || strCheck == '0165'
        || strCheck == '0166'
        || strCheck == '0167'
        || strCheck == '0168'
        || strCheck == '0169'
        || strCheck == '0197'
        || strCheck == '0198'
        || strCheck == '090'
        || strCheck == '093'
        || strCheck == '0122'
        || strCheck == '0126'
        || strCheck == '0121'
        || strCheck == '0128'
        || strCheck == '0120') {
        return true;
    }

    return false;
}

isEmail = function (val) { if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(val)) { return true; } return false; }



// BeforeSendAjax
function BeforeSendAjax() {
    $('#dlding').show();
}

// ErrorAjax
function ErrorAjax() {
    // Not implemented yet
}

function CallAjaxPost(url, dat, befHandle, sucHandle, errHandle, asy) {
    $.ajax({
        async: asy,
        url: url,
        data: dat,
        type: 'POST',
        cache: false,
        beforeSend: function () {
            befHandle();
        },
        success: function (e) {
            sucHandle(e);
        },
        error: function () {
            errHandle();
        }
    });
}
function formatNumberValue(number) {
    var intLength = number.toString().length;
    var intLeft = 0;
    var strNumber = '';
    var strNewNumber = '';
    while (intLength % 3 != 0) {
        intLength++;
        intLeft++;
    }
    if (intLeft != 0) {
        for (var intCount = 0; intCount < intLeft; intCount++) {
            strNumber += '0';
        }
    }
    strNumber += number.toString();
    for (var intCount = 0; intCount < intLength; intCount++) {
        strNewNumber += strNumber.charAt(intCount);

        if (intCount > 0 && (intCount + 1) % 3 == 0 && intCount != intLength - 1) {
            strNewNumber += '.';
        }
    }
    strNewNumber = strNewNumber.substring(intLeft);
    return strNewNumber;
}

function HideSmartphonePromote() {
    var expiredays = 7;
    var c_name = 'CK_TGDD_SMARTPHONE_PROMOTE';
    CreateCookie(c_name, '1', expiredays);
    $('.smartphonepromote').remove();
}

function CloseHuaweiMascot() {
    var expiredays = 7;
    var c_name = 'CK_HUAWEI_MASCOT';
    CreateCookie(c_name, '1', expiredays);
    $('.huaweimascot').fadeOut();
}

function LoadHuaweiMascot() {
    var ck = getCookie('CK_HUAWEI_MASCOT');
    if (ck != null && typeof (ck) != 'undefined')
        return;
    try {
        $('#HalloweenFestID').remove();
        setTimeout(function () { $('.huaweimascot').fadeIn(); }, 30000);
    } catch (e) { }
}