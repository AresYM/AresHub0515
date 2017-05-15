using System;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Reflection;

public class EmailHelper
{
    private EmailHelper() { }

    public static EmailHelper Instance = new EmailHelper();

    public bool SendMail(string title, string message)
    {
        string from = ConfigurationManager.AppSettings["EMAIL_FROM"];
        string to = ConfigurationManager.AppSettings["EMAIL_TO"];
        string cc = ConfigurationManager.AppSettings["EMAIL_CC"];
        string pwd = ConfigurationManager.AppSettings["EMAIL_PWD"];

        string[] cc_arr = null;
        if (!string.IsNullOrEmpty(cc))
        {
            cc_arr = cc.Split(',');
        }
        return SendMail(from, from, pwd, to.Split(','), cc_arr, title, message, null);
    }

    public bool SendMail(string from, string username, string password, string[] tos, string[] ccs, string subject, string context, Stream[] fileStreams, string msg = "")
    {
        try
        {
            MailMessage mailMessage = SetMailMessage(from, tos, ccs, subject, context, fileStreams);
            SmtpClient smtpClient = new SmtpClient();
            //设置邮箱端口，pop3端口:110, smtp端口是:25
            smtpClient.Host = "smtp." + from.Substring(from.IndexOf("@") + 1);
            smtpClient.Port = 25;
            smtpClient.Credentials = new NetworkCredential(username, password);
            smtpClient.Send(mailMessage);

            return true;
        }
        catch (Exception)
        {
            return false;
        }
    }

    public bool SendMail(string from, string username, string password, string[] tos, string[] ccs, string subject, string context, string[] files)
    {
        try
        {
            MailMessage mailMessage = SetMailMessage(from, tos, ccs, subject, context, files);
            SmtpClient smtpClient = new SmtpClient();
            //设置邮箱端口，pop3端口:110, smtp端口是:25
            smtpClient.Host = "smtp." + from.Substring(from.IndexOf("@") + 1);
            smtpClient.Port = 25;
            smtpClient.Credentials = new NetworkCredential(username, password);
            smtpClient.Send(mailMessage);

            //try
            //{
            //    if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["EmailEmlPath"]))
            //    {
            //        string filePath = ConfigurationManager.AppSettings["EmailEmlPath"] + "/" + DateTime.Now.ToShortDateString() + "/";
            //        if (!Directory.Exists(filePath))
            //            Directory.CreateDirectory(filePath);

            //        SaveToEml(mailMessage, filePath + DateTime.Now.Ticks + ".eml");
            //    }
            //}
            //catch
            //{
            //}

            return true;
        }
        catch (Exception e)
        {
            return false;
        }
    }

    public MailMessage SetMailMessage(string from, string[] tos, string[] ccs, string subject, string context, Stream[] fileStreams)
    {
        try
        {
            MailMessage mailMessage = new MailMessage();
            mailMessage.From = new MailAddress(from);

            foreach (string to in tos)
            {
                mailMessage.To.Add(new MailAddress(to));
            }

            if (ccs != null)
            {
                foreach (string cc in ccs)
                {
                    mailMessage.CC.Add(new MailAddress(cc));
                }
            }
            mailMessage.Subject = subject;
            mailMessage.Body = context;
            mailMessage.IsBodyHtml = true;
            mailMessage.Priority = MailPriority.High;

            if (fileStreams != null)
            {
                foreach (Stream fileStream in fileStreams)
                {
                    mailMessage.Attachments.Add(new Attachment(fileStream, ""));
                }
            }

            return mailMessage;
        }
        catch (Exception)
        {
            return null;
        }
    }

    public MailMessage SetMailMessage(string from, string[] tos, string[] ccs, string subject, string context, string[] files)
    {
        try
        {
            MailMessage mailMessage = new MailMessage();
            mailMessage.From = new MailAddress(from);

            foreach (string to in tos)
            {
                mailMessage.To.Add(new MailAddress(to));
            }

            if (ccs != null)
            {
                foreach (string cc in ccs)
                {
                    mailMessage.CC.Add(new MailAddress(cc));
                }
            }
            mailMessage.Subject = subject;
            mailMessage.Body = context;
            mailMessage.IsBodyHtml = true;
            mailMessage.Priority = MailPriority.High;

            if (files != null)
            {
                foreach (string file in files)
                {
                    if (File.Exists(file))
                    {
                        //using (FileStream stream = File.Open(file, FileMode.Open, FileAccess.Read, FileShare.Read))
                        //{
                        Attachment attach = new Attachment(file);
                        attach.Name = Path.GetFileName(file);
                        mailMessage.Attachments.Add(attach);
                        // }
                    }
                }
            }

            return mailMessage;
        }
        catch (Exception)
        {
            return null;
        }
    }

    /// <summary>
    /// 将MailMessage保存为eml文件
    /// </summary>
    /// <param name="msg">待保存的具有内容的MailMessage</param>
    /// <param name="emlFileAbsolutePath">保存后的eml文件的路径</param>
    private static void SaveToEml(MailMessage msg, string emlFileAbsolutePath)
    {
        const BindingFlags flags = BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.FlattenHierarchy;
        using (MemoryStream ms = new MemoryStream())
        {
            Assembly assembly = typeof(System.Net.Mail.SmtpClient).Assembly;
            Type tMailWriter = assembly.GetType("System.Net.Mail.MailWriter");
            object mailWriter = Activator.CreateInstance(tMailWriter, flags, null, new object[] { ms }, CultureInfo.InvariantCulture);
            msg.GetType().GetMethod("Send", flags).Invoke(msg, new object[] { mailWriter, true });
            File.WriteAllText(emlFileAbsolutePath, System.Text.Encoding.Default.GetString(ms.ToArray()), System.Text.Encoding.Default);
        }
    }
}