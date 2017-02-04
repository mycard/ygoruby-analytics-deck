this.config = {
  "server": "/ygopro/analytics2/deckIdentifier/"
}

this.getServerURL = (param) ->
  showTempNotification 'sending server ' + param + '...'
  config.server + '/' + param