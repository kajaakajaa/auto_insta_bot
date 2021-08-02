// jquery ajax
$(() => {
  $(".switch_auto").click(function(){
    $.ajax({
      url: "http://localhost:3000/instabots/auto",
      type: "post",
      // formのパラメーターをdataの値に取る
      data: $(".auto").serialize(),
      datatype: "html",
    }).done(function(data) {
      console.log("ajax送信成功");
      // console.log($(".auto").serializeArray());
    }).fail(function(data) {
      console.log("失敗");
    })
  });

  $("#hashsend").click(() => {

    $("#hashform").submit((e) => {
      e.preventDefault();
      $.ajax({
        url: "http://localhost:3000/hashtags",
        type: "post",
        data: $("#hashform").serialize(),
        datatype: "html",
      }).done((data) => {
        console.log("hash_tag送信成功");
      }).fail((data) => {
        console.log("失敗");
      })
    });
  });

  // ハッシュタグの削除
  // $(".delete_keyword").click(() => {
  //   $.ajax({
  //     url: "http://localhost:3000/hashtags/delete/:id",
  //     type: "post",
  //     data: $(".")
  //     datatype: "html",
  //   }).done((data) => {
  //     console.log("delete送信成功");
  //   }).fail((data) => {
  //     console.log("失敗");
  //   })
  // });
});


