//(function() {
//    "use strict";

var GINITOKEN = "BEARER 5374a7ab-5457-4b97-8551-73d77f6600c8";

// Bootstrap
window.addEventListener('load', function(e) {
    initHeader();
    initContent();
    addListeners();
    initWebSocket();
    setTimeout(function() {
        window.scrollTo(0, 0);
    }, 1);
}, false);

// Declaration & Initializing
var width, height, hideLangageList, largeHeader, language, oContent, aContactItems, oGlassContent, skipper, oHeaderBar, aImgItems, canvas, ctx, circles, target, animateHeader = true,
    isBgrAnimating = false,
    isSkipperAnimating = false,
    iCurrentBgr = 0,
    bgrInterval, noscroll = true,
    isRevealed = false,
    aAnimIn, t,
    oHotelIcon = document.querySelector('.hotel-case'),
    animInItems = document.querySelectorAll('.anim-in-l, .anim-in-r, .anim-in-b, .anim-in-t'),
    map, pointarray, heatmap,
    infoWindows = [],
    oCounter, cnt = 0;

// Event handling
function addListeners() {
    window.addEventListener('resize', resize);
    window.addEventListener('scroll', scroll);
    skipper.addEventListener('click', function() {
        toggle(1);
    });
    oHeaderBar.addEventListener('click', function() {
        toggle();
    });
    oHotelIcon.addEventListener('click', function(event) {
        // This is very inperformant but quick to implement (Hackathon style)
        if (event.currentTarget.rooms) {
            event.currentTarget.querySelector("img").src = "styles/img/hotel.svg";
            var myNodeList = document.querySelectorAll(".image-wrap img");
            [].forEach.call(myNodeList, function(img, index) {
                img.src = "styles/img/bgr_" + (index + 1) + ".jpg";
            });
            document.getElementById("product-suffix").innerHTML = "X Flights";
            document.querySelector(".subtitle p").innerHTML = "We'll revolutionize the flight ticket market!";
            event.currentTarget.rooms = false;
        } else {
            event.currentTarget.querySelector("img").src = "styles/img/airline.svg";
            var myNodeList = document.querySelectorAll(".image-wrap img");
            [].forEach.call(myNodeList, function(img, index) {
                img.src = "styles/img/bgr_" + (index + 3) + ".jpg";
            });
            document.getElementById("product-suffix").innerHTML = "X Rooms";
            document.querySelector(".subtitle p").innerHTML = "We'll revolutionize the hotel room market!";
            event.currentTarget.rooms = true;
        };
    });

    // init element visibility
    $(".loading-block").hide();
    $("#gini-kpi").hide();
    $("#gini-output").hide();
    document.getElementById("gini-start").addEventListener('click', function(event) {
        $(".loading-block").fadeIn();
        // window.setTimeout(function() {
        //     $(".loading-block").fadeOut();
        //     $("#gini-kpi").fadeIn();
        // }, 3000);
        $("#gini-detail").html(" ");
        document.querySelector("#gini-kpi div").innerHTML = "0 EUR"

        handleAuthClick(event);
    });

    document.getElementById("show-gini-detail").addEventListener('click', function(event) {
        $("#gini-output").fadeIn();
    });

    if (!language) return;
    for (var i = 0; i < language.children.length; i++) {
        language.children[i].addEventListener('click', function(e) {
            if (e.currentTarget.nodeName === 'A') {
                languageDialog();
            } else {
                selectLanguage(e);
            }
        });
    }
}

function initHeader() {
    width = window.innerWidth;
    height = window.innerHeight;
    target = {
        x: 0,
        y: height
    };

    largeHeader = document.getElementById('large-header');
    largeHeader.style.height = height + 'px';

    canvas = document.getElementById('header-canvas');
    canvas.width = width;
    canvas.height = height;
    ctx = canvas.getContext('2d');

    // create particles
    circles = [];
    var numberCircles = 100; //width * 0.5;
    for (var x = 0; x < numberCircles; x++) {
        var c = new Circle();
        circles.push(c);
    }
    limitLoop(animateHeaderCanvas, 60);

    aImgItems = document.querySelector('ul.image-wrap').children;
    bgrInterval = setInterval(animateBackgroundTransition, 5000);

    aContactItems = document.querySelectorAll('.btn-wrapper');

    var i = 0;
    var timeoutAnimation = function() {
        setTimeout(function() {
            if (aContactItems.length == 0) return;
            aContactItems[i].className = aContactItems[i].className + ' fxFlipInX';
            i++;
            if (i < aContactItems.length) timeoutAnimation();
        }, 100);
    }

    disable_scroll();
    timeoutAnimation();
}

function initWebSocket() {
    // var socket = io('localhost:3000');

    // socket.on('newCamera', function(data){
    //     console.log(data);

    //     var image = 'img/mapcamNew.svg';
    //     addCamMarker(data, image, true);
    // });
}

function initContent() {
    oContent = document.getElementById('content');
    oHeaderBar = document.querySelector('header');
    oGlassContent = document.querySelector("#glass-content");
    oCounter = document.querySelector(".number");
    skipper = document.querySelector("#header-skipper");
    aAnimIn = document.querySelectorAll('.animation-init');
    language = document.getElementById('language-setting');

    oContent.style.height = window.innerHeight + 'px';
    oContent.height = window.innerHeight + 'px';

    // INIT THE CHART
    /* Set some base options (settings will override the default settings in Chartist.js *see default settings*). We are adding a basic label interpolation function for the xAxis labels. */
    var options = {
        axisX: {
            labelInterpolationFnc: function(value) {
                return 'Time ' + value;
            }
        },
        low: 0,
        high: 300
    };

    /* Initialize the chart with the above settings */
    var chart = new Chartist.Line('#x-chart', {
        labels: [],
        series: []
    }, options);

    // Create AJAX request
    window.setInterval(function() {
        var r = new XMLHttpRequest();
        r.open("GET", "/orders/recent", true);
        r.onreadystatechange = function() {
            if (r.readyState != 4 || r.status != 200) return;

            // console.log(JSON.parse(r.response));

            var labels = new Array();
            var series = new Array();
            var iterate = 0;

            var map = _.chain(JSON.parse(r.response))
                .groupBy('carrier')
                .mapObject(function(val, key) {
                    var output = {
                        data: val.map(function(obj) {
                            if (iterate === 0) {
                                var date = new Date(obj.createdAt).toLocaleString().substring(11, 19);
                                labels.push(date);
                            };
                            return obj.price
                        }).reverse(),
                        key: key
                    };
                    iterate++;
                    series.push(output);
                    return output;
                })
                .value();

            var data = {
                labels: labels.reverse(),
                series: _.sortBy(series, 'key')
            };

            //$("#offers").html("");
            _.sortBy(JSON.parse(r.response).filter(function(obj) {
                return obj.type === "sell";
            }), "price").slice(0, 10).forEach(function(obj, index) {

                var newHtml = "<td scope=\"row\">" + obj.entityCode + "</td>" +
                    "<td>" + obj.carrier + "</td>" +
                    "<td>" + obj.quantity + "</td>" +
                    "<td>" + obj.price + " €</td>" +
                    "<td><a href=\"javascript:void(0)\">Buy</a></td>";

                var rows = $("#offers").children().toArray(); //[index];
                if (rows.length > index) {
                    row = rows[index];
                    if (row.innerHTML === newHtml) {
                        // nothing should happen
                    } else {
                        // TODO Animate
                        row.innerHTML = newHtml;
                    };
                } else {
                    $("#offers").append("<tr class='anim-row'>" +
                        newHtml + "</tr>");
                }
            });

            _.sortBy(JSON.parse(r.response).filter(function(obj) {
                return obj.type === "buy";
            }), "price").slice(0, 10).forEach(function(obj, index) {

                var newHtml = "<td scope=\"row\">" + obj.entityCode + "</td>" +
                    "<td>" + obj.carrier + "</td>" +
                    "<td>" + obj.quantity + "</td>" +
                    "<td>" + obj.price + " €</td>" +
                    "<td><a href=\"javascript:void(0)\">Buy</a></td>";

                var rows = $("#demand").children().toArray(); //[index];
                if (rows.length > index) {
                    row = rows[index];
                    if (row.innerHTML === newHtml) {
                        // nothing should happen
                    } else {
                        // TODO Animat
                        row.innerHTML = newHtml;
                    };
                } else {
                    $("#demand").append("<tr class='anim-row'>" +
                        newHtml + "</tr>");
                }
            });

            // console.log(labels);
            // console.log(data);

            // UPDATE THE CHART
            chart.update(data);
        };
        r.send();
    }, 1000);



}

function closeAllInfoWindows() {
    for (var i = 0; i < infoWindows.length; i++) {
        infoWindows[i].close();
    }
}

function disable_scroll() {
    var preventDefault = function(e) {
        e = e || window.event;
        if (e.preventDefault)
            e.preventDefault();
        e.returnValue = false;
    };
    document.body.ontouchmove = function(e) {
        preventDefault(e);
    };
}

function enable_scroll() {
    window.onmousewheel = document.onmousewheel = document.onkeydown = document.body.ontouchmove = null;
}

function scroll() {
    // Update Glass header
    // var iOffset = window.pageYOffset;
    // if (oGlassContent) oGlassContent.style.marginTop = (iOffset * -1) + 'px';

    // Upate Large Header
    var scrollVal = window.pageYOffset || largeHeader.scrollTop;
    if (noscroll) {
        if (scrollVal < 0) return false;
        window.scrollTo(0, 0);
    }
    if (isSkipperAnimating) {
        return false;
    }
    if (scrollVal <= 0 && isRevealed) {
        toggle(0);
    } else if (scrollVal > 0 && !isRevealed) {
        toggle(1);
    }

    var bodyRect = document.body.getBoundingClientRect(),
        viewYPosBottom = window.pageYOffset + window.innerHeight;

    // start entrance animation
    for (var i = 0; i < animInItems.length; i++) {
        if (!classie.has(animInItems[i], 'start-fx')) {
            var element = animInItems[i],
                elemRect = element.getBoundingClientRect(),
                elemTop = elemRect.top - bodyRect.top;

            // start animation when element passed one quarter of viewport
            if (elemTop - viewYPosBottom < window.innerHeight * -1 / 4) {
                classie.add(element, 'start-fx');
            }
        }
    }

    // Animate Sections
    for (var i = 0; i < aAnimIn.length; i++) {
        var animationElement = aAnimIn[i];

        var docViewTop = window.pageYOffset;
        var docViewBottom = docViewTop + window.innerHeight;

        var elemTop = animationElement.offsetTop;
        // var elemBottom = elemTop + animationElement.offsetHeight;

        if (elemTop <= docViewBottom - animationElement.offsetHeight / 3) {
            if (animationElement.classList.contains('animate-in') == false) {
                animationElement.className = animationElement.className + ' animate-in';
            }
        }
    }
}

function resize() {
    width = window.innerWidth;
    height = window.innerHeight;
    largeHeader.style.height = height + 'px';
    canvas.width = width;
    canvas.height = height;

    oContent.style.height = height + 'px';
    oContent.height = height + 'px';
}

function toggle(reveal) {
    isSkipperAnimating = true;

    if (reveal) {
        document.body.className = 'revealed';
    } else {
        animateHeader = true;
        noscroll = true;
        disable_scroll();
        document.body.className = '';
        // Reset animated content
        for (var i = 0; i < aAnimIn.length; i++) {
            var animationElement = aAnimIn[i];
            animationElement.className = animationElement.className.replace(' animate-in', '');
        }
    }

    // simulating the end of the transition:
    setTimeout(function() {
        isRevealed = !isRevealed;
        isSkipperAnimating = false;
        if (reveal) {
            animateHeader = false;
            noscroll = false;
            enable_scroll();
        }
    }, 1200);
}

function animateBackgroundTransition(dir) {
    if (isBgrAnimating) return false;
    isBgrAnimating = true;
    var cntAnims = 0;
    var itemsCount = aImgItems.length;
    dir = dir || 'next';

    var currentItem = aImgItems[iCurrentBgr];
    if (dir === 'next') {
        iCurrentBgr = (iCurrentBgr + 1) % itemsCount;
    } else if (dir === 'prev') {
        iCurrentBgr = (iCurrentBgr - 1) % itemsCount;
    }
    var nextItem = aImgItems[iCurrentBgr];

    var classAnimIn = dir === 'next' ? 'navInNext' : 'navInPrev'
    var classAnimOut = dir === 'next' ? 'navOutNext' : 'navOutPrev';

    var onEndAnimationCurrentItem = function() {
        currentItem.className = '';
        ++cntAnims;
        if (cntAnims === 2) {
            isBgrAnimating = false;
        }
    }

    var onEndAnimationNextItem = function() {
        nextItem.className = 'current';
        ++cntAnims;
        if (cntAnims === 2) {
            isBgrAnimating = false;
        }
    }

    setTimeout(onEndAnimationCurrentItem, 2000);
    setTimeout(onEndAnimationNextItem, 2000);

    currentItem.className = currentItem.className + ' ' + classAnimOut;
    nextItem.className = nextItem.className + classAnimIn;
}

var animateHeaderCanvas = function() {
    if (animateHeader) {
        ctx.clearRect(0, 0, width, height);
        for (var i in circles) {
            circles[i].draw();
        }
    }
}

var limitLoop = function(fn, fps) {

    // Use var then = Date.now(); if you
    // don't care about targetting < IE9
    var then = new Date().getTime();

    // custom fps, otherwise fallback to 60
    fps = fps || 60;
    var interval = 1000 / fps;

    return (function loop(time) {
        requestAnimationFrame(loop);

        // again, Date.now() if it's available
        var now = new Date().getTime();
        var delta = now - then;

        if (delta > interval) {
            // Update time
            // now - (delta % interval) is an improvement over just 
            // using then = now, which can end up lowering overall fps
            then = now - (delta % interval);

            // call the fn
            fn();
        }
    }(0));
};

// Canvas manipulation
function Circle() {
    var _this = this;

    // constructor
    (function() {
        _this.pos = {};
        init();
    })();

    function init() {
        _this.pos.x = Math.random() * width;
        _this.pos.y = height + Math.random() * 100;
        _this.alpha = 0.1 + Math.random() * 0.3;
        _this.scale = 0.1 + Math.random() * 0.3;
        _this.velocity = Math.random();
    }

    this.draw = function() {
        if (_this.alpha <= 0) {
            init();
        }
        _this.pos.y -= _this.velocity;
        _this.alpha -= 0.0005;
        ctx.beginPath();
        ctx.arc(_this.pos.x, _this.pos.y, _this.scale * 10, 0, 2 * Math.PI, false);
        ctx.fillStyle = 'rgba(255,255,255,' + _this.alpha + ')';
        ctx.fill();
    };
}

// GINI & GMAIL STUFF IS COMING HERE
var totalAmount = 0.0;
var openGiniDocs = [];

var SAVING_PCT = 0.1;

// Your Client ID can be retrieved from your project in the Google
// Developer Console, https://console.developers.google.com
var CLIENT_ID = '687173267686-moe5rcfrv7iiuq7tsa808tudjvdsetka.apps.googleusercontent.com';

var SCOPES = ['https://www.googleapis.com/auth/gmail.readonly'];

/**
 * Check if current user has authorized this application.
 */
function checkAuth() {
    gapi.auth.authorize({
        'client_id': '687173267686-moe5rcfrv7iiuq7tsa808tudjvdsetka.apps.googleusercontent.com',
        'scope': SCOPES,
        'immediate': true
    }, handleAuthResult);
}

/**
 * Handle response from authorization server.
 *
 * @param {Object} authResult Authorization result.
 */
function handleAuthResult(authResult) {
    //var authorizeDiv = document.getElementById('authorize-div');
    if (!authResult.error) { //authResult && !authResult.error) {
        // Hide auth UI, then load client library.
        //authorizeDiv.style.display = 'none';
        loadGmailApi();
    } else {
        // Show auth UI, allowing the user to initiate authorization by
        // clicking authorize button.
        //authorizeDiv.style.display = 'inline';
    }
}

/**
 * Initiate auth flow in response to user clicking authorize button.
 *
 * @param {Event} event Button click event.
 */
function handleAuthClick(event) {
    gapi.auth.authorize({
            client_id: CLIENT_ID,
            scope: SCOPES,
            immediate: false
        },
        handleAuthResult);
    return false;
}

/**
 * Load Gmail API client library. List labels once client library
 * is loaded.
 */
function loadGmailApi() {
    gapi.client.load('gmail', 'v1', startSearch);
}

function currenyCalculation(value, curr) {
    return value;
}

function startSearch() {
    listMessages("me", "flug filename:pdf", function(result) {
        //console.log(result);
        //Loop over message ids
        result.forEach(function(obj, index) {
            getMessage("me", obj.id, function(messages) {
                //console.log(messages);

                getAttachments("me", messages, function(fileName, fileType, data) {
                    //                            console.log(fileName);
                    //                            console.log(fileName.split('.').pop().toUpperCase());
                    if (fileName.split('.').pop().toUpperCase() == "PDF") {
                        //                                appendPre(fileName + " " + fileType);

                        //Make post to gini
                        var headers = {
                            'Accept': 'application/vnd.gini.v1+json',
                            'Authorization': GINITOKEN
                        };

                        var options = {
                            url: 'https://api.gini.net/documents',
                            method: 'POST',
                            headers: headers
                        };

                        var r = new XMLHttpRequest();
                        r.open("POST", "https://api.gini.net/documents", true);
                        r.setRequestHeader('Accept', 'application/vnd.gini.v1+json');
                        r.setRequestHeader('Authorization', GINITOKEN);
                        //r.setRequestHeader("Content-Type", fileType);
                        //r.setRequestHeader("X-File-Name", encodeURIComponent(fileName));
                        r.onreadystatechange = function() {
                            if (r.readyState != 4) return;
                            console.log(r.getResponseHeader("Location"));

                            setTimeout(function() {
                                var xhr = new XMLHttpRequest();
                                xhr.open("GET", r.getResponseHeader("Location") + "/extractions", true);
                                xhr.setRequestHeader('Accept', 'application/vnd.gini.v1+json');
                                xhr.setRequestHeader('Authorization', GINITOKEN);
                                xhr.onreadystatechange = function() {
                                    if (xhr.readyState != 4) return;
                                    console.log(xhr.responseText);
                                    var oResponse = JSON.parse(xhr.responseText);
                                    console.log(fileName);
                                    console.log(r.getResponseHeader("Location"));
                                    var amount, eurAmount;
                                    if (oResponse.extractions.amountToPay) {
                                        console.log(oResponse.extractions.amountToPay.value);
                                        amount = oResponse.extractions.amountToPay.value;
                                        eurAmount = currenyCalculation(amount.split(":")[0]);
                                        console.log(eurAmount);
                                        totalAmount += parseFloat(eurAmount);
                                        appendPre(totalAmount * SAVING_PCT);
                                    }
                                    $("#gini-detail").append("<tr><td>" +
                                        fileName + "</td><td>" + 
                                        eurAmount + " €</td></tr>")

                                }
                                xhr.send();

                            }, 4000); //Rough hack to let gini time to process

                        };

                        var s = data.data.replace(/-/g, "+").replace(/_/g, "/");
                        var byteArray = Base64Binary.decodeArrayBuffer(s);
                        r.send(byteArray);
                    }

                })
            });
        })

    })
}

/**
 * Get Message with given ID.
 *
 * @param  {String} userId User's email address. The special value 'me'
 * can be used to indicate the authenticated user.
 * @param  {String} messageId ID of Message to get.
 * @param  {Function} callback Function to call when the request is complete.
 */
function getMessage(userId, messageId, callback) {
    var request = gapi.client.gmail.users.messages.get({
        'userId': userId,
        'id': messageId
    });
    request.execute(callback);
}


/**
 * Get Attachments from a given Message.
 *
 * @param  {String} userId User's email address. The special value 'me'
 * can be used to indicate the authenticated user.
 * @param  {String} messageId ID of Message with attachments.
 * @param  {Function} callback Function to call when the request is complete.
 */
function getAttachments(userId, message, callback) {
    var parts = message.payload.parts;
    for (var i = 0; i < parts.length; i++) {
        var part = parts[i];
        if (part.filename && part.filename.length > 0) {
            var attachId = part.body.attachmentId;
            var request = gapi.client.gmail.users.messages.attachments.get({
                'id': attachId,
                'messageId': message.id,
                'userId': userId
            });
            request.execute(function(attachment) {
                callback(part.filename, part.mimeType, attachment);
            });
        }
    }
}

/**
 * Print all Labels in the authorized user's inbox. If no labels
 * are found an appropriate message is printed.
 */
function listLabels() {
    var request = gapi.client.gmail.users.labels.list({
        'userId': 'me'
    });

    request.execute(function(resp) {
        var labels = resp.labels;
        appendPre('Labels:');

        if (labels.length > 0) {
            for (i = 0; i < labels.length; i++) {
                var label = labels[i];
                appendPre(label.name)
            }
        } else {
            appendPre('No Labels found.');
        }
    });
}

/**
 * Retrieve Messages in user's mailbox matching query.
 *
 * @param  {String} userId User's email address. The special value 'me'
 * can be used to indicate the authenticated user.
 * @param  {String} query String used to filter the Messages listed.
 * @param  {Function} callback Function to call when the request is complete.
 */
function listMessages(userId, query, callback) {
    var getPageOfMessages = function(request, result) {
        request.execute(function(resp) {
            result = result.concat(resp.messages);
            var nextPageToken = resp.nextPageToken;
            if (nextPageToken) {
                request = gapi.client.gmail.users.messages.list({
                    'userId': userId,
                    'pageToken': nextPageToken,
                    'q': query
                });
                getPageOfMessages(request, result);
            } else {
                callback(result);
            }
        });
    };
    var initialRequest = gapi.client.gmail.users.messages.list({
        'userId': userId,
        'q': query
    });
    getPageOfMessages(initialRequest, []);
}

/**
 * Append a pre element to the body containing the given message
 * as its text node.
 *
 * @param {string} message Text to be placed in pre element.
 */
function appendPre(message) {

    $(".loading-block").fadeOut();
    $("#gini-kpi").fadeIn();
    document.querySelector("#gini-kpi div").innerHTML = Math.floor(parseFloat(document.querySelector("#gini-kpi div").innerHTML) + message) + ' EUR';

    // var pre = document.getElementById('output');
    // var textContent = document.createTextNode(message + '\n');
    // pre.appendChild(textContent);
}



//})();
