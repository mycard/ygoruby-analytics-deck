// Generated by CoffeeScript 1.8.0
(function() {
  var generation_item;

  this.generations_set_html = function(generations) {
    var a, generation, _i, _len;
    $("ul#deckDefinitions").empty();
    for (_i = 0, _len = generations.length; _i < _len; _i++) {
      generation = generations[_i];
      a = generation_item(generation.name);
      a.click(generation, function(event) {
        $("button#generation").html(event.data.name + "<span class=\"caret\"></span>");
        return classification_set_html(event.data);
      });
    }
    if (generations.length > 0) {
      return $("ul#deckDefinitions li a")[0].click();
    }
  };

  generation_item = function(name) {
    var a, li;
    li = $("<li></li>");
    li.attr("role", "menuitem");
    a = $("<a></a>");
    a.attr("href", "#");
    a.html(name);
    li.append(a);
    $("ul#deckDefinitions").append(li);
    return a;
  };

}).call(this);

//# sourceMappingURL=generationsAjax.js.map
