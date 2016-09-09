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

  // 小组帖子详情
  (function() {
    let $main = $('html, body');
    let $comment_textarea = $('#group_comment_content');

    $('.media').on('mouseenter', function() {
      $(this).find('.btn-edit, .btn-reply').removeClass('is-hidden');
    });

    $('.media').on('mouseleave', function() {
      $(this).find('.btn-edit, .btn-reply').addClass('is-hidden');
    })

    $('.btn-reply').on('click', function() {
      let floor = $(this).data('floor');
      let username = $(this).data('username');
      let content = $comment_textarea.val();
      let new_content = `${$.trim(content)? content + '\n' : ''}#${floor}楼 @${username} `;

      $comment_textarea.val(new_content).focus();
    });

    $('.btn-scroll-up').on('click', function() {
      $main.scrollTop(0);
    });

    $('.btn-scroll-down').on('click', function() {
      $main.scrollTop($main.height());
    });

    $('.btn-begin-comment').on('click', function() {
      $comment_textarea.focus();
    });
  })();
})

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
