this.generationSetHTML = (generations) ->
  switchToPreview()
  #@generations = generations
  $("ul#list-classifications").empty()
  for generation in generations
    [li, a] = generateLi generation.name
    $("ul#list-classifications").append li
    a.click generation, (event) ->
      $("button#dropdown-classification-list").html event.data.name + "<span class=\"caret\"></span>"
      classificationSetHTML event.data
  if generations.length > 0
    $("ul#list-classifications li a")[0].click()

this.generateLi = (name) ->
  li = $('<li></li>')
  li.attr 'role', 'menuitem'
  a = $('<a></a>')
  a.attr 'href', '#'
  a.html name
  li.append a
  [li, a]