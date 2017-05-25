﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StuffInstore.aspx.cs" Inherits="WebUI.StuffManager.StuffInstore" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>订单入库/物品入库</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <script src="../Scripts/JS/jquery.min.js"></script>
    <script src="../Scripts/Packages/Element-UI/vue.js"></script>
    <link href="../Scripts/Packages/Element-UI/element_ui.css" rel="stylesheet" />
    <script src="../Scripts/Packages/Element-UI/element_ui.js"></script>
    <script src="../Scripts/JS/Global.js"></script>
    <script src="../Scripts/JS/WebEntity.js"></script>
    <script src="../Scripts/JS/jquery.autocompleter.js"></script>

    <script>

        window.StuffInStoreOrderDetail = {
            GetEntity: function () {
                return { "DH": "", "STUFF_CODE": "", "STUFF_NAME": "", "PH": "", "GGDH": "", "PROVIDER": "", "PRODUCE_DATE": "", "AMOUNT": "", "UNIT_PRICE": "", "SELL_PRICE": "" };
            }
        }


        $(function () {
            var vm = new Vue({
                el: "#app",
                data: {
                    form: [],
                    dialogFormVisible: false,
                    formMain: { "DH": "" },
                    formNext: StuffInStoreOrderDetail.GetEntity(),
                    StuffCodeData: [],
                    BarCode: "",
                    tableData: [],
                    CurrentTableData: [],
                    fff: ''
                },
                methods: {
                    Update: function () {

                    },
                    Delete: function () {

                    },
                    AAA: function (a) {
                        alert('');

                    },
                    ScanBarcode: function () {
                        var barcode = this.BarCode;
                        if (barcode == '' || barcode == null) {
                            this.$message({
                                message: '条码为空,请检查扫描枪是否异常',
                                type: 'warning'
                            });
                            return;
                        }

                        Ares.Ajax("GetStuff", { BarCode: barcode }, function (a) {

                        }, true, null, "", true);
                    },
                    AddStuff: function () {
                        this.formNext = StuffInStoreOrderDetail.GetEntity();
                        this.dialogFormVisible = true;
                    },
                    Save: function () {
                        this.formNext.PRODUCE_DATE = this.formNext.PRODUCE_DATE.Format("yyyy-MM-dd hh:mm")
                        this.tableData.push(this.formNext);
                        this.CurrentTableData.push(this.formNext);
                        this.dialogFormVisible = false;
                    },
                    SureSave: function () {
                        this.$notify({
                            title: '警告',
                            message: '保存到数据库',
                            type: 'success'//success/warning/info/error
                        });
                    },
                    SelectStuff: function (a) {
                        alert(a);
                    }
                },
                mounted: function () {
                    var _this = this;
                    Ares.Ajax("StuffInstoreInit", {}, function (res) {
                        _this.formMain.DH = res.Message;
                    }, true, null, "../Handler/Handler.ashx", true);

                    Ares.Ajax("CODE_LIST", { "EntityName": "ARES_CODE_STUFF" }, function (a) {
                        _this.StuffCodeData = a;
                    }, true, null, "../Handler/Handler.ashx", true);

                    
                }
            })
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
            <el-form :model="formMain" label-width="120px">   
                <el-row>
                    <el-col :span="6">
                        <el-form-item label="入库单据流水号 :"  >
                            <el-input v-model="formMain.DH" :disabled="true"  placeholder="自动生成" class="inputText"></el-input>
                        </el-form-item>    
                    </el-col>
                </el-row>
            </el-form>
            <hr />
            <el-button class="query_btn"  style="margin:0px 5px 10px 5px" v-on:click="AddStuff">新增物品</el-button>
            <el-button class="query_btn"  style="margin:0px 5px 10px 5px;" v-on:click="SureSave" >确认入库</el-button>
            <el-input v-model="BarCode" placeholder="扫码区" style=" width:300px; margin-left:100px;" v-on:keyup.enter.native="ScanBarcode"></el-input>
            <el-table :data="CurrentTableData" border style="width: 100%">
                <el-table-column  prop="DH"  label="单据号(系统生成)"  width="180"></el-table-column>
                <el-table-column  prop="STUFF_NAME"  label="物品名称"></el-table-column>
                <el-table-column  prop="PH"  label="批号"></el-table-column>
                <el-table-column  prop="AMOUNT"  label="数量"></el-table-column>
                <el-table-column  prop="UNIT_PRICE"  label="进货价"></el-table-column>
                <el-table-column  prop="SELL_PRICE"  label="零售价"></el-table-column>
                <el-table-column  prop="TOTAL_PRICE"  label="总金额"></el-table-column>
                <el-table-column  prop="GGXH"  label="规格型号"></el-table-column>
                <el-table-column  prop="PROVIDER"  label="供应商"></el-table-column>
                <el-table-column  prop="PRODUCE_DATE"  label="生产日期"></el-table-column>
                <el-table-column  prop="___OP"  operation="操作"  label="操作"  width="200">
                    <template scope="scope">
                        <el-button  size="small" v-on:click.stop="Update(scope.$index, scope.row)">编辑 </el-button>
                        <el-button  size="small"  type="danger"  v-on:click="Delete(scope.$index, scope.row)">删除</el-button>
                    </template>
                </el-table-column>
            </el-table>
            
            
            <el-dialog title="添加" top="20px" v-model="dialogFormVisible">
                <el-form :model="formNext" label-width="80px">
                    <el-row>
                        <el-col :span="8">
                            <el-form-item label="流水号:"  >
                                <el-input v-model="formNext.DH" :disabled="true"  placeholder="自动生成" class="inputText"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="物品名称:"  >
                                <el-input v-model="formNext.STUFF_CODE" name="OOO" class="inputText"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="批号:"  >
                                <el-input v-model="formNext.PH" class="inputText"></el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="8">
                            <el-form-item label="规格型号:"  >
                                <el-input v-model="formNext.GGDH"  class="inputText"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="供应商:"  >
                                <el-input v-model="formNext.PROVIDER" class="inputText"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="生产日期:"  >
                                <el-date-picker v-model="formNext.PRODUCE_DATE" type="datetime" placeholder="选择日期时间"></el-date-picker>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row>
                        <el-col :span="8">
                            <el-form-item label="数量:"  >
                                <el-input v-model="formNext.AMOUNT"  class="inputText"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="进货价:"  >
                                <el-input v-model="formNext.UNIT_PRICE"  class="inputText"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="8">
                            <el-form-item label="零售价:"  >
                                <el-input v-model="formNext.SELL_PRICE"  class="inputText"></el-input>
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
