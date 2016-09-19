// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";
import $ from "jquery";
import Simditor from "simditor";
import angular from "angular";
import "ng-file-upload";
import "angular-events-calendar";
import moment from "moment";


(function() {
  if ($('#settings-profile').length <= 0) {
    return;
  }

  let app = angular.module('fileUpload', ['ngFileUpload']);

  app.controller('SettingsProfileCtrl', ['$scope', 'Upload', '$timeout', function ($scope, Upload, $timeout) {

    $scope.upload = function(file) {
      if (! file) {
        return;
      }
      Upload.upload({
          url: '/upload',
          headers: {"X-CSRF-TOKEN": $("meta[name=csrf]").attr("content")},
          data: {file: file}
      }).then(function (resp) {
        var avatar_url = resp.data.url + '?imageView2/1/w/200/h/200';
        $('#user_avatar').val(avatar_url);
        $('#user-avatar').attr('src', avatar_url);
      }, function (resp) {
        alert("上传失败")
      });
    }
  }]);

  angular.bootstrap(document, ['fileUpload']);
})();


(function() {
  if ($('#groups-new').length <= 0) {
    return;
  }

  let app = angular.module('fileUpload', ['ngFileUpload']);

  app.controller('GroupsNewCtrl', ['$scope', 'Upload', '$timeout', function ($scope, Upload, $timeout) {

    $scope.upload = function(file) {
      if (! file) {
        return;
      }
      Upload.upload({
          url: '/upload',
          headers: {"X-CSRF-TOKEN": $("meta[name=csrf]").attr("content")},
          data: {file: file}
      }).then(function (resp) {
        var img_url = resp.data.url + '?imageView2/1/w/200/h/200';
        $('#group_logo').val(img_url);
        $('#group-logo').attr('src', img_url);
      }, function (resp) {
        alert("上传失败")
      });
    }
  }]);

  angular.bootstrap(document, ['fileUpload']);
})();

$(function() {
  // 消息框
  (function() {
    let $notification = $('.notification');

    if ($notification.length) {
      setTimeout(function() {
        $notification.fadeOut();
      }, 2000);

      $notification.find('.delete').on('click', function() {
        $notification.fadeOut();
      });
    };
  })();

  // 发新贴
  (function() {
    let $textarea = $('#group_post_content');

    if ($textarea.length == 0) {
      return;
    }

    let editor = new Simditor({
      textarea: $textarea
    });

    editor.focus();
  })();

  // 小组帖子详情
  (function() {
    let $textarea = $('#group_comment_content');

    if ($textarea.length == 0) {
      return;
    }

    let $main = $('html, body');
    // ['title', 'bold', 'italic', 'underline', 'strikethrough', 'fontScale',
    //  'color', 'ol', 'ul', 'blockquote', 'code', 'table', 'link', 'image', 'hr',
    //  'indent', 'outdent', 'alignment']

    let editor = new Simditor({
      textarea: $textarea,
      toolbar: ['bold', 'ol', 'ul', 'blockquote','link', 'image']
    });

    $('.media').on('mouseenter', function() {
      $(this).find('.btn-edit, .btn-reply').removeClass('is-hidden');
    });

    $('.media').on('mouseleave', function() {
      $(this).find('.btn-edit, .btn-reply').addClass('is-hidden');
    })

    $('.btn-reply').on('click', function() {
      let floor = $(this).data('floor');
      let username = $(this).data('username');
      let content = editor.getValue();
      let new_content = `${$.trim(content)? content + '\n' : ''}#${floor}楼 @${username} <b>Hi</b>!`;

      editor.setValue(new_content);

      setTimeout(function() {
        editor.focus();
      }, 300);
    });

    $('.btn-scroll-up').on('click', function() {
      $main.animate({scrollTop: 0}, 200);
    });

    $('.btn-scroll-down').on('click', function() {
      $main.animate({scrollTop: $main.height()}, 200);
    });

    $('.btn-begin-comment').on('click', function() {
      setTimeout(function() {
        editor.focus();
      }, 300);
    });

  })();

  (function() {
    if ($('#user-show-profile').length <= 0) {
      return;
    }

    let app = angular.module('UserShowProfile', ['eventsCalendar']);

    app.filter("trust", ['$sce', function($sce) {
      return function(htmlCode){
        return $sce.trustAsHtml(htmlCode);
      }
    }]);

    app.filter("format", ['$sce', function($sce) {
      return function(date){
        return moment(date).format("HH:mm:ss");
      }
    }]);

    app.controller('UserCalendarController', ['$scope', '$http', function($scope, $http) {
      $scope.selectedDay = null;
      $scope.day = null;
      $scope.timelineList = [];

      $http.get($('#user-calendar').data('events-api')).success(function(res) {
        $scope.eventList = res.data;
        get_timelies(new Date());
      });

      function get_timelies(day) {
        $scope.day = moment(day).format('YYYY-MM-DD');
        let url = $('#user-calendar').data('timelines-api') + '?day=' + $scope.day;

        $http.get(url).success(function(res) {
          $scope.timelineList = res.data;
        })
      }

      $scope.$watch('selectedDay', function(n, o) {
        if (n == null || n == 'selectedDay') {return};
        get_timelies(n);
      });
    }]);

    angular.bootstrap(document, ['UserShowProfile']);
  })();
})

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
