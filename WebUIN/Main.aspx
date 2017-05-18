<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="WebUI.Main" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ares库存管理系统</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="Scripts/JS/jquery.min.js"></script>
    <script src="Scripts/Packages/Element-UI/vue.js"></script>
    <link href="Scripts/Packages/Element-UI/element_ui.css" rel="stylesheet" />
    <script src="Scripts/Packages/Element-UI/element_ui.js"></script>
    <script src="Scripts/JS/WebEntity.js"></script>
    <script src="Scripts/JS/Global.js"></script>
    <style>
        body {
            margin: 0 auto;
        }

        .TopMenu {
            background-color: #FFFFFF;
            color: #FFFFFF;
        }
    </style>
    <script>
        $(function () {
            var vm = new Vue({
                el: "#app",
                data: {
                    MenuData: [],
                    CurrntTab: '',
                    TabTable: [{
                        title: "首页",
                        name: "u-005",
                        content: "<iframe class='mainFrame' frameborder='0' scrolling='auto' src='HomePage.aspx' style='width:100%;height:100%;'></iframe>"
                    }],
                    tabIndex: 2
                },
                mounted: function () {
                    this.CurrntTab = "u-005";
                },
                methods: {
                    OpenPage: function (key, keyPath) {
                        if (key.indexOf("u") != -1) {
                            return;
                        }
                        //获取到菜单的名称和路径
                        var title = "", url = "";
                        var _this = this;
                        for (let i = 0; i < _this.MenuData.length; i++) {
                            for (var j = 0; j < _this.MenuData[i]["LV1_DETAIL"].length; j++) {
                                if (_this.MenuData[i]["LV1_DETAIL"][j]["MENU_CODE"] == key) {
                                    title = _this.MenuData[i]["LV1_DETAIL"][j]["MENU_NAME"];
                                    url = _this.MenuData[i]["LV1_DETAIL"][j]["MENU_URL"];
                                }
                            }
                        }
                        var isOpen = false;
                        for (let i = 0; i < _this.TabTable.length; i++) {
                            if (_this.TabTable[i]["name"] == key) {
                                isOpen = true;
                                break;
                            }
                        }
                        //如果已经打开了  激活并返回
                        if (isOpen) {
                            this.CurrntTab = key;
                            return;
                        }
                        this.TabTable.push({
                            title: title,
                            name: key,
                            content: "<iframe class='mainFrame' frameborder='0' scrolling='auto' src='" + url + "' style='width:100%;height:100%;'></iframe>"
                        });
                        this.CurrntTab = key;

                        $(".is-active").removeClass("is-active")
                    },
                    InitMenus: function () {
                        var _this = this;
                        Ares.Ajax("GetMenus", {}, function (c) {
                            _this.MenuData = c;
                        }, true, null, null, true);
                    },
                    removeTab(targetName) {
                        let tabs = this.TabTable;
                        let activeName = this.CurrntTab;
                        if (activeName === targetName) {
                            tabs.forEach((tab, index) => {
                                if (tab.name === targetName) {
                                    let nextTab = tabs[index + 1] || tabs[index - 1];
                                    if (nextTab) {
                                        activeName = nextTab.name;
                                    }
                                }
                            });
                        }
                        this.CurrntTab = activeName;
                        this.TabTable = tabs.filter(tab => tab.name !== targetName);
                    },
                    activeTab: function (a) {
                        this.CurrntTab = a.name;
                    },
                    Quit: function () {
                        Ares.Ajax("Quit", {}, function (data) {
                            alert(data.Message);
                            window.location.href = "Login.aspx";
                        }, false);
                    },
                    ChangePassword: function () {
                        var _this = this;
                        this.$prompt('请输入新密码', '修改密码', {
                            confirmButtonText: '确定',
                            cancelButtonText: '取消'
                        }).then(a => {
                            Ares.Ajax("ChangePassword", { password: a.value }, function (data) {
                                _this.$message({
                                    type: (data.Status == '200' ? "success" : "info"),
                                    message: data.Message
                                });
                            }, false);
                        }).catch(() => {

                        });
                    },
                    Suggest: function () {

                    }
                }
            })
           
            vm.InitMenus();
            //计算浏览器高度
        });
    </script>
</head>
<body>
    <div id="app">
        <template>
            <el-row class="TopMenu">
                <el-col :span="4" >
                    &nbsp;
                </el-col>
                <el-col :span="20">
                    <el-menu class="TopMenu" mode="horizontal" v-on:select="OpenPage" >
                        <el-menu-item index="u-001">
                            <img class="logo" src="Scripts/Images/index_logo2.png" style=" vertical-align:middle;" />
                            <sapn style="font-size:20px;">Ares</span>
                        </el-menu-item>
                        <template v-for="lv1 in MenuData"  >
                            <el-submenu :index="lv1.LV1_CODE>
                                <template slot="title">{{ lv1.LV1_NAME }}</template>
                                <templete  v-for="lv2 in lv1.LV1_DETAIL">
                                    <el-menu-item :index="lv2.MENU_CODE">{{ lv2.MENU_NAME }}</el-menu-item>
                                </templete>
                            </el-submenu>
                        </template>
                        <el-submenu index="u-002" style="margin-right:100px; float:right;">
                            <template slot="title"><i class="el-icon-setting"></i>{{Ares.User().NAME}}</template>
                            <el-menu-item index="u-003" v-on:click="Quit"><i class="el-icon-delete"></i>注销登录</el-menu-item>
                            <el-menu-item index="u-004" v-on:click="ChangePassword"><i class="el-icon-edit"></i>修改密码</el-menu-item>
                            <el-menu-item index="u-005" v-on:click="Suggest"><i class="el-icon-share"></i>意见反馈</el-menu-item>
                        </el-submenu>
                    </el-menu>
                </el-col>
            </el-row>
            <el-row>
                <el-col>
                    <el-tabs v-model="CurrntTab" type="card" closable v-on:tab-remove="removeTab" v-on:tab-click="activeTab">
                        <el-tab-pane v-for="(item, index) in TabTable" :key="item.name" :label="item.title" :name="item.name" >
                        <div v-html="item.content" style="height:800px; overflow:hidden;" ></div>
                        </el-tab-pane>
                    </el-tabs>
                </el-col>
            </el-row>
        </template>
    </div>
</body>
</html>
