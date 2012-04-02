using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using log4net;
using log4net.Config;

namespace Server
{

    class LogCoordinator
    {
        private TextBox logs = null;
        private delegate void WriteLogCallback( string log );
        private delegate void WriteExceptionCallback( Exception e );
        private ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public LogCoordinator( TextBox logs )
        {
            XmlConfigurator.Configure(new System.IO.FileInfo("log4net.xml"));
            this.logs = logs;
        }

        public void WriteOnlyTextLog(string log)
        {
                logger.Debug(log);
        }

        public void WriteOnlyTextError(string log)
        {
            logger.Error(log);
        }

        public void WriteLog( string log )
        {
            logger.Debug(log);

            lock ( logs )
            {
                if ( logs.InvokeRequired )
                {
                    WriteLogCallback writeLogCallback = new WriteLogCallback( WriteLog );
                    logs.Invoke( writeLogCallback );
                }
                else
                {
                    logs.AppendText( log + "\r\n" );
                }
            }
        }

        public void WriteLog( Exception e )
        {
            logger.Error(e.Message);

            lock ( logs )
            {
                if ( logs.InvokeRequired )
                {
                    WriteExceptionCallback writeLogCallback = new WriteExceptionCallback( WriteLog );
                    logs.Invoke( writeLogCallback );
                }
                else
                {
                    logs.AppendText( "Exception : " + e.Message + "\r\n" );
                    logs.AppendText( "------------ Call Stack ------------\r\n" );
                    logs.AppendText( e.StackTrace + "\r\n" );
                }
            }
        }

        public void ClearLog()
        {
            logs.Clear();
        }

    }
}