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
import $ from "jquery";
import "phoenix_html";
import Simditor from "simditor";


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
})

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
