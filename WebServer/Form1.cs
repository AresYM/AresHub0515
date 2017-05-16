using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Windows.Forms;
using WebDLL;

namespace WebServer
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
              
            string sqlTable = @"select object_id,name from sys.objects where type='U' order by object_id";
            DataTable dtTables = DbHelperSQL.QueryTable(sqlTable);
            StringBuilder cs = new StringBuilder();
            StringBuilder js = new StringBuilder();
            cs.Append("using System;" + System.Environment.NewLine);
            cs.Append("using System.Text;" + System.Environment.NewLine);
            cs.Append("namespace WebEntity" + System.Environment.NewLine);
            cs.Append("{" + System.Environment.NewLine);
            cs.Append("interface IARES_ENTITY { }");
            js.Append("window.EntityStructure = {");
            for (int i = 0; i < dtTables.Rows.Count; i++)
            {
                string entity_name = dtTables.Rows[i]["name"].ToString();
                string sqlCol = string.Format(@"select distinct a.column_id, a.name columnname, 
                case when a.is_nullable =0 then 'Not Null' else 'Null' end as nullable  
                from sys.columns a , sys.objects b, sys.types c 
                where a.object_id= b.object_id and b.name='{0}' and a.system_type_id=c.system_type_id 
                order by a.column_id", entity_name);
                DataTable dtCols = DbHelperSQL.QueryTable(sqlCol);
                cs.Append("     public class " + entity_name+ ":IARES_ENTITY" + System.Environment.NewLine);
                cs.Append("     {" + System.Environment.NewLine);
                js.Append("\"" + entity_name + "\":{");

                for (int j = 0; j < dtCols.Rows.Count; j++)
                {
                    string entity_column = dtCols.Rows[j]["columnname"].ToString();
                    cs.Append(@"        public string " + entity_column + " { get; set; }" + System.Environment.NewLine);
                    js.Append("\"" + entity_column + "\":\"\"");
                    if (j != dtCols.Rows.Count - 1)
                    {
                        js.Append(",");
                    }
                }
                js.Append("}");
                if (i != dtTables.Rows.Count - 1)
                {
                    js.Append(",");
                }
                js.Append(System.Environment.NewLine);
                cs.Append("     }" + System.Environment.NewLine);
                
            }
            js.Append("}");
            cs.Append("}" + System.Environment.NewLine);
            FileStream fs = new FileStream(@"WebEntity.cs", FileMode.OpenOrCreate, FileAccess.ReadWrite); //可以指定盘符，也可以指定任意文件名，还可以为word等文件
            StreamWriter sw = new StreamWriter(fs); // 创建写入流
            sw.WriteLine(cs.ToString());
            sw.Close(); //关闭文件

            FileStream fs1 = new FileStream(@"WebEntity.js", FileMode.OpenOrCreate, FileAccess.ReadWrite); //可以指定盘符，也可以指定任意文件名，还可以为word等文件
            StreamWriter sw1 = new StreamWriter(fs1); // 创建写入流
            sw1.WriteLine(js.ToString());
            sw1.Close(); //关闭文件
            MessageBox.Show("生成完毕");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //EmailHelper.Instance.SendMail(textBox1.Text, textBox2.Text);
        }
    }
}
