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
            Program.logCoord.WriteLog("Push Provider Setup" + certification_file + " pw : " + certification_password + "\n");    
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



        //⑤ APNS에 전송하는 메시지는 JSON 포맷을 따르며 256 바이트 이내여야 한다 , 메시지를 구성하는 키는 다음과 같다.

        //alert - 텍스트 메시지
        //sound - 재생할 사운드 (기기 내 사운드 파일 이름)
        //badge - 앱아이콘에 보여줄 뱃지번호
        //custom key - 길이가 허용되는 한도에서 임이 데이터 전달이 가능하다

        //예 )  
        //{"aps":{"sound":"default","alert":"My alert message","badge":45}}
        public bool SendPushMessage( string push_device_id, string alert, int badge, string sound = "default", string custom_key = "")
        {
            client = new TcpClient(hostname, port);
            if ( push_device_id.Length != 64 || push_device_id == "0000000000000000000000000000000000000000000000000000000000000000" )
                return false;
            try
            {
                SslStream sslStream = new SslStream( client.GetStream(), false, new RemoteCertificateValidationCallback( ValidateServerCertificate ), null );
                sslStream.AuthenticateAsClient( host_address, certificationCollection, System.Security.Authentication.SslProtocols.Tls, true );

                MemoryStream memoryStream = new MemoryStream();
                BinaryWriter writer = new BinaryWriter( memoryStream );
                writer.Write( ( byte )0 );  //The command
                writer.Write( ( byte )0 );  //The first byte of the deviceId length (big-endian first byte)
                writer.Write( ( byte )32 ); //The deviceId length (big-endian second byte)
                writer.Write( HexStringToByteArray( push_device_id.ToUpper() ) );

                if (alert.Length > 60)
                {
                    alert = alert.Substring(0, 60);
                }

                String payload = "{\"aps\":{\"alert\":\"" + alert + "\",\"badge\":" + badge + ",\"sound\":\"" + sound + "\"},\"t\":\"" + custom_key + "\"}";
                byte[] b1 = System.Text.Encoding.UTF8.GetBytes( payload );
                if ( b1.Length > 256 )
                {
                    Program.logCoord.WriteLog( "PayLoad is Too Long!" );
                    payload = "{\"aps\":{\"alert\":\"" + alert + "\",\"badge\":" + badge + ",\"sound\":\"" + sound + "\"}}";
                    b1 = System.Text.Encoding.UTF8.GetBytes( payload );
                }
                if ( b1.Length > 256 )
                {
                    Program.logCoord.WriteLog( "PayLoad is Too Long Again!" );
                    payload = "{\"aps\":{\"alert\":\"" + "메시지가 도착했습니다." + "\",\"badge\":" + badge + ",\"sound\":\"" + sound + "\"}}";
                    b1 = System.Text.Encoding.UTF8.GetBytes( payload );
                }

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

                //Program.logCoord.WriteLog( "\r\nbitearray : "+memoryStream.ToString()  );
                //Program.logCoord.WriteLog( "sslStream : "+sslStream + "\r\n");    
                

                sslStream.Flush();
                client.Close();

                Program.logCoord.WriteOnlyTextLog("IOS PUSH : " + alert);    

            }
            catch ( Exception error )
            {
                Program.logCoord.WriteOnlyTextLog("IOS PUSH error : " + error);
                return false;
            }
            return true;
        }

        public bool SendPushMessage()
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
                String deviceID = "eae344d872fff9ef4a8e7beb53277645065af62a38b8e74a4b52c2b9d622536c";
                
                //deviceID = "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000";
                writer.Write( HexStringToByteArray( deviceID.ToUpper() ) );

                String msg = "Hello?";
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
            }
            catch ( Exception error )
            {
                Program.logCoord.WriteLog( error );
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