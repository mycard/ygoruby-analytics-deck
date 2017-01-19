this.setEditingFileList = (data) ->
  $('#dropdown-file-lists li').remove()
  for str in data
    [li, a] = generateLi str
    $('#dropdown-file-lists').append li
    a.on 'click', {name: str}, fileInListClicked

fileInListClicked = (event) ->
  $('#dropdown-editing-file')[0].childNodes[0].textContent = event.data.name
  $.ajax
    url: getServerURL('product') + getAccessParameter(),
    data:
      filename: event.data.name
    success: (data) ->
      setMainContent data