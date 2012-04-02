using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace Server
{
    static class Program
    {
        /// <summary>
        /// 해당 응용 프로그램의 주 진입점입니다.
        /// </summary>
        [STAThread]
        static void Main()
        {

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault( false );
            Application.Run( new MainForm() );
        }

        public static LogCoordinator logCoord = null;
        public static DatabaseCoordinator dbCoord = null;
        public static PushProvider pushProvider = null;
        public static AndroidPushProvider androidPushProvider = null;
    }
}