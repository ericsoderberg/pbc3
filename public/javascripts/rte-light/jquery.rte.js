/*
* jQuery RTE plugin 0.5.1 - create a rich text form for Mozilla, Opera, Safari and Internet Explorer
*
* Copyright (c) 2009 Batiste Bieler
* Distributed under the GPL Licenses.
* Distributed under the MIT License.
*/

// define the rte light plugin
(function($) {

if(typeof $.fn.rte === "undefined") {

    var defaults = {
        media_url: "",
        content_css_url: "rte.css",
        dot_net_button_class: null,
        max_height: 350,
        enable_code_mode: true,
    };

    $.fn.rte = function(options) {

    $.fn.rte.html = function(iframe) {
        return iframe.contentWindow.document.getElementsByTagName("body")[0].innerHTML;
    };

    // build main options before element iteration
    var opts = $.extend(defaults, options);

    // iterate and construct the RTEs
    return this.each( function() {
        var textarea = $(this);
        var iframe;
        var element_id = textarea.attr("id");

        // enable design mode
        function enableDesignMode() {

            var content = textarea.val();

            // Mozilla needs this to display caret
            if($.trim(content)=='') {
                content = '<p>please edit</p>'; //'<br />';
            }

            // already created? show/hide
            if(iframe) {
                console.log("already created");
                textarea.hide();
                $(iframe).contents().find("body").html(content);
                $(iframe).show();
                $("#toolbar-" + element_id).remove();
                textarea.before(toolbar());
                iframe.contentWindow.focus();
                return true;
            }

            // for compatibility reasons, need to be created this way
            iframe = document.createElement("iframe");
            iframe.frameBorder=0;
            iframe.frameMargin=0;
            iframe.framePadding=0;
            iframe.height=400;
            if(textarea.attr('class'))
                iframe.className = textarea.attr('class');
            if(textarea.attr('id'))
                iframe.id = element_id;
            if(textarea.attr('name'))
                iframe.title = textarea.attr('name');

            textarea.after(iframe);

            var css = "";
            if(opts.content_css_url) {
                css = "<link type='text/css' rel='stylesheet' href='" + opts.content_css_url + "' />";
            }

            var doc = "<html><head>"+css+"</head><body class='frameBody'>"+content+"</body></html>";
            tryEnableDesignMode(doc, function() {
                $("#toolbar-" + element_id).remove();
                textarea.before(toolbar());
                // hide textarea
                textarea.hide();

            });

        }

        function tryEnableDesignMode(doc, callback) {
            if(!iframe) { return false; }

            try {
                iframe.contentWindow.document.open();
                iframe.contentWindow.document.write(doc);
                iframe.contentWindow.document.close();
            } catch(error) {
                //console.log(error);
            }
            if (document.contentEditable) {
                iframe.contentWindow.document.designMode = "On";
                callback();
                return true;
            }
            else if (document.designMode != null) {
                try {
                    iframe.contentWindow.document.designMode = "on";
                    callback();
                    return true;
                } catch (error) {
                    //console.log(error);
                }
            }
            setTimeout(function(){tryEnableDesignMode(doc, callback)}, 500);
            return false;
        }

        function disableDesignMode(submit) {
            var content = $(iframe).contents().find("body").html();

            if($(iframe).is(":visible")) {
                textarea.val(content);
            }

            if(submit !== true) {
                textarea.show();
                $(iframe).hide();
            }
        }

        // create toolbar and bind events to it's elements
        function toolbar() {
            var tb = $("<div class='rte-toolbar' id='toolbar-"+ element_id +"'><div>\
                <p>\
                    <select>\
                        <option value='p' selected='true'>Paragraph</option>\
                        <option value='h2'>Header</option>\
                        <option value='h3'>Sub Header</option>\
                        <option value='blockquote'>Quote</option>\
                    </select>\
                </p>\
                <p>\
                    <a href='#' class='bold'><img src='"+opts.media_url+"bold.png' alt='bold' /></a>\
                    <a href='#' class='unorderedlist'><img src='"+opts.media_url+"unordered.png' alt='unordered list' /></a>\
                    <a href='#' class='link'><img src='"+opts.media_url+"link.png' alt='link' /></a>\
                </p>\
                <p class='mode'>\
                  design | <a href='#' class='disable'>code</a>\
                </p></div></div>");

            $('select', tb).change(function(){
                var index = this.selectedIndex;
                if( index!=0 ) {
                    var selected = this.options[index].value;
                    formatText("formatblock", '<'+selected+'>');
                }
            });
            $('.bold', tb).click(function(){ formatText('bold');return false; });
            $('.italic', tb).click(function(){ formatText('italic');return false; });
            $('.unorderedlist', tb).click(function(){ formatText('insertunorderedlist');return false; });
            $('.link', tb).click(function(){
                var p=prompt("URL:");
                if(p)
                    formatText('CreateLink', p);
                return false; });

            $('.image', tb).click(function(){
                var p=prompt("image URL:");
                if(p)
                    formatText('InsertImage', p);
                return false; });

            $('.disable', tb).click(function() {
                disableDesignMode();
                var edm = $('<p class="mode"><a class="rte-edm" href="#">design</a> | code</p>');
                tb.empty().append(edm);
                edm.click(function(e){
                    e.preventDefault();
                    enableDesignMode();
                    // remove, for good measure
                    $(this).remove();
                });
                return false;
            });

            // .NET compatability
            if(opts.dot_net_button_class) {
                var dot_net_button = $(iframe).parents('form').find(opts.dot_net_button_class);
                dot_net_button.click(function() {
                    disableDesignMode(true);
                });
            // Regular forms
            } else {
                $(iframe).parents('form').submit(function(){
                    disableDesignMode(true);
                });
            }

            var iframeDoc = $(iframe.contentWindow.document);

            var select = $('select', tb)[0];
            iframeDoc.mouseup(function(){
                setSelectedType(getSelectionElement(), select);
                return true;
            });

            iframeDoc.keyup(function() {
                setSelectedType(getSelectionElement(), select);
                var body = $('body', iframeDoc);
                if(body.scrollTop() > 0) {
                    var iframe_height = parseInt(iframe.style['height'])
                    if(isNaN(iframe_height))
                        iframe_height = 0;
                    var h = Math.min(opts.max_height, iframe_height+body.scrollTop()) + 'px';
                    iframe.style['height'] = h;
                }
                $('#done_page_editing').fadeOut();
                return true;
            });

            return tb;
        };

        function formatText(command, option) {
            iframe.contentWindow.focus();
            try{
                iframe.contentWindow.document.execCommand(command, false, option);
            }catch(e){
                //console.log(e)
            }
            iframe.contentWindow.focus();
        };

        function setSelectedType(node, select) {
            while(node.parentNode) {
                var nName = node.nodeName.toLowerCase();
                for(var i=0;i<select.options.length;i++) {
                    if(nName==select.options[i].value){
                        select.selectedIndex=i;
                        return true;
                    }
                }
                node = node.parentNode;
            }
            select.selectedIndex=0;
            return true;
        };

        function getSelectionElement() {
            if (iframe.contentWindow.document.selection) {
                // IE selections
                selection = iframe.contentWindow.document.selection;
                range = selection.createRange();
                try {
                    node = range.parentElement();
                }
                catch (e) {
                    return false;
                }
            } else {
                // Mozilla selections
                try {
                    selection = iframe.contentWindow.getSelection();
                    range = selection.getRangeAt(0);
                }
                catch(e){
                    return false;
                }
                node = range.commonAncestorContainer;
            }
            return node;
        };
        
        // enable design mode now
        enableDesignMode();

    }); //return this.each
    
    }; // rte

} // if

})(jQuery);
