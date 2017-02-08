@showNotification = (mes, type) ->
  jqObj = createNotification mes, type
  $('#manage-body-main').prepend jqObj
  hint.alert('close') for hint in hints
  hints.clear
  setTimeout ->
    jqObj.alert('close')
  , 10000

@showLineNotifications = (mes) ->
  lines = mes.split "\n"
  showNotification lines[0], 'info'
  showNotification line, 'warning' if line != "" for line in lines[1..-1]

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