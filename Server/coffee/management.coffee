this.data = ->
this.data.file = null
this.data.mode = 'test'

this.initManageBoard = ->
  initEnvironmentDropdown()
  switchEnvironmentTest()
  initProductButtons()
  initTestButtons()
  initGitButtons()
  initFileInputs()

initEnvironmentDropdown = ->
  $('#btn-environment-choose-test').on 'click', switchEnvironmentTest
  $('#btn-environment-choose-product').on 'click', switchEnvironmentProduct

initTestButtons = ->
  $('#btn-compile-file').on 'click', testCompileFileClicked
  $('#btn-test-file').on 'click', testTestFileClicked
  $('#btn-reset-environment').on 'click', testResetEnvironmentClicked

initProductButtons = ->
  $('#btn-pull-dir').on 'click', productPullListClicked
  $('#btn-push-file').on 'click', productPushFileClicked
  $('#btn-delete-file').on 'click', productRemoveFileClicked
  $('#btn-restart-service').on 'click', productRestartClicked

initGitButtons = ->
  $('#btn-pull-git').on 'click', gitPullClicked
  $('#btn-push-git').on 'click', gitPushClicked

initFileInputs = ->
  document.getElementById('manage-input-file').addEventListener 'change', onInputFileChanged

switchEnvironmentTest = ->
  data.mode = 'test'
  $('#dropdown-environment')[0].childNodes[0].nodeValue = '测试 '
  $('#panel-management').removeClass 'panel-danger'
  $('#panel-management').addClass 'panel-warning'
  $('#dropdown-environment').removeClass 'btn-danger'
  $('#dropdown-environment').addClass 'btn-warning'
  $('#panel-test-board').show()
  $('#panel-product-board').hide()
  $('#panel-git-board').hide()

switchEnvironmentProduct = ->
  data.mode = 'product'
  $('#dropdown-environment')[0].childNodes[0].nodeValue = '生产 '
  $('#panel-management').removeClass 'panel-warning'
  $('#panel-management').addClass 'panel-danger'
  $('#dropdown-environment').removeClass 'btn-warning'
  $('#dropdown-environment').addClass 'btn-danger'
  $('#panel-product-board').show()
  $('#panel-git-board').show()
  $('#panel-test-board').hide()

testCompileFileClicked = ->
  $.ajax
    url: getServerURL('test/compiler/heavy') + getAccessParameter()
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
      showNotification 'server answer - 200 - ' + data, 'success'
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
      showNotification 'server answer - 200 - ' + data, 'success'
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
  reader.onload = (e) ->
    $('#txarea-main')[0].value = e.target.result + $('#txarea-main')[0].value
  reader.readAsText file
  $('#dropdown-editing-file')[0].childNodes[0].textContent = '本地文件 ' + file.name
  data.file = file

@getAccessKey = ->
  $('#input-password')[0].value

@getAccessParameter = ->
  "?accesskey=#{getAccessKey()}"

@getMainContent = ->
  $('#txarea-main')[0].value

@setMainContent = (value) ->
  $('#txarea-main')[0].value = value

initManageBoard()