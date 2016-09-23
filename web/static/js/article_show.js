import $ from "jquery";

(function() {
  $(function() {
    $('.zizhixi-comment').on('mouseenter', function() {
      $(this).find('.btn-edit, .btn-reply').removeClass('is-hidden');
    });

    $('.zizhixi-comment').on('mouseleave', function() {
      $(this).find('.btn-edit, .btn-reply').addClass('is-hidden');
    });
  });
})();
