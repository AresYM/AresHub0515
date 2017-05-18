
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WebDLL
{
    class BackUp
    {
        public static class AresEntityFactory
        {
            //public static IARES_ENTITY MakeAresEntity(string name, Newtonsoft.Json.Linq.JObject tokens)
            //{
            //    IARES_ENTITY AresEntity = null;
            //    try
            //    {
            //        var assembly = Assembly.GetExecutingAssembly();
            //        var types = assembly.GetTypes();
            //        foreach (var type in types)
            //        {
            //            if (type.Name == name)
            //            {
            //                Type t = Type.GetType(type.ToString());
            //                AresEntity = Activator.CreateInstance(t) as IARES_ENTITY;
            //            }
            //        }
            //        PropertyInfo[] properties = AresEntity.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance);
            //        foreach (PropertyInfo property in properties)
            //        {
            //            string value = tokens[property.Name].ToString();
            //            property.SetValue(AresEntity, value, null);
            //        }
            //    }
            //    catch (Exception ex)
            //    {
            //        Console.WriteLine(ex.Message);
            //    }
            //    return AresEntity;
            //}
        }
    }
}
