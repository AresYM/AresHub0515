using System;
using System.Collections;
using System.Web;
using System.Web.SessionState;
using WebDLL;
using Newtonsoft.Json;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace WebUI.Handler
{
    /// <summary>
    /// Summary description for Handler
    /// </summary>
    public class Handler : IHttpHandler, IRequiresSessionState
    {
        private HttpContext g_Context = null;
        private string SessionUID = "";
        public void ProcessRequest(HttpContext context)
        {
            g_Context = context;
            g_Context.Response.ContentType = "application/json";
            string operate = g_Context.Request["operate"];
            string authSession = g_Context.Request["authSession"];



            if (authSession == "Y" && !string.IsNullOrEmpty(operate))
            {
                //判断Session情况
                if (g_Context.Session["LoginStatus"] == null)
                {
                    Send(new SendError("301", "<script type='text/javascript'>alert('登陆失效请重新登陆');';</script>", "body"));
                    return;
                }
                else
                {
                    SessionUID = g_Context.Session["LoginStatus"].ToString();
                }
            }
            switch (operate)
            {
                case "Login":
                    Login();
                    break;
                case "Register":
                    Register();
                    break;
                case "CreateAuthCode":
                    CreateAuthCode();
                    break;
                case "GetUserInfo":
                    GetUserInfo();
                    break;
                case "GetFriend":
                    GetFriend();
                    break;
                case "GetMenus":
                    GetMenus();
                    break;
                case "Quit":
                    Quit();
                    break;
                case "GetUsers":
                    GetUsers();
                    break;
                case "GetCodeStuffList":
                    GetCodeStuffList();
                    break;
                case "Save_CODE_STUFF":
                    Save_CODE_STUFF();
                    break;
                case "Delete_CODE_STUFF":
                    Delete_CODE_STUFF();
                    break;
                case "SendEmail":
                    SendEmail();
                    break;
                default:
                    break;
            }
            g_Context.Response.End();
        }

        private void Delete_CODE_STUFF()
        {
            string CODE = g_Context.Request["CODE"];
            Hashtable hs = new Hashtable();
            hs.Add("delete from ARES_CODE_STUFF where CODE=@CODE", new SqlParameter[] {
                        new SqlParameter("@CODE",CODE)
                    });
            try
            {
                DbHelperSQL.ExecuteSqlTran(hs);
                SendError sendError = new SendError("200", "删除成功", "auth_code");
                Send(sendError);
                return;
            }
            catch (Exception e)
            {
                SendError sendError = new SendError("100", e.ToString(), "auth_code");
                Send(sendError);
                return;
            }
        }

        private void Save_CODE_STUFF()
        {
            string CODE = g_Context.Request["CODE"];
             
            Hashtable hs = new Hashtable();
            hs.Add("insert into ARES_CODE_STUFF (CODE,NAME) values(@CODE,@NAME)", new SqlParameter[] {
                        new SqlParameter("@CODE",CODE),
                        new SqlParameter("@NAME","你好")
                    });
            try
            {
                DbHelperSQL.ExecuteSqlTran(hs);
                SendError sendError = new SendError("200", "数据操作成功", "auth_code");
                Send(sendError);
                return;
            }
            catch (Exception e)
            {
                SendError sendError = new SendError("100", e.ToString(), "auth_code");
                Send(sendError);
                return;
            }
        }

        private void SendEmail()
        {
            EmailHelper.Instance.SendMail("你好", "这不是一个垃圾邮件");
           
        }

        private void GetCodeStuffList()
        {
            string sql = string.Format(@"Select * from ARES_CODE_STUFF");
            DataTable dt = DbHelperSQL.QueryTable(sql);
            if (dt != null && dt.Rows.Count > 0)
            {
                DataGridSend(dt);
            }
        }

        private void GetUsers()
        {
            string queryVal = g_Context.Request["queryVal"];
            string sql = string.Format(@"Select A.ID,A.UID,A.PWD,A.NAME,A.AdminLv,A.COMPANY_CODE,B.COMPANY_NAME,A.DEPARTMENT_CODE,C.DEPARTMENT_NAME
            from (ARES_USER A 
            LEFT JOIN ARES_CODE_COMPANY B ON A.COMPANY_CODE=B.COMPANY_CODE)
            LEFT JOIN ARES_CODE_DEPARTMENT C ON A.DEPARTMENT_CODE=C.DEPARTMENT_CODE ");

            if (!String.IsNullOrEmpty(queryVal))
            {
                sql += string.Format(" where A.UID like '*{0}*' ");
            }
            DataTable dt = DbHelperSQL.QueryTable(sql);
            if (dt != null && dt.Rows.Count > 0)
            {
                Send(new SendError("201", JsonConvert.SerializeObject(dt), ""));
            }
            else
            {
                Send(new SendError("100", "没有查询到信息", ""));
            }

        }

        private void Quit()
        {
            g_Context.Session["LoginStatus"] = null;
            Send(new SendError("200", "退出成功", ""));
        }

        private void GetMenus()
        {
            DataTable dtMenus = WebUserBase.GetMenus(SessionUID);
            DataRow[] Lv1 = dtMenus.Select("MENU_LEVEL='1'");
            DataRow[] Lv2 = dtMenus.Select("MENU_LEVEL='2'");
            try
            {
                StringBuilder sb1 = new StringBuilder();
                sb1.Append("[");
                foreach (DataRow r_lv1 in Lv1)
                {
                    StringBuilder sb2 = new StringBuilder();
                    sb1.Append("{\"LV1_NAME\":\"" + r_lv1["MENU_NAME"] + "\",\"LV1_DETAIL\":[");
                    foreach (DataRow r_lv2 in Lv2)
                    {
                        if (r_lv1["MENU_ID"].ToString() == r_lv2["MENU_FATHER"].ToString())
                        {
                            sb2.Append("{\"MENU_CODE\":\"" + r_lv2["MENU_ID"].ToString() + "\",\"MENU_NAME\":\"" + r_lv2["MENU_NAME"].ToString() + "\",\"MENU_URL\":\"" + r_lv2["MENU_URL"].ToString() + "\"},");
                        }
                    }
                    if (sb2.ToString() != "")
                    {
                        sb1.Append(sb2.ToString().TrimEnd(','));
                    }
                    sb1.Append("]},");
                }

                string s = sb1.ToString().TrimEnd(',') + "]";

                Send(new SendError("201", s, ""));
            }
            catch (Exception e)
            {
                Send(new SendError("100", e.ToString(), ""));
            }
        }

        private void GetFriend()
        {

            Friend f = WebUserBase.GetFriend(SessionUID);
            if (f.ID == null)
            {
                SendError sendError = new SendError("100", "不存在小伙伴信息", "user_id");
                Send(sendError);
            }
            else
            {
                SendError sendError = new SendError("201", JsonConvert.SerializeObject(f), "user_id");
                Send(sendError);
            }
        }

        private void GetUserInfo()
        {

            User u = WebUserBase.GetUser(SessionUID);
            if (u.ID == null)
            {
                SendError sendError = new SendError("100", "不存在小伙伴信息", "user_id");
                Send(sendError);
            }
            else
            {
                SendError sendError = new SendError("201", JsonConvert.SerializeObject(u), "user_id");
                Send(sendError);
            }
        }

        private void CreateAuthCode()
        {
            string AuthText = g_Context.Request["AuthText"];
            string md5 = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(AuthText, "MD5");
            //数据插入 
            //验证账户登录名的有效性
            string sql = string.Format(@"SELECT * FROM ARES_AUTHCODE WHERE AUTH_CODE=@AUTH_CODE");
            DataTable dt = DbHelperSQL.QueryTable(sql, new SqlParameter[] {
                    new SqlParameter("@AUTH_CODE",md5)
            });
            if (dt.Rows.Count > 0)
            {
                Send("已存在该邀请码");
            }
            else
            {
                //注册信息
                Hashtable hs = new Hashtable();
                hs.Add("insert into ARES_AUTHCODE (AUTH_CODE,STATUS) values(@AUTH_CODE,'0')", new SqlParameter[] {
                        new SqlParameter("@AUTH_CODE",md5)
                    });
                try
                {
                    DbHelperSQL.ExecuteSqlTran(hs);
                    Send(md5);
                }
                catch (Exception e)
                {
                    e.ToString();
                }
            }
        }

        private void Login()
        {
            string UID = g_Context.Request["user_id"];
            string PWD = g_Context.Request["password"];
            string PWD_MD5 = System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(PWD, "MD5");
            User user = WebUserBase.GetUser(UID);
            bool isSuccess = false;
            if (user.PWD == PWD_MD5)
            {
                isSuccess = true;
            }
            if (isSuccess)
            {
                //记录Session
                g_Context.Session["LoginStatus"] = UID;
                SendError sendError = new SendError("200", "登陆成功", "user_id");
                Send(sendError);
            }
            else
            {
                SendError sendError = new SendError("100", "登陆失败，账号密码有误，请重试！", "user_id");
                Send(sendError);
            }
        }

        private void Register()
        {
            string UID = g_Context.Request["user_id"];
            string NAME = g_Context.Request["user_name"];
            if (string.IsNullOrEmpty(NAME))
            {
                NAME = UID;
            }
            string PWD = g_Context.Request["password"];
            string PWD_CK = g_Context.Request["password_ck"];
            string AUTH_CODE = g_Context.Request["auth_code"];
            if (UID == "")
            {
                SendError sendError = new SendError("100", "登陆名不能为空", "user_id");
                Send(sendError);
                return;
            }
            System.Text.RegularExpressions.Regex reg1 = new System.Text.RegularExpressions.Regex(@"^[A-Za-z0-9]+$");
            if (!reg1.IsMatch(UID))
            {
                SendError sendError = new SendError("100", "登陆名只能是英文字母或者数字", "user_id");
                Send(sendError);
                return;
            }
            if (PWD == "")
            {
                SendError sendError = new SendError("100", "密码不能为空", "password");
                Send(sendError);
                return;
            }
            if (PWD_CK == "")
            {
                SendError sendError = new SendError("100", "密码确认不能为空", "password_ck");
                Send(sendError);
                return;
            }
            if (PWD != PWD_CK)
            {
                SendError sendError = new SendError("100", "两次输入密码不一致", "password");
                Send(sendError);
                return;
            }
            if (AUTH_CODE == "")
            {
                SendError sendError = new SendError("100", "注册邀请码不能为空", "auth_code");
                Send(sendError);
                return;
            }
            //验证账户登录名的有效性
            string sql = string.Format(@"SELECT COUNT(1) AS T,'A' AS F FROM ARES_USER WHERE UID=@UID
            UNION ALL 
            SELECT COUNT(1),'B' FROM ARES_AUTHCODE WHERE AUTH_CODE=@AUTH_CODE AND STATUS=0");

            DataTable dt = DbHelperSQL.QueryTable(sql, new SqlParameter[] {
                    new SqlParameter("@UID",UID),
                    new SqlParameter("@AUTH_CODE",AUTH_CODE)
            });
            if (dt != null && dt.Rows.Count > 0)
            {
                bool CanReg = false;
                foreach (DataRow row in dt.Rows)
                {
                    if (row["F"].ToString() == "A")
                    {
                        if (Convert.ToInt32(row["T"]) > 0)
                        {
                            SendError sendError = new SendError("100", "用户名已存在，请更换后重试", "user_id");
                            Send(sendError);
                            return;
                        }
                        else
                        {
                            CanReg = true;
                        }
                    }
                    else
                    {
                        if (Convert.ToInt32(row["T"]) == 0)
                        {
                            SendError sendError = new SendError("100", "注册邀请码已经失效，请更换后重试", "auth_code");
                            Send(sendError);
                            return;
                        }
                    }
                }
                if (CanReg)
                {
                    //注册信息
                    Hashtable hs = new Hashtable();
                    hs.Add("insert into ARES_USER (UID,NAME,PWD,RegistDate,AdminLv) values(@UID,@NAME,@PWD,now(),@AdminLv)", new SqlParameter[] {
                        new SqlParameter("@UID",UID),
                        new SqlParameter("@NAME",NAME),
                        new SqlParameter("@PWD",System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(PWD, "MD5")),
                        new SqlParameter("@AdminLv","1")
                    });
                    //更新邀请码状态
                    hs.Add("update ARES_AUTHCODE set STATUS=1,UID=@UID where AUTH_CODE=@AUTH_CODE", new SqlParameter[] {
                        new SqlParameter("@UID",UID),
                        new SqlParameter("@AUTH_CODE",AUTH_CODE)
                    });
                    try
                    {
                        DbHelperSQL.ExecuteSqlTran(hs);
                        DbHelperSQL.ExecuteSqlTran(hs);
                        SendError sendError = new SendError("200", "注册成功，请返回登陆！", "auth_code");
                        Send(sendError);
                        return;
                    }
                    catch (Exception e)
                    {
                        SendError sendError = new SendError("100", e.ToString(), "auth_code");
                        Send(sendError);
                        return;
                    }
                }
            }
        }

        private void Send(string msg)
        {
            g_Context.Response.Write(msg);

        }
        private void Send(object obj)
        {
            string msg = JsonConvert.SerializeObject(obj);
            g_Context.Response.Write(msg);
        }

        private void DataGridSend(DataTable obj)
        {
            string msg = JsonConvert.SerializeObject(obj);

            string a = "{\"total\":" + obj.Rows.Count.ToString() + ",\"rows\":";
            a += msg;
            a += "}";
            g_Context.Response.Write(a);
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }

    public class SendError
    {
        public string Status { get; set; }
        public string Message { get; set; }
        public string Field { get; set; }
        public SendError(string _status, string _message, string _field)
        {
            this.Status = _status;
            this.Message = _message;
            this.Field = _field;

        }
        public SendError()
        { }
    }
}