$(function(){
  $fileField = $('#task_image')

  $($fileField).on('change', $fileField, function(e) {
    file = e.target.files[0]
    reader = new FileReader(),
    $preview = $('#img_field');
    
    reader.onload = (function(file) {
      return function(e) {
        $preview.empty();
        $preview.append($('<img>').attr({
          src: e.target.result,
          width: "100%",
          class: "preview",
          title: file.name
        }));
      };
    })(file);
    reader.readAsDataURL(file);

    let formData = new FormData();
    formData.append('task[image]', file);
    const token = $('meta[name="csrf-token"]').attr('content');
    $.ajax({
      headers: {'X-CSRF-Token' : token},
      url: "/image_authentications",
      type: "post",
      data: formData,
      dataType:'json',
      processData: false,
      contentType: false
    }).done(function(data) {
      //成功したら、ImageAuthenticationsコントローラーから送られてきた値を入力する
      debugger
      $('#task_note').val(data.task_note)

    }).fail(function(data) {
      //エラー時の処理

    });
  });
});


    // ajaxでデータを送信する
    // let form = $('#account_form').get(0);

    // reader.loadend  = (function(file) {
    //   debugger
    //   return function(e) {
    //     $preview.empty();
    //     $preview.append($('<img>').attr({
    //       src: e.target.result,
    //       width: "100%",
    //       class: "preview",
    //       title: file.name
    //     }));
    //   };
    // })(file);

        // let image = $('img[class="preview"]').attr('src');
    //   src: e.target.result
    // //   data: { "src" : image },
    // //   dataType : "json"
    //   // data : formData,  // dataに FormDataを指定
    //   // processData: false,  //ajaxがdataを整形しない指定
    //   // contentType: false  //contentTypeもfalseに指定