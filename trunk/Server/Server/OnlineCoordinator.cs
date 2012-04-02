using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Server
{
    class OnlineCoordinator
    {
        public List<int> MentorStatus = null;
        public List<int> MenteeStatus = null;
        public List<string> OnlineMentor = null;
        public List<string> OnlineMentee = null;
        public Dictionary<string, string> accountToSession = null;
        private ListBox mentorListBox;
        private ListBox menteeListBox;
        private Label mentorLabel, menteeLabel;

        public OnlineCoordinator( ListBox mentorListBox, ListBox menteeListBox, Label mentorLabel, Label menteeLabel)
        {
            OnlineMentor = new List<string>();
            OnlineMentee = new List<string>();
            MentorStatus = new List<int>();
            MenteeStatus = new List<int>();
            accountToSession = new Dictionary<string, string>();
            this.mentorListBox = mentorListBox;
            this.menteeListBox = menteeListBox;
            this.mentorLabel = mentorLabel;
            this.menteeLabel = menteeLabel;
        }

        public void Login( string account )
        {
            string session = ( account + DateTime.Now ).GetHashCode().ToString();
            if ( Program.dbCoord.IsMentor( account ) )   // 멘토 로그인시
            {
                lock ( OnlineMentor )
                {
                    if ( !OnlineMentor.Contains( account ) )
                    {
                        MentorStatus.Add(-1);
                        OnlineMentor.Add( account );
                        mentorListBox.Items.Add( account );
                        mentorLabel.Text = "online mentor (" + mentorListBox.Items.Count + "명)";
                    }
                }
            }
            else // mentee
            {
                lock ( OnlineMentee )
                {
                    if ( !OnlineMentee.Contains( account ) )
                    {
                        MenteeStatus.Add(-1);
                        OnlineMentee.Add( account );
                        menteeListBox.Items.Add( account );
                        menteeLabel.Text = "online mentee (" + menteeListBox.Items.Count + "명)";
                    }
                }
            }
            lock ( accountToSession )
            {
                if ( accountToSession.ContainsKey( account ) )
                {
                    accountToSession[ account ] = session;
                }
                else
                {
                    accountToSession.Add( account, session );
                }
            }
        }
        public void Logout( string account )
        {
            if ( Program.dbCoord.IsMentor( account ) )
            {
                lock ( OnlineMentor )
                {
                    if ( OnlineMentor.Contains( account ) )
                    {
                        OnlineMentor.Remove(account);
                        mentorListBox.Items.Remove(account);
                    }
                }
            }
            else // mentee
            {
                lock ( OnlineMentee )
                {
                    if ( OnlineMentee.Contains( account ) )
                    {
                        OnlineMentee.Remove(account);
                        menteeListBox.Items.Remove(account);
                    }
                }
            }
            lock ( accountToSession )
            {
                if ( accountToSession.ContainsKey( account ) )
                {
                    accountToSession.Remove( account );
                }
            }
        }
        public string GetSession( string account )
        {
            if ( accountToSession.ContainsKey( account ) )
            {
                return accountToSession[ account ];
            }
            else
            {
                return "";
            }
        }
    }
}