this.generations_set_html = (generations) ->
  #@generations = generations
  $("ul#deckDefinitions").empty()
  for generation in generations
    a = generation_item generation.name
    a.click generation, (event) ->
      $("button#generation").html event.data.name + "<span class=\"caret\"></span>"
      classification_set_html event.data
  if generations.length > 0
    $("ul#deckDefinitions li a")[0].click()

generation_item = (name) ->
  li = $("<li></li>")
  li.attr "role", "menuitem"
  a = $("<a></a>")
  a.attr "href", "#"
  a.html name
  li.append a
  $("ul#deckDefinitions").append li
  a