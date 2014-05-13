using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography.X509Certificates;
using System.Net.Sockets;
using System.Net.Security;
using System.IO;

namespace Server
{
    class PushProvider
    {
        static private int port = 2195;
        static private string hostname = "gateway.push.apple.com";
        
        public PushProvider( string address, int port, string certification_file, string certification_password )
        {
            try
            {
                
                //client = new TcpClient( address, port );
                X509Certificate2 clientCertificate = new X509Certificate2( certification_file, certification_password );
                certificationCollection = new X509Certificate2Collection( clientCertificate );
                
            }
            catch ( Exception error )
            {
                Program.logCoord.WriteLog( error );
                return;
            }
            Program.logCoord.WriteLog( "Push Provider Setup Complete.\n" );
            host_address = address;
        }
        ~PushProvider()
        {
            if (client != null)
            {
                if (client.Connected)
                    client.Close();
            }
        }


        public bool SendPushMessage(String msg, String deviceID)
        {
            try
            {
                client = new TcpClient(hostname, port);
                SslStream sslStream = new SslStream( client.GetStream(), false, new RemoteCertificateValidationCallback( ValidateServerCertificate ), null );
                sslStream.AuthenticateAsClient( host_address, certificationCollection, System.Security.Authentication.SslProtocols.Tls, true );


                MemoryStream memoryStream = new MemoryStream();
                BinaryWriter writer = new BinaryWriter( memoryStream );
                writer.Write( ( byte )0 );  //The command
                writer.Write( ( byte )0 );  //The first byte of the deviceId length (big-endian first byte)
                writer.Write( ( byte )32 ); //The deviceId length (big-endian second byte)
                //String deviceID = "7193a81600cbc47cbf0278f705246d17522274bb5dba005da611da4e401e5c1a";
                
                //deviceID = "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000";
                writer.Write( HexStringToByteArray( deviceID.ToUpper() ) );

                //String msg = "Hello?";
                String payload = "{\"aps\":{\"alert\":\"" + msg + "\",\"badge\":0,\"sound\":\"default\"}}";
                //String payload = "{\"aps\":{\"alert\":\"잘되나?\",\"badge\":0,\"sound\":\"default\"}}";
                byte[] b1 = System.Text.Encoding.UTF8.GetBytes( payload );
                writer.Write( ( byte )0 );
                //writer.Write((byte)payload.Length);
                writer.Write( ( byte )b1.Length );
                //writer.Write(0);
                //writer.Write(payload.Length);
                //http://localhost/SPTSWeb/Photo/SPTS_PS_PR.aspx?pjt_cd=BASE100524&user_id=test2&msg=gogogo&ruser_ids=tester2&pto_idx=40
                //byte[] b1 = System.Text.Encoding.Default.GetBytes(payload);
                //byte[] b1 = System.Text.Encoding.Unicode.GetBytes(payload);
                //byte[] b1 = System.Text.Encoding.ASCII.GetBytes(payload);
                writer.Write( b1 );
                writer.Flush();
                byte[] array = memoryStream.ToArray();
                sslStream.Write( array );
                sslStream.Flush();
                client.Close();
                
                Program.logCoord.WriteOnlyTextLog("푸시 전송 성공! -> msg= "+msg +"deviceID= "+ deviceID);
            }
            catch ( Exception error )
            {
                Program.logCoord.WriteOnlyTextLog(error.ToString()); //Error
                return false;
            }
            return true;
        }
        private TcpClient client;
        private string host_address;
        private X509Certificate2Collection certificationCollection;
        //int port = 2195;
        //String hostname = "gateway.sandbox.push.apple.com"; //테스트 서버
        ////String hostname = "gateway.push.apple.com";       //실서버

        //X509Certificate2Collection certificatesCollection = new X509Certificate2Collection();
        //try
        //{
        //    X509Certificate2 clientCertificate = new X509Certificate2("PushServerCert.pem", "tangible.idea");
        //    certificatesCollection = new X509Certificate2Collection(clientCertificate);
        //}
        //catch (Exception error)
        //{
        //    MessageBox.Show(error.Message);
        //    //msg_cd = "E510";        //패스워드 인증실패
        //    return;
        //}
        //TcpClient client = new TcpClient(hostname, port);
        //SslStream sslStream = new SslStream(client.GetStream(), false, new RemoteCertificateValidationCallback(WindowsFormsApplication1.Program.ValidateServerCertificate), null);
        //try
        //{
        //    sslStream.AuthenticateAsClient(hostname, certificatesCollection, System.Security.Authentication.SslProtocols.Tls, true);
        //}
        //catch (Exception error)
        //{
        //    MessageBox.Show(error.Message);
        //   //msg_cd = "E510";        //인증오류
        //    client.Close();
        //    return;
        //}
        //MemoryStream memoryStream = new MemoryStream();
        //BinaryWriter writer = new BinaryWriter(memoryStream);
        //writer.Write((byte)0);  //The command
        //writer.Write((byte)0);  //The first byte of the deviceId length (big-endian first byte)
        //writer.Write((byte)32); //The deviceId length (big-endian second byte)
        //String deviceID = "3c69ba4184905ba71595b139a3e1b0f0c86e97e0294882a429c9fd91bb5725e5";
        ////deviceID = "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000";
        //writer.Write(WindowsFormsApplication1.Program.HexStringToByteArray(deviceID.ToUpper()));

        //String msg = "Hello?";
        //String payload = "{\"aps\":{\"alert\":\"" + msg + "\",\"badge\":0,\"sound\":\"default\"}}";
        ////String payload = "{\"aps\":{\"alert\":\"잘되나?\",\"badge\":0,\"sound\":\"default\"}}";
        //byte[] b1 = System.Text.Encoding.UTF8.GetBytes(payload);
        //writer.Write((byte)0);
        ////writer.Write((byte)payload.Length);
        //writer.Write((byte)b1.Length);
        ////writer.Write(0);
        ////writer.Write(payload.Length);
        ////http://localhost/SPTSWeb/Photo/SPTS_PS_PR.aspx?pjt_cd=BASE100524&user_id=test2&msg=gogogo&ruser_ids=tester2&pto_idx=40
        ////byte[] b1 = System.Text.Encoding.Default.GetBytes(payload);
        ////byte[] b1 = System.Text.Encoding.Unicode.GetBytes(payload);
        ////byte[] b1 = System.Text.Encoding.ASCII.GetBytes(payload);
        //writer.Write(b1);
        //writer.Flush();
        //byte[] array = memoryStream.ToArray();
        //sslStream.Write(array);
        //sslStream.Flush();
        //client.Close();
        public static bool ValidateServerCertificate( Object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors )
        {
            return true;
        }
        public static byte[] HexStringToByteArray( String s )
        {
            s = s.Replace( " ", "" );
            byte[] buffer = new byte[ s.Length / 2 ];
            for ( int i = 0; i < s.Length; i += 2 )
            {
                buffer[ i / 2 ] = ( byte )Convert.ToByte( s.Substring( i, 2 ), 16 );
            }
            return buffer;
        }
    }
}