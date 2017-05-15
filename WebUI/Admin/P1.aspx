<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="P1.aspx.cs" Inherits="WebUI.Admin.P1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="../Scripts/JS/jquery.min.js"></script>
    <link href="../Scripts/Packages/Semantic-UI-master/dist/semantic.min.css" rel="stylesheet" />
    <script src="../Scripts/Packages/Semantic-UI-master/dist/semantic.min.js"></script>
    <script src="../Scripts/JS/Global.js"></script>
    <script>

        $(function () {
            $("#C").click(function () {
                var src = $("#B").val();
                $("#A").attr("src", "http://api.47ks.com/webcloud/?url=" + src);
            });
        });

    </script>
</head>
<body>


    <div class="ui message">
        免费看VIP视频（爱奇艺，腾讯，优酷等），仅限本站使用，不得对外传播。<br />
        使用步骤:<br />
        1.到视频网站找到想要看的VIP视频<br />
        2.打开视频,因为不是VIP,会提示VIP才能观看<br />
        3.复制视频地址,粘贴到下面的文本框内,点击【立即播放】按钮,即可免VIP观看VIP视频<br />
        什么是<span style="color: red; font-weight: bold;">视频地址</span><br />
        <img src="../Scripts/Images/说明.png" />


    </div>

    <div class="ui input">
        <input type="text" id="B" style="width: 500px;" placeholder="将地址粘贴在这"><div class="ui green button" id="C" style="margin-left: 20px;">立即播放</div>
    </div>


    <iframe id="A" width="100%" height="600px" allowtransparency="true" frameborder="0" scrolling="no" src=""></iframe>
</body>
</html>
