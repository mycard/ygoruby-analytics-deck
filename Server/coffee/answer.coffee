@switchToPreview = ->
  #$('#panel-preview').show()
  #$('#panel-answer').hide()
@switchToAnswer = ->
  #$('#panel-answer').show()
  #$('#panel-preview').hide()

switchToPreview()

this.setAnswerList = (data) ->
  switchToAnswer()
  $("ul#answer-extra-message-list").empty()
  if data == undefined
    $('#answer-deck-name').html "卡组辨识结果：谜之卡组"
  else
    $('#answer-deck-name').html "卡组辨识结果：" + data[0]
  for tag in data[1]
    a = $ "<a></a>"
    a.addClass "list-group-item"
    a.html tag
    $("ul#answer-extra-message-list").append a