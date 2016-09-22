import $ from "jquery";
import Simditor from "simditor";

(function() {
  $(function() {
    var $simditor_textarea = $('.simditor-textarea');

    if ($simditor_textarea.length <= 0) {
      return;
    };

    new Simditor({
      textarea: $simditor_textarea,
      imageButton: 'upload',
      pasteImage: true,
      upload: {
        url: "/editor/upload",
        fileKey: "file"
      }
    });
  });
})();
