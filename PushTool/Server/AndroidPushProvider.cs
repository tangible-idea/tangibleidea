using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Collections.Specialized;
using System.IO;

namespace Server
{
    //public class AndroidPushProvider
    //{
    //    // Hardcoded for now
    //    private const string REG_ID = "XXXXXXXXXXX";

    //    private const string GOOGLE_AUTH_URL = "https://www.google.com/accounts/ClientLogin";
    //    // TODO : Production code should use https (secure) push and have the correct certificate
    //    private const string GOOGLE_MSG_URL = "http://android.clients.google.com/c2dm/send";

    //    private const string POST_WEB_REQEST = "POST";
    //    private const string AUTH_TOKEN_HEADER = "Auth=";
    //    private const string UPDATE_CLIENT_AUTH = "Update-Client-Auth";

    //    // Post data parameters
    //    private const string REG_ID_PARAM = "registration_id";
    //    private const string COLLAPSE_KEY_PARAM = "collapse_key";
    //    private const string DATA_PAYLOD_PARAM = "data.payload";
    //    private const string DELAY_WHILE_IDLE_PARAM = "delay_while_idle";

    //    private string _authTokenString = String.Empty;
    //    private string _updatedAuthTokenString = String.Empty;
    //    private string _message = String.Empty;

    //    public void StartServer()
    //    {
    //        if ((_authTokenString = GetAuthentificationToken()).Equals(String.Empty))
    //        {
    //            Console.ReadLine();
    //            return;
    //        }

    //        while (true)
    //        {
    //            try
    //            {
    //                Console.Write("Message> ");
    //                _message = Console.ReadLine().ToLower().Trim();
    //                SendMessage(_authTokenString, REG_ID, _message);
    //            }
    //            catch (Exception ex)
    //            {
    //                Console.WriteLine(ex.Message);
    //                Console.WriteLine(ex.StackTrace);
    //            }
    //        }
    //    }

    //    private static string GetAuthentificationToken()
    //    {
    //        string authTokenString = String.Empty;
    //        try
    //        {
    //            WebRequest request = WebRequest.Create(GOOGLE_AUTH_URL);
    //            request.Method = POST_WEB_REQEST;

    //            NameValueCollection postFieldNameValue = new NameValueCollection();
    //            postFieldNameValue.Add("Email", "XXXXXXXXXXX");
    //            postFieldNameValue.Add("Passwd", "XXXXXXXXXXX");
    //            postFieldNameValue.Add("accountType", "GOOGLE");
    //            postFieldNameValue.Add("source", "Google-cURL-Example");
    //            postFieldNameValue.Add("service", "ac2dm");

    //            string postData = GetPostStringFrom(postFieldNameValue);
    //            byte[] byteArray = Encoding.UTF8.GetBytes(postData);

    //            request.ContentType = "application/x-www-form-urlencoded";
    //            request.ContentLength = byteArray.Length;

    //            Stream dataStream = request.GetRequestStream();
    //            dataStream.Write(byteArray, 0, byteArray.Length);
    //            dataStream.Close();

    //            WebResponse response = request.GetResponse();
    //            if (((HttpWebResponse)response).StatusCode.Equals(HttpStatusCode.OK))
    //            {
    //                dataStream = response.GetResponseStream();
    //                StreamReader reader = new StreamReader(dataStream);

    //                string responseFromServer = reader.ReadToEnd();

    //                authTokenString = ParseForAuthTokenKey(responseFromServer);

    //                reader.Close();
    //                dataStream.Close();
    //            }
    //            else
    //            {
    //                Console.WriteLine("Response from web service not OK :");
    //                Console.WriteLine(((HttpWebResponse)response).StatusDescription);
    //            }

    //            response.Close();
    //        }
    //        catch (Exception ex)
    //        {
    //            Console.WriteLine("Getting Authentication Failure");
    //            Console.WriteLine(ex.Message);
    //        }
    //        return authTokenString;
    //    }

    //    private static void SendMessage(string authTokenString, string registrationId, string message)
    //    {
    //        //Certeficate was not being accepted for the sercure call
    //        //ServicePointManager.ServerCertificateValidationCallback += new RemoteCertificateValidationCallback(ValidateServerCertificate);

    //        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(GOOGLE_MSG_URL);
    //        request.Method = POST_WEB_REQEST;
    //        request.KeepAlive = false;

    //        NameValueCollection postFieldNameValue = new NameValueCollection();
    //        postFieldNameValue.Add(REG_ID_PARAM, registrationId);
    //        postFieldNameValue.Add(COLLAPSE_KEY_PARAM, "0");
    //        postFieldNameValue.Add(DELAY_WHILE_IDLE_PARAM, "0");
    //        postFieldNameValue.Add(DATA_PAYLOD_PARAM, message);

    //        string postData = GetPostStringFrom(postFieldNameValue);
    //        byte[] byteArray = Encoding.UTF8.GetBytes(postData);

    //        request.ContentType = "application/x-www-form-urlencoded;charset=UTF-8";
    //        request.ContentLength = byteArray.Length;

    //        request.Headers.Add(HttpRequestHeader.Authorization, "GoogleLogin auth=" + authTokenString);

    //        Stream dataStream = request.GetRequestStream();
    //        dataStream.Write(byteArray, 0, byteArray.Length);
    //        dataStream.Close();

    //        WebResponse response = request.GetResponse();
    //        HttpStatusCode responseCode = ((HttpWebResponse)response).StatusCode;
    //        if (responseCode.Equals(HttpStatusCode.Unauthorized) || responseCode.Equals(HttpStatusCode.Forbidden))
    //        {
    //            Console.WriteLine("Unauthorized - need new token");
    //        }
    //        else if (!responseCode.Equals(HttpStatusCode.OK))
    //        {
    //            Console.WriteLine("Response from web service not OK :");
    //            Console.WriteLine(((HttpWebResponse)response).StatusDescription);
    //        }

    //        StreamReader reader = new StreamReader(response.GetResponseStream());
    //        string responseLine = reader.ReadLine();
    //        reader.Close();
    //    }

    //    private static string GetPostStringFrom(NameValueCollection nameValuePair)
    //    {
    //        StringBuilder postString = new StringBuilder();
    //        for (int i = 0; i < nameValuePair.Count; i++)
    //        {
    //            postString.Append(nameValuePair.GetKey(i));
    //            postString.Append("=");
    //            postString.Append(Uri.EscapeDataString(nameValuePair[i]));
    //            if (i + 1 != nameValuePair.Count)
    //            {
    //                postString.Append("&");
    //            }
    //        }
    //        return postString.ToString();
    //    }

    //    private static string ParseForAuthTokenKey(string webResponse)
    //    {
    //        string tokenKey = String.Empty;
    //        if (webResponse.Contains(AUTH_TOKEN_HEADER))
    //        {
    //            tokenKey = webResponse.Substring(webResponse.IndexOf(AUTH_TOKEN_HEADER) + AUTH_TOKEN_HEADER.Length);
    //            if (tokenKey.Contains(Environment.NewLine))
    //            {
    //                tokenKey.Substring(0, tokenKey.IndexOf(Environment.NewLine));
    //            }
    //        }
    //        return tokenKey.Trim();
    //    }

    //    public static bool ValidateServerCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
    //    {
    //        // Return "true" to force the certificate to be accepted.
    //        return true;
    //    }
    //}







    public class AndroidPushProvider
    {
        // PW-old : apsxhfld
        //public const string AUTH_TOKEN = "DQAAAAMBAAASJFtBQLVy0jmaEnHJ_yLwr6hrchyOG2Fwea7JWMjKQiGX8CC1zU1z9DWkF63agiQ-I7dsYraK9p_Tfr14wWAvTzlYwpXZJmly9BQNUiYFFIMSa5tik0YnpJiweyQxHaymhlLT9VTnZRKExigwFMwNE5aYxU53RIQ_lafRm7_mQYv3je9HCNMmTUw5xE1OjFiQRo29JkQeEUU74rqufMT-GEsUaWRdOpePS-qwgix6cXG2RLdxUC4aL3NwqMPWLrsZ6V-QWncY70Xwnn-pmGKK76VUUUz0E4MRw3gXkdaHyfw9WERQLITTV9f_zyII2BGkVXmK1CBEpk-CNIn8ACGO1Tr13T5cXDUnV08dqyWmtg";
        public const string AUTH_TOKEN = "DQAAAAUBAABHJ_XQ4IGHjIjbXyQezrdInkLGxLmUmMw8AyCe7s6FtXqnNJDQttvPvbWuY81KGF500EzxJg9QgEP0ageuOuzVwVuPHU-dteqOjMJDXtCrJvmd7LscNSvBukouGY0C1zjmr_woAe9hl7Y7CMv-0w26zi03PH9sXI8BDfOI5k9ov2crx19IZ51I9lnhlq2rgnqAoHHjhJ0qU_glZOlqWZDlboWlN2NeevrG9fm7lOQXOf82eaBnnaMPFeqmeETp3gQD6M5aHy_ItgcXtdIg4p6ViHsWPLEpkPQr5XMOtwF9AmXvYhMJELBXHhvPphbDOgvffnp1l-LaHE3X4Y2pYs2L9Y6JdZkPswKfsStC1FNR-Q";

        public AndroidPushProvider()
        {

        }

        // Post data parameters 
        private const string REGISTRATION_ID_PARAM = "registration_id";
        private const string COLLAPSE_KEY_PARAM = "collapse_key";
        private const string DATA_PAYLOAD_PARAM1 = "data.type";
        private const string DATA_PAYLOAD_PARAM2 = "data.message";
        private const string DELAY_WHILE_IDLE_PARAM = "delay_while_idle";

        // TODO : Production code should use https (secure) push and have the correct certificate 
        private const string GOOGLE_MESSAGE_URL = "http://android.clients.google.com/c2dm/send";

        private const string POST_WEB_REQUEST = "POST";




        // 푸쉬 메서드
        public bool sendMessage(string registrationId, string message, string type)
        {
            if (registrationId == null || registrationId == "NULL" || registrationId == "0")
                return false;

            //Certeficate was not being accepted for the sercure call 
            //ServicePointManager.ServerCertificateValidationCallback += new RemoteCertificateValidationCallback(ValidateServerCertificate); 

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(GOOGLE_MESSAGE_URL);
            request.Method = POST_WEB_REQUEST;
            request.KeepAlive = false;

            NameValueCollection postFieldNameValue = new NameValueCollection();
            postFieldNameValue.Add(REGISTRATION_ID_PARAM, registrationId);
            postFieldNameValue.Add(COLLAPSE_KEY_PARAM, type); // 이값을 랜덤값으로 넣을시 중복값도 바로바로 전송됨

            postFieldNameValue.Add(DELAY_WHILE_IDLE_PARAM, "0");
            postFieldNameValue.Add(DATA_PAYLOAD_PARAM1, type);
            postFieldNameValue.Add(DATA_PAYLOAD_PARAM2, message);

            string postData = getPostStringFrom(postFieldNameValue);
            byte[] byteArray = Encoding.UTF8.GetBytes(postData);

            request.ContentType = "application/x-www-form-urlencoded;charset=UTF-8";
            request.ContentLength = byteArray.Length;

            request.Headers.Add(HttpRequestHeader.Authorization, "GoogleLogin auth=" + AUTH_TOKEN);

            Stream dataStream = request.GetRequestStream();
            dataStream.Write(byteArray, 0, byteArray.Length);
            dataStream.Close();

            WebResponse response;
            try
            {
                response = request.GetResponse();
                HttpStatusCode responseCode = ((HttpWebResponse)response).StatusCode;
                if (responseCode.Equals(HttpStatusCode.Unauthorized) || responseCode.Equals(HttpStatusCode.Forbidden))
                {
                    Console.WriteLine("Unauthorized - need new token");
                }
                else if (!responseCode.Equals(HttpStatusCode.OK))
                {
                    Console.WriteLine("Response from web service not OK :");
                    Console.WriteLine(((HttpWebResponse)response).StatusDescription);
                }
                StreamReader reader = new StreamReader(response.GetResponseStream());
                string responseLine = reader.ReadLine();
                reader.Close();
            }
            catch (WebException ex)
            {
                Console.WriteLine(ex.ToString());
                return false;
            }

            return true;
        }

        private string getPostStringFrom(NameValueCollection nameValuePair)
        {
            StringBuilder postString = new StringBuilder();
            for (int i = 0; i < nameValuePair.Count; i++)
            {
                postString.Append(nameValuePair.GetKey(i));
                postString.Append("=");
                postString.Append(Uri.EscapeDataString(nameValuePair[i]));
                if (i + 1 != nameValuePair.Count)
                {
                    postString.Append("&");
                }
            }
            return postString.ToString();
        }


    }


}
