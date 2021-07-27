// $(() => {
//   // いいねon時で自動化発動
//   var good = document.querySelector(".switch_auto");
//   var auto = document.querySelector(".auto"); //formタグ
//   // フォローon時で自動化発動
//   var follow = document.querySelector(".switch_follow");

//   good.addEventListener("click", () => {
//     // console.log(good.checked);
//     if(good.checked == true) {
//       auto.submit();
//     }else{
//       console.log("あらんど");
//     }
//   })

//   follow.addEventListener("click", () => {
//     if(follow.checked == true) {
//       auto.submit();
//     }else{
//       console.log("あらんどぉんでぃ！");
//     }
//   });
// });



$(() => {
  $(".switch_good").click(function(){
    $.ajax({
      url: "http://localhost:3000/instabots/good",
      type: "post",
      // formのクラスのパラメーターをdataの値に取る
      data: $(".auto").serialize(),
      datatype: "html",
    }).done(function(data) {
      console.log("ajax送信成功");
        // alert("ok");
    }).fail(function(data) {
      console.log("失敗");
        // alert("error");
    })
    good = document.querySelector(".switch_good");
    if(good.checked == true) {
      console.log("on");
    }else{
      console.log("off");
    }
  });
});


$(() => {
  $(".switch_follow").click(function(){
    $.ajax({
      url: "http://localhost:3000/instabots/follow",
      type: "post",
      // formのクラスのパラメーターをdataの値に取る
      data: $(".auto").serialize(),
      datatype: "html",
    }).done(function(data) {
      console.log("ajax送信成功");
        // alert("ok");
    }).fail(function(data) {
      console.log("失敗");
        // alert("error");
    })
    good = document.querySelector(".switch_follow");
    if(good.checked == true) {
      console.log("on");
    }else{
      console.log("off");
    }
  });
});

