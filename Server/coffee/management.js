// Generated by CoffeeScript 1.8.0
(function() {
  var gitPullClicked, gitPushClicked, initEnvironmentDropdown, initFileInputs, initGitButtons, initProductButtons, initTestButtons, onInputFileChanged, productPullListClicked, productPushFileClicked, productRemoveFileClicked, productRestartClicked, switchEnvironmentProduct, switchEnvironmentTest, testCompileFileClicked, testResetEnvironmentClicked, testTestFileClicked;

  this.data = function() {};

  this.data.file = null;

  this.data.mode = 'test';

  this.initManageBoard = function() {
    initEnvironmentDropdown();
    switchEnvironmentTest();
    initProductButtons();
    initTestButtons();
    initGitButtons();
    return initFileInputs();
  };

  initEnvironmentDropdown = function() {
    $('#btn-environment-choose-test').on('click', switchEnvironmentTest);
    return $('#btn-environment-choose-product').on('click', switchEnvironmentProduct);
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

  initGitButtons = function() {
    $('#btn-pull-git').on('click', gitPullClicked);
    return $('#btn-push-git').on('click', gitPushClicked);
  };

  initFileInputs = function() {
    return document.getElementById('manage-input-file').addEventListener('change', onInputFileChanged);
  };

  switchEnvironmentTest = function() {
    data.mode = 'test';
    $('#dropdown-environment')[0].childNodes[0].nodeValue = '测试 ';
    $('#panel-management').removeClass('panel-danger');
    $('#panel-management').addClass('panel-warning');
    $('#dropdown-environment').removeClass('btn-danger');
    $('#dropdown-environment').addClass('btn-warning');
    $('#panel-test-board').show();
    $('#panel-product-board').hide();
    return $('#panel-git-board').hide();
  };

  switchEnvironmentProduct = function() {
    data.mode = 'product';
    $('#dropdown-environment')[0].childNodes[0].nodeValue = '生产 ';
    $('#panel-management').removeClass('panel-warning');
    $('#panel-management').addClass('panel-danger');
    $('#dropdown-environment').removeClass('btn-warning');
    $('#dropdown-environment').addClass('btn-danger');
    $('#panel-product-board').show();
    $('#panel-git-board').show();
    return $('#panel-test-board').hide();
  };

  testCompileFileClicked = function() {
    return $.ajax({
      url: getServerURL('test/compiler/heavy') + getAccessParameter(),
      method: 'post',
      data: getMainContent(),
      success: function(data) {
        showNotification('server answer - 200 - ' + data.length + ' objs', 'success');
        return generations_set_html(data);
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + (" - " + data.responseText), 'danger');
      }
    });
  };

  testTestFileClicked = function() {
    return $.ajax({
      url: getServerURL('test/test') + getAccessParameter(),
      method: 'post',
      data: getMainContent(),
      success: function(data) {
        return showNotification('server answer - 200', 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + (" - " + data.responseText), 'danger');
      }
    });
  };

  testResetEnvironmentClicked = function() {
    return $.ajax({
      url: getServerURL('test/reset') + getAccessParameter(),
      method: 'post',
      success: function(data) {
        return showNotification('server answer - 200 - ' + data, 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + (" - " + data.responseText), 'danger');
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
        return showNotification('server answer - ' + data.status + (" - " + data.responseText), 'danger');
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
        return showNotification('server answer - ' + data.status + (" - " + data.responseText), 'danger');
      }
    });
  };

  productRemoveFileClicked = function() {};

  productRestartClicked = function() {
    return $.ajax({
      url: getServerURL('restart') + getAccessParameter(),
      method: 'post',
      success: function(data) {
        return showNotification('server answer - 200 - ' + data, 'success');
      },
      error: function(data) {
        return showNotification('server answer - ' + data.status + (" - " + data.responseText), 'danger');
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
        return showNotification('server answer - ' + data.status + (" - " + data.responseText), 'danger');
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
        return showNotification('server answer - ' + data.status + (" - " + data.responseText), 'danger');
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
    reader.onload = function(e) {
      return $('#txarea-main')[0].value = e.target.result + $('#txarea-main')[0].value;
    };
    reader.readAsText(file);
    $('#dropdown-editing-file')[0].childNodes[0].textContent = '本地文件 ' + file.name;
    return data.file = file;
  };

  this.getAccessKey = function() {
    return $('#input-password')[0].value;
  };

  this.getAccessParameter = function() {
    return "?accesskey=" + (getAccessKey());
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
