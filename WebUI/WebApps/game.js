$(function () {
    //验证是否存在小伙伴
    $.ajax({
        url: "../Handler/Handler.ashx",
        type: "POST",
        data: { "operate": "GetFriend" },
        dataType: 'text',
        success: function (data) {
            data = JSON.parse(data);
            //不存在，新建
            if (data.Status == "100") {
                $("#div_new").show();
                $("#div_continue").hide();
            }
                //存在 绑定数据
            else {
                $("#div_new").hide();
                $("#div_continue").show();
            }
        }
    });
});