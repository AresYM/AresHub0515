<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebUI.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>登录</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="Scripts/JS/jquery.min.js"></script>
    <link href="Scripts/Packages/Semantic-UI-master/dist/semantic.min.css" rel="stylesheet" />
    <script src="Scripts/Packages/Semantic-UI-master/dist/semantic.min.js"></script>
    <script src="Scripts/JS/Global.js"></script>
    <script src="plug.js"></script>
    <style type="text/css">
        body {
            background-color: #DADADA;
        }

        .grid {
            height: 100%;
        }

        .image {
            margin-top: -100px;
        }

        .column {
            max-width: 450px;
        }
    </style>
</head>
<body>
    <div class="ui middle aligned center aligned grid">
        <div class="column">

            <h2 class="ui teal image header">
                <img src="Scripts/Images/login_logo.png" class="image">
                <div class="content">
                    登录到您的账户
                </div>
            </h2>
            <form class="ui large form">
                <div class="ui stacked segment">
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="user icon"></i>
                            <input type="text" name="user_id" placeholder="登录名">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="lock icon"></i>
                            <input type="password" name="password" placeholder="密 码">
                        </div>
                    </div>
                    <div class="ui fluid large teal submit button" field="L">登 录</div>
                </div>
            </form>
            <div class="ui error message" id="div_error" style="display: none;"></div>
            <div class="ui message">
                新用户? <a href="Register.aspx">点此注册</a>
            </div>
        </div>
    </div>
</body>
</html>
