/// <reference path="E:\袁满\橼\aresz.cn\WebUI\Scripts/JS/md5.js" />
/// <reference path="E:\袁满\橼\aresz.cn\WebUI\Scripts/JS/Global.js" />
/// <reference path="E:\袁满\橼\aresz.cn\WebUI\Scripts/JS/jquery.min.js" />
$(function () {
    var defaultUID = Ares.UrlParser.PARAM("UID");
    if (defaultUID != null) {
        $("[name='user_id']").val(defaultUID);
    }
    //注册提交按钮
    $(".ui.fluid.large.teal.submit.button").click(function () {
        var _this = this;
        var m = "";
        if ($(_this).attr("field") == "L") {
            m = "Login";
        }
        else if ($(_this).attr("field") == "R") {
            m = "Register";
        }
        else {
            return;
        }
        var formData = decodeURI($('.ui.form input').serialize());//serialize serializeArray
        var c = Ares.UrlParser.JSON(formData);

        $(_this).addClass("disabled");
        Ares.Ajax(m, c, function (f) {
            $(_this).removeClass("disabled");
            if (f.Status == "100") {
                $("#div_error").show().html(f.Message);
                $("[name='" + f.Field + "']").select();
            }
            else {
                $("#div_error").show().html(f.Message);
                if (m == "Register") {
                    alert(f.Message);
                    window.location.href = "Login.aspx?UID=" + c.user_id;
                }
                else {
                    window.location.href = "Main.aspx";
                }
            }
        }, true, null, null, false)
    });
    $("#hbtn_create_auth_code").click(function () {
        CreateAuthCode();
    });
});



window.CreateAuthCode = function () {
    var a = $("#htxt_auth_code").val();
    if (a == "") {
        return;
    }
    $.ajax({
        url: "Handler/Handler.ashx",
        type: "POST",
        dataType: 'text',//'application/json' 'text'
        data: { "operate": "CreateAuthCode", "authSession": "N", "AuthText": a },
        success: function (data) {
            $("[name='auth_code']").val(data)
        },
        error: function (a, b, c) {

        }
    });
}