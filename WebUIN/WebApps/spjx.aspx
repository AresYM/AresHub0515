<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="spjx.aspx.cs" Inherits="WebUI.WebApps.spjx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>首页</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="../Scripts/JS/jquery.min.js"></script>
    <link href="../Scripts/Packages/Semantic-UI-master/dist/semantic.min.css" rel="stylesheet" />
    <script src="../Scripts/Packages/Semantic-UI-master/dist/semantic.min.js"></script>
    <script src="../Scripts/JS/md5.js"></script>
    <script src="../plug.js"></script>
    <script src="../Scripts/JS/Global.js"></script>
    <script>
        $(function () {


            $("#hbtn_jump").click(function () {
                Jump();
            });
        });

        window.Jump = function () {
            $("#I").attr("src", "http://api.47ks.com/webcloud/?url=" + $("#htxt_url").val());
            $("#P_URL").html("http://api.47ks.com/webcloud/?url=" + $("#htxt_url").val());
        }
    </script>
</head>
<body>

    <div class="ui message">
        <p>使用说明：</p>
        <p>在视频网站，比如《优酷》，《爱奇艺》找到要看的VIP才能看的视频，打开视频后，复制浏览器地址栏的连接，粘贴到下面的文本框内，点击观看即可</p>
        <p>复制下面的连接发送给好友:</p>
        <p id="P_URL">http://api.47ks.com/webcloud/?url=http://v.youku.com/v_show/id_XMjY1NDkzNzEzMg==.html?spm=a2h03.8164468.2967961.14</p>
    </div>
    <div class="ui message">
        专享VIP视频解析
        <div class="ui input">
            <input type="text" style="width: 100%;" id="htxt_url" placeholder="输入视频URL" />
        </div>
        <div class="ui button" id="hbtn_jump">观看</div>
    </div>

    <iframe id="I" width="100%" height="600px" allowtransparency="true" frameborder="0" scrolling="no" src="1http://api.47ks.com/webcloud/?url=http://v.youku.com/v_show/id_XMjY1NDkzNzEzMg==.html?spm=a2h03.8164468.2967961.14"></iframe>

     
</body>
</html>
