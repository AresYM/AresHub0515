<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebUI.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>登录</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="Scripts/JS/jquery.min.js"></script>
    <script src="Scripts/JS/Global.js"></script>
    <script src="assets/js/supersized.3.2.7.min.js"></script>
    <script src="assets/js/supersized-init.js"></script>
    <link rel="stylesheet" href="assets/css/supersized.css" />
    <link rel="stylesheet" href="assets/css/style.css" />
    <script>
        $(function () {
            $("#hbtn_submit").click(function () {
                var user_id = $(".username").val();
                var password = $(".password").val();
                if (user_id == "" || password == "") {
                    return;
                }


                Ares.Ajax("Login", { "user_id": user_id, "password": password }, function (f) {
                    if (f.Status == "100") {
                        alert("登录失败!");
                    }
                    else {
                        alert("登录成功!");
                        window.location.href = "Main.aspx";
                    }
                }, true, null, null, false)
            });
        })

    </script>
</head>
<body>
    <div class="page-container">
        <h1>系统登录</h1>
        <form action="" method="post">
            <input type="text" name="user_id" class="username" placeholder="Username">
            <input type="password" name="password" class="password" placeholder="Password">
            <button type="button" id="hbtn_submit" field="L">登 录</button>
        </form>
        <div class="connect">
            <a style="width: 100%; font-size: 16px;" href="Register.aspx">没有账户?点此注册-></a>
        </div>
    </div>

</body>
</html>
