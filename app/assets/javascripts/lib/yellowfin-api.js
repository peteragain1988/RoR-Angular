window.yellowfin = window.yellowfin || {
  /*
   * Yellowfin External Javascript Base API
   */
  "apiVersion": "2.1",
  "baseURL": "https://bi.eventhub.com.au/JsAPI",

  "serverInfo": {
    "releaseVersion": "7.1",
    "buildVersion": "20140827",
    "javaVersion": "1.8.0_20",
    "operatingSystem": "Windows Server 2008",
    "operatingSystemArch": "x86",
    "operatingSystemVersion": "6.0",
    "schemaVersion": ""
  },

  "requests": [],
  "nextRequestId": 0,

  "traceEnabled": false,

  "trace": function(name) {
    if (this.traceEnabled) {
      this.log('TRACE: ' + name);
    }
  },

  "log": function(text) {
    if (window.console && console.log) {
      console.log(text);
    }
  },

  "apiError": function(object) {
    this.trace('yellowfin.yellowfin.apiError()');
    alert('API Error: ' + object.errorDescription);
  },

  "apiLoadError": function(object) {
    this.trace('yellowfin.yellowfin.apiLoadError()');
    alert('Error loading API: ' + object.errorDescription);
  },

  "insertStylesheet": function(url) {
    this.trace('yellowfin.insertStylesheet()');

    var css = document.createElement('link');
    css.type = 'text/css';
    css.rel = 'stylesheet';
    css.href = url;
    css.media = 'screen';
    var head = document.getElementsByTagName('head')[0];
    if (head.firstChild) {
      head.insertBefore(css, head.firstChild);
    } else {
      head.appendChild(css);
    }

  },

  "insertScript": function(url) {
    this.trace('yellowfin.insertScript()');

    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = url;
    document.getElementsByTagName('head')[0].appendChild(s);

  },

  "loadApi": function(type, callback, arg) {
    this.trace('yellowfin.loadApi(\'' + type + '\')');

    var url = this.baseURL + '?api=' + encodeURIComponent(type);
    if (callback && callback != '') {
      url += '&callback=' + encodeURIComponent(callback);
      if (arg != null) {
        url += '&arg=' + encodeURIComponent(arg);
      }
    }
    this.insertScript(url);

  },

  "loadScript": function(script, callback, arg) {
    this.trace('yellowfin.loadScript(\'' + script + '\')');

    var url = this.baseURL + '?load=' + script;
    if (callback && callback != '') {
      url += '&callback=' + encodeURIComponent(callback);
      if (arg) {
        url += '&arg=' + encodeURIComponent(arg);
      }
    }
    this.insertScript(url);

  },

  "getObj": function(id) {
    this.trace('yellowfin.getObj()');

    if (document.layers) return document.layers[id];
    if (document.getElementById) return document.getElementById(id);
    return document.all[id];
  },

  "hasClassName": function(element, className) {
    this.trace('yellowfin.hasClassName()');

    if (!element) return;
    var cn = element.className;
    return (cn && (cn == className || new RegExp("(^|\\s)" + className + "(\\s|$)").test(cn)));
  },

  "EventObj" : function(event, element) {

    /* the event object */
    this.event = event || window.event;

    /* mouse buttons */
    this.buttonLeft = false;
    this.buttonMiddle = false;
    this.buttonRight = false;
    if (this.event.which) {
      switch (this.event.which) {
        case 1:
          this.buttonLeft = true;
          break;
        case 2:
          this.buttonMiddle = true;
          break;
        case 3:
          this.buttonRight = true;
          break;
      }
    } else if (this.event.button) {
      this.buttonLeft = (this.event.button & 1) == 1;
      this.buttonMiddle = (this.event.button & 2) == 2;
      this.buttonRight = (this.event.button & 4) == 4;
    }

    /* mouse and window co-ordinates */
    if (this.event.pageX) {
      this.pageX = this.event.pageX;
      this.pageY = this.event.pageY;
    } else {
      this.pageX = this.event.clientX + yellowfin.getScrollLeft() - 2;
      this.pageY = this.event.clientY + yellowfin.getScrollTop() - 2;
    }
    this.clientX = this.event.clientX;
    this.clientY = this.event.clientY;

    /* source element */
    this.element = element;
    this.target = this.event.target || this.event.srcElement;
    this.fromElement = this.event.fromElement || this.event.relatedTarget;
    this.toElement = this.event.toElement || this.event.relatedTarget;

    /* prevent default function */
    this.preventDefault = function() {
      if (this.event.preventDefault) {
        this.event.preventDefault();
      } else {
        this.event.returnValue = false;
      }
    };

  },

  "loadReport": function(object) {
    this.trace('yellowfin.loadReport()');

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "options": object
    };
    this.requests['r' + rid] = robj;

    if (yellowfin.reports) {
      this.loadReportNow(rid);
    } else {
      this.loadApi('reports', 'yellowfin.loadReportNow', rid);
    }
  },

  "loadReportNow": function(reqId) {
    this.trace('yellowfin.loadReportNow()');

    var object = this.requests['r' + reqId];
    if (!object) {
      alert('Error: invalid request');
      return;
    }
    this.requests['r' + reqId] = null;

    yellowfin.reports.loadReport(object.options);
  },

  "loadDash": function(object) {
    this.trace('yellowfin.loadDash()');

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "options": object
    };
    this.requests['r' + rid] = robj;

    if (yellowfin.dash) {
      this.loadDashNow(rid);
    } else {
      this.loadApi('dash', 'yellowfin.loadDashNow', rid);
    }
  },

  "loadDashNow": function(reqId) {
    this.trace('yellowfin.loadDashNow()');

    var object = this.requests['r' + reqId];
    if (!object) {
      alert('Error: invalid request');
      return;
    }
    this.requests['r' + reqId] = null;

    yellowfin.dash.loadDash(object.options);
  },

  "getAbsoluteTop": function(elem) {
    this.trace('yellowfin.getAbsoluteTop()');

    var topPosition = 0;
    while (elem) {
      if (elem.tagName.toUpperCase() == 'BODY') break;
      topPosition += elem.offsetTop;
      elem = elem.offsetParent;
    }
    return topPosition;
  },

  "getAbsoluteLeft": function(elem) {
    this.trace('yellowfin.getAbsoluteLeft()');

    var leftPosition = 0;
    while (elem) {
      if (elem.tagName.toUpperCase() == 'BODY') break;
      leftPosition += elem.offsetLeft;
      elem = elem.offsetParent;
    }
    return leftPosition;
  },

  "eventOnObject": function(obj, onEvent, handler) {
    this.trace('yellowfin.eventOnObject()');

    if (obj.attachEvent) {
      obj.attachEvent("on" + onEvent, handler);
    } else {
      obj.addEventListener(onEvent, handler, true);
    }
  },

  "eventOffObject": function(obj, onEvent, handler) {
    this.trace('yellowfin.eventOffObject()');

    if (obj.detachEvent) {
      obj.detachEvent("on" + onEvent, handler);
    } else {
      obj.removeEventListener(onEvent, handler, true);
    }
  },

  "getScrollLeft": function() {
    this.trace('yellowfin.getScrollLeft()');

    if (document.compatMode && document.compatMode != 'BackCompat') {
      return Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);
    } else {
      return document.body.scrollLeft;
    }
  },

  "getScrollTop": function() {
    this.trace('yellowfin.getScrollTop()');

    if (document.compatMode && document.compatMode != 'BackCompat') {
      return Math.max(document.documentElement.scrollTop, document.body.scrollTop);
    } else {
      return document.body.scrollTop;
    }
  }


};
window.yellowfin = window.yellowfin || {};
yellowfin.dash = yellowfin.dash || {

  "requests": [],
  "nextRequestId": 0,
  "dashOptions": [],
  "loadingDash": false,
  "dashQueue": [],
  "commonStyleLoaded": false,

  "dashLoadError": function(object) {
    yellowfin.trace('yellowfin.dash.dashLoadError()');
    /*
     if (object.errorCodeStr == 'NO_ACCESS') {
     yellowfin.showLogonFormWithErrors(object, object.errorDescription);
     return;
     }
     */

    if (object.reqId) {
      var robj = this.requests['r' + object.reqId];
      if (robj && robj.options && robj.options.outerContainer && robj.loadingDiv) {
        robj.options.outerContainer.removeChild(robj.loadingDiv);
      }
      this.requests['r' + object.reqId] = null;
    }

    alert('Error loading dashboard: ' + object.errorDescription);
    this.loadNextDash();
  },

  "loadDash": function(options) {
    yellowfin.trace('yellowfin.dash.loadDash()');

    // validate
    if (!options) {
      alert('No options specified');
      return;
    }

    if (!options.dashUUID || options.dashUUID == '') {
      alert('No dashUUID specified');
      return;
    }

    if (!options.element) {
      if (options.elementId) {
        options.element = yellowfin.getObj(options.elementId);
        if (!options.element) {
          alert('Element not found: ' + options.elementId);
          return;
        }
      }
    }
    if (!options.element) {
      alert('No Element specified');
      return;
    }

    this.dashOptions['d' + options.dashUUID] = options;
    options.showTitle = options.showTitle == null || options.showTitle == true || options.showTitle == 'true';
    options.showInfo = options.showInfo == null || options.showInfo == true || options.showInfo == 'true';
    options.showFilters = options.showFilters == null || options.showFilters == true || options.showFilters == 'true';
    options.showTimesel = options.showTimesel == null || options.showTimesel == true || options.showTimesel == 'true';
    options.showExport = options.showExport == null || options.showExport == true || options.showExport == 'true';

    if (!options.height) {
      if (options.innerElement) {
        options.height = options.innerElement.offsetHeight;
      } else if (options.element.offsetHeight) {
        options.height = options.element.offsetHeight - 5;
        if (options.showTitle) options.height -= 30;
        if (options.height < 0) options.height = null;
      }
    }

    if (!options.width) {
      if (options.innerElement) {
        options.width = options.innerElement.offsetWidth;
      } else {
        options.width = options.element.offsetWidth;
      }
    }

    // set up the container div etc
    this.setupDash(options);

    if (this.loadingDash) {
      this.dashQueue.push(options);
    } else {
      this.loadDashNow(options);
    }
  },

  "loadDashNow": function(options) {
    yellowfin.trace('yellowfin.dash.loadDashNow(' + options.dashUUID + ')');

    this.loadingDash = true;

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "options": options
    };
    this.requests['r' + rid] = robj;

    div = this.createLoadingDiv('Loading Dashboard...');
    options.outerContainer.appendChild(div);
    robj.loadingDiv = div;

    var src = yellowfin.baseURL + '?api=dash&cmd=loadDash&reqId=' + rid;
    src += '&version=' + yellowfin.apiVersion;
    src += '&dashUUID=' + options.dashUUID;
    if (options.height) {
      src += '&height=' + options.height;
    }
    if (options.width) {
      src += '&width=' + options.width;
    }
    if (options.reload == null || options.reload == true) {
      src += '&reload=true';
    }
    if (options.username) {
      src += '&username=' + encodeURIComponent(options.username);
    }
    if (options.password) {
      src += '&password=' + encodeURIComponent(options.password);
    }
    if (options.token) {
      src += '&token=' + encodeURIComponent(options.token);
    }
    if (options.filters) {
      for (var k in options.filters) {
        src += '&yfFilter' + k + '=';
        if (options.filters[k] instanceof Array) {
          src += encodeURIComponent(this.serialiseList(options.filters[k]));
        } else {
          src += encodeURIComponent(options.filters[k]);
        }
      }
    }

    src += '&r=' + Math.floor(Math.random() * 1000000000);

    yellowfin.insertScript(src);

  },

  "setupDash": function(options) {
    yellowfin.trace('yellowfin.dash.setupDash()');

    if (!options) return;
    if (!options.element) return;
    if (!options.dashUUID) return;

    if (!this.commonStyleLoaded) {
      yellowfin.insertStylesheet(yellowfin.baseURL + '?api=dash&cmd=commonCss&u=' + Math.floor(Math.random() * 1000000000));
      this.commonStyleLoaded = true;
    }

    if (!options.outerContainer) {

      // set up divs
      while (options.element.firstChild)
        options.element.removeChild(options.element.firstChild);

      var div = document.createElement('div');
      div.className = 'yfDashOuterContainer';
      if (options.element.offsetHeight) {
        div.style.height = options.element.offsetHeight + 'px';
      }
      div.style.width = '100%';
      div.style.position = 'relative';
      options.element.appendChild(div);
      options.outerContainer = div;

      if (options.showTitle) {
        div = document.createElement('div');
        div.className = 'yfDashTitleOuter';
        if (options.width) {
          div.style.width = options.width + 'px';
        } else {
          div.style.width = '100%';
        }

        options.outerContainer.appendChild(div);
        options.titleElement = div;
      }

      div = document.createElement('div');
      div.className = 'yfDash';
      if (options.height) {
        div.style.height = options.height + 'px';
      }
      if (options.width) {
        div.style.width = options.width + 'px';
      } else {
        div.style.width = '100%';
      }
      div.style.position = 'relative';
      div.style.overflow = 'auto';
      options.outerContainer.appendChild(div);
      options.innerElement = div;

      div = document.createElement('div');
      div.className = 'yfLogon';
      div.style.position = 'relative';
      div.style.overflow = 'auto';
      div.style.width = '100%';
      if (options.height) {
        div.style.height = options.height + 'px';
      }
      div.style.padding = '2px 0px';
      div.style.display = 'none';
      var div2 = document.createElement('div');
      div2.className = 'yfLogonErrors';
      div2.style.display = 'none';
      div.appendChild(div2);
      options.logonErrorsElement = div2;
      var tbl = document.createElement('table');
      var tbody = document.createElement('tbody');
      var tr = document.createElement('tr');
      var td = document.createElement('td');
      td.appendChild(document.createTextNode('Username:'));
      tr.appendChild(td);
      td = document.createElement('td');
      var txtel = document.createElement('input');
      txtel.type = 'text';
      td.appendChild(txtel);
      options.logonUsernameEl = txtel;
      tr.appendChild(td);
      tbody.appendChild(tr);
      tr = document.createElement('tr');
      td = document.createElement('td');
      td.appendChild(document.createTextNode('Password:'));
      tr.appendChild(td);
      td = document.createElement('td');
      txtel = document.createElement('input');
      txtel.type = 'password';
      td.appendChild(txtel);
      options.logonPasswordEl = txtel;
      tr.appendChild(td);
      tbody.appendChild(tr);
      tr = document.createElement('tr');
      td = document.createElement('td');
      tr.appendChild(td);
      td = document.createElement('td');
      var el = document.createElement('input');
      el.type = 'submit';
      el.name = 'submitbutton';
      el.value = 'Login';
      el.onclick = function() { yellowfin.dash.logon(options.dashUUID) };
      td.appendChild(el);
      tr.appendChild(td);
      tbody.appendChild(tr);
      tbl.appendChild(tbody);
      div.appendChild(tbl);
      options.outerContainer.appendChild(div);
      options.logonElement = div;


      div = document.createElement('div');
      div.className = 'yfDashFooter';
      if (options.width) {
        div.style.width = options.width + 'px';
      } else {
        div.style.width = '100%';
      }
      div.style.position = 'relative';
      options.outerContainer.appendChild(div);
      options.footerElement = div;

    }

  },

  "loadNextDash": function() {
    yellowfin.trace('yellowfin.dash.loadNextDash()');

    if (this.dashQueue.length > 0) {
      this.loadDashNow(this.dashQueue.shift());
    } else {
      this.loadingDash = false;
    }

  },

  "createLoadingDiv": function(text) {
    yellowfin.trace('yellowfin.dash.createLoadingDiv()');

    var div = document.createElement('div');
    div.className = 'yfReportLoading';
    div.style.background = '#c0c0c0';
    div.style.position = 'absolute';
    div.style.top = '0px';
    div.style.left = '0px';
    div.style.fontFamily = 'Arial, Helvetica, sans-serif';
    div.style.fontSize = '16px';
    div.style.padding = '1px';
    div.appendChild(document.createTextNode(text));
    return div;
  },

  "dashLoaded": function(object) {
    yellowfin.trace('yellowfin.dash.dashLoaded()');

    var robj = this.requests['r' + object.reqId];
    if (!robj) {
      alert('Error: invalid request');
      this.loadNextDash();
      return;
    }

    this.requests['r' + object.reqId] = null;

    if (robj.options.titleElement && robj.options.showTitle) {

      while (robj.options.titleElement.firstChild)
        robj.options.titleElement.removeChild(robj.options.titleElement.firstChild);

      var tbl2 = document.createElement('table');
      tbl2.border = 0;
      tbl2.cellPadding = 0;
      tbl2.cellSpacing = 0;
      tbl2.width = '100%';
      var tbody2 = document.createElement('tbody');
      var tr2 = document.createElement('tr');
      var td2 = document.createElement('td');
      td2.width = 4;
      var img = document.createElement('img');
      img.src = yellowfin.baseURL + '?cmd=img&fn=js_top_left.png';
      img.border = 0;
      img.style.display = 'block';
      td2.appendChild(img);
      tr2.appendChild(td2);
      td2 = document.createElement('td');
      td2.setAttribute('width', '*');
      td2.style.background = 'url(' + yellowfin.baseURL + '?cmd=img&fn=js_top.png)';

      var innerDiv = document.createElement('div');
      innerDiv.className = 'yfDashTitleInner';

      var tbl = document.createElement('table');
      tbl.width = '100%';
      tbl.border = 0;
      tbl.cellSpacing = 0;
      tbl.cellPadding = 0;
      var tbody = document.createElement('tbody');
      var tr = document.createElement('tr');
      var td = document.createElement('td');
      td.className = 'yfDashTitle';

      var div = document.createElement('div');
      div.className = 'yfDashTitle';
      div.appendChild(document.createTextNode(object.dashTitle));
      td.appendChild(div);
      tr.appendChild(td);

      td = document.createElement('td');
      td.width = '3';
      tr.appendChild(td);

      td = document.createElement('td');
      td.className = 'yfDashTitleLinks';

      if (robj.options.showInfo) {
        var a = document.createElement('a');
        a.href = 'javascript:yellowfin.dash.toggleDashInfo(\'' + robj.options.dashUUID + '\');';
        var img = document.createElement('img');
        img.src = yellowfin.baseURL + '?cmd=img&fn=js_info.png';
        img.border = 0;
        img.align = 'absmiddle';
        img.title = 'Dashboard Info';
        a.appendChild(img);
        td.appendChild(a);
        td.appendChild(document.createTextNode(' '));
        robj.options.infoBtnImg = img;

        a = document.createElement('a');
        a.href = 'javascript:yellowfin.dash.toggleShare(\'' + robj.options.dashUUID + '\');';
        var img = document.createElement('img');
        img.src = yellowfin.baseURL + '?cmd=img&fn=js_share.png';
        img.border = 0;
        img.align = 'absmiddle';
        img.title = 'Share';
        a.appendChild(img);
        td.appendChild(a);
        td.appendChild(document.createTextNode(' '));
        robj.options.shareBtnImg = img;

      }

      if (robj.options.showFilters && object.filterhtml && object.filterhtml != '') {
        var a = document.createElement('a');
        a.href = 'javascript:yellowfin.dash.toggleFilters(\'' + robj.options.dashUUID + '\');';
        var img = document.createElement('img');
        img.src = yellowfin.baseURL + '?cmd=img&fn=js_filter.png';
        img.border = 0;
        img.align = 'absmiddle';
        img.title = 'Filters';
        a.appendChild(img);
        td.appendChild(a);
        td.appendChild(document.createTextNode(' '));
        robj.options.filterBtnImg = img;
      }

      if (robj.options.showExport && object.exporthtml && object.exporthtml != '') {
        var a = document.createElement('a');
        a.href = 'javascript:yellowfin.dash.toggleExport(\'' + robj.options.dashUUID + '\');';
        var img = document.createElement('img');
        img.src = yellowfin.baseURL + '?cmd=img&fn=js_export.png';
        img.border = 0;
        img.align = 'absmiddle';
        img.title = 'Export';
        a.appendChild(img);
        td.appendChild(a);
        td.appendChild(document.createTextNode(' '));
        robj.options.exportBtnImg = img;
      }

      if (robj.options.showTimesel && object.timeselhtml && object.timeselhtml != '') {
        var a = document.createElement('a');
        a.href = 'javascript:yellowfin.dash.toggleTimesel(\'' + robj.options.dashUUID + '\');';
        var img = document.createElement('img');
        img.src = yellowfin.baseURL + '?cmd=img&fn=js_aggregation.png';
        img.border = 0;
        img.align = 'absmiddle';
        img.title = 'Time Period';
        a.appendChild(img);
        td.appendChild(a);
        td.appendChild(document.createTextNode(' '));
        robj.options.timeselBtnImg = img;
      }

      tr.appendChild(td);
      tbody.appendChild(tr);
      tbl.appendChild(tbody);

      innerDiv.appendChild(tbl);
      td2.appendChild(innerDiv);
      tr2.appendChild(td2);
      td2 = document.createElement('td');
      td2.width = 4;
      var img = document.createElement('img');
      img.src = yellowfin.baseURL + '?cmd=img&fn=js_top_right.png';
      img.border = 0;
      img.style.display = 'block';
      td2.appendChild(img);
      tr2.appendChild(td2);
      tbody2.appendChild(tr2);
      tbl2.appendChild(tbody2);

      robj.options.titleElement.appendChild(tbl2);

    }

    if (robj && robj.options && robj.options.outerContainer && robj.loadingDiv) {
      robj.options.outerContainer.removeChild(robj.loadingDiv);
    }

    while (robj.options.innerElement.firstChild)
      robj.options.innerElement.removeChild(robj.options.innerElement.firstChild);

    if (robj.options.filterFormElement) {
      if (robj.options.filterFormElement.parentNode) {
        robj.options.filterFormElement.parentNode.removeChild(robj.options.filterFormElement);
      }
      robj.options.filterFormElement = null;
    }
    if (robj.options.filterElement) {
      if (robj.options.filterElement.parentNode) {
        robj.options.filterElement.parentNode.removeChild(robj.options.filterElement);
      }
      robj.options.filterElement = null;
    }

    if (robj.options.showFilters && object.filterhtml && object.filterhtml != '') {

      var outerDiv = document.createElement('div');
      outerDiv.className = 'yfDashLeftMenu yfDashFilters';

      var frm = document.createElement('form');
      frm.style.margin = '0px';
      frm.style.padding = '0px';

      div = document.createElement('div');
      div.className = 'yfDashFiltersInner';
      div.innerHTML = object.filterhtml;
      frm.appendChild(div);

      outerDiv.appendChild(frm);
      robj.options.innerElement.appendChild(outerDiv);
      robj.options.filterFormElement = frm;
      robj.options.filterElement = outerDiv;
      robj.options.filterInnerElement = div;
      robj.options.filters = object.filters;

      this.setupFilters(object.dashUUID);

    }

    if (robj.options.infoElement) {
      if (robj.options.infoElement.parentNode) {
        robj.options.infoElement.parentNode.removeChild(robj.options.infoElement);
      }
      robj.options.infoElement = null;
    }
    if (robj.options.shareElement) {
      if (robj.options.shareElement.parentNode) {
        robj.options.shareElement.parentNode.removeChild(robj.options.shareElement);
      }
      robj.options.shareElement = null;
    }

    if (robj.options.showInfo && robj.options.showTitle) {
      div = document.createElement('div');
      div.className = 'yfDashTopMenu yfDashInfo';

      tbl = document.createElement('table');
      tbl.className = 'yfDashInfoInner';
      tbl.width = '100%';
      tbl.cellPadding = 0;
      tbl.cellSpacing = 0;
      tbody = document.createElement('tbody');
      tr = document.createElement('tr');
      td = document.createElement('td');
      td.innerHTML = object.infohtml;
      tr.appendChild(td);
      td = document.createElement('td');
      td.align = 'right';
      td.vAlign = 'top';
      a = document.createElement('a');
      a.href = 'javascript:yellowfin.dash.toggleDashInfo(\'' + robj.options.dashUUID + '\');';
      img = document.createElement('img');
      img.src = yellowfin.baseURL + '?cmd=img&fn=js_close.png';
      img.border = 0;
      img.align = 'absmiddle';
      img.title = 'Close';
      a.appendChild(img);
      td.appendChild(a);
      tr.appendChild(td);
      tbody.appendChild(tr);
      tbl.appendChild(tbody);
      div.appendChild(tbl);

      robj.options.innerElement.appendChild(div);
      robj.options.infoElement = div;

      div = document.createElement('div');
      div.className = 'yfDashTopMenu yfDashShare';

      tbl = document.createElement('table');
      tbl.className = 'yfDashShareInner';
      tbl.width = '100%';
      tbl.cellPadding = 0;
      tbl.cellSpacing = 0;
      tbody = document.createElement('tbody');
      tr = document.createElement('tr');
      td = document.createElement('td');
      var inp = document.createElement('input');
      inp.type = 'text';
      inp.className = 'yfDashShareInput';

      var w = Math.round(robj.options.titleElement.offsetWidth * 0.9);
      if (w < 60) w = 60;
      inp.style.width = w + 'px';

      inp.value = '<script type="text/javascript" src="' + object.embedLinkEsc + '"></script>';
      inp.onclick = inp.select;
      td.appendChild(inp);
      tr.appendChild(td);
      td = document.createElement('td');
      td.align = 'right';
      td.vAlign = 'top';
      a = document.createElement('a');
      a.href = 'javascript:yellowfin.dash.toggleShare(\'' + robj.options.dashUUID + '\');';
      img = document.createElement('img');
      img.src = yellowfin.baseURL + '?cmd=img&fn=js_close.png';
      img.border = 0;
      img.align = 'absmiddle';
      img.title = 'Close';
      a.appendChild(img);
      td.appendChild(a);
      tr.appendChild(td);
      tbody.appendChild(tr);
      tbl.appendChild(tbody);
      div.appendChild(tbl);

      robj.options.innerElement.appendChild(div);
      robj.options.shareElement = div;

    }

    if (robj.options.timeselElement) {
      if (robj.options.timeselElement.parentNode) {
        robj.options.timeselElement.parentNode.removeChild(robj.options.timeselElement);
      }
      robj.options.timeselElement = null;
    }
    if (robj.options.showTimesel) {

      var outerDiv = document.createElement('div');
      outerDiv.className = 'yfDashTopMenu yfDashTimesel';

      var tbl = document.createElement('table');
      tbl.className = 'yfDashTimeselInner';
      tbl.cellPadding = 0;
      tbl.cellSpacing = 0;
      tbl.width = '100%';
      var tbody = document.createElement('tbody');
      var tr = document.createElement('tr');
      var td = document.createElement('td');
      td.className = 'yfDashTimeselCell';
      td.width = '99%';
      td.innerHTML = object.timeselhtml || '';
      tr.appendChild(td);
      td = document.createElement('td');
      td.align = 'right';
      var a = document.createElement('a');
      a.href = 'javascript:yellowfin.dash.toggleTimesel(\'' + robj.options.dashUUID + '\');';
      var img = document.createElement('img');
      img.src = yellowfin.baseURL + '?cmd=img&fn=js_close.png';
      img.border = 0;
      img.align = 'absmiddle';
      img.title = 'Close';
      a.appendChild(img);
      td.appendChild(a);
      tr.appendChild(td);
      tbody.appendChild(tr);
      tbl.appendChild(tbody);

      outerDiv.appendChild(tbl);
      robj.options.innerElement.appendChild(outerDiv);
      robj.options.timeselElement = outerDiv;

    }

    if (robj.options.exportElement) {
      if (robj.options.exportElement.parentNode) {
        robj.options.exportElement.parentNode.removeChild(robj.options.exportElement);
      }
      robj.options.exportElement = null;
    }
    if (robj.options.showExport) {

      var outerDiv = document.createElement('div');
      outerDiv.className = 'yfDashTopMenu yfDashExport';

      var tbl = document.createElement('table');
      tbl.className = 'yfDashExportInner';
      tbl.cellPadding = 0;
      tbl.cellSpacing = 0;
      tbl.width = '100%';
      var tbody = document.createElement('tbody');
      var tr = document.createElement('tr');
      var td = document.createElement('td');
      td.className = 'yfDashExportCell';
      td.width = '99%';
      td.innerHTML = object.exporthtml || '';
      tr.appendChild(td);
      td = document.createElement('td');
      td.align = 'right';
      var a = document.createElement('a');
      a.href = 'javascript:yellowfin.dash.toggleExport(\'' + robj.options.dashUUID + '\');';
      var img = document.createElement('img');
      img.src = yellowfin.baseURL + '?cmd=img&fn=js_close.png';
      img.border = 0;
      img.align = 'absmiddle';
      img.title = 'Close';
      a.appendChild(img);
      td.appendChild(a);
      tr.appendChild(td);
      tbody.appendChild(tr);
      tbl.appendChild(tbody);

      outerDiv.appendChild(tbl);
      robj.options.innerElement.appendChild(outerDiv);
      robj.options.exportElement = outerDiv;

    }

    var div = document.createElement('div');
    div.innerHTML = object.html;
    robj.options.innerElement.appendChild(div);

    while (robj.options.footerElement.firstChild)
      robj.options.footerElement.removeChild(robj.options.footerElement.firstChild);

    var tbl = document.createElement('table');
    tbl.width = '100%';
    tbl.border = 0;
    tbl.cellPadding = 0;
    tbl.cellSpacing = 0;
    var tbody = document.createElement('tbody');
    var tr = document.createElement('tr');
    var td = document.createElement('td');
    td.width = 4;
    var img = document.createElement('img');
    img.src = yellowfin.baseURL + '?cmd=img&fn=js_bottom_left.png';
    img.style.display = 'block';
    td.appendChild(img);
    tr.appendChild(td);
    td = document.createElement('td');
    td.style.background = 'url(' + yellowfin.baseURL + '?cmd=img&fn=js_bottom.png)';
    td.width = '99%';
    td.appendChild(document.createTextNode(' '));
    tr.appendChild(td);
    td = document.createElement('td');
    td.width = 4;
    var img = document.createElement('img');
    img.src = yellowfin.baseURL + '?cmd=img&fn=js_bottom_right.png';
    img.style.display = 'block';
    td.appendChild(img);
    tr.appendChild(td);
    tbody.appendChild(tr);
    tbl.appendChild(tbody);
    robj.options.footerElement.appendChild(tbl);

    robj.options.reports = object.reports;
    for (var i = 0; i < object.reports.length; i++) {
      this.loadDashReport(robj.options.dashUUID, object.reports[i].reportId);
    }

    robj.options.menus = null;

    this.loadNextDash();

  },

  "toggleDashInfo": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.toggleDashInfo()');
    this.toggleMenu(dashUUID, 'info');
  },

  "toggleShare": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.toggleShare()');
    this.toggleMenu(dashUUID, 'share');
  },

  "toggleExport": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.toggleExport()');
    this.toggleMenu(dashUUID, 'export');
  },

  "toggleFilters": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.toggleFilters()');
    this.toggleMenu(dashUUID, 'filter');
  },

  "toggleTimesel": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.toggleTimesel()');
    this.toggleMenu(dashUUID, 'timesel');
  },

  "initMenus": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.initMenus()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var menus = {};

    var topMenus = [ 'info', 'share', 'export', 'timesel' ];
    var leftMenus = [ 'filter' ];

    var div, menu;
    for (var i = 0; i < topMenus.length; i++) {

      div = options[topMenus[i] + 'Element'];
      if (!div) continue;

      menu = {};
      menu.div = div;
      menu.key = topMenus[i];
      menu.top = true;
      menu.img = options[menu.key + 'BtnImg'];
      menu.open = false;
      if (menu.key == 'timesel') {
        menu.imgsrc = yellowfin.baseURL + '?cmd=img&fn=js_aggregation.png';
        menu.imgoversrc = yellowfin.baseURL + '?cmd=img&fn=js_aggregation_on.png';
      } else {
        menu.imgsrc = yellowfin.baseURL + '?cmd=img&fn=js_' + menu.key + '.png';
        menu.imgoversrc = yellowfin.baseURL + '?cmd=img&fn=js_' + menu.key + '_on.png';
      }

      div.style.top = (-10 - div.offsetHeight) + 'px';
      div.style.visibility = 'visible';

      menus[menu.key] = menu;

    }

    for (var i = 0; i < leftMenus.length; i++) {
      div = options[leftMenus[i] + 'Element'];
      if (!div) continue;

      menu = {};
      menu.div = div;
      menu.key = leftMenus[i];
      menu.top = false;
      menu.img = options[menu.key + 'BtnImg'];
      menu.open = false;
      menu.imgsrc = yellowfin.baseURL + '?cmd=img&fn=js_' + menu.key + '.png';
      menu.imgoversrc = yellowfin.baseURL + '?cmd=img&fn=js_' + menu.key + '_on.png';

      div.style.left = (-15 - div.offsetWidth) + 'px';
      div.style.visibility = 'visible';

      menus[menu.key] = menu;

    }

    options.menus = menus;

  },

  "closeFilters": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.closeFilters()');
    this.closeMenu(dashUUID, 'filter');
  },

  //"menus": [ 'info', 'share', 'export' ],
  "toggleMenu": function(dashUUID, menuKey, notransition) {
    yellowfin.trace('yellowfin.dash.toggleMenu()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    // get the menu
    if (!options.menus) {
      this.initMenus(dashUUID);
    }
    var menu = options.menus[menuKey];
    if (!menu) return;

    // close any other menus
    for (var k in options.menus) {

      if (k != menuKey) {
        this.closeMenu(dashUUID, k);
      }

    }

    if (menu.open) {
      // just close this menu
      this.closeMenu(dashUUID, menuKey);
    } else {

      // open this menu
      if (notransition) {
        menu.div.style.transition = '';
        menu.div.style.MozTransition = '';
        menu.div.style.OTransition = '';
        menu.div.style.WebkitTransition = '';
      } else {

        var t;
        if (menu.top) {
          t = 'top 0.3s ease-in-out';
        } else {
          t = 'left 0.3s ease-in-out';
        }
        menu.div.style.transition = t;
        menu.div.style.MozTransition = t;
        menu.div.style.OTransition = t;
        menu.div.style.WebkitTransition = t;

      }

      // open the div
      if (menu.top) {
        menu.div.style.top = '0px';
      } else {
        menu.div.style.left = '0px';
      }
      // change the image
      if (menu.img) menu.img.src = menu.imgoversrc;
      menu.open = true;

      if (options.innerElement) {
        options.innerElement.scrollLeft = 0;
        options.innerElement.scrollTop = 0;
      }

    }

  },

  "closeMenu": function(dashUUID, menuKey) {
    yellowfin.trace('yellowfin.dash.closeMenu()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    // get the menu
    if (!options.menus) {
      this.initMenus(dashUUID);
    }
    var menu = options.menus[menuKey];
    if (!menu) return;
    if (!menu.open) return;

    var t;
    if (menu.top) {
      t = 'top 0.3s ease-in-out';
    } else {
      t = 'left 0.3s ease-in-out';
    }
    menu.div.style.transition = t;
    menu.div.style.MozTransition = t;
    menu.div.style.OTransition = t;
    menu.div.style.WebkitTransition = t;

    // close the div
    if (menu.top) {
      menu.div.style.top = (-10 - menu.div.offsetHeight) + 'px';
    } else {
      menu.div.style.left = (-15 - menu.div.offsetWidth) + 'px';
    }
    if (menu.img) menu.img.src = menu.imgsrc;
    menu.open = false;

  },

  "closeAllMenus": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.closeAllMenus()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    if (!options.menus) {
      this.initMenus(dashUUID);
    }

    for (var k in options.menus) {
      this.closeMenu(dashUUID, k);
    }

  },

  "loadDashReport": function(dashUUID, reportId) {
    yellowfin.trace('yellowfin.dash.loadDashReport()');

    var str = dashUUID + '|' + reportId;

    if (yellowfin.reports) {
      this.loadDashReportNow(str);
    } else {
      yellowfin.loadApi('reports', 'yellowfin.dash.loadDashReportNow', str);
    }

  },

  "loadDashReportNow": function(str) {
    yellowfin.trace('yellowfin.dash.loadDashReportNow()');

    var arr = str.split('|');
    var dashUUID = arr[0];
    var reportId = arr[1];

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var rpt = null;
    for (var i = 0; i < options.reports.length; i++) {
      if (options.reports[i].reportId == reportId) {
        rpt = options.reports[i];
        break;
      }
    }
    if (!rpt) return;

    var div = yellowfin.getObj('yfDash' + dashUUID + 'Rpt' + reportId);
    if (!div) return;

    // if we're reloading an existing report, use the existing report options
    // the reports api should be loaded by now
    var rptOptions = yellowfin.reports.reportOptions['r' + reportId] || {};
    rptOptions.element = div;
    rptOptions.reportId = reportId;
    rptOptions.showFilters = false;
    rptOptions.width = rpt.width;
    rptOptions.height = rpt.height;
    rptOptions.dashUUID = dashUUID;
    rptOptions.outerContainer = null;

    yellowfin.reports.loadReport(rptOptions);

  },

  "dashReportLoaded": function(object) {
    yellowfin.trace('yellowfin.dash.dashReportLoaded()');

    var div = yellowfin.getObj('yfDash' + object.dashUUID + 'Rpt' + object.reportId);
    if (!div) return;

    var robj = this.requests['r' + object.reqId];
    if (!robj) {
      alert('Error: invalid request');
      return;
    }

    if (robj.loadingDiv) {
      div.removeChild(robj.loadingDiv);
    }

    this.requests['r' + object.reqId] = null;

    div.innerHTML = object.html;
  },

  "runReportCmd": function(dashUUID, reportId, cmd) {
    yellowfin.trace('yellowfin.dash.runReportCmd()');

    if (!dashUUID || dashUUID == '') {
      alert('No dashUUID specified');
      return;
    }

    if (!reportId || reportId == '') {
      alert('No reportId specified');
      return;
    }

    if (!cmd || cmd == '') {
      alert('No command specified');
      return;
    }

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "dashUUID": dashUUID,
      "reportId": reportId,
      "cmd": cmd
    };
    this.requests['r' + rid] = robj;

    var options = this.dashOptions['d' + dashUUID];

    var div = this.createLoadingDiv('Running command...');

    var rptDiv = yellowfin.getObj('yfDash' + dashUUID + 'Rpt' + reportId);
    rptDiv.appendChild(div);
    robj.loadingDiv = div;

    var url = yellowfin.baseURL + '?api=dash&cmd=rptcmd';
    url += '&dashUUID=' + dashUUID;
    url += '&reportId=' + reportId;
    url += '&reqId=' + rid;
    url += '&reportCmd=' + encodeURIComponent(cmd);
    url += '&u=' + Math.floor(Math.random() * 1000000000);
    yellowfin.insertScript(url);

  },

  "reportCmdFinished": function(object) {
    yellowfin.trace('yellowfin.dash.reportCmdFinished()');

    var robj = this.requests['r' + object.reqId];
    if (!robj) {
      alert('Error: invalid request');
      return;
    }

    var div = yellowfin.getObj('yfDash' + object.dashUUID + 'Rpt' + object.reportId);
    if (div && robj.loadingDiv) {
      div.removeChild(robj.loadingDiv);
    }

    this.requests['r' + object.reqId] = null;

    // now re-run the report
    this.loadDashReport(object.dashUUID, object.reportId);

  },

  "reportCmdError": function(object) {
    yellowfin.trace('yellowfin.dash.reportCmdError()');

    var div = yellowfin.getObj('yfDash' + object.dashUUID + 'Rpt' + object.reportId);
    if (div && robj.loadingDiv) {
      div.removeChild(robj.loadingDiv);
    }
    if (object.reqId) {
      this.requests['r' + object.reqId] = null;
    }
    alert('Error running report command: ' + object.errorDescription);
  },

  "showLogonForm": function(object) {
    yellowfin.trace('yellowfin.dash.showLogonForm()');

    var robj = this.requests['r' + object.reqId];
    if (robj) {
      this.requests['r' + object.reqId] = null;
    }

    var options = this.dashOptions['d' + object.dashUUID];
    if (!options && robj) {
      options = robj.options;
    }

    if (!options) {
      alert('Error: invalid request');
      this.loadNextDash();
      return;
    }

    if (options.outerContainer && robj && robj.loadingDiv) {
      robj.options.outerContainer.removeChild(robj.loadingDiv);
    }

    if (options.infoElement && options.infoElement.style.display == 'block') {
      this.toggleDashInfo(options.dashUUID);
    }

    if (options.titleElement) {

      while (options.titleElement.firstChild)
        options.titleElement.removeChild(options.titleElement.firstChild);

      var tbl2 = document.createElement('table');
      tbl2.border = 0;
      tbl2.cellPadding = 0;
      tbl2.cellSpacing = 0;
      tbl2.width = '100%';
      var tbody2 = document.createElement('tbody');
      var tr2 = document.createElement('tr');
      var td2 = document.createElement('td');
      td2.width = 4;
      var img = document.createElement('img');
      img.src = yellowfin.baseURL + '?cmd=img&fn=js_top_left.png';
      img.border = 0;
      img.style.display = 'block';
      td2.appendChild(img);
      tr2.appendChild(td2);
      td2 = document.createElement('td');
      td2.setAttribute('width', '*');
      td2.style.background = 'url(' + yellowfin.baseURL + '?cmd=img&fn=js_top.png)';

      var innerDiv = document.createElement('div');
      innerDiv.className = 'yfDashTitleInner';

      var tbl = document.createElement('table');
      tbl.width = '100%';
      tbl.border = 0;
      tbl.cellSpacing = 0;
      tbl.cellPadding = 0;
      var tbody = document.createElement('tbody');
      var tr = document.createElement('tr');
      var td = document.createElement('td');
      td.className = 'yfDashTitle';

      var div = document.createElement('div');
      div.className = 'yfDashTitle';
      div.appendChild(document.createTextNode('Login'));
      td.appendChild(div);
      tr.appendChild(td);
      tbody.appendChild(tr);
      tbl.appendChild(tbody);

      innerDiv.appendChild(tbl);
      td2.appendChild(innerDiv);
      tr2.appendChild(td2);
      td2 = document.createElement('td');
      td2.width = 4;
      var img = document.createElement('img');
      img.src = yellowfin.baseURL + '?cmd=img&fn=js_top_right.png';
      img.border = 0;
      img.style.display = 'block';
      td2.appendChild(img);
      tr2.appendChild(td2);
      tbody2.appendChild(tr2);
      tbl2.appendChild(tbody2);

      options.titleElement.appendChild(tbl2);

    }

    if (options.innerElement) {
      while (options.innerElement.firstChild)
        options.innerElement.removeChild(options.innerElement.firstChild);
      options.innerElement.style.display = 'none';
    }
    if (options.footerElement) {
      while (options.footerElement.firstChild)
        options.footerElement.removeChild(options.footerElement.firstChild);
    }

    options.logonUsernameEl.value = '';
    options.logonPasswordEl.value = '';
    options.logonElement.style.display = 'block';
    options.logonErrorsElement.style.display = 'none';

    this.loadNextDash();

  },

  "showLogonFormWithErrors": function(object, errors) {
    yellowfin.trace('yellowfin.dash.showLogonFormWithErrors()');

    var robj = this.requests['r' + object.reqId];
    var options = robj ? robj.options : null;

    this.showLogonForm(object);

    if (options && options.logonErrorsElement) {
      var html = '<div style=\"border: 1px solid #c0c0c0; background: #eeeeee; padding: 2px;\">' + errors + '</div>';
      options.logonErrorsElement.innerHTML = html;
      options.logonErrorsElement.style.display = 'block';
    }

  },

  "logon": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.logon()');

    if (yellowfin.auth) {
      this.logonNow(dashUUID);
    } else {
      yellowfin.loadApi('auth', 'yellowfin.dash.logonNow', dashUUID);
      return;
    }

  },

  "logonNow": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.logonNow()');
    var options = this.dashOptions['d' + dashUUID];
    if (!options) {
      alert('Error: invalid request');
      return;
    }

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "options": options
    };
    this.requests['r' + rid] = robj;

    options.logonElement.style.display = 'none';

    div = this.createLoadingDiv('Logging in...');
    options.outerContainer.appendChild(div);
    robj.loadingDiv = div;

    // auth api should be loaded
    yellowfin.auth.logonUser(options.logonUsernameEl.value, options.logonPasswordEl.value, 'yellowfin.dash.logonCallback', rid);

  },

  "logonCallback": function(reqId, success, errors) {
    yellowfin.trace('yellowfin.dash.logonCallback()');

    var robj = this.requests['r' + reqId];
    if (!robj) {
      alert('Error: invalid request');
      return;
    }

    this.requests['r' + reqId] = null;

    var options = robj.options;
    if (robj.loadingDiv) {
      options.outerContainer.removeChild(robj.loadingDiv);
    }

    if (success) {

      if (options.innerElement) {
        options.innerElement.style.display = 'block';
      }
      this.loadDash(options);

      // also reload any other dashboards
      var opt;
      for (var k in this.dashOptions) {
        opt = this.dashOptions[k];
        if (opt.dashUUID != options.dashUUID) {
          if (opt.logonElement) {
            opt.logonElement.style.display = 'none';
          }
          if (opt.innerElement) {
            opt.innerElement.style.display = 'block';
          }
          this.loadDash(opt);
        }
      }

    } else {

      options.logonErrorsElement.innerHTML = errors;
      options.logonErrorsElement.style.display = 'block';
      options.logonElement.style.display = 'block';

    }

  },

  "logoff": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.logoff()');

    if (yellowfin.auth) {
      this.logoffNow(dashUUID);
    } else {
      yellowfin.loadApi('auth', 'yellowfin.dash.logoffNow', dashUUID);
    }

  },

  "logoffNow": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.logoffNow()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) {
      alert('Error: invalid request');
      return;
    }

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "options": options
    };
    this.requests['r' + rid] = robj;

    var div = this.createLoadingDiv('Logging out...');
    options.outerContainer.appendChild(div);
    robj.loadingDiv = div;

    // auth api should be loaded
    yellowfin.auth.logoffUser('yellowfin.dash.logoffCallback', rid);

  },

  "logoffCallback": function(reqId) {
    yellowfin.trace('yellowfin.dash.logoffCallback()');

    var robj = this.requests['r' + reqId];
    if (!robj) {
      alert('Error: invalid request');
      return;
    }

    this.requests['r' + reqId] = null;

    var options = robj.options;
    if (robj.loadingDiv) {
      options.outerContainer.removeChild(robj.loadingDiv);
    }

    this.showLogonForm({"dashUUID": options.dashUUID});

    // also logoff any other reports
    var opt;
    for (var k in this.dashOptions) {
      opt = this.dashOptions[k];
      if (opt.dashUUID != options.dashUUID) {
        this.showLogonForm({"dashUUID": opt.dashUUID});
      }
    }

  },

  "setupFilters": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.setupFilters()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var filters = options.filters;
    if (!filters) return;

    for (var i = 0; i < filters.length; i++) {
      if (filters[i].display == 'DIAL' && !yellowfin.DialWidget) {
        yellowfin.loadScript('DialWidget', 'yellowfin.dash.setupFilters', dashUUID);
        return;
      } else if (filters[i].display == 'NUMERIC_SLIDER') {
        if (!yellowfin.SliderWidget) {
          yellowfin.loadScript('SliderWidget', 'yellowfin.dash.setupFilters', dashUUID);
          return;
        }
        if (!yellowfin.NumericFormatter) {
          yellowfin.loadScript('NumericFormatter', 'yellowfin.dash.setupFilters', dashUUID);
          return;
        }
      }
    }

    if (!yellowfin.ElementInfo) {
      yellowfin.loadScript('ElementInfo', 'yellowfin.dash.setupFilters', dashUUID);
      return;
    }

    this.setupFiltersNow(dashUUID);

  },

  "setupFiltersNow": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.setupFiltersNow()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var filters = options.filters;
    if (!filters) return;

    var frm = options.filterFormElement;
    if (!frm) return;

    var obj;
    for (var i = 0; i < filters.length; i++) {
      if (!filters[i].displayed) continue;

      if (filters[i].display == 'DATE') {

        if (filters[i].list) {
          for (var j = 0; ; j++) {
            obj = frm.elements[filters[i].key + '-' + j + '-d'];
            if (!obj) break;

            yellowfin.ElementInfo.addElementInfo(obj, 'dd');
            yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key + '-' + j + '-m'], 'mm');
            yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key + '-' + j + '-y'], 'yyyy');
          }

        } else {

          yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key + '-d'], 'dd');
          yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key + '-m'], 'mm');
          yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key + '-y'], 'yyyy');

          if (filters[i].between) {
            yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key + 'b-d'], 'dd');
            yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key + 'b-m'], 'mm');
            yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key + 'b-y'], 'yyyy');
          }

        }

      } else if (filters[i].display == 'TIMESTAMP') {

        if (filters[i].list) {

          for (var j = 0; ; j++) {
            obj = frm.elements[filters[i].key + '-' + j];
            if (!obj) break;
            yellowfin.ElementInfo.addElementInfo(obj, 'yyyy-mm-dd hh:mm:ss');
          }

        } else {

          yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key], 'yyyy-mm-dd hh:mm:ss');
          if (filters[i].between) {
            yellowfin.ElementInfo.addElementInfo(frm.elements[filters[i].key + 'b'], 'yyyy-mm-dd hh:mm:ss');
          }

        }

      } else if (filters[i].display == 'DIAL') {

        yellowfin.DialWidget.setupDial(frm, filters[i].key);

      } else if (filters[i].display == 'NUMERIC_SLIDER') {

        var fparms = {};
        var fkeys = ['DECIMALPLACES', 'THOUSANDSEPARATOR', 'PREFIX', 'SUFFIX'];
        for (var j = 0; j < fkeys.length; j++) {
          if (frm.elements[filters[i].key + '|fmt|' + fkeys[j]])
            fparms[fkeys[j]] = frm.elements[filters[i].key + '|fmt|' + fkeys[j]].value;
        }
        var fmt = yellowfin.NumericFormatter.createFormatter(fparms);

        yellowfin.SliderWidget.setupSlider(frm, filters[i].key, filters[i].key, fmt);
        if (yellowfin.getObj(filters[i].key + 'b|sliderDiv')) {
          yellowfin.SliderWidget.setupSlider(frm, filters[i].key, filters[i].key + 'b', fmt);
          yellowfin.SliderWidget.sliders[filters[i].key].maxSlider = yellowfin.SliderWidget.sliders[filters[i].key + 'b'];
          yellowfin.SliderWidget.sliders[filters[i].key + 'b'].minSlider = yellowfin.SliderWidget.sliders[filters[i].key];
        }

      } else if (filters[i].display == 'PREDEF_DATE_DROPDOWN') {

        yellowfin.ElementInfo.addElementInfo(yellowfin.getObj(filters[i].key + '-d'), 'dd');
        yellowfin.ElementInfo.addElementInfo(yellowfin.getObj(filters[i].key + '-m'), 'mm');
        yellowfin.ElementInfo.addElementInfo(yellowfin.getObj(filters[i].key + '-y'), 'yyyy');

        if (filters[i].between) {
          yellowfin.ElementInfo.addElementInfo(yellowfin.getObj(filters[i].key + 'b-d'), 'dd');
          yellowfin.ElementInfo.addElementInfo(yellowfin.getObj(filters[i].key + 'b-m'), 'mm');
          yellowfin.ElementInfo.addElementInfo(yellowfin.getObj(filters[i].key + 'b-y'), 'yyyy');
        }

      }

    }


  },

  "toggleFilterGroup": function(dashUUID, componentId) {
    yellowfin.trace('yellowfin.dash.toggleFilterGroup()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var grp = null;
    if (options.filters) {
      for (var i = 0; i < options.filters.length; i++) {
        if (options.filters[i].type != 'FILTERGROUP') continue;
        if (options.filters[i].groupId == componentId) {
          grp = options.filters[i];
          break;
        }
      }
    }
    if (!grp) return;

    var div = yellowfin.getObj('yfDash' + dashUUID + 'filterGroup' + componentId);
    if (!div) return;

    var img = yellowfin.getObj('yfDash' + dashUUID + 'Grp' + componentId + 'Img');

    if (grp.state == 'OPEN') {
      // close the div
      div.style.display = 'none';
      if (img) img.src = yellowfin.baseURL + '?cmd=img&fn=expand.gif';
      grp.state = 'CLOSED';
    } else {
      // open the div
      div.style.display = 'block';
      if (img) img.src = yellowfin.baseURL + '?cmd=img&fn=collaps.gif';
      grp.state = 'OPEN';

      if (!grp.loaded) {
        // load the filter group now

        var rid = this.nextRequestId++;
        var robj = {
          "id": rid,
          "dashUUID": dashUUID,
          "groupId": componentId
        };
        this.requests['r' + rid] = robj;

        var ldiv = this.createLoadingDiv('Loading...');
        div.appendChild(ldiv);
        robj.loadingDiv = ldiv;

        var src = yellowfin.baseURL + '?api=dash&cmd=loadFilterGroup&reqId=' + rid;
        src += '&version=' + yellowfin.apiVersion;
        src += '&dashUUID=' + dashUUID;
        src += '&groupId=' + componentId;
        src += '&u=' + Math.floor(Math.random() * 1000000000);

        yellowfin.insertScript(src);

      }

    }

  },

  "filterGroupLoaded": function(object) {
    yellowfin.trace('yellowfin.dash.filterGroupLoaded()');

    var robj = this.requests['r' + object.reqId];
    if (!robj) {
      alert('Error: invalid request');
      return;
    }

    this.requests['r' + object.reqId] = null;

    var options = this.dashOptions['d' + object.dashUUID];
    if (!options) return;

    var grp = null;
    if (options.filters) {
      for (var i = 0; i < options.filters.length; i++) {
        if (options.filters[i].type != 'FILTERGROUP') continue;
        if (options.filters[i].groupId == object.groupId) {
          grp = options.filters[i];
          break;
        }
      }
    }
    if (!grp) return;

    var div = yellowfin.getObj('yfDash' + object.dashUUID + 'filterGroup' + object.groupId);
    if (!div) return;

    if (robj.loadingDiv) {
      div.removeChild(robj.loadingDiv);
    }

    div.innerHTML = object.html;
    grp.loaded = true;

    this.setupFilters(object.dashUUID);

  },

  "applyFilters": function(dashUUID, reloadReports, focusElName) {
    yellowfin.trace('yellowfin.dash.applyFilters()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;
    if (!options.filters) return;

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "dashUUID": dashUUID,
      "reloadReports": reloadReports,
      "focusElName": focusElName
    };
    this.requests['r' + rid] = robj;

    yellowfin.ElementInfo.removeAllElementInfo(options.filterFormElement);

    var src = yellowfin.baseURL + '?api=dash&cmd=applyFilters&reqId=' + rid;
    src += '&version=' + yellowfin.apiVersion;
    src += '&dashUUID=' + dashUUID;
    var skip = false;
    var val;
    for (var i = 0; i < options.filters.length; i++) {

      if (options.filters[i].type == 'FILTERGROUP') {
        skip = !options.filters[i].loaded;
        src += '&yfFilter' + options.filters[i].key + '|state=' + options.filters[i].state;
        continue;
      }

      if (skip) continue;

      if (!options.filters[i].displayed) continue;

      val = this.serialiseFilter(dashUUID, options.filterFormElement, options.filters[i]);
      src += '&yfFilter' + options.filters[i].key + '=' + encodeURIComponent(val);

    }
    src += '&u=' + Math.floor(Math.random() * 1000000000);

    var div = options.filterElement;

    var ldiv = this.createLoadingDiv('Loading...');
    div.appendChild(ldiv);
    robj.loadingDiv = ldiv;

    yellowfin.insertScript(src);

  },

  "serialiseFilter": function(dashUUID, form, filter) {
    yellowfin.trace('yellowfin.dash.serialiseFilter()');

    var datefn = function(form, key) {
      var y = form.elements[key + '-y'].value;
      var m = form.elements[key + '-m'].value;
      var d = form.elements[key + '-d'].value;
      return y + '-' + m + '-' + d;
    };

    if (filter.display == 'CACHED_DROPDOWN' ||
      filter.display == 'ACCESS_FILTER_DROPDOWN' ||
      filter.display == 'ORGREFCODE_DROPDOWN' ||
      filter.display == 'PREDEF_DATE_DROPDOWN' ||
      filter.display == 'CACHED_QUERY_DROPDOWN') {

      var predefCustom = filter.display == 'PREDEF_DATE_DROPDOWN' && form.elements[filter.key].value.indexOf('CUSTOM') == 0;

      if(predefCustom)
      {
        if(filter.nativeType == 'DATE')
        {
          if (filter.between) {
            arr = [];
            arr.push(datefn(form, filter.key));
            arr.push(datefn(form, filter.key + 'b'));
            return this.serialiseList(arr);
          } else {
            return datefn(form, filter.key);
          }
        }
        else	//timestamp
        {
          if (filter.between) {
            arr = [];
            arr.push(form.elements[filter.key + '-custom'].value);
            arr.push(form.elements[filter.key + 'b-custom'].value);
            return this.serialiseList(arr);
          } else {
            return form.elements[filter.key + '-custom'].value;
          }
        }
      }
      else
      {

        if (filter.list) {

          var fel = form.elements[filter.key];
          var list = [];
          for (var j = 0; j < fel.options.length; j++) {
            if (fel.options[j].selected) {
              list.push(fel.options[j].value);
            }
          }
          return this.serialiseList(list);

        } else {

          if (filter.between && filter.display != 'PREDEF_DATE_DROPDOWN') {
            var list = [];
            list.push(form.elements[filter.key].value);
            list.push(form.elements[filter.key + 'b'].value);
            return this.serialiseList(list);
          } else {
            return form.elements[filter.key].value;
          }
        }

      }

    } else if (filter.display == 'CHECKBOX_LIST') {

      var fel = form.elements[filter.key];
      var list = [];
      if (fel.length) {
        for (var j = 0; j < fel.length; j++) {
          if (fel[j].checked) {
            list.push(fel[j].value);
          }
        }
      } else {
        if (fel.checked) {
          list.push(fel.value);
        }
      }
      return this.serialiseList(list);

    } else if (filter.display == 'DATE') {

      if (filter.list) {
        var list = [];
        var txt;
        for (var j = 0; ; j++) {
          if (!form.elements[filter.key + '-' + j + '-d']) break;
          txt = form.elements[filter.key + '-' + j + '-y'].value + '-' +
            form.elements[filter.key + '-' + j + '-m'].value + '-' +
            form.elements[filter.key + '-' + j + '-d'].value;
          if (txt == '--') continue;
          list.push(txt);
        }
        return this.serialiseList(list);
      } else {

        var val = form.elements[filter.key + '-y'].value + '-' +
          form.elements[filter.key + '-m'].value + '-' +
          form.elements[filter.key + '-d'].value;
        if (val == '--') val = '';

        if (filter.between) {
          var list = [];
          list.push(val);
          val = form.elements[filter.key + 'b-y'].value + '-' +
            form.elements[filter.key + 'b-m'].value + '-' +
            form.elements[filter.key + 'b-d'].value;
          if (val == '--') val = '';
          list.push(val);
          return this.serialiseList(list);
        } else {
          return val;
        }

      }

    } else if (filter.display == 'BOOLEAN') {

      var fel = form.elements[filter.key];
      for (var j = 0; j < fel.length; j++) {
        if (fel[j].checked) {
          return fel[j].value;
        }
      }
      return '';

    } else if (filter.display == 'TIME') {

      var timefn = function(key) {

        var h = parseInt(form.elements[key + '-h'].value, 10);
        var m = parseInt(form.elements[key + '-m'].value, 10);
        var a = form.elements[key + '-ampm'].value;
        if (a == 'AM') {
          if (h == 12) h = 0;
        } else {
          if (h < 12) h += 12;
        }
        return h + ':' + m;

      };

      if (filter.list) {

        var list = [];
        for (var j = 0; ; j++) {
          if (!form.elements[filter.key + '-' + j + '-h']) break;
          list.push(timefn(filter.key + '-' + j));
        }
        return this.serialiseList(list);

      } else {

        var val = timefn(filter.key);
        if (filter.between) {
          var list = [];
          list.push(val);
          val = timefn(filter.key + 'b');
          list.push(val);
          return this.serialiseList(list);
        } else {
          return val;
        }

      }

    } else if (filter.display == 'NUMERIC_SLIDER') {

      if (filter.between) {
        var list = [];
        list.push(form.elements[filter.key + '|value1'].value);
        list.push(form.elements[filter.key + '|value2'].value);
        return this.serialiseList(list);
      } else {
        return form.elements[filter.key + '|value1'].value;
      }

    } else if (filter.display == 'NUMERIC_RANGE') {

      return form.elements[filter.key + '|value1'].value;

    } else {

      if (filter.list) {
        var list = [];
        for (var j = 0; ; j++) {
          if (!form.elements[filter.key + '-' + j]) break;
          list.push(form.elements[filter.key + '-' + j].value);
        }
        return this.serialiseList(list);
      } else {
        if (filter.between) {
          var list = [];
          list.push(form.elements[filter.key].value);
          list.push(form.elements[filter.key + 'b'].value);
          return this.serialiseList(list);
        } else {
          return form.elements[filter.key].value;
        }
      }

    }

    return '';

  },

  "serialiseList": function(list) {
    yellowfin.trace('yellowfin.dash.serialiseList()');

    var txt = '';
    var str;
    for (var i = 0; i < list.length; i++) {
      str = list[i];
      // escape any slashes
      str = str.replace(/\\/g, '\\\\');
      // escape any pipes
      str = str.replace(/\|/g, '\\|');

      if (i > 0) txt += '|';
      txt += str;
    }
    return txt;

  },

  "resetFilters": function(dashUUID) {
    yellowfin.trace('yellowfin.dash.resetFilters()');

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "dashUUID": dashUUID,
      "reloadReports": true
    };
    this.requests['r' + rid] = robj;

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var div = options.filterElement;

    var ldiv = this.createLoadingDiv('Loading...');
    div.appendChild(ldiv);
    robj.loadingDiv = ldiv;

    var src = yellowfin.baseURL + '?api=dash&cmd=resetFilters&reqId=' + rid;
    src += '&version=' + yellowfin.apiVersion;
    src += '&dashUUID=' + dashUUID;
    src += '&grps=';
    for (var i = 0; i < options.filters.length; i++) {
      if (options.filters[i].type == 'FILTERGROUP' &&
        options.filters[i].state == 'OPEN') {
        src += options.filters[i].groupId + ',';
      }
    }
    src += '&u=' + Math.floor(Math.random() * 1000000000);

    yellowfin.insertScript(src);

  },

  "filtersLoaded": function(object) {
    yellowfin.trace('yellowfin.dash.filtersLoaded()');

    var robj = this.requests['r' + object.reqId];
    if (!robj) {
      alert('Error: invalid request: ' + object.reqId);
      return;
    }

    this.requests['r' + object.reqId] = null;

    var options = this.dashOptions['d' + object.dashUUID];
    if (!options) return;

    if (robj.loadingDiv) {
      options.filterElement.removeChild(robj.loadingDiv);
    }

    options.filterInnerElement.innerHTML = object.html;
    options.filters = object.filters;

    if (robj.focusElName) {
      var el = options.filterFormElement.elements[robj.focusElName];
      if (el && el.focus) {
        el.focus();
      }
    }

    if (robj.reloadReports) {
      for (var i = 0; i < object.reportIds.length; i++) {
        this.loadDashReport(object.dashUUID, object.reportIds[i]);
      }
    }

    this.setupFilters(object.dashUUID);

  },

  "filterSelectAll": function(dashUUID, key, sel) {
    yellowfin.trace('yellowfin.dash.filterSelectAll()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var frm = options.filterFormElement;
    if (!frm) return;

    var el = frm.elements[key];
    if (!el) return;

    if (el.type == 'select-one' || el.type == 'select-multiple') {

      for (var i = 0; i < el.options.length; i++) {
        el.options[i].selected = sel;
      }

      el.focus();

    } else {

      // checkboxes
      if (el.length) {
        for (var i = 0; i < el.length; i++) {
          el[i].checked = sel;
        }
      } else {
        el.checked = sel;
      }

    }

    var filter = null;
    for (var i = 0; i < options.filters.length; i++) {
      if (options.filters[i].key == key) {
        filter = options.filters[i];
        break;
      }
    }
    if (filter && filter.dependencies) {
      // refresh filters
      this.applyFilters(dashUUID, false, key);
    }


  },

  "filterChanged": function(dashUUID, key) {
    yellowfin.trace('yellowfin.dash.filterChanged()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var filter = null;
    for (var i = 0; i < options.filters.length; i++) {
      if (options.filters[i].key == key) {
        filter = options.filters[i];
        break;
      }
    }
    if (filter && filter.dependencies) {
      // refresh filters
      this.applyFilters(dashUUID, false, key);
    }

  },

  "exportDash": function(dashUUID, fmt) {
    yellowfin.trace('yellowfin.dash.exportDash()');

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "dashUUID": dashUUID,
      "fmt": fmt
    };
    this.requests['r' + rid] = robj;

    var src = yellowfin.baseURL + '?api=dash&cmd=' + encodeURIComponent(fmt) + '&dashUUID=' + dashUUID + '&reqId=' + rid;
    src += '&u=' + Math.floor(Math.random() * 1000000000);
    yellowfin.insertScript(src);

  },

  "exportReady": function(reqId) {
    yellowfin.trace('yellowfin.dash.exportReady()');

    var robj = this.requests['r' + reqId];
    if (!robj) {
      alert('Error: invalid request');
      return;
    }

    this.requests['r' + reqId] = null;

    window.location.href = yellowfin.baseURL + '?api=dash&cmd=download&fmt=' + encodeURIComponent(robj.fmt) + '&dashUUID=' + encodeURIComponent(robj.dashUUID);

  },

  "exportFailed": function(object) {
    yellowfin.trace('yellowfin.dash.exportFailed()');

    if (object.reqId) {
      this.requests['r' + object.reqId] = null;
    }

    yellowfin.apiError(object);
  },

  "loadDashFilters": function(dashUUID, callback, arg) {
    yellowfin.trace('yellowfin.dash.loadDashFilters()');

    var options = this.dashOptions['d' + dashUUID];
    if (options) {
      callback(options.filters, arg);
      return;
    }

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "dashUUID": dashUUID,
      "callback": callback,
      "arg": arg
    };
    this.requests['r' + rid] = robj;

    var src = yellowfin.baseURL + '?api=dash&cmd=loaddashfilters&reqId=' + rid + '&dashUUID=' + encodeURIComponent(dashUUID);
    src += '&u=' + Math.floor(Math.random() * 1000000000);

    yellowfin.insertScript(src);

  },

  "dashFiltersLoaded": function(reqId, filters) {
    yellowfin.trace('yellowfin.dash.dashFiltersLoaded()');

    var robj = this.requests['r' + reqId];
    if (!robj) return;

    this.requests['r' + reqId] = null;

    robj.callback(filters, robj.arg);

  },

  "switchGran": function(dashUUID, str) {
    yellowfin.trace('yellowfin.dash.switchGran()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "dashUUID": dashUUID,
      "options": options
    };
    this.requests['r' + rid] = robj;

    var div = this.createLoadingDiv('Running command...');
    options.outerContainer.appendChild(div);
    robj.loadingDiv = div;

    var src = yellowfin.baseURL + '?api=dash&cmd=switchgran&reqId=' + rid + '&dashUUID=' + encodeURIComponent(dashUUID);
    src += '&gran=' + str;
    src += '&u=' + Math.floor(Math.random() * 1000000000);

    yellowfin.insertScript(src);

  },

  "reloadDash": function(object) {
    yellowfin.trace('yellowfin.dash.reloadDash()');

    var robj = this.requests['r' + object.reqId];
    if (!robj) {
      alert('Error: invalid request');
      return;
    }

    if (robj.options && robj.options.outerContainer && robj.loadingDiv) {
      robj.options.outerContainer.removeChild(robj.loadingDiv);
    }

    this.requests['r' + object.reqId] = null;

    // now re-run the dashboard
    var options = {};
    var oldOptions = this.dashOptions['d' + robj.dashUUID];
    for (var k in oldOptions) {
      options[k] = oldOptions[k];
    }

    options["reload"] = false;
    this.loadDash(options);

  },

  "reloadReports": function(object) {
    yellowfin.trace('yellowfin.dash.reloadReports()');

    var robj = this.requests['r' + object.reqId];
    if (!robj) {
      alert('Error: invalid request');
      return;
    }

    if (robj.options && robj.options.outerContainer && robj.loadingDiv) {
      robj.options.outerContainer.removeChild(robj.loadingDiv);
    }

    this.requests['r' + object.reqId] = null;

    // load the requested reports
    for (var i = 0; i < object.reports.length; i++) {
      this.loadDashReport(object.dashUUID, object.reports[i]);
    }

  },


  "drillDownReport": function(dashUUID, reportId, cmd) {
    yellowfin.trace('yellowfin.dash.drillDownReport()');

    var options = this.dashOptions['d' + dashUUID];
    if (!options) return;

    var rid = this.nextRequestId++;
    var robj = {
      "id": rid,
      "dashUUID": dashUUID,
      "options": options
    };
    this.requests['r' + rid] = robj;

    var div = this.createLoadingDiv('Running command...');
    options.outerContainer.appendChild(div);
    robj.loadingDiv = div;

    var src = yellowfin.baseURL + '?api=dash&cmd=drilldown&reqId=' + rid + '&dashUUID=' + encodeURIComponent(dashUUID);
    src += '&reportId=' + reportId;
    src += '&rptcmd=' + encodeURIComponent(cmd);
    src += '&u=' + Math.floor(Math.random() * 1000000000);

    yellowfin.insertScript(src);

  }

};