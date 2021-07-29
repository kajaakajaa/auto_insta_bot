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
    }).fail(function(data) {
      console.log("失敗");
    })
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

const xhr = new XMLHttpRequest();
xhr.open( "POST", "http://localhost:3000/instabots/hashtag" );
xhr.setRequestHeader( "content-type", "application/x-www-form-urlencoded;charset=UTF-8" );

var set_hash = document.querySelector(".set_hash");
var submit_hash = document.querySelector("#submit_hash");
const request = set_hash.name
set_hash.addEventListener("click", () => {
  xhr.send(request);
});

xhr.onreadystatechange = function() {
  if(xhr.readyState === 4 && xhr.status === 200 ) {
    console.log("xmlhttp送信成功");
  }
}

