this.data = ->
this.data.file = null
this.data.mode = 'test'

this.initManageBoard = ->
  initEnvironmentDropdown()
  switchEnvironmentTest()
  initProductButtons()
  initTestButtons()
  initRecordButtons()
  initGitButtons()
  initFileInputs()
  initSearchBoxes()

initEnvironmentDropdown = ->
  $('#btn-environment-choose-test').on 'click', switchEnvironmentTest
  $('#btn-environment-choose-product').on 'click', switchEnvironmentProduct
  $('#btn-environment-choose-record').on 'click', switchEnvironmentRecord

initTestButtons = ->
  $('#btn-compile-file').on 'click', testCompileFileClicked
  $('#btn-test-file').on 'click', testTestFileClicked
  $('#btn-reset-environment').on 'click', testResetEnvironmentClicked

initProductButtons = ->
  $('#btn-pull-dir').on 'click', productPullListClicked
  $('#btn-push-file').on 'click', productPushFileClicked
  $('#btn-delete-file').on 'click', productRemoveFileClicked
  $('#btn-restart-service').on 'click', productRestartClicked

initRecordButtons = ->
  $('#btn-next-record').on 'click', recordNextClicked
  $('#btn-download-record').on 'download', recordDownloadClicked
  $('#btn-record-reset').on 'click', recordResetClicked
  $('#btn-record-clear').on 'click', recordClearClicked

initGitButtons = ->
  $('#btn-pull-git').on 'click', gitPullClicked
  $('#btn-push-git').on 'click', gitPushClicked

initFileInputs = ->
  document.getElementById('manage-input-file').addEventListener 'change', onInputFileChanged

initSearchBoxes = ->
  document.getElementById('tbox-search-generation').onchange = ->
    setGenerationHTML document.getElementById('tbox-search-generation').value

switchEnvironmentTest = ->
  data.mode = 'test'
  $('#dropdown-environment')[0].childNodes[0].nodeValue = '测试 '
  $('#panel-management').removeClass 'panel-danger'
  $('#panel-management').removeClass 'panel-info'
  $('#panel-management').addClass 'panel-warning'
  $('#dropdown-environment').removeClass 'btn-danger'
  $('#dropdown-environment').removeClass 'btn-info'
  $('#dropdown-environment').addClass 'btn-warning'
  $('#panel-test-board').show()
  $('#panel-product-board').hide()
  $('#panel-record-board').hide()
  #$('#panel-git-board').hide()

switchEnvironmentProduct = ->
  data.mode = 'product'
  $('#dropdown-environment')[0].childNodes[0].nodeValue = '生产 '
  $('#panel-management').removeClass 'panel-warning'
  $('#panel-management').removeClass 'panel-info'
  $('#panel-management').addClass 'panel-danger'
  $('#dropdown-environment').removeClass 'btn-warning'
  $('#dropdown-environment').removeClass 'btn-info'
  $('#dropdown-environment').addClass 'btn-danger'
  $('#panel-product-board').show()
  #$('#panel-git-board').show()
  $('#panel-test-board').hide()
  $('#panel-record-board').hide()

switchEnvironmentRecord = ->
  data.mode = 'record'
  $('#dropdown-environment')[0].childNodes[0].nodeValue = '记录 '
  $('#panel-management').removeClass 'panel-warning'
  $('#panel-management').removeClass 'panel-danger'
  $('#panel-management').addClass 'panel-info'
  $('#dropdown-environment').removeClass 'btn-warning'
  $('#dropdown-environment').removeClass 'btn-danger'
  $('#dropdown-environment').addClass 'btn-info'
  $('#panel-product-board').hide()
  $('#panel-test-board').hide()
  $('#panel-record-board').show()


testCompileFileClicked = ->
  $.ajax
    url: getServerURL('test/compiler/full') + getAccessParameter()
    method: 'post'
    data: getMainContent()
    success: (data) ->
      showNotification 'server answer - 200 - ' + data.length + ' objs', 'success'
      generationSetHTML data
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'

testTestFileClicked = ->
  $.ajax
    url: getServerURL('test/test') + getAccessParameter()
    method: 'post'
    data: getMainContent()
    success: (data) ->
      showNotification 'server answer - 200 - ' + data[0], 'success'
      setAnswerList data
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'


testResetEnvironmentClicked = ->
  $.ajax
    url: getServerURL('test/reset') + getAccessParameter()
    method: 'post'
    success: (data) ->
      showLineNotifications 'server answer - 200 - ' + data, 'success'
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'

productPullListClicked = ->
  $.ajax
    url: getServerURL('product/list') + getAccessParameter()
    success: (data) ->
      showNotification 'server answer - 200 - ' + data.length + ' objs', 'success'
      setEditingFileList data
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'

productPushFileClicked = ->
  $.ajax
    url: getServerURL('product') + getAccessParameter()
    method: 'post'
    data:
      filename: data.file.name
      file: getMainContent()
    success: (data) ->
      showNotification 'server answer - 200 - ' + data, 'success'
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'

productRemoveFileClicked = ->
  # develop it later.

productRestartClicked = ->
  $.ajax
    url: getServerURL('restart') + getAccessParameter()
    method: 'post'
    success: (data) ->
      showLineNotifications 'server answer - 200 - ' + data, 'success'
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'

recordNextClicked = ->
  $.ajax
    url: getServerURL('record/next') + getAccessParameter()
    success: (data) ->
      if data.responseText == ''
        deckAnswer = '0 deck'
      else
        deckAnswer = '1 deck'
      showLineNotifications 'server answer - 200 - ' + deckAnswer, 'success'
      setInputDeck data
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'

recordDownloadClicked = ->

recordResetClicked = ->
  $.ajax
    url: getServerURL('record/reset') + getAccessParameter()
    success: (data) ->
      showLineNotifications 'server answer - 200 - ' + data, 'success'
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'

recordClearClicked = ->
  $.ajax
    url: getServerURL('record/clear') + getAccessParameter()
    success: (data) ->
      showLineNotifications 'server answer - 200 - ' + data, 'success'
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'


gitPullClicked = ->
  $.ajax
    url: getServerURL('git/pull') + getAccessParameter()
    method: 'post'
    success: (data) ->
      showNotification 'server answer - 200 - ' + data, 'success'
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'

gitPushClicked = ->
  $.ajax
    url: getServerURL('git/push') + getAccessParameter()
    method: 'post'
    success: (data) ->
      showNotification 'server answer - 200 - ' + data, 'success'
    error: (data) ->
      showNotification 'server answer - ' + data.status + " - #{data.responseText}", 'danger'

onInputFileChanged = (evt) ->
  files = evt.target.files
  file = files[0]
  return if !file
  return if file.size > 20480
  # read file
  reader = new FileReader()
  setMainContent ''
  reader.readAsText file
  $('#dropdown-editing-file')[0].childNodes[0].textContent = '本地文件 ' + file.name
  data.file = file
  reader.onload = (e) ->
    $('#txarea-main')[0].value = e.target.result + $('#txarea-main')[0].value
    if file.name.endsWith ".ydk"
      switchToDeck e.target.result
    else
      switchToText()

setInputDeck = (response) ->
  console.log response
  $('#dropdown-editing-file')[0].childNodes[0].textContent = '记录 ' + response.name
  setMainContent response.content
  switchToDeck response.content

switchToDeck = (deckStr) ->
  $('#div-deck').html generateDeckHTML generateDeck deckStr
  $('#div-deck').show()
  $('.form-group').hide()
  
switchToText = ->
  $('#div-deck').hide()
  $('.form-group').show()

@getAccessKey = ->
  $('#input-password')[0].value

@getAccessParameter = ->
  "?accesskey=#{getAccessKey()}"

@getMainContent = ->
  $('#txarea-main')[0].value
@setMainContent = (value) ->
  $('#txarea-main')[0].value = value

initManageBoard()