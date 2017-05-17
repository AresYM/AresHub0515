<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserManager.aspx.cs" Inherits="WebUI.Admin.UserManager" %>

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
        window.TabUserList = new Ares.Table("window.TabUserList");
        $(function () {
            TabUserList.Init("tab_user_list");
            TabUserList.Setting.PageSize = 5;
            TabUserList.OnRowBound(function (tr, rdata) {
                $(tr).find("i[name='btnUpdate']").click(function () {
                    alert(rdata.NAME);
                });
            });

            $("#hbtn_search").click(function () {
                GetUsers();
            });
        });

        window.GetUsers = function () {
             
            Ares.Ajax("ParallelTest", {  }, function (data) {
                
            }, true, null, "../Handler/Handler.ashx", true)
        }
    </script>


</head>
<body>
    <div id="div_top">
        <div class="ui action input">
            <input type="text" placeholder="用户名、昵称" id="htxt_queryVal" />
            <div class="ui button" id="hbtn_search">搜索</div>
        </div>
    </div>
    <div class="ui divider" id="DIV_E"></div>
    <div id="tab_user_list">
        <table class="ui celled table" >
            <thead>
                <tr>
                    <th>用户编号</th>
                    <th>用户名</th>
                    <th>昵称</th>
                    <th>性别</th>
                    <th>手机号</th>
                    <th>单位名称</th>
                    <th>部门名称</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <tr style="display: none;" field="TMP">
                    <td>{ID}</td>
                    <td>{UID}</td>
                    <td>{NAME}</td>
                    <td>{SEX}</td>
                    <td>{PHONE}</td>
                    <td>{COMPANY_NAME}</td>
                    <td>{DEPARTMENT_NAME}</td>
                    <td><a href='javascript:void(0);' data-content='修改' ></a><i class='edit green icon' name='btnUpdate' data-content='修改'></i>
                        <a href='javascript:void(0);' data-content='删除'></a><i class='trash red icon' name='btnDelete' data-content='删除'></i>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
</html>
