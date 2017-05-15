<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="WebUI.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>首页</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="Scripts/JS/jquery.min.js"></script>
    <link href="Scripts/Packages/Semantic-UI-master/dist/semantic.min.css" rel="stylesheet" />
    <script src="Scripts/Packages/Semantic-UI-master/dist/semantic.min.js"></script>
    <script src="Scripts/JS/Global.js"></script>

    <style type="text/css">
        body {
            background-color: #FFFFFF;
        }

        .ui.menu .item img.logo {
            margin-right: 1.5em;
        }

        .item_close {
            position: absolute;
            right: 2px;
            top: 5px;
            animation: initial;
        }

        .item_title {
            margin: 2px 15px 1px 1px;
            font-size: 14px;
        }
    </style>
    <script>
        $(function () {
            Ares.Ajax("GetMenus", {}, function (res) {
                var a = res;
                for (var i = 0; i < a.length; i++) {
                    var h = "<div class='ui simple dropdown item'>";
                    h += a[i]["LV1_NAME"] + "<i class='dropdown icon'></i>";
                    h += "<div class='menu'>";
                    for (var j = 0; j < a[i]["LV1_DETAIL"].length; j++) {
                        h += "<a class='item' data='" + a[i]["LV1_DETAIL"][j].MENU_CODE + "' data-url='" + a[i]["LV1_DETAIL"][j].MENU_URL + "' onclick=''>" + a[i]["LV1_DETAIL"][j].MENU_NAME + "</a>";
                    }
                    h += "</div>";
                    h += "</div>";
                    $("#MENU_LIST").append(h);
                }
                $("#MENU_LIST").find("a").click(function () {
                    var _this = $(this);
                    AddMenu(_this.html(), _this.attr("data"), _this.attr("data-url"));
                });
            }, false, null, null, true);
            $("#MENU_ACCOUNT").find("a").click(function () {
                var ctype = $(this).attr("field");

                switch (ctype) {
                    case "Quit":
                        Ares.Ajax("Quit", {}, function (data) {
                            alert(data.Message);
                            window.location.href = "Login.aspx";
                        }, false);
                        break;
                    case "ChangePassword":

                        break;
                    default:
                }
            });
        });
        //判断窗口是否被打开
        window.CheckMenu = function (data) {
            var a = $("#menu_contain_in").find("a[data-tab='" + data + "']")
            if (a.length != 0) {
                Active(data);
                return true;
            }
            else {
                return false;
            }
        }
        //激活窗口
        window.Active = function (data) {
            $("#menu_contain_in").find("a").removeClass("active");
            $("#menu_contain_out").find("div").removeClass("active");
            $("#menu_contain_in").find("a[data-tab='" + data + "']").addClass("active");
            $("#menu_contain_out").find("div[data-tab='" + data + "']").addClass("active");
        }
        //打开窗口
        window.AddMenu = function (name, data, url) {
            if (CheckMenu(data)) {
                return;
            }
            $("#menu_contain_in").find("a").removeClass("active");
            $("#menu_contain_in").append("<a class='item active' data-tab='" + data + "'><span class='item_title'>" + name + "</span><i class='remove icon  link item_close'></i></a>");
            $("#menu_contain_out").find("div").removeClass("active");
            $("#menu_contain_out").append("<div class='ui bottom attached tab segment active' style=' height: calc(100% - 38px);'  data-tab='" + data + "'><iframe rel='11062' class='mainFrame' frameborder='0' scrolling='auto' src='" + url + "' style='width:100%;height: 100%'></iframe></div>");
            //注册关闭事件
            $("#menu_contain_in").find("a[data-tab='" + data + "']").click(function () {
                Active(data);
            }).find(".item_close").click(function () {
                var a = $(this).closest("a");
                var data_tab = $(a).attr("data-tab");
                if ($(a).hasClass("active")) {
                    var left = $(a).prev().attr("data-tab");
                    Active(left);
                }
                $("[data-tab='" + data_tab + "']").remove();
            });
        }
    </script>
</head>
<body>
    <div class="ui main container">
        <div class="ui menu">
            <div class="ui container" id="MENU_LIST">
                <a href="#" class="header item" data="first">
                    <img class="logo" src="Scripts/Images/index_logo2.png" />
                    Ares小管家
                </a>
                <a href="javascript:Active('first')" class="item" data="first">首页</a>
            </div>
            <div class="right menu" style="padding-right: 20px;" id="MENU_ACCOUNT">
                <div class='ui simple dropdown item'>
                    <i class='user icon'></i>账户操作
                    <div class='menu'>
                        <a class='item' field="Quit">安全退出</a>
                        <a class='item' field="ChangePassword">修改密码</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="margin-top: 10px;"></div>
    <div class="ui main container" style="height: 85%;" id="menu_contain_out">
        <div class="ui top attached  tabular menu" id="menu_contain_in">
            <a class="item active" data-tab="first" href="javascript:Active('first')">
                <span class="item_title">首页
                </span>
            </a>
        </div>
        <div class="ui bottom attached tab segment active" data-tab="first" style="height: calc(100% - 38px);">
            <iframe rel='11062' frameborder='0' scrolling='auto' src='HomePage.aspx' style='width: 100%; height: 100%;'></iframe>
        </div>
    </div>
</body>
</html>
