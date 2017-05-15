using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json;
using System.Web;

namespace WebDLL
{
    public static class WebManager
    {

        public static void Send(string sendMsg)
        {
            HttpContext _context = System.Web.HttpContext.Current;
            _context.Response.Write(sendMsg);
            _context.Response.End();
        }


        public static void Send(object sendMsg)
        {
            HttpContext _context = System.Web.HttpContext.Current;
            
            _context.Response.Write(JsonConvert.SerializeObject(sendMsg));
            _context.Response.End();
        }

    }
}
