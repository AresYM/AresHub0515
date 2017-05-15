<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CODE_STUFF.aspx.cs" Inherits="WebUI.BaseSet.CODE_STUFF" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>物品代码维护</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="../Scripts/JS/jquery.min.js"></script>
    <script src="../Scripts/Packages/Element-UI/vue.js"></script>
    <link href="../Scripts/Packages/Element-UI/element_ui.css" rel="stylesheet" />
    <script src="../Scripts/Packages/Element-UI/element_ui.js"></script>
    <script src="../Scripts/JS/Global.js"></script>
    <script src="../Scripts/JS/code_data.js"></script>


    <script>
        $(function () {

            var vm = new Vue({
                el: "#app",
                data: {
                    form: ___CODE_STRUCTURE.CODE_STUFF,
                    dialogFormVisible: false, //控制添加数据的弹框显示关闭
                    total: 600,
                    tableData: []
                },
                methods: {
                    //插入和更新操作
                    Save: function () {
                        var _this = this;
                        Ares.Ajax("Save_CODE_STUFF", this.form, function (res) {
                            if (res.Status == "200") {
                                _this.$message({
                                    showClose: true,
                                    message: res.Message,
                                    onClose: () => { _this.Query(); _this.dialogFormVisible = false }
                                });
                            }
                            else {
                                _this.$message({
                                    showClose: true,
                                    message: res.Message
                                });
                            }
                        }, true, null, "../Handler/Handler.ashx", true);
                    },
                    //删除操作
                    Delete: function (index, row) {
                        var _this = this;
                        Ares.Ajax("Delete_CODE_STUFF", { CODE: row.CODE }, function (res) {
                            if (res.Status == "200") {
                                _this.$message({
                                    showClose: true,
                                    message: res.Message,
                                    onClose: () => { _this.Query(); _this.dialogFormVisible = false }
                                });
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
                    },
                    Query: function () {
                        var that = this;
                        Ares.Ajax("GetCodeStuffList", {}, function (a) {
                            that.tableData = a.rows;
                            that.total = a.rows.length
                        }, true, null, "../Handler/Handler.ashx", true)
                         
                    },
                    handleSizeChange(val) {
                        console.log(`每页 ${val} 条`);
                    },
                    handleCurrentChange(val) {
                        alert(val);
                    }
                }
            })//.$mount('#app');   //$mount('#app')是作用域(说白了就是一个div的盒子),用来存放列表

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
            <el-button class="add_btn" v-on:click="dialogFormVisible = true">添加</el-button>
            <el-table :data="tableData" border style="width: 100%" >
                <el-table-column prop="ID"  label="编号"  width="180"></el-table-column>
                <el-table-column  prop="CODE"  label="代码"  width="180"></el-table-column>
                <el-table-column  prop="NAME"  label="名称"></el-table-column>
                <el-table-column  prop="ENG_NAME"  label="英文名称"></el-table-column>
                <el-table-column  prop="SHORT_NAME"  label="简称"></el-table-column>
                <el-table-column  prop="F_CLASS_CODE"  label="一级分类"></el-table-column>
                <el-table-column  prop="S_CLASS_CODE"  label="二级分类"></el-table-column>
                <el-table-column  prop="T_CLASS_CODE"  label="三级分类"></el-table-column>
                <el-table-column  prop="GG"  label="规格"></el-table-column>
                <el-table-column  prop="XH"  label="型号"></el-table-column>
                <el-table-column  prop="STATUS"  label="状态"></el-table-column>
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
          :current-page=10
          :page-sizes="[5, 20, 50, 100]"
          :page-size="5"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total">
        </el-pagination>
 
        <el-input v-model="form.CODE" label="物品代码"></el-input>

        <el-dialog title="添加" v-model="dialogFormVisible">
            <el-form :model="form" label-width="80px">   
                <el-row>
                    <el-col :span="11">
                        <el-form-item label="物品代码:"  >
                            <el-input v-model="form.CODE"  class="inputText"></el-input>
                        </el-form-item>    
                    </el-col>  
                    <el-col :span="11">
                        <el-form-item label="物品名称:" >
                            <el-input v-model="form.NAME"  class="inputText"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>

                <el-row>
                    <el-col :span="11">
                        <el-form-item label="英文名称:" >
                            <el-input v-model="form.ENG_NAME"  class="inputText"></el-input>
                        </el-form-item>       
                    </el-col>
                    <el-col :span="11">
                        <el-form-item label="简 称:"  >
                            <el-input v-model="form.SHORT_NAME"  class="inputText"></el-input>
                        </el-form-item>    
                    </el-col>                    
                </el-row>

                <el-row>
                    <el-col :span="11">
                        <el-form-item label="一级分类:">
                            <el-input v-model="form.F_CLASS_CODE"  class="inputText"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="11">
                        <el-form-item label="二级分类:">
                            <el-input v-model="form.S_CLASS_CODE"  class="inputText"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>

                <el-row>
                    <el-col :span="11">
                        <el-form-item label="三级分类:">
                            <el-input v-model="form.T_CLASS_CODE"  class="inputText"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="11">
                        <el-form-item label="规格:">
                            <el-input v-model="form.GG"  class="inputText"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="11">
                        <el-form-item label="型号:">
                            <el-input v-model="form.XH"  class="inputText"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="11">
                        <el-form-item label="显示标志:">
                            <el-checkbox v-model="form.STATUS"></el-checkbox>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="11">
                        <el-form-item label="拆包标志:">
                            <el-checkbox v-model="form.OPEN_FLAG"></el-checkbox>
                        </el-form-item>
                    </el-col>
                    <el-col :span="11">
                        <el-form-item label="大单位:">
                            <el-input v-model="form.B_UNIT_CODE"  class="inputText"></el-input>
                        </el-form-item>
                    </el-col>
                    
                </el-row>
                <el-row>
                    <el-col :span="11">
                        <el-form-item label="小单位:">
                            <el-input v-model="form.S_UNIT_CODE"  class="inputText"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="11">
                        <el-form-item label="单位转换基数:">
                            <el-input v-model="form.UNIT_SWITCH"  class="inputText"></el-input>
                        </el-form-item>
                    </el-col>
                </el-row>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button v-on:click="dialogFormVisible = false">取 消</el-button>
                <el-button v-on:click="Save" type="danger" >确 定</el-button>
            </div>
        </el-dialog>
    </template>
    </div>
</body>
</html>
