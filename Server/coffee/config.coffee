this.config = {
  "server": "/ygopro/analytics2/deckIdentifier"
}

this.getServerURL = (param) ->
  showTempNotification 'sending server ' + param + '...'
  config.server + '/' + param

this.cardImgHTML = (id) ->
  "<a href='http://www.ourocg.cn/S.aspx?key=#{id}' target='_blank'><img src='http://ygo233.my-card.in/ygopro/pics/thumbnail/#{id}.jpg'</a>"
