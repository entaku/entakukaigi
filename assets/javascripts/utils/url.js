var linkTo, api;

(function() {
  var URLs, baseURL,
    __slice = [].slice,
    VERSION = "v1";

  URLs = {
    root: function() {
      return "";
    },
    roomsShow: function(id) {
      return "rooms/" + id;
    },
    roomsUsersShow: function(id) {
      return "rooms/" + id + "/users";
    },
    roomsUsersDestroy: function(id, userID) {
      return this.roomsUsersShow(id) + "/" + userID;
    }
  };

  var baseURL = function(type, args) {
    return URLs[type].apply(URLs, args);
  };

  linkTo = function() {
    var args, type;
    type = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return "/" + baseURL(type, args);
  };

  api = function() {
    var args, type;
    type = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return "/api/" + VERSION + "/" + baseURL(type, args);
  };

}).call(this);