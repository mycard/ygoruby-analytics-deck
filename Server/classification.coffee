#$ = require "jquery"

this.classification_set_html  = (classification)->
  classification_set_name_html classification.name
  classification_set_priority_html classification.priority
  classification_restrain_set_html classification.restrain
  classification_set_extra_message_html classification
  type = classification.type
  if type == 'deck'
    decktype_set_type_name()
  else if type == 'tag'
    tag_set_type_name()

classification_set_name_html = (name) ->
  $("div#deckName").html name

classification_set_priority_html = (id) ->
  $("div#deckPriority").html id

classification_restrain_set_html = (restrains) ->
  $("ul#restrains").empty()
  if !(restrains instanceof Array)
    restrains = [restrains]
  for restrain in restrains
    restrain_gotten_html = @restrain_html restrain
    $("ul#restrains").append restrain_gotten_html[0]
    $("ul#restrains").append restrain_gotten_html[1]

classification_set_extra_message_html = (classification) ->
  type = classification.type
  if type == 'deck'
    decktype_set_extra_message_name()
    decktype_set_extra_message_html classification
  else if type == 'tag'
    tag_set_extra_message_name()
    tag_set_extra_message_html classification

classification_set_extra_message_content_html = (messages)->
  $("ul#extraMessageList").empty()
  if messages == null or messages == undefined
    return
  if !(messages instanceof Array)
    messages = [messages]
  for message in messages
    classification_add_extra_message message

classification_add_extra_message = (message) ->
  a = $ "<a></a>"
  a.addClass "list-group-item"
  if message.name != undefined
    message = message.name
  a.html message
  $("ul#extraMessageList").append a

decktype_set_type_name = ->
  $("div#typeName").html "卡组"

decktype_set_extra_message_name = ->
  $("div#extraMessageName").html "标签"

decktype_set_extra_message_html = (decktype) ->
  classification_set_extra_message_content_html decktype.tags

tag_set_type_name = ->
  $("div#typeName").html "标签"

tag_set_extra_message_name = ->
  $("div#extraMessageName").html "参数"

tag_set_extra_message_html = (tag) ->
  classification_set_extra_message_content_html tag.configs