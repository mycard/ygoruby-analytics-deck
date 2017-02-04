@showNotification = (mes, type) ->
  jqObj = createNotification mes, type
  $('#manage-body-main').prepend jqObj
  hint.alert('close') for hint in hints
  hints.clear
  setTimeout ->
    jqObj.alert('close')
  , 5000

hints = []
@showTempNotification = (mes) ->
  jqObj = createNotification mes, 'info'
  $('#manage-body-main').prepend jqObj
  hints.push jqObj

@createNotification = (mes, type) ->
  html = "<div class='alert alert-#{type}' role='alert'>
    <button type='button' class='close' data-dismiss='alert'>
      <span aria-hidden='true'>x</span>
    </button>
    #{mes}
  </div>"
  jqObj = $(html)
  jqObj