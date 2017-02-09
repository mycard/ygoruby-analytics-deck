this.generationSetHTML = (generations) ->
  switchToPreview()
  #console.log generations
  @generations = generations
  setGenerationHTML()

this.setGenerationHTML = (filter) ->
  return if @generations == null
  filter = "" if !filter
  $("ul#list-classifications").empty()
  targets = []
  for generation in @generations
    if generation.name.includes filter
      targets.push generation
  for generation in targets
    [li, a] = generateLi generation.name
    $("ul#list-classifications").append li
    a.click generation, (event) ->
      $("button#dropdown-classification-list").html event.data.name + "<span class=\"caret\"></span>"
      classificationSetHTML event.data
  if targets.length > 0
    $("ul#list-classifications li a")[0].click()

this.generateLi = (name) ->
  li = $('<li></li>')
  li.attr 'role', 'menuitem'
  a = $('<a></a>')
  a.attr 'href', '#'
  a.html name
  li.append a
  [li, a]