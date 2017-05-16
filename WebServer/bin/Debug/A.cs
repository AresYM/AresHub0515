using System;
using System.Text;
namespace WebEntity
{
     public class ARES_CODE_COMPANY
     {
        public string ID { get; set; }
        public string COMPANY_CODE { get; set; }
        public string COMPANY_NAME { get; set; }
        public string STATUS { get; set; }
     }
     public class ARES_CODE_DEPARTMENT
     {
        public string ID { get; set; }
        public string DEPARTMENT_CODE { get; set; }
        public string DEPARTMENT_NAME { get; set; }
        public string COMPANY_CODE { get; set; }
     }
     public class ARES_CODE_STUFF
     {
        public string ID { get; set; }
        public string CODE { get; set; }
        public string NAME { get; set; }
        public string ENG_NAME { get; set; }
        public string SHORT_NAME { get; set; }
        public string F_CLASS_CODE { get; set; }
        public string S_CLASS_CODE { get; set; }
        public string T_CLASS_CODE { get; set; }
        public string GG { get; set; }
        public string XH { get; set; }
        public string USE_TYPE_CODE { get; set; }
        public string OPEN_FLAG { get; set; }
        public string B_UNIT_CODE { get; set; }
        public string S_UNIT_CODE { get; set; }
        public string UNIT_SWITCH { get; set; }
        public string SRM1 { get; set; }
        public string SRM2 { get; set; }
        public string SRM3 { get; set; }
        public string STATUS { get; set; }
     }
     public class ARES_FRIEND
     {
        public string UID { get; set; }
        public string NAME { get; set; }
        public string BIRTH_DAY { get; set; }
        public string SEX { get; set; }
        public string IMG { get; set; }
     }
     public class ARES_LANGUAGE_LIST
     {
        public string ID { get; set; }
        public string QUESTION { get; set; }
        public string ANSWER { get; set; }
     }
     public class ARES_MENUS
     {
        public string ID { get; set; }
        public string MENU_ID { get; set; }
        public string MENU_NAME { get; set; }
        public string MENU_LEVEL { get; set; }
        public string MENU_FATHER { get; set; }
        public string MENU_URL { get; set; }
        public string ORDER_NUM { get; set; }
        public string STATUS { get; set; }
     }
     public class ARES_ROLE_MENU_LINK
     {
        public string ID { get; set; }
        public string ROLE_ID { get; set; }
        public string MENU_ID { get; set; }
     }
     public class ARES_ROLES
     {
        public string ID { get; set; }
        public string ROLE_ID { get; set; }
        public string ROLE_NAME { get; set; }
        public string STATUS { get; set; }
     }
     public class ARES_USER
     {
        public string ID { get; set; }
        public string UID { get; set; }
        public string NAME { get; set; }
        public string PWD { get; set; }
        public string RegistDate { get; set; }
        public string AdminLv { get; set; }
        public string COMPANY_CODE { get; set; }
        public string DEPARTMENT_CODE { get; set; }
     }
     public class ARES_USER_ROLE_LINK
     {
        public string ID { get; set; }
        public string USER_ID { get; set; }
        public string ROLE_ID { get; set; }
     }
     public class ARES_WORDS
     {
        public string ID { get; set; }
        public string UID { get; set; }
        public string WORDS { get; set; }
     }
     public class ARES_CODE_FEED
     {
        public string F_TYPE { get; set; }
        public string F_CODE { get; set; }
     }
     public class ARES_TABLE_LOCK
     {
        public string TABLE_NAME { get; set; }
        public string LOCK { get; set; }
     }
     public class ARES_AUTHCODE
     {
        public string ID { get; set; }
        public string AUTH_CODE { get; set; }
        public string STATUS { get; set; }
        public string UID { get; set; }
     }
     public class ARES_CODE_APPROACH
     {
        public string ID { get; set; }
        public string APPROACH_CODE { get; set; }
        public string APPROACH_NAME { get; set; }
     }
     public class ARES_CODE_CLASS
     {
        public string ID { get; set; }
        public string CLASS_CODE { get; set; }
        public string CLASS_NAME { get; set; }
        public string CLASS_LV { get; set; }
        public string FATHER_CODE { get; set; }
     }
}

