using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SQLite;
using System.IO;
using System.Data;

namespace Server
{
    class SqliteCoordinator
    {
        private SQLiteConnection connection = null;
        private SQLiteCommand command = null;
        private SQLiteDataReader reader = null;
        private object locker;
        private static string CreateChatsTableCommand = "create table Chats ( Id integer primary key, SenderAccount text, ReceiverAccount text, Chat text, SendedTime date );";
        private static string CreateMessagesTableCommand = "create table Messages ( Id integer primary key, SenderAccount text, ReceiverAccount text, Message text, SendedTime date );";
        private static string CreateHistoriesTableCommand = "create table Histories ( HistoryType text, RequestedId int, LastSendId int, RequestedTime date);";

        public SqliteCoordinator()
        {
            locker = new object();
        }

        private string DbPath( string account )
        {
            return @"C:\meeple\UserDb\" + account + ".db3";
        }
  
        private void Connect( string dbPath )
        {
            connection = new SQLiteConnection( "Data Source=" + dbPath + ";Version=3;New=True;Compress=True;" ); // sqlite connection string
            if ( !File.Exists( dbPath ) )
            {
                if ( connection.State == ConnectionState.Closed )
                {
                    connection.Open();
                }
                command = new SQLiteCommand( CreateChatsTableCommand, connection );
                command.ExecuteNonQuery();
                connection.Close();
                if ( connection.State == ConnectionState.Closed )
                {
                    connection.Open();
                }
                command = new SQLiteCommand( CreateMessagesTableCommand, connection );
                command.ExecuteNonQuery();
                connection.Close();
                if ( connection.State == ConnectionState.Closed )
                {
                    connection.Open();
                }
                command = new SQLiteCommand( CreateHistoriesTableCommand, connection );
                command.ExecuteNonQuery();
                connection.Close();
            }
        }

        public void EndChatNew(string localAccount, string oppoAccount)
        {
            if (File.Exists(DbPath(localAccount + "_" + oppoAccount)))
            {
                try
                {
                    File.Move(DbPath(localAccount + "_" + oppoAccount), DbPath(localAccount + "_" + oppoAccount + DateTime.Today.ToString("yyyyMMddhmm")));
                }
                catch
                {
                    
                }
            }

            if (File.Exists(DbPath(oppoAccount + "_" + localAccount)))
            {
                try
                {
                    File.Move(DbPath(oppoAccount + "_" + localAccount), DbPath(oppoAccount + "_" + localAccount + DateTime.Today.ToString("yyyyMMddhmm")));
                }
                catch
                {

                }
            }
        }

        public int LastRequestedChat( string account )
        {
            lock ( locker )
            {
                try
                {
                    Connect( DbPath( account ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand( "select RequestedId from Histories where HistoryType='Chat'", connection );
                    reader = command.ExecuteReader();
                    int ret = -1;
                    if ( reader.Read() )
                    {
                        ret = Convert.ToInt32( reader[ "RequestedId" ] );
                    }
                    reader.Close();
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return -1;
                }
                finally
                {
                    if ( connection != null
                        && connection.State == ConnectionState.Open )
                    {
                        connection.Close();
                    }
                }
            }
        }



        public int LastSendMessageNew(string account)
        {
            lock (locker)
            {
                try
                {
                    Connect(DbPath(account));
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("select * from Histories where HistoryType='Message' order by rowid desc", connection);
                    reader = command.ExecuteReader();
                    int ret = -1;
                    if (reader.Read())
                    {
                        ret = Convert.ToInt32(reader["LastSendId"]);
                    }
                    reader.Close();
                    connection.Close();
                    return ret;
                }
                catch (Exception)
                {
                    return -1;
                }
                finally
                {
                    if (connection != null
                        && connection.State == ConnectionState.Open)
                    {
                        connection.Close();
                    }
                }
            }
        }

        public int LastSendedChatNew(string account, string oppoAccount)
        {
            lock (locker)
            {
                try
                {
                    Connect(DbPath(account + "_" + oppoAccount));
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("select * from Histories where HistoryType='Chat'", connection);
                    reader = command.ExecuteReader();
                    int ret = -1;
                    if (reader.Read())
                    {
                        ret = Convert.ToInt32(reader["LastSendId"]);
                    }
                    reader.Close();
                    connection.Close();
                    return ret;
                }
                catch (Exception)
                {
                    return -1;
                }
                finally
                {
                    if (connection != null
                        && connection.State == ConnectionState.Open)
                    {
                        connection.Close();
                    }
                }
            }
        }





        public int LastRequestedChatNew(string account, string oppoAccount)
        {
            lock (locker)
            {
                try
                {
                    Connect(DbPath(account+"_"+oppoAccount));
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("select * from Histories where HistoryType='Chat' order by rowid desc", connection);
                    reader = command.ExecuteReader();
                    int ret = -1;
                    if (reader.Read())
                    {
                        ret = Convert.ToInt32(reader["RequestedId"]);
                    }
                    reader.Close();
                    connection.Close();
                    return ret;
                }
                catch (Exception)
                {
                    return -1;
                }
                finally
                {
                    if (connection != null
                        && connection.State == ConnectionState.Open)
                    {
                        connection.Close();
                    }
                }
            }
        }

        // 실제 서버 DB에 있는 마지막 ChatId
        public int LastRealChatIDNew(string account, string oppoAccount)
        {
            lock (locker)
            {
                try
                {
                    Connect(DbPath(account + "_" + oppoAccount));
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("select * from Histories where HistoryType='Chat' order by rowid desc", connection);
                    reader = command.ExecuteReader();
                    int ret = -1;
                    if (reader.Read())
                    {
                        ret = Convert.ToInt32(reader["LastSendId"]);
                    }
                    reader.Close();
                    connection.Close();
                    return ret;
                }
                catch (Exception)
                {
                    return -1;
                }
                finally
                {
                    if (connection != null
                        && connection.State == ConnectionState.Open)
                    {
                        connection.Close();
                    }
                }
            }
        }




        public int LastRequestedMessage( string account )
        {
            lock ( locker )
            {
                try
                {
                    Connect( DbPath( account ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand( "select RequestedId from Histories where HistoryType='Message'", connection );
                    reader = command.ExecuteReader();
                    int ret = -1;
                    if ( reader.Read() )
                    {
                        ret = Convert.ToInt32( reader[ "RequestedId" ] );
                    }
                    reader.Close();
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return -1;
                }
                finally
                {
                    if ( connection != null
                        && connection.State == ConnectionState.Open )
                    {
                        connection.Close();
                    }
                }
            }
        }

        public bool WriteChat( string localAccount, string oppoAccount, string chat )
        {
            lock ( locker )
            {
                try
                {
                    Connect( DbPath( localAccount ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("insert into Chats values ( NULL, '" + localAccount + "', '" + oppoAccount + "', '" + chat + "', date('now','localtime') );", connection);
                    command.ExecuteNonQuery();
                    connection.Close();
                    Connect( DbPath( oppoAccount ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("insert into Chats values ( NULL, '" + localAccount + "', '" + oppoAccount + "', '" + chat + "', date('now','localtime') );", connection);
                    command.ExecuteNonQuery();
                    connection.Close();
                    return true;
                }
                catch ( Exception )
                {
                    return false;
                }
                finally
                {
                    if ( connection != null
                        && connection.State == ConnectionState.Open )
                    {
                        connection.Close();
                    }
                }
            }
        }

        public bool WriteChatNew(string localAccount, string oppoAccount, string chat)
        {
            lock (locker)
            {
                try
                {
                    Connect(DbPath(localAccount + "_" + oppoAccount));
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("insert into Chats values ( NULL, '" + localAccount + "', '" + oppoAccount + "', '" + chat + "', strftime('%Y-%m-%d %H:%M:%S','now','localtime') );", connection);
                    command.ExecuteNonQuery();
                    connection.Close();
                    Connect(DbPath(oppoAccount+"_"+localAccount));
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("insert into Chats values ( NULL, '" + localAccount + "', '" + oppoAccount + "', '" + chat + "', strftime('%Y-%m-%d %H:%M:%S','now','localtime') );", connection);
                    command.ExecuteNonQuery();
                    connection.Close();
                    return true;
                }
                catch (Exception)
                {
                    return false;
                }
                finally
                {
                    if (connection != null
                        && connection.State == ConnectionState.Open)
                    {
                        connection.Close();
                    }
                }
            }
        }

        public int GetTotalBadgeNum(string account, List<string> oppoAccounts)
        {
            int totalNum = 0;
            for (int i = 0; i < oppoAccounts.Count; i++)
            {
                string oppoAccount = oppoAccounts[i];

                int lastSendChat = LastSendedChatNew(account, oppoAccount);
                if (lastSendChat < 0)
                {
                    lastSendChat = 0;
                }
                lock (locker)
                {
                    try
                    {
                        Connect(DbPath(account + "_" + oppoAccount));
                        if (connection.State == ConnectionState.Closed)
                        {
                            connection.Open();
                        }
                        command = new SQLiteCommand("select Id - " + lastSendChat + " as count from Chats where Id>" + lastSendChat + " order by Id desc limit 1;", connection);
                        reader = command.ExecuteReader();
                        while (reader.Read())
                        {
                            totalNum = totalNum + Convert.ToInt32(reader["count"]);
                        }
                        reader.Close();
                        connection.Close();
                    }
                    catch (Exception)
                    {
                    }
                    finally
                    {
                        if (connection != null
                            && connection.State == ConnectionState.Open)
                        {
                            connection.Close();
                        }
                    }
                }
            }
            int lastSendMessage = LastSendMessageNew(account);
            if (lastSendMessage < 0)
            {
                lastSendMessage = 0;
            }
            lock (locker)
            {
                try
                {
                    Connect(DbPath(account));
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("select Id - " + lastSendMessage + " as count from Messages where Id>" + lastSendMessage + " order by Id desc limit 1;", connection);
                    reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        totalNum = totalNum + Convert.ToInt32(reader["count"]);
                    }
                    reader.Close();
                    connection.Close();
                }
                catch (Exception)
                {
                }
                finally
                {
                    if (connection != null
                        && connection.State == ConnectionState.Open)
                    {
                        connection.Close();
                    }
                }
            }
            return totalNum;
        }
        public List<RecentChat> GetRecentChatsNew(string account, List<string> oppoAccounts)
        {
            List<RecentChat> ret = new List<RecentChat>();
            for(int i=0;i<oppoAccounts.Count;i++)
            {
                string oppoAccount = oppoAccounts[i];

                int lastSendChat = LastSendedChatNew(account, oppoAccount);
                if (lastSendChat < 0)
                {
                    lastSendChat = 0;
                }
                lock (locker)
                {
                    try
                    {
                        Connect(DbPath(account + "_" + oppoAccount));
                        if (connection.State == ConnectionState.Closed)
                        {
                            connection.Open();
                        }
                        command = new SQLiteCommand("select *, Id - " + lastSendChat + " as count from Chats where Id>=" + lastSendChat + " order by Id desc limit 1;", connection);
                        reader = command.ExecuteReader();
                        while (reader.Read())
                        {
                            ret.Add(new RecentChat(reader["SenderAccount"].ToString(), reader["ReceiverAccount"].ToString(), reader["Chat"].ToString(), ((DateTime)reader["SendedTime"]).ToString("yyyy.MM.dd tt h:mm"), reader["Id"].ToString() ,reader["count"].ToString()));
                        }
                        reader.Close();
                        connection.Close();
                    }
                    catch (Exception)
                    {
                    }
                    finally
                    {
                        if (connection != null
                            && connection.State == ConnectionState.Open)
                        {
                            connection.Close();
                        }
                    }
                }
            }
            return ret;
        }

        public List<Chat> GetChatsNew(string account, string oppoAccount, int chatId)
        {
            int lastRequestedChat = LastRequestedChatNew(account,oppoAccount);
            int lastSendChat = LastSendedChatNew(account, oppoAccount);
            if (lastSendChat < chatId)
            {
                lastSendChat = chatId;
            }
            lock (locker)
            {
                try
                {
                    Connect(DbPath(account + "_" + oppoAccount));
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("select * from Chats where Id>" + chatId + ";", connection);
                    reader = command.ExecuteReader();
                    
                    List<Chat> ret = new List<Chat>();
                    while (reader.Read())
                    {
                        ret.Add(new Chat(reader["SenderAccount"].ToString(), reader["ReceiverAccount"].ToString(), reader["Chat"].ToString(), ((DateTime)reader["SendedTime"]).ToString("yyyy.MM.dd tt h:mm"), reader["Id"].ToString()));
                        lastSendChat = Convert.ToInt32(reader["Id"]);
                    }
                    reader.Close();
                    connection.Close();
                    if (lastRequestedChat == -1)
                    {
                        if (connection.State == ConnectionState.Closed)
                        {
                            connection.Open();
                        }
                        command = new SQLiteCommand("insert into Histories (HistoryType, RequestedId, LastSendId, RequestedTime) values ( 'Chat', " + chatId + "," + lastSendChat + ",datetime('now','localtime') );", connection);
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                    else if (lastRequestedChat >= 0)
                    {
                        if (connection.State == ConnectionState.Closed)
                        {
                            connection.Open();
                        }
                        command = new SQLiteCommand("update Histories set RequestedId=" + chatId + ", LastSendId=" + lastSendChat + ", RequestedTime=datetime('now','localtime') where HistoryType='Chat';", connection);
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                    return ret;
                }
                catch (Exception)
                {
                    return new List<Chat>();
                }
                finally
                {
                    if (connection != null
                        && connection.State == ConnectionState.Open)
                    {
                        connection.Close();
                    }
                }
            }
        }

        public bool CheckChats( string account )
        {
            int lastRequestedChat = LastRequestedChat( account );
            lock ( locker )
            {
                try
                {
                    Connect( DbPath( account ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand( "select * from Chats where Id>" + lastRequestedChat + ";", connection );
                    reader = command.ExecuteReader();
                    bool ret = false;
                    if ( reader.Read() )
                    {
                        ret = true;
                    }
                    reader.Close();
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return false;
                }
                finally
                {
                    if ( connection != null
                        && connection.State == ConnectionState.Open )
                    {
                        connection.Close();
                    }
                }
            }
        }

        public bool CheckChatsNew(string account, string oppoAccount)
        {
            int lastRequestedChat = LastRequestedChat(account);
            lock (locker)
            {
                try
                {
                    Connect(DbPath(account+"_"+oppoAccount));
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("select * from Chats where Id>" + lastRequestedChat + ";", connection);
                    reader = command.ExecuteReader();
                    bool ret = false;
                    if (reader.Read())
                    {
                        ret = true;
                    }
                    reader.Close();
                    connection.Close();
                    return ret;
                }
                catch (Exception)
                {
                    return false;
                }
                finally
                {
                    if (connection != null
                        && connection.State == ConnectionState.Open)
                    {
                        connection.Close();
                    }
                }
            }
        }

        public bool WriteMessage( string localAccount, string oppoAccount, string chat )
        {
            lock ( locker )
            {
                try
                {
                    Connect( DbPath( localAccount ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("insert into Messages values ( NULL, '" + localAccount + "', '" + oppoAccount + "', '" + chat + "', strftime('%Y-%m-%d %H:%M:%S','now','localtime') );", connection);
                    command.ExecuteNonQuery();
                    connection.Close();
                    Connect( DbPath( oppoAccount ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand("insert into Messages values ( NULL, '" + localAccount + "', '" + oppoAccount + "', '" + chat + "', strftime('%Y-%m-%d %H:%M:%S','now','localtime') );", connection);
                    command.ExecuteNonQuery();
                    connection.Close();

                    return true;
                }
                catch ( Exception )
                {
                    return false;
                }
                finally
                {
                    if ( connection != null
                        && connection.State == ConnectionState.Open )
                    {
                        connection.Close();
                    }
                }
            }
        }
        public List<MessageWithId> GetMessagesFirst(string account)
        {
            int lastRequestedMessage = LastRequestedMessage(account);
            int lastSendMessage = LastSendMessageNew(account);
            if (lastSendMessage < 0)
            {
                lastSendMessage = 0;
            }
            
            lock ( locker )
            {
                try
                {
                    Connect( DbPath( account ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand( "select * from Messages where Id>" + lastSendMessage + ";", connection );
                    reader = command.ExecuteReader();
                    List<MessageWithId> ret = new List<MessageWithId>();
 
                    while ( reader.Read() )
                    {
                        ret.Add(new MessageWithId(reader["Id"].ToString(),reader["SenderAccount"].ToString(), reader["ReceiverAccount"].ToString(), reader["Message"].ToString(), ((DateTime)reader["SendedTime"]).ToString("yyyy.MM.dd")));
                        lastSendMessage = Convert.ToInt32(reader["Id"]);
                    }
                    reader.Close();
                    connection.Close();
                    if ( lastRequestedMessage == -1 )
                    {
                        if ( connection.State == ConnectionState.Closed )
                        {
                            connection.Open();
                        }
                        command = new SQLiteCommand("insert into Histories (HistoryType, RequestedId, RequestedTime, LastSendId) values ( 'Message', " + lastSendMessage + ", date('now','localtime')," + lastSendMessage + ");", connection);
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                    else if ( lastRequestedMessage >= 0 )
                    {
                        if ( connection.State == ConnectionState.Closed )
                        {
                            connection.Open();
                        }
                        command = new SQLiteCommand("update Histories set RequestedId=" + lastSendMessage + " ,RequestedTime=date('now','localtime'), lastSendId =" + lastSendMessage + " where HistoryType='Message';", connection);
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                    return ret;
                }
                catch ( Exception )
                {
                    return new List<MessageWithId>();
                }
                finally
                {
                    if ( connection != null
                        && connection.State == ConnectionState.Open )
                    {
                        connection.Close();
                    }
                }
            }
        }
        public List<Message> GetMessages( string account, int chatId )
        {
            int lastRequestedMessage = LastRequestedMessage( account );
            int lastSendMessage = LastSendMessageNew(account);
            if (lastSendMessage < chatId)
            {
                lastSendMessage = chatId;
            }
            lock ( locker )
            {
                try
                {
                    Connect( DbPath( account ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand( "select * from Messages where Id>" + chatId + ";", connection );
                    reader = command.ExecuteReader();
                    List<Message> ret = new List<Message>();
 
                    while ( reader.Read() )
                    {
                        ret.Add(new Message(reader["SenderAccount"].ToString(), reader["ReceiverAccount"].ToString(), reader["Message"].ToString(), ((DateTime)reader["SendedTime"]).ToString("yyyy.MM.dd")));
                        lastSendMessage = Convert.ToInt32(reader["Id"]);
                    }
                    reader.Close();
                    connection.Close();
                    if ( lastRequestedMessage == -1 )
                    {
                        if ( connection.State == ConnectionState.Closed )
                        {
                            connection.Open();
                        }
                        command = new SQLiteCommand("insert into Histories (HistoryType, RequestedId, RequestedTime, LastSendId) values ( 'Message', " + chatId + ", date('now','localtime')," + lastSendMessage + ");", connection);
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                    else if ( lastRequestedMessage >= 0 )
                    {
                        if ( connection.State == ConnectionState.Closed )
                        {
                            connection.Open();
                        }
                        command = new SQLiteCommand("update Histories set RequestedId=" + chatId + " ,RequestedTime=date('now','localtime'), lastSendId =" + lastSendMessage + " where HistoryType='Message';", connection);
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                    return ret;
                }
                catch ( Exception )
                {
                    return new List<Message>();
                }
                finally
                {
                    if ( connection != null
                        && connection.State == ConnectionState.Open )
                    {
                        connection.Close();
                    }
                }
            }
        }

        public bool CheckMessages( string account )
        {
            int lastRequestedMessage = LastRequestedMessage( account );
            lock ( locker )
            {
                try
                {
                    Connect( DbPath( account ) );
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    command = new SQLiteCommand( "select * from Messages where Id>" + lastRequestedMessage + ";", connection );
                    reader = command.ExecuteReader();
                    bool ret = false;
                    if ( reader.Read() )
                    {
                        ret = true;
                    }
                    reader.Close();
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return false;
                }
                finally
                {
                    if ( connection != null
                        && connection.State == ConnectionState.Open )
                    {
                        connection.Close();
                    }
                }
            }
        }
    }
}

/*
public List<Chat> GetChats( string account, int chatId )
{
    int lastRequestedChat = LastRequestedChat( account );
    lock ( locker )
    {
        try
        {
            Connect( DbPath( account ) );
            if ( connection.State == ConnectionState.Closed )
            {
                connection.Open();
            }
            command = new SQLiteCommand( "select * from Chats where Id>" + chatId + ";", connection );
            reader = command.ExecuteReader();
            List<Chat> ret = new List<Chat>();
            while ( reader.Read() )
            {
                ret.Add( new Chat( reader[ "SenderAccount" ].ToString(), reader[ "ReceiverAccount" ].ToString(), reader[ "Chat" ].ToString(), reader[ "SendedTime" ].ToString() ) );
            }
            reader.Close();
            connection.Close();
            if ( lastRequestedChat == -1 )
            {
                if ( connection.State == ConnectionState.Closed )
                {
                    connection.Open();
                }
                command = new SQLiteCommand( "insert into Histories values ( 'Chat', " + chatId + ", date('now');", connection );
                command.ExecuteNonQuery();
                connection.Close();
            }
            else if ( lastRequestedChat >= 0 )
            {
                if ( connection.State == ConnectionState.Closed )
                {
                    connection.Open();
                }
                command = new SQLiteCommand( "update Histories set RequestedId=" + chatId + " RequestedTime=date('now') where HistoryType='Chat';", connection );
                command.ExecuteNonQuery();
                connection.Close();
            }
            return ret;
        }
        catch ( Exception )
        {
            return new List<Chat>();
        }
        finally
        {
            if ( connection != null
                && connection.State == ConnectionState.Open )
            {
                connection.Close();
            }
        }
    }
}
 */