<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebUI.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>注册</title>
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
            height: 90%;
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
                <img src="Scripts/Images/register_logo.png" class="image">
                <div class="content">
                    注册新用户
     
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
                            <i class="user icon"></i>
                            <input type="text" name="user_name" placeholder="昵 称">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="lock icon"></i>
                            <input type="password" name="password" placeholder="密 码">
                        </div>
                    </div>

                    <div class="field">
                        <div class="ui left icon input">
                            <i class="lock icon"></i>
                            <input type="password" name="password_ck" placeholder="密码确认" />
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="barcode icon"></i>
                            <input type="text" name="auth_code" placeholder="注册邀请码" />
                        </div>
                    </div>
                    <div class="ui fluid large teal submit button" field="R">确认注册</div>
                </div>


            </form>
            <div class="ui message">
                <div class="ui input">
                    <input type="text" id="htxt_auth_code" placeholder="生成注册邀请码" />
                </div>
                <div class="ui button" id="hbtn_create_auth_code">生成</div>
            </div>
            <div class="ui error message" id="div_error" style="display: none;"></div>
            <div class="ui message">
                已有账户? <a href="Login.aspx">返回登陆</a>
            </div>
        </div>
    </div>
</body>
</html>
