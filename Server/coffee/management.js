// Generated by CoffeeScript 2.0.0-alpha1
(function() {
  var gitPullClicked, gitPushClicked, initEnvironmentDropdown, initFileInputs, initGitButtons, initProductButtons, initRecordButtons, initSearchBoxes, initSwitchButton, initTestButtons, onInputFileChanged, productPullListClicked, productPushFileClicked, productRemoveFileClicked, productRestartClicked, recordClearClicked, recordDownloadClicked, recordNextClicked, recordResetClicked, setInputDeck, switchEnvironmentProduct, switchEnvironmentRecord, switchEnvironmentTest, switchToDeck, switchToText, testCompileFileClicked, testResetEnvironmentClicked, testTestFileClicked;

  this.data = function() {};

  this.data.file = null;

  this.data.mode = 'test';

  this.initManageBoard = function() {
    initEnvironmentDropdown();
    switchEnvironmentTest();
    initProductButtons();
    initTestButtons();
    initRecordButtons();
    initGitButtons();
    initFileInputs();
    initSearchBoxes();
    return initSwitchButton();
  };

  initEnvironmentDropdown = function() {
    $('#btn-environment-choose-test').on('click', switchEnvironmentTest);
    $('#btn-environment-choose-product').on('click', switchEnvironmentProduct);
    return $('#btn-environment-choose-record').on('click', switchEnvironmentRecord);
  };

  initTestButtons = function() {
    $('#btn-compile-file').on('click', testCompileFileClicked);
    $('#btn-test-file').on('click', testTestFileClicked);
    return $('#btn-reset-environment').on('click', testResetEnvironmentClicked);
  };

  initProductButtons = function() {
    $('#btn-pull-dir').on('click', productPullListClicked);
    $('#btn-push-file').on('click', productPushFileClicked);
    $('#btn-delete-file').on('click', productRemoveFileClicked);
    return $('#btn-restart-service').on('click', productRestartClicked);
  };

  initRecordButtons = function() {
    $('#btn-next-record').on('click', recordNextClicked);
    $('#btn-download-record').on('download', recordDownloadClicked);
    $('#btn-record-reset').on('click', recordResetClicked);
    return $('#btn-record-clear').on('click', recordClearClicked);
  };

  initGitButtons = function() {
    $('#btn-pull-git').on('click', gitPullClicked);
    return $('#btn-push-git').on('click', gitPushClicked);
  };

  initFileInputs = function() {
    return document.getElementById('manage-input-file').addEventListener('change', onInputFileChanged);
  };

  initSearchBoxes = function() {
    return document.getElementById('tbox-search-generation').onchange = function() {
      return setGenerationHTML(document.getElementById('tbox-search-generation').value);
    };
  };

  initSwitchButton = function() {
    $('#button-switch-deck').hide();
    return $('#button-switch-deck').click(function() {
      $('#button-switch-deck').hide();
      return switchToText();
    });
  };

  switchEnvironmentTest = function() {
    data.mode = 'test';
    $('#dropdown-environment')[0].childNodes[0].nodeValue = '测试 ';
    $('#panel-management').removeClass('panel-danger');
    $('#panel-management').removeClass('panel-info');
    $('#panel-management').addClass('panel-warning');
    $('#dropdown-environment').removeClass('btn-danger');
    $('#dropdown-environment').removeClass('btn-info');
    $('#dropdown-environment').addClass('btn-warning');
    $('#panel-test-board').show();
    $('#panel-product-board').hide();
    return $('#panel-record-board').hide();
  };

  switchEnvironmentProduct = function() {
    data.mode = 'product';
    $('#dropdown-environment')[0].childNodes[0].nodeValue = '生产 ';
    $('#panel-management').removeClass('panel-warning');
    $('#panel-management').removeClass('panel-info');
    $('#panel-management').addClass('panel-danger');
    $('#dropdown-environment').removeClass('btn-warning');
    $('#dropdown-environment').removeClass('btn-info');
    $('#dropdown-environment').addClass('btn-danger');
    $('#panel-product-board').show();
    $('#panel-test-board').hide();
    return $('#panel-record-board').hide();
  };

  switchEnvironmentRecord = function() {
    data.mode = 'record';
    $('#dropdown-environment')[0].childNodes[0].nodeValue = '记录 ';
    $('#panel-management').removeClass('panel-warning');
    $('#panel-management').removeClass('panel-danger');
    $('#panel-management').addClass('panel-info');
    $('#dropdown-environment').removeClass('btn-warning');
    $('#dropdown-environment').removeClass('btn-danger');
    $('#dropdown-environment').addClass('btn-info');
    $('#panel-product-board').hide();
    $('#panel-test-board').hide();
    return $('#panel-record-board').show();
  };

  testCompileFileClicked = function() {
    return $.ajax({
      url: getServerURL('test/compiler/full') + getAccessParameter(),
      method: 'post',
      data: getMainContent(),
      success: function(data) {
        showNotification('server answer - 200 - ' + data.length + ' objs', 'success');
        return generationSetHTML(data);
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  testTestFileClicked = function() {
    return $.ajax({
      url: getServerURL('test/test') + getAccessParameter(),
      method: 'post',
      data: getMainContent(),
      success: function(data) {
        showNotification('server answer - 200 - ' + data[0], 'success');
        return setAnswerList(data);
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  testResetEnvironmentClicked = function() {
    return $.ajax({
      url: getServerURL('test/reset') + getAccessParameter(),
      method: 'post',
      success: function(data) {
        return showLineNotifications('server answer - 200 - ' + data, 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  productPullListClicked = function() {
    return $.ajax({
      url: getServerURL('product/list') + getAccessParameter(),
      success: function(data) {
        showNotification('server answer - 200 - ' + data.length + ' objs', 'success');
        return setEditingFileList(data);
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  productPushFileClicked = function() {
    return $.ajax({
      url: getServerURL('product') + getAccessParameter(),
      method: 'post',
      data: {
        filename: data.file.name,
        file: getMainContent()
      },
      success: function(data) {
        return showNotification('server answer - 200 - ' + data, 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  productRemoveFileClicked = function() {};

  productRestartClicked = function() {
    return $.ajax({
      url: getServerURL('restart') + getAccessParameter(),
      method: 'post',
      success: function(data) {
        return showLineNotifications('server answer - 200 - ' + data, 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  recordNextClicked = function() {
    return $.ajax({
      url: getServerURL('record/next') + getAccessParameter(),
      success: function(data) {
        var deckAnswer;
        if (data === '' || data === void 0) {
          deckAnswer = '0 deck';
        } else {
          deckAnswer = data.remain + ' deck(s)';
        }
        showLineNotifications('server answer - 200 - ' + deckAnswer, 'success');
        return setInputDeck(data);
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  recordDownloadClicked = function() {};

  recordResetClicked = function() {
    return $.ajax({
      url: getServerURL('record/reset') + getAccessParameter(),
      success: function(data) {
        return showLineNotifications('server answer - 200 - ' + data, 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  recordClearClicked = function() {
    return $.ajax({
      url: getServerURL('record/clear') + getAccessParameter(),
      success: function(data) {
        return showLineNotifications('server answer - 200 - ' + data, 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  gitPullClicked = function() {
    return $.ajax({
      url: getServerURL('git/pull') + getAccessParameter(),
      method: 'post',
      success: function(data) {
        return showNotification('server answer - 200 - ' + data, 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  gitPushClicked = function() {
    return $.ajax({
      url: getServerURL('git/push') + getAccessParameter(),
      method: 'post',
      success: function(data) {
        return showNotification('server answer - 200 - ' + data, 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + ` - ${data.responseText}`, 'danger');
      }
    });
  };

  onInputFileChanged = function(evt) {
    var file, files, reader;
    files = evt.target.files;
    file = files[0];
    if (!file) {
      return;
    }
    if (file.size > 20480) {
      return;
    }
    reader = new FileReader();
    setMainContent('');
    reader.readAsText(file);
    $('#dropdown-editing-file')[0].childNodes[0].textContent = '本地文件 ' + file.name;
    data.file = file;
    return reader.onload = function(e) {
      $('#txarea-main')[0].value = e.target.result + $('#txarea-main')[0].value;
      if (file.name.endsWith(".ydk")) {
        return switchToDeck(e.target.result);
      } else {
        return switchToText();
      }
    };
  };

  setInputDeck = function(response) {
    console.log(response);
    $('#dropdown-editing-file')[0].childNodes[0].textContent = '记录 ' + response.name;
    setMainContent(response.content);
    return switchToDeck(response.content);
  };

  switchToDeck = function(deckStr) {
    $('#div-deck').html(generateDeckHTML(generateDeck(deckStr)));
    $('#div-deck').show();
    $('.form-group').hide();
    return $('#button-switch-deck').show();
  };

  switchToText = function() {
    $('#div-deck').hide();
    return $('.form-group').show();
  };

  this.getAccessKey = function() {
    return $('#input-password')[0].value;
  };

  this.getAccessParameter = function() {
    return `?accesskey=${getAccessKey()}`;
  };

  this.getMainContent = function() {
    return $('#txarea-main')[0].value;
  };

  this.setMainContent = function(value) {
    return $('#txarea-main')[0].value = value;
  };

  initManageBoard();

}).call(this);

//# sourceMappingURL=management.js.map
