using System;
using System.Reflection;
using System.Text;
namespace WebEntity
{

    public interface IARES_ENTITY { }
    public class ARES_CODE_COMPANY : IARES_ENTITY
    {
        public string ID { get; set; }
        public string COMPANY_CODE { get; set; }
        public string COMPANY_NAME { get; set; }
        public string STATUS { get; set; }
    }
    public class ARES_CODE_DEPARTMENT : IARES_ENTITY
    {
        public string ID { get; set; }
        public string DEPARTMENT_CODE { get; set; }
        public string DEPARTMENT_NAME { get; set; }
        public string COMPANY_CODE { get; set; }
    }
    public class ARES_CODE_STUFF : IARES_ENTITY
    {
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
    public class ARES_CODE_APPROACH : IARES_ENTITY
    {
        public string ID { get; set; }
        public string APPROACH_CODE { get; set; }
        public string APPROACH_NAME { get; set; }
    }
    public class ARES_CODE_CLASS : IARES_ENTITY
    {
        public string CODE { get; set; }
        public string NAME { get; set; }
        public string CLASS_LV { get; set; }
        public string FATHER_CODE { get; set; }
    }


    public static class AresEntityFactory
    {
        public static IARES_ENTITY MakeAresEntity(string name, Newtonsoft.Json.Linq.JObject tokens)
        {
            IARES_ENTITY AresEntity = null;
            try
            {
                var assembly = Assembly.GetExecutingAssembly();
                var types = assembly.GetTypes();
                foreach (var type in types)
                {
                    if (type.Name == name)
                    {
                        Type t = Type.GetType(type.ToString());
                        AresEntity = Activator.CreateInstance(t) as IARES_ENTITY;
                    }
                }
                PropertyInfo[] properties = AresEntity.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance);

                foreach (PropertyInfo property in properties)
                {
                    string value = tokens[property.Name].ToString();
                    property.SetValue(AresEntity, value, null);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return AresEntity;
        }
    }
}

