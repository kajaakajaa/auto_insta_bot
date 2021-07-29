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
      console.log($(".auto").serializeArray());
    }).fail(function(data) {
      console.log("失敗");
    })
  });

  $("#hashsend").click(() => {
    $("#hashform").submit((e) => {
      e.preventDefault();
      $.ajax({
        url: "http://localhost:3000/instabots/hashtag",
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
});


// XMLHttpRequest ajax
// const インスタンス名 = new XMLHttpRequest();

// インスタンス名.open( 'POST', 送信先 );
// インスタンス名.setRequestHeader( 'content-type', 'application/x-www-form-urlencoded;charset=UTF-8' );
// インスタンス名.send( 'パラメータ=値' );

// インスタンス名.onreadystatechange = function() {
//   if( インスタンス名.readyState === 4 && インスタンス名.status === 200 ) {
//     //エラーを出さずに通信が完了した時の処理。例↓
//     console.log( インスタンス名.responseText );
//   }
// }
