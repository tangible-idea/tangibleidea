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
using System.Threading;

namespace Server
{
    // 푸시를 보내는 스레드
    //public class SendPushThread
    //{
    //    public void Send()
    //    {
    //    }
    //}

    public partial class MainForm : Form
    {
        ServiceHost serviceHost = null;
        public MainForm()
        {
            InitializeComponent();
            Program.logCoord = new LogCoordinator(logs);
            Program.dbCoord = new DatabaseCoordinator();
            //Program.pushProvider = new PushProvider("gateway.sandbox.push.apple.com", 2195, @"..\..\PushServerCert.p12", "tangible.idea");
            Program.pushProvider = new PushProvider("gateway.push.apple.com", 2195, @"..\..\cert.p12", "tangible.idea");
            Program.androidPushProvider = new AndroidPushProvider();
            
        }
      

        private void Form1_Load( object sender, EventArgs e )
        {
            serviceHost = new ServiceHost( typeof( MeepleService ), new Uri( "http://" + Environment.MachineName + ":9093/MeepleService" ) );
            WebHttpBinding webHttpBinding = new WebHttpBinding();
            webHttpBinding.ReaderQuotas.MaxStringContentLength = 1000000;
            webHttpBinding.MaxReceivedMessageSize = int.MaxValue;
            
            serviceHost.AddServiceEndpoint( typeof( IMeepleService ), webHttpBinding, "" ).Behaviors.Add( new WebHttpBehavior() );
            serviceHost.Open();
           
        }

        private void Form1_FormClosed( object sender, FormClosedEventArgs e )
        {
            serviceHost.Close();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            if (textBox1.TextLength == 0)
                button1.Enabled = false;
            else
                button1.Enabled = true;

            lblTextLenth.Text = textBox1.TextLength.ToString() + "/127글자";
        }

        private void SendPush()
        {
            String text = textBox1.Text;
            List<IdAndPush> pushlist = Program.dbCoord.GetIdAndPush();
            int count1 = 0, count2 = 0;

            foreach (IdAndPush temp in pushlist)    // 푸시리스트를 돌면서
            {
                if (temp.isApple && temp.push == "0000000000000000000000000000000000000000000000000000000000000000")
                {
                    continue;
                }
                if (!temp.isApple && temp.androidpush == "0")
                {
                    continue;
                }

                if (chkTarget.Checked)
                {
                    if (temp.userId == txtTarget.Text)
                    {
                        if (temp.isApple)
                        {
                            Program.pushProvider.SendPushMessage(text, temp.push);
                            this.Invoke(new MethodInvoker(delegate()
                            {
                                    Program.logCoord.WriteLog("Id :[" + temp.userId + "] Push :[" + temp.push + "] 푸쉬 전달 완료");
                            }));
                            
                        }
                        else
                        {
                            
                            this.Invoke(new MethodInvoker(delegate()
                            {
                                if( Program.androidPushProvider.sendMessage(temp.androidpush, text, "notice") )
                                    Program.logCoord.WriteLog("Id :[" + temp.userId + "] Push :[" + temp.androidpush.Substring(0, 64) + "...] 푸쉬 전달 완료");
                                else
                                    Program.logCoord.WriteLog("Id :[" + temp.userId + "] 푸쉬 전달 오류");
                            }));
                            
                        }
                    }
                    continue;
                }

                if (temp.isApple)   // 아이폰이면
                {
                    if (chkIOS.Checked)
                    {
                        if (chkMentor.Checked && temp.isMentor) // 멘토에 체크되어있으면
                        {
                            Program.pushProvider.SendPushMessage(text, temp.push);
                            this.Invoke(new MethodInvoker(delegate()
                            {
                                Program.logCoord.WriteLog("Id :[" + temp.userId + "] Push :[" + temp.push + "] 푸쉬 전달 완료");
                            }));
                            count1++;
                        }
                        if (chkMentee.Checked && !temp.isMentor) // 멘티에 체크되어있으면
                        {
                            Program.pushProvider.SendPushMessage(text, temp.push);
                            this.Invoke(new MethodInvoker(delegate()
                            {
                                Program.logCoord.WriteLog("Id :[" + temp.userId + "] Push :[" + temp.push + "] 푸쉬 전달 완료");
                            }));
                            count1++;
                        }
                    }
                    else
                    {
                        this.Invoke(new MethodInvoker(delegate()
                        {
                            Program.logCoord.WriteLog("Id :[" + temp.userId + "] 아이폰 체크해제 되어 있어서 푸시 안보냄");
                        }));
                    }
                }
                else // 안드로이드면
                {
                    if (chkAndroid.Checked) // 안드로이드 체크ㅇ
                    {
                        if (chkMentor.Checked && temp.isMentor) // 멘토에 체크되어있으면
                        {   
                            this.Invoke(new MethodInvoker(delegate()
                            {
                                if(Program.androidPushProvider.sendMessage(temp.androidpush, text, "notice"))
                                    Program.logCoord.WriteLog("Id :[" + temp.userId + "] Push :[" + temp.androidpush.Substring(0, 64) + "...] 푸쉬 전달 완료");
                                else
                                    Program.logCoord.WriteLog("Id :[" + temp.userId + "] 푸쉬 전달 오류");
                            }));
                            count2++;
                        }
                        if (chkMentee.Checked && !temp.isMentor) // 멘티에 체크되어있으면
                        {   
                            this.Invoke(new MethodInvoker(delegate()
                            {
                                if(Program.androidPushProvider.sendMessage(temp.androidpush, text, "notice"))
                                    Program.logCoord.WriteLog("Id :[" + temp.userId + "] Push :[" + temp.androidpush.Substring(0, 64) + "...] 푸쉬 전달 완료");
                                else
                                    Program.logCoord.WriteLog("Id :[" + temp.userId + "] 푸쉬 전달 오류");
                            }));
                            count2++;
                        }
                    }
                    else
                    {
                        this.Invoke(new MethodInvoker(delegate()
                        {
                            Program.logCoord.WriteLog("Id :[" + temp.userId + "] 안드로이드 체크해제 되어 있어서 푸시 안보냄");
                        }));
                    }
                }
            }
            int count = count1 + count2;
            this.Invoke(new MethodInvoker(delegate()
            {
                Program.logCoord.WriteLog("아이폰 " + count1 + " 명");
                Program.logCoord.WriteLog("안드로이드 " + count2 + " 명");
                Program.logCoord.WriteLog("총 " + count + " 명에게 푸쉬메세지를 전송했습니다");
                Program.logCoord.WriteLog("내용:[" + text + "]");

                txtTarget.Text = "";    // 지정 대상 ID 삭제
                if (chkInit.Checked)
                    textBox1.Text = ""; // 체크되어있으면 보낸 내용을 삭제
            }));


        }

        private void button1_Click(object sender, EventArgs e)
        {
            Thread t1 = new Thread(new ThreadStart(SendPush));
            t1.Start();
        }

        private void CheckTarget()
        {
            List<IdAndPush> pushlist = Program.dbCoord.GetIdAndPush();
            int count1 = 0, count2 = 0, count3 = 0, count4 = 0;

            foreach (IdAndPush temp in pushlist)    // 푸시리스트를 돌면서
            {


                if (temp.isApple && temp.push == "0000000000000000000000000000000000000000000000000000000000000000")
                {
                    continue;
                }
                if (!temp.isApple && temp.androidpush == "0")
                {
                    continue;
                }

                if (chkTarget.Checked)
                {
                    if (temp.userId == txtTarget.Text)
                    {
                        if (temp.isApple)
                        {
                            if (temp.isMentor)
                                count1++;
                            else
                                count2++;
                        }
                        else
                        {
                            if (temp.isMentor)
                                count3++;
                            else
                                count4++;
                        }
                    }
                    continue;
                }

                if (temp.isApple)   // 아이폰이면
                {
                    if (chkIOS.Checked)
                    {
                        if (chkMentor.Checked && temp.isMentor) // 멘토에 체크되어있으면
                        {
                            count1++;
                        }
                        if (chkMentee.Checked && !temp.isMentor) // 멘티에 체크되어있으면
                        {
                            count2++;
                        }
                    }
                    else
                    {
                    }
                }
                else // 안드로이드면
                {
                    if (chkAndroid.Checked) // 안드로이드 체크ㅇ
                    {
                        if (chkMentor.Checked && temp.isMentor) // 멘토에 체크되어있으면
                        {
                            count3++;
                        }
                        if (chkMentee.Checked && !temp.isMentor) // 멘티에 체크되어있으면
                        {
                            count4++;
                        }
                    }
                    else
                    {
                    }
                }
            }
            lblTarget.Text = "iOS(멘토) : " + count1 + "명        "
                                 + "iOS(멘티) : " + count2 + "명\n"
                                 + "Android(멘토) : " + count3 + "명        "
                                 + "ANdroid(멘티) : " + count4 + "명\n";

        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.CheckTarget();
        }

        private void chkMentee_CheckedChanged(object sender, EventArgs e)
        {
            this.CheckTarget();
        }

        private void chkMentor_CheckedChanged(object sender, EventArgs e)
        {
            this.CheckTarget();
        }

        private void chkIOS_CheckedChanged(object sender, EventArgs e)
        {
            this.CheckTarget();
        }

        private void chkAndroid_CheckedChanged(object sender, EventArgs e)
        {
            this.CheckTarget();
        }

        private void chkTarget_CheckedChanged(object sender, EventArgs e)
        {
            if (chkTarget.Checked)
            {
                chkAndroid.Enabled = false;
                chkIOS.Enabled = false;
                chkMentee.Enabled = false;
                chkMentor.Enabled = false;
                txtTarget.Enabled = true;
            }
            else
            {
                chkAndroid.Enabled = true;
                chkIOS.Enabled = true;
                chkMentee.Enabled = true;
                chkMentor.Enabled = true;
                txtTarget.Enabled = false;
            }
            
        }

        private void lblTarget_Click(object sender, EventArgs e)
        {

        }

        private void chkInit_CheckedChanged(object sender, EventArgs e)
        {
            
        }



    }
}