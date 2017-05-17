<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="P2.aspx.cs" Inherits="WebUI.Admin.P2" %>

<!DOCTYPE html>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>vue简单案例</title>
    <script src="../Scripts/JS/jquery.min.js"></script>
    <script src="../Scripts/Packages/Element-UI/vue.js"></script>
    <link href="../Scripts/Packages/Element-UI/element_ui.css" rel="stylesheet" />
    <script src="../Scripts/Packages/Element-UI/element_ui.js"></script>

    <script>
        
        $(function myfunction() {
            var vm = new Vue({
                el: "#app",
                data: {
                    form: {   //添加列表时,初始化数据
                        date: '',
                        name: '',
                        address: ''
                    },
                    formLabelWidth: '50px', //添加数据弹框label标签宽度
                    dialogFormVisible: false, //控制添加数据的弹框显示关闭
                    total: 600,
                    tableData: []
                },
                methods: {  //方法
                    add: function () {
                        this.form.date = this.form.date.Format("yyyy-MM-dd");
                        this.tableData.push(this.form);
                        this.dialogFormVisible = false;
                        this.form = {   //添加列表时,初始化数据
                            date: '',
                            name: '',
                            address: ''
                        }
                    },
                    //删除
                    handleDelete(index, row) {
                        this.tableData.splice(index, 1);
                    },
                    //编辑
                    modify(index, row) {
                        var that = this;
                        this.$prompt('修改姓名', '编辑', {
                            confirmButtonText: '保存',
                            cancelButtonText: '取消',
                            inputValue: row.name
                        }).then(
                            (a) => {
                                row.name = a.value;
                            }
                         ).catch(
                            () => {
                                that.$message({
                                    type: 'info',
                                    message: '取消编辑'
                                });
                            }
                        )
                    },
                    ABC: function (a, b, c) {

                    },
                    Query: function () {
                        var that = this;
                        $.ajax({
                            type: "POST",
                            url: "../Handler/Handler.ashx?operate=SendEmail",
                            data: {},
                            success:
                                (a) => {
                                    //that.tableData = a.rows;
                                    //that.total = a.rows.length
                                }
                        });


                    },
                    handleSizeChange(val) {
                        console.log(`每页 ${val} 条`);
                    },
                    handleCurrentChange(val) {

                    }

                }
            })//.$mount('#app');   //$mount('#app')是作用域(说白了就是一个div的盒子),用来存放列表

        });



    </script>
</head>
<body>




    <!--element-ui组件模板-->
    <div id="app">
        <template>

        <el-table
                :data="tableData"
                border
                style="width: 100%" v-on:row-click="ABC">
            <el-table-column prop="ID"  label="编号"  width="180"></el-table-column>
            <el-table-column  prop="CODE"  label="代码"  width="180"></el-table-column>
            <el-table-column  prop="NAME"  label="名称"></el-table-column>
            <el-table-column  operation="操作"  label="操作">
                <template scope="scope">
                    <el-button  size="small" v-on:click="modify(scope.$index, scope.row)">编辑 </el-button>
                    <el-button  size="small"  type="danger"  v-on:click="handleDelete(scope.$index, scope.row)">删除</el-button>
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
 
        <el-button class="add_btn" v-on:click="dialogFormVisible = true">添加</el-button>
        <el-button class="query_btn" v-on:click="Query">查询</el-button>

        <el-dialog title="添加" v-model="dialogFormVisible ">
            <el-form :model="form">
                <el-form-item label="日期" :label-width="formLabelWidth">
                    <el-date-picker type="date"placeholder="选择日期" v-model="form.date"></el-date-picker>
                </el-form-item>
                <el-form-item label="姓名" :label-width="formLabelWidth">
                    <el-input v-model="form.name" auto-complete="off"></el-input>
                </el-form-item>
                <el-form-item label="地址" :label-width="formLabelWidth">
                    <el-input v-model="form.address" auto-complete="off"></el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button v-on:click="dialogFormVisible = false">取 消</el-button>
                <el-button v-on:click="add" type="danger" >确 定</el-button>
            </div>
        </el-dialog>
    </template>
    </div>



    <style>
        #app {
            width: 90%;
            margin: 30px auto;
        }

        .add_btn {
            float: right;
            margin: 10px 0;
        }

        .query_btn {
            float: right;
            margin: 10px 10px;
        }

        .el-dialog--small {
            width: 40%;
        }

        .el-dialog__body {
            padding-bottom: 0;
        }
    </style>

</body>
</html>
