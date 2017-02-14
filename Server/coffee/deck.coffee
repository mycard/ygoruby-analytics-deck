this.generateDeck = (str) ->
  lines = str.split /\n|\r/
  main = []
  side = []
  ex = []
  focus = main
  this.data.line = []
  for line in lines
    line.trim()
    this.data.line.push line
    continue if line.startsWith('#') and line != "#extra"
    continue if line == ""
    if line == "#extra"
      focus = ex
    else if line == "!side"
      focus = side
    else
      focus.push parseInt line
  {
    'main': main,
    'side': side,
    'ex': ex
  }

this.generateDeckHTML = (deck) ->
  console.log deck
  html = "<p>"
  for card in deck.main
    html += cardImgHTML card
  html += "</p><p>"
  for card in deck.side
    html += cardImgHTML card
  html += "</p><p>"
  for card in deck.ex
    html += cardImgHTML card
  html += "</p>"
  $(html)