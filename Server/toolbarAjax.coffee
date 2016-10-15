@onCompileClick = () ->
  text = $("textarea#inputDeckdef")[0].value
  $.post "http://127.0.0.1:8080/deckidentifier/compiler", text, (data, textStatus)->
    console.log data
    generations_set_html data
  ""

$("document").ready ()->
  $("a#generate").click () ->
    onCompileClick()