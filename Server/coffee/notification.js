// Generated by CoffeeScript 1.8.0
(function() {
  var hints;

  this.showNotification = function(mes, type) {
    var hint, jqObj, _i, _len;
    jqObj = createNotification(mes, type);
    $('#manage-body-main').prepend(jqObj);
    for (_i = 0, _len = hints.length; _i < _len; _i++) {
      hint = hints[_i];
      hint.alert('close');
    }
    hints.clear;
    return setTimeout(function() {
      return jqObj.alert('close');
    }, 10000);
  };

  this.showLineNotifications = function(mes) {
    var line, lines, _i, _len, _ref;
    lines = mes.split("\n");
    showNotification(lines[0], 'info');
    _ref = lines.slice(1);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      line = _ref[_i];
      if (line !== "") {
        showNotification(line, 'warning');
      }
    }
    return '';
  };

  hints = [];

  this.showTempNotification = function(mes) {
    var jqObj;
    jqObj = createNotification(mes, 'info');
    $('#manage-body-main').prepend(jqObj);
    return hints.push(jqObj);
  };

  this.createNotification = function(mes, type) {
    var html, jqObj;
    html = "<div class='alert alert-" + type + "' role='alert'> <button type='button' class='close' data-dismiss='alert'> <span aria-hidden='true'>x</span> </button> " + mes + " </div>";
    jqObj = $(html);
    return jqObj;
  };

}).call(this);

//# sourceMappingURL=notification.js.map
