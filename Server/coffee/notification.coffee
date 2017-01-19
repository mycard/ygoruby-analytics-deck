@showNotification = (mes, type) ->
  html = "<div class='alert alert-#{type}' role='alert'>
    <button type='button' class='close' data-dismiss='alert'>
      <span aria-hidden='true'>x</span>
    </button>
    #{mes}
  </div>"
  jqObj = $(html)
  $('#manage-body-main').prepend jqObj
  setTimeout ->
    jqObj.alert('close')
  , 5000