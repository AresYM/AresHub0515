using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace WebDLL
{

    //网站用户登录状态管理
    public static class WebUserBase
    {
        public static User GetUser(string UID)
        {
            string sql = string.Format(@"Select A.ID,A.UID,A.PWD,A.NAME,A.AdminLv,A.COMPANY_CODE,B.COMPANY_NAME,A.DEPARTMENT_CODE,C.DEPARTMENT_NAME
            from ARES_USER A 
            LEFT JOIN ARES_CODE_COMPANY B ON A.COMPANY_CODE=B.COMPANY_CODE
            LEFT JOIN ARES_CODE_DEPARTMENT C ON A.DEPARTMENT_CODE=C.DEPARTMENT_CODE
            where A.UID=@UID ");
            DataTable dt = DbHelperSQL.QueryTable(sql, new SqlParameter[] {
                new SqlParameter("@UID",UID)
            });
            if (dt != null && dt.Rows.Count > 0)
            {
                User u = new User(UID);
                u.Set(dt.Rows[0]["ID"].ToString(), dt.Rows[0]["NAME"].ToString(), dt.Rows[0]["PWD"].ToString(),
                    dt.Rows[0]["AdminLv"].ToString(), dt.Rows[0]["COMPANY_CODE"].ToString(),
                    dt.Rows[0]["COMPANY_NAME"].ToString(), dt.Rows[0]["DEPARTMENT_CODE"].ToString(),
                    dt.Rows[0]["DEPARTMENT_NAME"].ToString());
                return u;
            }
            else
            {
                return new User();
            }
        }

        

         

        public static DataTable GetMenus(string UID)
        {
            string sql = string.Format(@"Select T5.* from (((ARES_USER T1
            INNER JOIN ARES_USER_ROLE_LINK T2 ON T1.UID=T2.USER_ID)
            INNER JOIN ARES_ROLES T3 ON T3.ROLE_ID=T2.ROLE_ID)
            INNER JOIN ARES_ROLE_MENU_LINK T4 ON T4.ROLE_ID=T3.ROLE_ID)
            INNER JOIN ARES_MENUS T5 ON T5.MENU_ID=T4.MENU_ID
            WHERE T1.UID=@UID ORDER BY T5.ORDER_NUM");
            DataTable dt = DbHelperSQL.QueryTable(sql, new SqlParameter[] {
                    new SqlParameter("@UID",UID)
            });

            return dt;
        }

    }

    public class User
    {
        public string ID { get; set; }
        public string UID { get; set; }
        public string PWD { get; set; }
        public string NAME { get; set; }
        public string AdminLv { get; set; }
        public string COMPANY_CODE { get; set; }
        public string COMPANY_NAME { get; set; }
        public string DEPARTMENT_CODE { get; set; }
        public string DEPARTMENT_NAME { get; set; }
        public string IP { get; set; }
        public User(string _uid)
        {
            this.UID = _uid;
            this.IP = HttpContext.Current.Request.UserHostAddress;
        }

        public User()
        {

        }
        internal void Set(string ID, string NAME, string PWD, string AdminLv, string COMPANY_CODE, string COMPANY_NAME, string DEPARTMENT_CODE, string DEPARTMENT_NAME)
        {
            this.ID = ID;
            this.NAME = NAME;
            this.PWD = PWD;
            this.AdminLv = AdminLv;
            this.COMPANY_CODE = COMPANY_CODE;
            this.COMPANY_NAME = COMPANY_NAME;
            this.DEPARTMENT_CODE = DEPARTMENT_CODE;
            this.DEPARTMENT_NAME = DEPARTMENT_NAME;
        }
    }


    public class Friend
    {
        public string ID { get; set; }
        public string NAME { get; set; }
        public string AGE { get; set; }
        public string Birth_Day { get; set; }
        public string SEX { get; set; }
        public string IMG { get; set; }


        public Friend(string id, string name, string birth_day, string sex, string img)
        {
            this.ID = id;
            this.NAME = name;
            this.AGE = ParseBirthday(birth_day, DateTime.Now);
            this.Birth_Day = birth_day;
            this.SEX = sex;
            this.IMG = img;
        }

        public Friend() { }



        private string ParseBirthday(string birthdayString, DateTime targetDateTime)
        {
            int year = targetDateTime.Year;
            int month = targetDateTime.Month;
            int days = targetDateTime.Day;
            DateTime currentMoment = new DateTime();
            if (!DateTime.TryParse(birthdayString, out currentMoment))
            {
                return "";
            }
            int currentYear = currentMoment.Year;
            int currentMonth = currentMoment.Month;
            int currentDays = currentMoment.Day;
            var diffYear = year - currentYear;
            var diffMonth = month - currentMonth;
            if (diffMonth < 0)
            {
                diffMonth = month + 12 - currentMonth;
                diffYear--;
            }
            var diffDays = days - currentDays;
            if (diffDays < 0)
            {
                DateTime prevMonthDate = currentMoment.AddMonths(-1);
                int step = DateTime.DaysInMonth(prevMonthDate.Year, prevMonthDate.Month);
                diffDays = days + step - currentDays;
                --diffMonth;
                if (diffMonth < 0)
                {
                    diffMonth = diffMonth + 12;
                    diffYear--;
                }
            }
            return string.Format("{0}岁{1}月{2}天", diffYear, diffMonth, diffDays);
        }

    }
}
