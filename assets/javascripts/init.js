var doc = document, win = window, title = doc.getElementsByTagName("title");

if (typeof console === "undefined") {
  console = {};
  console.log = function() {
    return;
  }
}

// window.CKEDITOR_BASEPATH = "#{location.origin}/assets/vendor/ckeditor/"

if (!window.location.origin) {
  window.location.origin = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port: '');
}
// HBT = HandlebarsTemplates;

//User Agent Class
var uaType = function() {
  var self = this;
  var ua = win.navigator.userAgent;
  var msie = ua.indexOf ("MSIE ");
  self.iPhone = ( ua.indexOf('iPhone') !== -1 || ua.indexOf('iPod') !== -1 );
  self.iPad = ua.indexOf('iPad') !== -1;
  self.Android2 = (ua.indexOf('Android 2.') !== -1);
  self.Android4 = (ua.indexOf('Android 4.') !== -1);
  self.Android = ((ua.indexOf('Android') !== -1) && (ua.indexOf('Mobile') !== -1)) && (ua.indexOf('SC-01C') == -1);
  self.AndroidTab = (ua.indexOf('Android') !== -1) && ((ua.indexOf('Mobile') == -1) || (ua.indexOf('SC-01C') !== -1));
  self.WindowsPhone = ( ua.indexOf('IEMobile') !== -1 || ua.indexOf('ZuneWP') !== -1 );
  self.PC = ( typeof win.orientation === "undefined" );
  self.IE = ( ua.indexOf("MSIE ") !== -1 );
  self.IEver = ( parseInt (ua.substring (msie+5, ua.indexOf (".", msie ))) );
  self.MOBILE = ( self.iPhone || self.iPad || (ua.indexOf('Android') !== -1) || self.WindowsPhone );
  self.SMART = ( self.iPhone || self.Android || self.WindowsPhone );
  self.ua = ua;
}
ua = new uaType();

// added trim function
if (typeof(String.prototype.trim) === "undefined") {
  String.prototype.trim = function() {
    return String(this).replace(/^\s+|\s+$/g, '');
  };
}

Date.fromISO = (function(){
    var testIso = '2011-11-24T09:00:27+0200';
    // Chrome
    var diso= Date.parse(testIso);
    if(diso===1322118027000) return function(s){
        return new Date(Date.parse(s));
    }
    // JS 1.8 gecko
    var noOffset = function(s) {
      var day= s.slice(0,-5).split(/\D/).map(function(itm){
        return parseInt(itm, 10) || 0;
      });
      day[1]-= 1;
      day= new Date(Date.UTC.apply(Date, day));
      var offsetString = s.slice(-5)
      var offset = parseInt(offsetString,10)/100;
      if (offsetString.slice(0,1)=="+") offset*=-1;
      day.setHours(day.getHours()+offset);
      return day.getTime();
    }
    if (noOffset(testIso)===1322118027000) {
       return noOffset;
    }
    return function(s){ // kennebec@SO + QTax@SO
        var day, tz,
//        rx = /^(\d{4}\-\d\d\-\d\d([tT][\d:\.]*)?)([zZ]|([+\-])(\d{4}))?$/,
        rx = /^(\d{4}\-\d\d\-\d\d([tT][\d:\.]*)?)([zZ]|([+\-])(\d\d):?(\d\d))?$/,

        p= rx.exec(s) || [];
        if(p[1]){
            day= p[1].split(/\D/).map(function(itm){
                return parseInt(itm, 10) || 0;
            });
            day[1]-= 1;
            day= new Date(Date.UTC.apply(Date, day));
            if(!day.getDate()) return NaN;
            if(p[5]){
                tz= parseInt(p[5], 10)/100*60;
                if(p[6]) tz += parseInt(p[6], 10);
                if(p[4]== "+") tz*= -1;
                if(tz) day.setUTCMinutes(day.getUTCMinutes()+ tz);
            }
            return day;
        }
        return NaN;
    }
})()


// Track basic JavaScript errors
window.addEventListener('error', function(e) {
  if (typeof window.ga !== "undefined") {
    ga('send',
      'event',
      'javascript',
      'error',
      e.message
    );
  };
}, false);

// Track AJAX errors (jQuery API)
$(document).ajaxError(function(e, request, settings) {
  if (typeof window.ga !== "undefined") {
    ga('send',
      'event',
      'ajax',
      'error',
      e.result,
      {'page': settings.url}
    );
  }
});

if (typeof Backbone !== "undefined") {
  Backbone.History.prototype.loadUrl = function (fragment) {
    fragment = this.fragment = this.getFragment(fragment);
    return _.any(this.handlers, function(handler) {
      if (handler.route.test(fragment)) {
        handler.callback(fragment);
        if (typeof window.ga !== "undefined") {
          ga('send', 'pageview');
        }
        return true;
      }
    });
  }
}