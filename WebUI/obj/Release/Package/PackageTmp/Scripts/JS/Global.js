$(function () {
    if (is_weixn()) {
        var inp = $("input"),
            win = $(window),
            bod = $("body"),
            winH = win.height();
        inp.each(function () {
            var t = $(this),
                tTop = t.offset().top,
                tType = t.prop('type');
            if (is_text(tType)) {
                t.on('click', function (event) {
                    bod.height(winH + 300);
                    bod.animate({ scrollTop: tTop - 100 + 'px' }, 200);
                });
            };
        });
    };
});


function is_weixn() {
    var ua = navigator.userAgent.toLowerCase();
    if (ua.match(/MicroMessenger/i) == "micromessenger") {
        return true;
    } else {
        return false;
    }
}


// 判断是否为文本框
function is_text(type) {
    if (type == "text" || type == "number" || type == "password" || type == "tel" || type == "url" || type == "email") {
        return true;
    };
}

(function () {
    var _ares = {};
    _ares.User = function () {
        var _data = {};
        _ares.Ajax("GetUserInfo", { "authSession": "Y" }, function (data) {
            _data = data;
        }, false)
        return _data;
    }
    /*301 Sesson失效
      100 失败提示文字信息
      101 失败提示对象信息
      200 成功提示文字信息
      201 成功提示对象信息
    */

    _ares.Ajax = function (operate, data, fun_success, udf_async, udf_fun_error, udf_url, udf_authSession) {
        var url = "Handler/Handler.ashx?operate=" + operate;
        if (udf_url != null && udf_url != undefined) {
            url = udf_url + "?operate=" + operate;
        }
        if (udf_authSession === false) {
            udf_authSession = "N";
        }
        else {
            udf_authSession = "Y";
        }
        data.authSession = udf_authSession;
        $.ajax({
            url: url,
            type: "POST",
            dataType: 'text',//'application/json' 'text'
            data: data,
            async: udf_async,
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            success: function (data) {
                try {
                    data = JSON.parse(data);
                    if (data.Status == "301") {
                        $("body").html("");
                        setTimeout(function () {
                            alert("登录信息失效,请重新登录");
                            if (udf_url != null && udf_url != undefined) {
                                window.parent.location.href = "../Login.aspx";
                            }
                            else {
                                window.location.href = "Login.aspx";
                            }

                        }, 500);
                    }
                    else if (data.Status == "100" || data.Status == "200") {
                        fun_success(data);
                    }
                    else if (data.Status == "101" || data.Status == "201") {
                        fun_success(JSON.parse(data.Message));
                    }
                }
                catch (e) {

                }
            }
        });
    }
    _ares.UrlParser = {
        //将地址栏传递的参数转换成JSON对象
        JSON: function (url) {
            var arr = url.split("&");
            var obj = "{"
            for (var i = 0; i < arr.length; i++) {
                var a = arr[i].split("=");
                obj += "\"" + a[0] + "\":\"" + a[1] + "\",";
            }
            obj = obj.substring(0, obj.length - 1);
            obj += "}";
            return JSON.parse(obj);
        },
        //获取地址栏中的传递参数
        PARAM: function (name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = window.location.search.substr(1).match(reg);  //匹配目标参数
            if (r != null) return unescape(r[2]); return null; //返回参数值
        }
    }
    _ares.stringFormat = function (source, params) {
        if (arguments.length == 1)
            return function () {
                var args = $.makeArray(arguments);
                args.unshift(source);
                return $.stringFormat.apply(this, args);
            };
        if (arguments.length > 2 && params.constructor != Array) {
            params = $.makeArray(arguments).slice(1);
        }
        if (params == null) {
            console.log(source);
        }

        if (params.constructor != Array) {
            params = [params];
        }
        if (!source || source == "")
            return "";

        var num_match = source.match(/\{\s*\d\s*\}/g);
        if (num_match && num_match.length > 0) {
            $.each(params, function (i, n) {
                if (typeof (n) != "undenfined") {
                    source = source.replace(new RegExp("\\{" + i + "\\}", "g"), n);
                }
            });
            return source;
        }
        else {
            var tranfs = [];
            $(params).each(function (index) {
                if (typeof (this) != "object") {
                    return true;
                }

                var ret = source.match(/\{\s*\w+\s*:\s*\w*\s*\}|\{\s*\w+\s*\}/g);
                if (!ret)
                    return true;

                var _whole = source;;
                for (var i = 0; i < ret.length; i++) {
                    var _tpl = ret[i];
                    var _split_array = _tpl.replace("{", "").replace("}", "").split(":")
                    if (_split_array.length <= 2) {
                        var target = $.trim(_split_array[0]);
                        var format = "";
                        if (_split_array.length >= 2) {
                            format = $.trim(_split_array[1]);
                        }
                        var _val = this[target];
                        if (typeof (_val) != "undefined") {
                            _whole = _whole.replace(_tpl, _val);
                        }
                    }
                }
                tranfs.push(_whole);
            })
            if (tranfs.length == 0) {
                return source;
            }
            else if (tranfs.length == 1)
                return tranfs[0];
            return tranfs;
        }
    };

    _ares.stringFormatWithKeys = function (source, params) {
        if (arguments.length == 1)
            return function () {
                var args = $.makeArray(arguments);
                args.unshift(source);
                return $.stringFormat.apply(this, args);
            };
        if (arguments.length > 2 && params.constructor != Array) {
            params = $.makeArray(arguments).slice(1);
        }

        if (!params) {
            console.log(source);
        }

        if (params.constructor != Array) {
            params = [params];
        }
        if (!source || source == "")
            return "";

        var num_match = source.match(/\{\s*\d\s*\}/g);
        if (num_match && num_match.length > 0) {
            $.each(params, function (i, n) {
                if (typeof (n) != "undenfined") {
                    source = source.replace(new RegExp("\\{" + i + "\\}", "g"), n);
                }
            });
            return source;
        }
        else {
            var tranfs = [];
            $(params).each(function (index) {
                if (typeof (this) != "object") {
                    return true;
                }

                var ret = source.match(/\{\s*\w+\s*:\s*\w*\s*\}|\{\s*\w+\s*\}/g);
                if (!ret)
                    return true;

                var _whole = source;;
                for (var i = 0; i < ret.length; i++) {
                    var _tpl = ret[i];
                    var _split_array = _tpl.replace("{", "").replace("}", "").split(":")
                    if (_split_array.length <= 2) {
                        var target = $.trim(_split_array[0]);
                        var format = "";
                        if (_split_array.length >= 2) {
                            format = $.trim(_split_array[1]);
                        }
                        var _val = this[target];
                        if (typeof (_val) != "undefined") {
                            _whole = _whole.replace(_tpl, _val);
                        }
                        else {
                            _whole = _whole.replace(_tpl, "");
                        }
                    }
                }
                tranfs.push(_whole);
            })
            if (tranfs.length == 0) {
                return source;
            }
            else if (tranfs.length == 1)
                return tranfs[0];
            return tranfs;
        }
    };
    _ares.Page = {

    }

    _ares.Table = {
        TableID: "",
        PageSize: 10,
        TotalRows: 0,
        Init: function (tableID, dataSource) {

        },
        Bind: function (data) {

        }
    };

    _ares.Table = function (tableName) {
        var _this = this;
        _this.TableName = tableName;
        _this.divID = "";
        _this.DataSource = [];
        _this.Setting = {
            PageSize: 10,
            CurrentPage: 1,
            TotalPage: 0,
            TotalRows: 0
        }
        _this.Event = null;
        _this.Init = function (divID) {
            _this.divID = divID;
            var tab = $("#" + divID).find("table");
            //初始化分页控件
            var div = document.createElement("div");
            $(div).attr("class", "ui right floated pagination menu");
            var iHtml = "<a class='icon item'>第&nbsp;<span data-field='pagination_current'>1</span>&nbsp;页 &nbsp;共&nbsp;<span  data-field='pagination_total'>1</span>&nbsp;页 &nbsp;共&nbsp;<span  data-field='pagination_totalrows'>0</span>&nbsp;条数据</a>" +
                        "<a class='icon item first'>首 页</a>" +
                        "<a class='icon item previous'>上一页</a>" +
                        "<a class='icon item next'>下一页</a>" +
                        "<a class='icon item last'>尾 页</a>" +
                        "<div class='ui action input'>" +
                            "<input type='text' style='width:100px;' data-field='htxt_pageNum' placeholder='跳转页码' />" +
                            "<div class='ui button' data-field='hbtn_jump'>跳转</div>" +
                        "</div>";
            $(div).html(iHtml);
            $("#" + divID).append(div);
            $(div).find(".previous").click(function () {
                _this.Previous();
            });
            $(div).find(".next").click(function () {
                _this.Next();
            });
            $(div).find(".first").click(function () {
                _this.First();
            });
            $(div).find(".last").click(function () {
                _this.Last();
            });
            $(div).find("div[data-field='hbtn_jump']").click(function () {
                var jumpPage = $(div).find("input[data-field='htxt_pageNum']").val();
                if (jumpPage <= 0 || jumpPage > _this.Setting.TotalPage || isNaN(jumpPage)) {
                    alert("超出查询范围");
                }
                else {
                    _this.Setting.CurrentPage = jumpPage;
                    _this._Bind();
                }
            });
        }
        _this.Event = null;
        _this.OnRowBound = function (fun) {
            _this.Event = fun;
        }
        _this._Bind = function () {
            var data = _this.DataSource;
            var cur = _this.Setting.CurrentPage - 1;
            var size = _this.Setting.PageSize;
            var _data = [];
            for (var i = cur * size; i < cur * size + size; i++) {
                _data.push(data[i]);
            }
            var a = $("#" + _this.divID).find("table");
            var b = a.find("tbody");
            var c = b.find("tr[field='TMP']").html();
            b.html("");
            b.append("<tr style='display:none;' field='TMP'>" + c + "</tr>");
            for (var i = 0; i < _data.length; i++) {
                var d = _data[i];
                var e = _ares.stringFormatWithKeys(c, d);
                var tr = document.createElement("tr");
                $(tr).attr("data", JSON.stringify(d));
                $(tr).html(e);
                b.append($(tr));
                _this.Event($(tr), d);
            }
            //更新页码信息
            var css = { "color": "blue" };
            $("#" + _this.divID).find("span[data-field='pagination_current']").css(css).html(_this.Setting.CurrentPage);
            $("#" + _this.divID).find("span[data-field='pagination_total']").css(css).html(_this.Setting.TotalPage);
            $("#" + _this.divID).find("span[data-field='pagination_totalrows']").css(css).html(_this.Setting.TotalRows);

        },
        _this.Bind = function (data) {
            //给data加唯一ID
            for (var i = 0; i < data.length; i++) {
                data[i].RN = i;
            }
            _this.Setting.CurrentPage = 1;
            _this.Setting.TotalRows = data.length;
            _this.DataSource = data;
            _this.Setting.TotalPage = data.length % _this.Setting.PageSize == 0 ? data.length / _this.Setting.PageSize : Math.ceil(data.length / _this.Setting.PageSize);
            _this._Bind();
        },
        _this.Next = function () {
            _this.Setting.CurrentPage = this.Setting.CurrentPage + 1;
            if (_this.Setting.CurrentPage > _this.Setting.TotalPage) {
                _this.Setting.CurrentPage = _this.Setting.TotalPage
            }
            _this._Bind();
        }
        _this.Previous = function () {
            _this.Setting.CurrentPage = this.Setting.CurrentPage - 1;
            if (_this.Setting.CurrentPage == 0) {
                _this.Setting.CurrentPage = 1;
            }
            _this._Bind();
        }
        _this.First = function () {
            _this.Setting.CurrentPage = 1;
            _this._Bind();

        }
        _this.Last = function () {
            _this.Setting.CurrentPage = _this.Setting.TotalPage;
            _this._Bind();
        }
    }

    window.Ares = _ares;

})(window)