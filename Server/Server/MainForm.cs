using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.ServiceModel.Description;
using log4net;
using log4net.Config;
using System.Threading;

namespace Server
{
    public partial class MainForm : Form
    {
        ServiceHost serviceHost = null;
        private System.Timers.Timer timer = null;
        private System.Timers.Timer timer_AutoRecommendations = null;
        private static int nTimerCount = 0;
        private static int nAutoTimerCount = 0;

        public MainForm()
        {
            InitializeComponent();
            Program.logCoord = new LogCoordinator( logs );
            Program.dbCoord = new DatabaseCoordinator();
            Program.onlineCoord = new OnlineCoordinator( lstMentor, lstMentee , label1, label2); // dbCoord를 사용하기 때문에 dbCoord이 사용가능한 상태여야 한다.
            Program.sqliteCoord = new SqliteCoordinator();
            //Program.pushProvider = new PushProvider("gateway.sandbox.push.apple.com", 2195, @"..\..\PushServerCert.p12", "tangible.idea");
            Program.pushProvider = new PushProvider("gateway.push.apple.com", 2195, @"..\..\cert.p12", "tangible.idea");
            Program.AndroidPushProvider = new AndroidPushProvider();
            
            // 타이머 설정 부분
            timer = new System.Timers.Timer();
            timer.Interval = 300100;    // 추천 interval (5분)
            timer.Elapsed += new System.Timers.ElapsedEventHandler( timer_Elapsed );

            timer_AutoRecommendations = new System.Timers.Timer();
            timer_AutoRecommendations.Interval = 55000;    // 2분마다 자동으로 수락해주는 타이머 (55초 interval)
            timer_AutoRecommendations.Elapsed += new System.Timers.ElapsedEventHandler(timer_AutoRecommendations_Elapsed);
        }
        private static Random random = new Random();

        private List<string> ShuffleList(List<string> list)
        {
            if (list.Count > 1)
            {
                for (int i = list.Count - 1; i >= 0; i--)
                {
                    string tmp = list[i];
                    int randomIndex = random.Next(i + 1);

                    //Swap elements
                    list[i] = list[randomIndex];
                    list[randomIndex] = tmp;
                }
            }
            return list;
        }

        private void timer_AutoRecommendations_Elapsed()
        {
            Program.logCoord.WriteOnlyTextLog("===== 자동 추천 타이머 동작 =====");

            List<string> MentorAccounts = Program.dbCoord.AutoMenteeRecommendation();
            foreach (string mentorAccount in MentorAccounts)
            {
                Program.dbCoord.AutoMenteeRecommendationConfirm(mentorAccount);
                if (Program.dbCoord.IsApple(mentorAccount))   // 애플이면
                {
                    //Program.logCoord.WriteOnlyTextLog("----->매칭이 완료됬당. 멘토가 아이폰을 쓰고있으니까 아이폰 푸시를 날려주자");
                    int count = GetMenteeBadgeCount(mentorAccount);
                    string pushToken = Program.dbCoord.GetDeviceToken(mentorAccount);
                    Program.pushProvider.SendPushMessage(pushToken, "새로운 멘티가 추천되었습니다. 확인해주세요.", count, "default", "3");
                }
                else
                {
                    //Program.logCoord.WriteOnlyTextLog("----->매칭이 완료됬당. 멘토가 안드로이드를 쓰고있으니까 안드로이드 푸시를 날려주자");
                    string androidToken = Program.dbCoord.GetAndroidDeviceToken(mentorAccount);
                    Program.AndroidPushProvider.sendMessage(androidToken, "새로운 멘티가 추천되었습니다. 확인해주세요.", "recommend");
                }
            }

            List<string> MenteeAccounts = Program.dbCoord.AutoMentorRecommendation();
            foreach (string menteeAccount in MenteeAccounts)
            {
                Program.dbCoord.AutoMentorRecommendationConfirm(menteeAccount);
                if (Program.dbCoord.IsApple(menteeAccount))   // 애플이면
                {
                    //Program.logCoord.WriteOnlyTextLog("----->매칭이 완료됬당. 멘토가 아이폰을 쓰고있으니까 아이폰 푸시를 날려주자");
                    int count = GetMenteeBadgeCount(menteeAccount);
                    string pushToken = Program.dbCoord.GetDeviceToken(menteeAccount);
                    Program.pushProvider.SendPushMessage(pushToken, "새로운 멘티가 추천되었습니다. 확인해주세요.", count, "default", "3");
                }
                else
                {
                    //Program.logCoord.WriteOnlyTextLog("----->매칭이 완료됬당. 멘토가 안드로이드를 쓰고있으니까 안드로이드 푸시를 날려주자");
                    string androidToken = Program.dbCoord.GetAndroidDeviceToken(menteeAccount);
                    Program.AndroidPushProvider.sendMessage(androidToken, "새로운 멘티가 추천되었습니다. 확인해주세요.", "recommend");
                }
            }
        }


        private void timer_AutoRecommendations_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            Thread t2 = new Thread(new ThreadStart(timer_AutoRecommendations_Elapsed));
            t2.Start();
        }

        private void timer_Elapsed_Thread()
        {

            ++nTimerCount;
            if (nTimerCount == 288) // 하루가 지나면 카운트 초기화
            {
                nTimerCount = 0;
                Program.logCoord.ClearLog();    // 로그 클리어
            }

            Program.logCoord.WriteOnlyTextLog("=====하루중 " + nTimerCount + "번째 타이머 도달했습니다.=====");

            //Program.logCoord.WriteLog("timer_Elapsed");
            //if ( DateTime.Now.Hour >= 7 && DateTime.Now.Hour < 24 )// && DateTime.Now.Minute % 43 == 0 )
            Program.dbCoord.DeleteRecommendations();
            Program.onlineCoord.OnlineMentor = ShuffleList(Program.onlineCoord.OnlineMentor);    // 멘ta토리스트를 셔플해준다.

            foreach (string mentorAccount in Program.onlineCoord.OnlineMentor)
            {//
                //Program.logCoord.WriteOnlyTextLog(">멘토 " + mentorAccount + "에게 추천해줄 멘티를 찾아보자");
                int numberOfMentees = Program.dbCoord.CountMentorRecommendation(mentorAccount);   // 멘토 계정에 추천되어있는 멘티 수
                // Program.logCoord.WriteOnlyTextLog("->이 멘토에게 할당된 "+numberOfMentees+"명의 멘티가 있군...");
                if (numberOfMentees < 3) // 가 3명 미만이면
                {
                    //Program.logCoord.WriteOnlyTextLog("-->이 멘토에게 "+ (3-numberOfMentees)+"명의 멘티를 더 붙여주자");
                    for (int i = 0; i < 3 - numberOfMentees; i++) // 필요한 멘티수 만큼 추천을 추가해줌 : 3-(추천수)
                    {
                        foreach (string menteeAccount in Program.onlineCoord.OnlineMentee) // 한번이라도 접속한 멘티중에서 
                        {
                            //Program.logCoord.WriteOnlyTextLog("--->멘티 " + menteeAccount+"는 어떨까..?");
                            if (Program.dbCoord.CountMenteeRecommendation(menteeAccount) == 0)  // 멘토의 추천이 없는 멘티만 골라서
                            {
                                // Program.logCoord.WriteOnlyTextLog("---->이 멘티는 멘토가 없군! 매칭 시켜줘야겟다! ["+mentorAccount+"]<-매칭준비->["+menteeAccount+"]");
                                if (Program.dbCoord.AddRecommendation(mentorAccount, menteeAccount) == 0)   // 추천해줌
                                {
                                    if (Program.dbCoord.IsApple(mentorAccount))   // 애플이면
                                    {
                                        //Program.logCoord.WriteOnlyTextLog("----->매칭이 완료됬당. 멘토가 아이폰을 쓰고있으니까 아이폰 푸시를 날려주자");
                                        int count = GetMenteeBadgeCount(mentorAccount);
                                        string pushToken = Program.dbCoord.GetDeviceToken(mentorAccount);
                                        Program.pushProvider.SendPushMessage(pushToken, "새로운 멘티가 추천되었습니다. 확인해주세요.", count, "default", "3");
                                    }
                                    else
                                    {
                                        //Program.logCoord.WriteOnlyTextLog("----->매칭이 완료됬당. 멘토가 안드로이드를 쓰고있으니까 안드로이드 푸시를 날려주자");
                                        string androidToken = Program.dbCoord.GetAndroidDeviceToken(mentorAccount);
                                        Program.AndroidPushProvider.sendMessage(androidToken, "새로운 멘티가 추천되었습니다. 확인해주세요.", "recommend");
                                    }
                                    break;
                                }
                                else
                                {
                                    //Program.logCoord.WriteOnlyTextLog("----->매칭이 실패했다. AddRecommendation에서.. [" + mentorAccount + "]<-/매칭실패/->[" + menteeAccount + "]");
                                }
                            }
                            else
                            {
                                //Program.logCoord.WriteOnlyTextLog("---->이 멘티는 멘토의 추천이 이미 있군... 다른 멘티를 찾아보자");
                            }
                        }
                        //Program.logCoord.WriteOnlyTextLog("--->더이상 온라인 멘티가 없군");
                    }
                }
                else
                {
                    //Program.logCoord.WriteOnlyTextLog("-->3명이니까 다음 멘토로 넘어가자");
                }
                //Program.logCoord.WriteOnlyTextLog("->그럼 다음 멘토로 넘어가자");
            }

            //Program.logCoord.WriteOnlyTextLog(">더 이상 온라인 멘토가 없군... 그러면 상태를 다시 한번 확인해보자");

            for (int i = 0; i < Program.onlineCoord.OnlineMentor.Count; ++i)
            {
                int nStat = Program.dbCoord.GetMentorActiveStatus(Program.onlineCoord.OnlineMentor[i]);
                Program.onlineCoord.MentorStatus[i] = nStat;

                //Program.logCoord.WriteOnlyTextLog("=>멘토 " + Program.onlineCoord.OnlineMentor[i] + "의 상태는 " + nStat + "이군...");
            }


            for (int i = 0; i < Program.onlineCoord.OnlineMentee.Count; ++i)
            {
                int nStat = Program.dbCoord.GetMenteeActiveStatus(Program.onlineCoord.OnlineMentee[i]);
                Program.onlineCoord.MenteeStatus[i] = nStat;

                //Program.logCoord.WriteOnlyTextLog("=>멘티 " + Program.onlineCoord.OnlineMentee[i] + "의 상태는 " + nStat + "이군...");
            }

            //Program.logCoord.WriteOnlyTextLog("=====타이머가 할일이 끝났다. 다음 타이머를 기다리자=====");
        }

        // 타이머 도달마다...
        private void timer_Elapsed( object sender, System.Timers.ElapsedEventArgs e )
        {
            Thread t1 = new Thread(new ThreadStart(timer_Elapsed_Thread));
            t1.Start();
        }


        private void lstMentor_DrawItem(object sender, System.Windows.Forms.DrawItemEventArgs e)
        {
            lstMentor.DrawMode = DrawMode.OwnerDrawFixed;
            e.DrawBackground();
            Brush myBrush = Brushes.Black;

            try
            {

                // Determine the color of the brush to draw each item based on the index of the item to draw.
                switch (Program.onlineCoord.MentorStatus[e.Index])
                {
                    case -1:
                        myBrush = Brushes.DarkGray; // 타이머 대기중
                        break;
                    case 0:
                        myBrush = Brushes.Black;  // 추천없음
                        break;
                    case 1:
                        myBrush = Brushes.DarkRed;  // 추천받음
                        break;
                    case 2:
                        myBrush = Brushes.DarkOrange;   // 멘토만 수락했음
                        break;
                    case 3:
                        myBrush = Brushes.DarkGreen; // 대화중
                        break;
                }

                // Draw the current item text based on the current Font and the custom brush settings.
                e.Graphics.DrawString(lstMentor.Items[e.Index].ToString(), e.Font, myBrush, e.Bounds, StringFormat.GenericDefault);
                // If the ListBox has focus, draw a focus rectangle around the selected item.
                e.DrawFocusRectangle();
            }
            catch
            {
            }
        }

        private void lstMentee_DrawItem(object sender, System.Windows.Forms.DrawItemEventArgs e)
        {
            lstMentee.DrawMode = DrawMode.OwnerDrawFixed;
            e.DrawBackground();
            Brush myBrush = Brushes.Black;


            try
            {
                // Determine the color of the brush to draw each item based on the index of the item to draw.
                switch (Program.onlineCoord.MenteeStatus[e.Index])
                {
                    case -1:
                        myBrush = Brushes.DarkGray; // 타이머 대기중
                        break;
                    case 0:
                        myBrush = Brushes.Black;  // 추천없음
                        break;
                    case 1:
                        myBrush = Brushes.DarkRed;  // 추천받음
                        break;
                    case 2:
                        myBrush = Brushes.DarkOrange;   // 멘토만 수락했음
                        break;
                    case 3:
                        myBrush = Brushes.DarkGreen; // 대화중
                        break;
                }

            

            // Draw the current item text based on the current Font and the custom brush settings.
            e.Graphics.DrawString(lstMentee.Items[e.Index].ToString(), e.Font, myBrush, e.Bounds, StringFormat.GenericDefault);
            // If the ListBox has focus, draw a focus rectangle around the selected item.
            e.DrawFocusRectangle();

            }
            catch
            {
            }
        }


        private void Form1_Load( object sender, EventArgs e )
        {
            String URI=  "http://" + Environment.MachineName + ":9091/MeepleService" ;
            
            //MainForm.ActiveForm.Text = "MEEPLE SERVER (" + URI + ")";

            serviceHost = new ServiceHost( typeof( MeepleService ), new Uri(URI) );
            WebHttpBinding webHttpBinding = new WebHttpBinding();
            webHttpBinding.ReaderQuotas.MaxStringContentLength = 1000000;
            webHttpBinding.MaxReceivedMessageSize = int.MaxValue;
            
            serviceHost.AddServiceEndpoint( typeof( IMeepleService ), webHttpBinding, "" ).Behaviors.Add( new WebHttpBehavior() );
            serviceHost.Open();
            timer.Enabled = true;
            timer_AutoRecommendations.Enabled = true;
        }

        private void Form1_FormClosed( object sender, FormClosedEventArgs e )
        {
            serviceHost.Close();
        }


        public int GetMentorBadgeCount(string localAccount)
        {
            int totalnum = 0;
            List<string> mentees = Program.dbCoord.InProgressMenteeRecommendations(localAccount);
            totalnum = Program.sqliteCoord.GetTotalBadgeNum(localAccount, mentees);
            List<string> recommends = Program.dbCoord.PendingMenteeRecommendations(localAccount);
            if (recommends.Count >= 0)
            {
                totalnum += recommends.Count;
            }

            return totalnum;

        }
        public int GetMenteeBadgeCount(string localAccount)
        {
            int totalnum = 0;
            List<string> mentors = Program.dbCoord.InProgressMentorRecommendations(localAccount);
            totalnum = Program.sqliteCoord.GetTotalBadgeNum(localAccount, mentors);
            List<string> recommends = Program.dbCoord.PendingMentorRecommendations(localAccount);
            totalnum += recommends.Count;

            return totalnum;
        }

        private void btnLogout_Click(object sender, EventArgs e)
        {
            Program.onlineCoord.Logout(txtToAction.Text);
        }



    }
}