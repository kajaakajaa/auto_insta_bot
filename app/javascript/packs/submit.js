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

});


var unit_prices = document.getElementsByClassName("unit_price"); // 単価。

unit_prices = Array.from( unit_prices );
// 必要な変数の初期化
let total = 0;
let count = 0;

// 全ての商品の合計金額を求める
unit_prices.forEach(unit_price => {
  total += parseInt(unit_price.dataset.price) * parseInt(amounts[count].value); 
  count++ 
});