this.config = {
  "server": "http://127.0.0.1:8080/deckIdentifier"
}

this.getServerURL = (param) ->
  config.server + '/' + param