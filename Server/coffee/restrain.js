// Generated by CoffeeScript 1.8.0
(function() {
  var restrainConditionHTML, restrainExampleHTML, restrainFigureHTML, restrainGroupHTML, restrainIds, restrainImgHTML, restrainRangeHTML, restrainTypeHTML, setExampleHTML, setFigureHTML;

  this.restrainHTML = function(restrain_json) {
    return [restrainExampleHTML(restrain_json), restrainFigureHTML(restrain_json)];
  };

  this.restrainGroupHTML = function(restrain_group_json) {
    return ["", restrainGroupHTML(restrain_group_json)];
  };

  this.setHTML = function(set_json) {
    return [setExampleHTML(set_json), setFigureHTML(set_json)];
  };

  restrainExampleHTML = function(restrain_json) {
    var a, id, ids, _i, _len;
    if (!restrain_json) {
      return;
    }
    ids = restrainIds(restrain_json);
    a = $("<a></a>");
    a.addClass("list-group-item");
    for (_i = 0, _len = ids.length; _i < _len; _i++) {
      id = ids[_i];
      a.append(restrainImgHTML(id));
    }
    return a;
  };

  setExampleHTML = function(set_json) {
    var a, id, ids, _i, _len;
    if (!set_json) {
      return;
    }
    ids = set_json.ids;
    a = $("<a></a>");
    a.addClass("list-group-item");
    for (_i = 0, _len = ids.length; _i < _len; _i++) {
      id = ids[_i];
      a.append(restrainImgHTML(id));
    }
    return a;
  };

  restrainImgHTML = function(id) {
    return cardImgHTML(id);
  };

  restrainIds = function(restrain_json) {
    var ids, number, type;
    if (!restrain_json) {
      return;
    }
    type = restrain_json.type;
    if (type === 'card') {
      return Array(restrain_json.condition.number).fill(restrain_json.id);
    } else if (type === 'set') {
      ids = restrain_json.set.ids.slice(0);
      number = restrain_json.condition.number;
      if (number < ids.length) {
        return ids.slice(0, number);
      } else if (numbers <= ids.length * 2) {
        return ids.times(2).slice(0, number);
      } else {
        return ids.times(3).slice(0, number);
      }
    }
  };

  restrainFigureHTML = function(restrain_json) {
    var a;
    a = $("<a></a>");
    a.addClass("list-group-item disabled");
    a.append(restrainTypeHTML(restrain_json));
    a.append(restrainRangeHTML(restrain_json.range));
    a.append(restrainConditionHTML(restrain_json.condition, restrain_json.type));
    return a;
  };

  restrainGroupHTML = function(restrain_group_html) {
    var a;
    a = $("<a>迷之约束组 - 今天的 II 也懒的不行</a>");
    a.addClass("list-group-item disabled");
    return a;
  };

  setFigureHTML = function(set_json) {
    var a;
    a = $("<a></a>");
    a.addClass("list-group-item disabled");
    a.append(restrainRangeHTML(set_json.ids.length));
    a.append(" cards");
    return a;
  };

  restrainConditionHTML = function(condition_json, type) {
    var number, operator;
    operator = condition_json.operator;
    number = condition_json.number;
    return " <code>" + operator + "</code> <kbd class='" + type + "'>" + number + "</kbd>";
  };

  restrainRangeHTML = function(range_json) {
    if (range_json === "all") {
      return "";
    } else {
      return " <kbd class=\"" + range_json + "\">" + range_json + "</kbd>";
    }
  };

  restrainTypeHTML = function(restrain_json) {
    var name, type;
    type = restrain_json.type;
    name = restrain_json.name['zh-CN'];
    if(!name)
      name = restrain_json.name;
    return "<kbd class='" + type + "'>" + name + "</kbd>";
  };


  /*
        <div class="row">
          <div class="col-md-4">
              <div class="bs-example">
                  <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/60473572.jpg">
                  <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/33256280.jpg">
                  <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/7868571.jpg">
                  <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/69351984.jpg">
                  <img src="http://cdn233.my-card.in/ygopro/pics/thumbnail/18716735.jpg">
              </div>
              <figure class="highlight">
                  <kbd class="set">炼装</kbd> <code>>=</code> <kbd class="set">5</kbd>
              </figure>
          </div>
      </div>
   */

  Array.prototype.times = function(times) {
    var answer, item, _i, _len;
    answer = [];
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      item = this[_i];
      Array.prototype.push.apply(answer, Array(times).fill(item));
    }
    return answer;
  };

  this.help = function(index) {
    var jq;
    jq = restrainHTML(ex[index].restrain);
    return $('div.row:last').append(jq);
  };

}).call(this);

//# sourceMappingURL=restrain.js.map
