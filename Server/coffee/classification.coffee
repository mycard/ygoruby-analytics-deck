#$ = require "jquery"

this.classificationSetHTML  = (classification)->
  classificationSetNameHTML classification.name
  classificationSetPriorityHTML classification.priority
  classificationRestrainSetHTML classification.restrain
  classificationSetExtraMessageHTML classification
  type = classification.type
  if type == 'deck'
    decktypeSetTypeName()
  else if type == 'tag'
    tagSetTypeName()

classificationSetNameHTML = (name) ->
  $("div#deck-name").html name

classificationSetPriorityHTML = (id) ->
  $("div#deck-prioirity").html id

classificationRestrainSetHTML = (restrains) ->
  $("ul#preview-restrains").empty()
  if !(restrains instanceof Array)
    restrains = [restrains]
  for restrain in restrains
    restrain_gotten_html = @restrainHTML restrain
    $("ul#preview-restrains").append restrain_gotten_html[0]
    $("ul#preview-restrains").append restrain_gotten_html[1]

classificationSetExtraMessageHTML = (classification) ->
  type = classification.type
  if type == 'deck'
    decktypeSetExtraMessageName()
    decktypeSetExtraMessageHTML classification
  else if type == 'tag'
    tagSetExtraMessageName()
    tagSetExtraMessageHTML classification

classificationSetExtraMessageContentHTML = (messages)->
  $("ul#preview-extra-message-list").empty()
  if messages == null or messages == undefined
    return
  if !(messages instanceof Array)
    messages = [messages]
  for message in messages
    classificationAddExtraMessage message

classificationAddExtraMessage = (message) ->
  a = $ "<a></a>"
  a.addClass "list-group-item"
  if message.name != undefined
    message = message.name
  a.html message
  $("ul#preview-extra-message-list").append a

decktypeSetTypeName = ->
  $("div#type-name").html "卡组"

decktypeSetExtraMessageName = ->
  $("div#preview-extra-message-name").html "标签"

decktypeSetExtraMessageHTML = (decktype) ->
  classificationSetExtraMessageContentHTML decktype.tags

tagSetTypeName = ->
  $("div#type-name").html "标签"

tagSetExtraMessageName = ->
  $("div#preview-extra-message-name").html "参数"

tagSetExtraMessageHTML = (tag) ->
  classificationSetExtraMessageContentHTML tag.configs