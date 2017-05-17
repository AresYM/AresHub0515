<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="WebUI.Main" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="Scripts/JS/jquery.min.js"></script>
    <script src="Scripts/Packages/Element-UI/vue.js"></script>
    <link href="Scripts/Packages/Element-UI/element_ui.css" rel="stylesheet" />
    <script src="Scripts/Packages/Element-UI/element_ui.js"></script>
    <script src="Scripts/JS/WebEntity.js"></script>
    <script src="Scripts/JS/Global.js"></script>
    <script>
        $(function () {
            var vm = new Vue({
                el: "#app",
                data: {
                    MenuData: [],
                    CurrntTab: '',
                    TabTable: [],
                    tabIndex: 2
                },
                methods: {
                    OpenPage: function (key, keyPath) {
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
                            content: "<iframe class='mainFrame' frameborder='0' scrolling='auto' src='" + url + "' style='width:100%;'></iframe>"
                        });
                        this.CurrntTab = key;
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
            <el-menu theme="dark" mode="horizontal" v-on:select="OpenPage" >
                <template v-for="lv1 in MenuData" >
                    <el-submenu :index="lv1.LV1_CODE">
                        <template slot="title">{{ lv1.LV1_NAME }}</template>
                        <templete  v-for="lv2 in lv1.LV1_DETAIL">
                            <el-menu-item :index="lv2.MENU_CODE">{{ lv2.MENU_NAME }}</el-menu-item>
                        </templete>
                    </el-submenu>
                </template>
            </el-menu>

            <el-tabs v-model="CurrntTab" type="card" closable v-on:tab-remove="removeTab">
              <el-tab-pane v-for="(item, index) in TabTable" :key="item.name" :label="item.title" :name="item.name" >
                <div v-html="item.content" ></div>
              </el-tab-pane>
            </el-tabs>
        </template>
    </div>
</body>
</html>
