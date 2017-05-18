<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CODE_CLASS.aspx.cs" Inherits="WebUI.BaseSet.CODE_CLASS" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>物品类别维护</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="../Scripts/JS/jquery.min.js"></script>
    <script src="../Scripts/Packages/Element-UI/vue.js"></script>
    <link href="../Scripts/Packages/Element-UI/element_ui.css" rel="stylesheet" />
    <script src="../Scripts/Packages/Element-UI/element_ui.js"></script>
    <script src="../Scripts/JS/Global.js"></script>
    <script src="../Scripts/JS/WebEntity.js"></script>


    <script>
        $(function () {
            var vm = new Vue({
                el: "#app",
                data: {
                    form: EntityStructure.ARES_CODE_CLASS,
                    dialogFormVisible: false, //控制添加数据的弹框显示关闭
                    total: 600,
                    tableData: [],
                    CurrentTableData: [],
                    PageSize: 5,
                    CurrentPage: 1,
                    ClassData: EntityData.ARES_CODE_CLASS
                },
                methods: {
                    Add:function () {
                        this.dialogFormVisible = true
                        this.form = EntityStructure.ARES_CODE_CLASS;
                    },
                    //插入和更新操作
                    Save: function () {
                        var _this = this;
                        Ares.Ajax("CODE_OPERTAE", { "data": JSON.stringify(this.form), "EntityName": "ARES_CODE_CLASS" }, function (res) {
                            _this.form = EntityStructure.ARES_CODE_CLASS;
                            if (res.Status == "200") {
                                _this.$message({
                                    showClose: true,
                                    message: res.Message,
                                    onClose: () => { }
                                });
                                _this.dialogFormVisible = false
                                _this.Query();
                            }
                            else {
                                _this.$message({
                                    showClose: true,
                                    message: res.Message
                                });
                            }
                        }, true, null, "../Handler/Handler.ashx", false);
                    },
                    //删除操作
                    Delete: function (index, row) {
                        var _this = this;

                        var isSure = confirm("确定删除?");
                        if (!isSure) {
                            return;
                        }
                        Ares.Ajax("CODE_DELETE", { CODE: row.CODE, "EntityName": "ARES_CODE_CLASS" }, function (res) {
                            if (res.Status == "200") {
                                _this.$message({
                                    showClose: true,
                                    message: res.Message,
                                    onClose: () => { }
                                });
                                _this.Query();
                                _this.dialogFormVisible = false
                            }
                            else {
                                _this.$message({
                                    showClose: true,
                                    message: res.Message
                                });
                            }

                        }, true, null, "../Handler/Handler.ashx", true);
                    },
                    //更新操作
                    Update: function (index, row) {
                        var _this = this;
                        _this.form = row;
                        _this.dialogFormVisible = true;
                        return;
                    },
                    Query: function () {
                        var _this = this;
                        Ares.Ajax("CODE_LIST", { "EntityName": "ARES_CODE_CLASS" }, function (a) {
                            //获取第一页内容
                            _this.tableData = a;
                          
                            _this.CurrentTableData = Ares.CurrentData(_this.PageSize, _this.CurrentPage, _this.tableData);
                            _this.total = a.length
                        }, true, null, "../Handler/Handler.ashx", true)

                    },
                    handleSizeChange(val) {
                        this.PageSize = val;
                        this.CurrentPage = 1;
                        this.CurrentTableData = Ares.CurrentData(this.PageSize, this.CurrentPage, this.tableData);
                    },
                    handleCurrentChange(val) {
                        this.CurrentPage = val;
                        this.CurrentTableData = Ares.CurrentData(this.PageSize, val, this.tableData);
                    },
                    ResetSelect: function () {
                        ///this.form.S_CLASS_CODE = "";
                    }
                }
            })
            vm.Query();
        });


    </script>
    <style>
        .inputText {
            width: 180px;
        }
    </style>
</head>
<body>

    <div id="app">
        <template>
            <el-button class="query_btn"  style="margin:0px 5px 10px 5px" v-on:click="Query">查询</el-button>
            <el-button class="add_btn" v-on:click="Add">添加</el-button>
            <el-table :data="CurrentTableData" border style="width: 100%" >
                <el-table-column  prop="CODE"  label="分类代码"  width="180"></el-table-column>
                <el-table-column  prop="NAME"  label="分类名称"></el-table-column>
                <el-table-column  prop="CLASS_LV"  label="分类等级"></el-table-column>
                <el-table-column  prop="FATHER_NAME"  label="父级名称"></el-table-column>
                <el-table-column  operation="操作"  label="操作" width="200">
                    <template scope="scope">
                        <el-button  size="small" v-on:click.stop="Update(scope.$index, scope.row)">编辑 </el-button>
                        <el-button  size="small"  type="danger"  v-on:click="Delete(scope.$index, scope.row)">删除</el-button>
                    </template>
                </el-table-column>
            </el-table>
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="CurrentPage"
          :page-sizes="[5, 20]"
          :page-size="PageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total">
        </el-pagination>
        <el-dialog title="添加" top="20px" v-model="dialogFormVisible">
            <el-form :model="form" label-width="80px">   
                <el-row>
                    <el-col :span="11">
                        <el-form-item label="分类代码:"  >
                            <el-input v-model="form.CODE" :disabled="true"  class="inputText"></el-input>
                        </el-form-item>    
                    </el-col>  
                    <el-col :span="11">
                        <el-form-item label="分类名称:" >
                            <el-input v-model="form.NAME"  class="inputText"></el-input>

                            
                        </el-form-item>
                    </el-col>
                </el-row>

                <el-row>
                    <el-col :span="11">
                        <el-form-item label="分类等级:" >
                            <el-select v-model="form.CLASS_LV" clearable placeholder="请选择">
                                <el-option key="1" label="1" value="1"> </el-option>
                                <el-option key="2" label="2" value="2"> </el-option>
                            </el-select>
                            
                        </el-form-item>       
                    </el-col>
                    <el-col :span="11">
                        <el-form-item label="父级代码:"  >
                            <el-select v-model="form.FATHER_CODE" clearable placeholder="请选择">
                                <el-option v-for="item in ClassData" v-if="item.CLASS_LV==1" :key="item.CODE" :label="item.NAME" :value="item.CODE"> </el-option>
                            </el-select>

                        </el-form-item>
                    </el-col>                    
                </el-row>
                 
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button v-on:click="Save" type="danger" >确 定</el-button>
                <el-button v-on:click="dialogFormVisible = false">取 消</el-button>
            </div>
        </el-dialog>
    </template>
    </div>
</body>
</html>
