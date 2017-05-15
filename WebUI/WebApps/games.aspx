<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="games.aspx.cs" Inherits="WebUI.WebApps.games" %>

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
    <script src="game.js"></script>
</head>
<body>

    <div id="div_new">
        <div class="ui message head">
            <p>你好，我目前是一个小白机器人，等待您来认领，希望我们以后会成为最好最好的朋友！</p>
        </div>
        <form class="ui large form">
            <div class="ui stacked segment">
                <div class="field">
                    <div class="ui left icon input">
                        <i class="user icon"></i>
                        <input type="text" name="name" placeholder="给我起个名字吧">
                    </div>
                </div>
                <div class="field">
                    <div class="ui left icon input">
                        <i class="lock icon"></i>
                        <select class="ui dropdown">
                            <option value="">你希望我是男生还是女生呢</option>
                            <option value="1">帅哥</option>
                            <option value="0">美女</option>
                        </select>
                    </div>
                </div>
                <div class="field">
                     
                        <input type="file" name="name" placeholder="给我起个名字吧">
                     
                </div>
                <div class="ui fluid large teal submit button" field="L">登 录</div>
            </div>
        </form>
    </div>
    <div id="div_continue">
    </div>

</body>
</html>
