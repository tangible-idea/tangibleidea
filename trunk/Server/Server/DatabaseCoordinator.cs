using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Threading;

namespace Server
{
    class DatabaseCoordinator
    {
        private SqlConnection connection = null;

        public DatabaseCoordinator()
        {
            connection = new SqlConnection("Password=sksmsrhksflwkek;Persist Security Info=True;User ID=DBAdmin;Initial Catalog=Meeple;Data Source=WINDOWS-2CFD36G\\SQLEXPRESS");
        }

        // 성공하면 AccountId(> 0)를 리턴, 이미 아이디가 있거나 실패하면 -1을 리턴
        public int AddAccount( string account, string password, int gender, bool isApple, string push, bool isMentor, string Email, string AndroidPush)
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "AddAccount", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Password", SqlDbType.Char ).Value = password;
                    command.Parameters.Add( "@Gender", SqlDbType.Int ).Value = gender;
                    command.Parameters.Add( "@IsApple", SqlDbType.Bit ).Value = isApple;
                    command.Parameters.Add( "@Push", SqlDbType.Char ).Value = push;
                    command.Parameters.Add( "@AndroidPush", SqlDbType.Char).Value = AndroidPush;
                    command.Parameters.Add( "@IsMentor", SqlDbType.Bit ).Value = isMentor;
                    command.Parameters.Add( "@Email", SqlDbType.NVarChar).Value = Email;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int AddMentorInfo( int accountId, string name, string univ, string major, int promo, string email, string comment, string image )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "AddMentorInfo", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@AccountId", SqlDbType.Int ).Value = accountId;
                    command.Parameters.Add( "@Name", SqlDbType.NVarChar ).Value = name;
                    command.Parameters.Add( "@Univ", SqlDbType.NVarChar ).Value = univ;
                    command.Parameters.Add( "@Major", SqlDbType.NVarChar ).Value = major;
                    command.Parameters.Add( "@Promo", SqlDbType.Int ).Value = promo;
                    command.Parameters.Add( "@Email", SqlDbType.NVarChar ).Value = email;
                    command.Parameters.Add( "@Comment", SqlDbType.NVarChar ).Value = comment;
                    command.Parameters.Add( "@Image", SqlDbType.NVarChar ).Value = image;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int AddMenteeInfo( int accountId, string name, string school, int grade, string email, string comment, string image )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "AddMenteeInfo", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@AccountId", SqlDbType.Int ).Value = accountId;
                    command.Parameters.Add( "@Name", SqlDbType.NVarChar ).Value = name;
                    command.Parameters.Add( "@School", SqlDbType.NVarChar ).Value = school;
                    command.Parameters.Add( "@Grade", SqlDbType.Int ).Value = grade;
                    command.Parameters.Add( "@Email", SqlDbType.NVarChar ).Value = email;
                    command.Parameters.Add( "@Comment", SqlDbType.NVarChar ).Value = comment;
                    command.Parameters.Add( "@Image", SqlDbType.NVarChar ).Value = image;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int AddMentorInfoAndCategory(int accountId, string name, string univ, string major, int promo, string email, string comment, int category, string image)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("AddMentorInfoAndCategory", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@AccountId", SqlDbType.Int).Value = accountId;
                    command.Parameters.Add("@Name", SqlDbType.NVarChar).Value = name;
                    command.Parameters.Add("@Univ", SqlDbType.NVarChar).Value = univ;
                    command.Parameters.Add("@Major", SqlDbType.NVarChar).Value = major;
                    command.Parameters.Add("@Promo", SqlDbType.Int).Value = promo;
                    command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = email;
                    command.Parameters.Add("@Comment", SqlDbType.NVarChar).Value = comment;
                    command.Parameters.Add("@Category", SqlDbType.Int).Value = category;
                    command.Parameters.Add("@Image", SqlDbType.NVarChar).Value = image;
                    command.Parameters.Add("return_value", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32(command.Parameters["return_value"].Value);
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int AddMenteeInfoAndCategory(int accountId, string name, string school, int grade, string email, string comment, int category, string image)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("AddMenteeInfoAndCategory", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@AccountId", SqlDbType.Int).Value = accountId;
                    command.Parameters.Add("@Name", SqlDbType.NVarChar).Value = name;
                    command.Parameters.Add("@School", SqlDbType.NVarChar).Value = school;
                    command.Parameters.Add("@Grade", SqlDbType.Int).Value = grade;
                    command.Parameters.Add("@Email", SqlDbType.NVarChar).Value = email;
                    command.Parameters.Add("@Comment", SqlDbType.NVarChar).Value = comment;
                    command.Parameters.Add("@Category", SqlDbType.Int).Value = category;
                    command.Parameters.Add("@Image", SqlDbType.NVarChar).Value = image;
                    command.Parameters.Add("return_value", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32(command.Parameters["return_value"].Value);
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

        // 멘토인 경우 true, 멘티인 경우 false
        public string GetDeviceToken(string account)
        {
            string pushToken = null;
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("GetDeviceToken", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Account", SqlDbType.NVarChar).Value = account;
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        pushToken = reader["Push"] as string;
                    }
                    connection.Close();
                    return pushToken;
                }
                catch (Exception)
                {
                    return null;
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

        public string GetAndroidDeviceToken(string account)
        {
            string pushToken = null;
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("GetAndroidDeviceToken", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Account", SqlDbType.NVarChar).Value = account;
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        pushToken = reader["AndroidPush"] as string;
                    }
                    connection.Close();
                    return pushToken;
                }
                catch (Exception)
                {
                    return null;
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

        public bool IsMentor( string account )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "IsMentor", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    bool ret = Convert.ToBoolean( command.Parameters[ "return_value" ].Value );
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

        public bool IsApple(string account)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("IsApple", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Account", SqlDbType.NVarChar).Value = account;
                    command.Parameters.Add("return_value", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    bool ret = Convert.ToBoolean(command.Parameters["return_value"].Value);
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
        public void UpdatePush(string account, string push)
        {
            if (push != "0000000000000000000000000000000000000000000000000000000000000000")
            {
                lock (connection)
                {
                    try
                    {
                        if (connection.State == ConnectionState.Closed)
                        {
                            connection.Open();
                        }
                        SqlCommand command = new SqlCommand("UpdatePush", connection);
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Account", SqlDbType.NVarChar).Value = account;
                        command.Parameters.Add("@Push", SqlDbType.Char).Value = push;
                        command.Parameters.Add("@NewPush", SqlDbType.Char).Value = "0000000000000000000000000000000000000000000000000000000000000000";
                        //command.Parameters.Add("return_value", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
                        command.ExecuteNonQuery();
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
        }
        public void UpdateAndroidPush(string account, string androidpush)
        {
            if (androidpush != "0")
            {
                lock (connection)
                {
                    try
                    {
                        if (connection.State == ConnectionState.Closed)
                        {
                            connection.Open();
                        }
                        SqlCommand command = new SqlCommand("UpdateAndroidPush", connection);
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.Add("@Account", SqlDbType.NVarChar).Value = account;
                        command.Parameters.Add("@AndroidPush", SqlDbType.Char).Value = androidpush;
                        command.Parameters.Add("@NewAndroidPush", SqlDbType.Char).Value = "0";
                        //command.Parameters.Add("return_value", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
                        command.ExecuteNonQuery();
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
        }

        // 해당하는 계정 정보가 있을 경우 0보다 큰 값을 리턴, 없는 경우 0을 리턴, 실패할경우 -1을 리턴
        public int CheckAccount( string account, string password )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "CheckAccountPassword", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Password", SqlDbType.Char ).Value = password;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
                    connection.Close();
                    return ret;
                }
                catch ( Exception e )
                {
                    Program.logCoord.WriteLog("CheckAccountPassword::저장프로시저 에러\t" + e.Message);
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

        // 해당하는 계정 정보가 있을 경우 0보다 큰 값을 리턴, 없는 경우 0을 리턴, 실패할경우 -1을 리턴
        public int CheckAccount( string account )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "CheckAccount", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int UpdateAccount( string account, string password, string push)
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "UpdateAccount", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Password", SqlDbType.Char ).Value = password;
                    command.Parameters.Add( "@Push", SqlDbType.Char ).Value = push;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int UpdateAndroidAccount(string account, string password, string androidpush)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("UpdateAndroidAccount", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@Account", SqlDbType.NVarChar).Value = account;
                    command.Parameters.Add("@Password", SqlDbType.Char).Value = password;
                    command.Parameters.Add("@AndroidPush", SqlDbType.Char).Value = androidpush;
                    command.Parameters.Add("return_value", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32(command.Parameters["return_value"].Value);
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int AddRecommendation( string mentorAccount, string menteeAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "AddRecommendation", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MentorAccount", SqlDbType.NVarChar ).Value = mentorAccount;
                    command.Parameters.Add("@MenteeAccount", SqlDbType.NVarChar).Value = menteeAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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


        // 해당하는 대화중이 있을 경우 0보다 큰 값을 리턴, 없는 경우 0을 리턴, 실패할경우 -1을 리턴
        public int CheckRecommendation( string mentorAccount, string menteeAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "CheckRecommendation", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MentorAccount", SqlDbType.NVarChar ).Value = mentorAccount;
                    command.Parameters.Add( "@MenteeAccount", SqlDbType.NVarChar ).Value = menteeAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    //int mentor = Convert.ToInt32(command.Parameters["MentorAccepted"].Value);
                    //int mentee = Convert.ToInt32(command.Parameters["MenteeAccepted"].Value);
                    
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 멘토와 멘티의 관계를 조건없이 삭제한다. (대화를 종료했거나, 수락을 거절했을 경우에 해당)
        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int DeleteRecommendation( string mentorAccount, string menteeAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "DeleteRecommendation", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MentorAccount", SqlDbType.NVarChar ).Value = mentorAccount;
                    command.Parameters.Add( "@MenteeAccount", SqlDbType.NVarChar ).Value = menteeAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int DeleteRecommendations()
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "DeleteRecommendations", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        public int CountRecommendation( string account )
        {
            if ( IsMentor( account ) )
            {
                return CountMentorRecommendation( account );
            }
            else
            {
                return CountMenteeRecommendation( account );
            }
        }

        // 멘토가 몇명의 멘티와 연결되어있는지(추천 중인 것 포함) 리턴, 실패하면 0 리턴
        public int CountMentorRecommendation( string mentorAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "CountMentorRecommendation", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MentorAccount", SqlDbType.NVarChar ).Value = mentorAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
                    connection.Close();
                    ret = Math.Max( 0, ret );
                    return ret;
                }
                catch ( Exception )
                {
                    return 0;
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
        
        // 멘티가 몇명의 멘토와 연결되어있는지(추천 중인 것 포함) 리턴, 실패하면 0 리턴
        public int CountMenteeRecommendation( string menteeAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "CountMenteeRecommendation", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MenteeAccount", SqlDbType.NVarChar ).Value = menteeAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
                    connection.Close();
                    ret = Math.Max( 0, ret );
                    return ret;
                }
                catch ( Exception )
                {
                    return 0;
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

        // 추천중인 Mentee들의 Account List를 리턴
        public List<string> PendingMentorRecommendations( string mentorAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "PendingMentorRecommendations", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MentorAccount", SqlDbType.NVarChar ).Value = mentorAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = command.ExecuteReader();
                    List<string> ret = new List<string>();
                    while ( reader.Read() )
                    {
                        ret.Add( reader[ "MenteeAccount" ] as string );
                    }
                    connection.Close();
                    return ret;
                }
                catch ( Exception e )
                {
                    Program.logCoord.WriteLog("PendingMentorRecommendations::저장프로시저 에러\t"+e.Message);
                    return new List<string>();
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

        // 추천중인 Mentor들의 Account List를 리턴
        public List<string> PendingMenteeRecommendations( string menteeAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "PendingMenteeRecommendations", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MenteeAccount", SqlDbType.NVarChar ).Value = menteeAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = command.ExecuteReader();
                    List<string> ret = new List<string>();
                    while ( reader.Read() )
                    {
                        ret.Add( reader[ "MentorAccount" ] as string );
                    }
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return new List<string>();
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int AcceptMentorRecommendation( string mentorAccount, string menteeAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "AcceptMentorRecommendation", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MentorAccount", SqlDbType.NVarChar ).Value = mentorAccount;
                    command.Parameters.Add( "@MenteeAccount", SqlDbType.NVarChar ).Value = menteeAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int AcceptMenteeRecommendation( string menteeAccount, string mentorAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "AcceptMenteeRecommendation", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MentorAccount", SqlDbType.NVarChar ).Value = mentorAccount;
                    command.Parameters.Add( "@MenteeAccount", SqlDbType.NVarChar ).Value = menteeAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 대화중인 Mentee들의 Account List를 리턴
        public List<string> InProgressMenteeRecommendations( string mentorAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "InProgressMentorRecommendations", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MentorAccount", SqlDbType.NVarChar ).Value = mentorAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = command.ExecuteReader();
                    List<string> ret = new List<string>();
                    while ( reader.Read() )
                    {
                        ret.Add( reader[ "MenteeAccount" ] as string );
                    }
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return new List<string>();
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

        // 대화중인 Mentor들의 Account List를 리턴
        public List<string> InProgressMentorRecommendations( string menteeAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "InProgressMenteeRecommendations", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MenteeAccount", SqlDbType.NVarChar ).Value = menteeAccount;
                    //command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = command.ExecuteReader();
                    List<string> ret = new List<string>();
                    while ( reader.Read() )
                    {
                        ret.Add( reader[ "MentorAccount" ] as string );
                    }
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return new List<string>();
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

        // 대화중인 Mentor들의 Account List를 리턴
        public List<string> WaitingMenteeRecommendations( string mentorAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "WaitingMenteeRecommendations", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@MentorAccount", SqlDbType.NVarChar ).Value = mentorAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = command.ExecuteReader();
                    List<string> ret = new List<string>();
                    while ( reader.Read() )
                    {
                        ret.Add( reader[ "MenteeAccount" ] as string );
                    }
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return new List<string>();
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int AddRelation( string aAccount, string bAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "AddRelation", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@AAccount", SqlDbType.NVarChar ).Value = aAccount;
                    command.Parameters.Add( "@BAccount", SqlDbType.NVarChar ).Value = bAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int DeleteRelation( string aAccount, string bAccount )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "DeleteRelation", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@AAccount", SqlDbType.NVarChar ).Value = aAccount;
                    command.Parameters.Add( "@BAccount", SqlDbType.NVarChar ).Value = bAccount;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 1,0 상태이고 추천한지 2분이 된 리스트를 1,1으로 만들어준다.
        public List<string> AutoMenteeRecommendation()
        {
            lock (connection)
            {
                List<string> result = new List<string>();
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("AutoMenteeRecommendation", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    SqlDataReader reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        result.Add((reader["MentorAccount"] as string));
                    }
                    connection.Close();
                    return result;
                }
                catch (Exception)
                {
                    return result;
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

        // AutoMentorRecommendation 으로부터 MenteeAccount string을 받아서 confrim해준다.
        public int AutoMenteeRecommendationConfirm(string account)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("AutoMenteeRecommendationConfirm", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@MentorAccount", SqlDbType.NVarChar).Value = account;
                    SqlDataReader reader = command.ExecuteReader();
                    
                    int ret = Convert.ToInt32(command.Parameters["return_value"].Value);
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

        // 0,0 상태이고 추천한지 2분이 된 리스트를 1,0으로 만들어준다.
        public List<string> AutoMentorRecommendation()
        {
            lock (connection)
            {
                List<string> result = new List<string>();

                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("AutoMentorRecommendation", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    SqlDataReader reader = command.ExecuteReader();
                    

                    while (reader.Read())
                    {
                        result.Add((reader["MenteeAccount"] as string));
                    }
                    connection.Close();
                    return result;
                }
                catch (Exception)
                {
                    return result;
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

        // AutoMentorRecommendation 으로부터 MenteeAccount string을 받아서 confrim해준다.
        public int AutoMentorRecommendationConfirm(string account)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("AutoMentorRecommendationConfirm", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@MenteeAccount", SqlDbType.NVarChar).Value = account;
                    SqlDataReader reader = command.ExecuteReader();

                    int ret = Convert.ToInt32(command.Parameters["return_value"].Value);
                    connection.Close();
                    return ret;
                }
                catch (Exception e)
                {
                    //Console.WriteLine(e.ToString());
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

        // 즐찾에 추가한 Account List를 리턴
        public List<string> GetRelations( string account )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "GetRelations", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@AAccount", SqlDbType.NVarChar ).Value = account;
                    //command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = command.ExecuteReader();
                    List<string> ret = new List<string>();
                    while ( reader.Read() )
                    {
                        ret.Add( reader[ "BAccount" ] as string );
                    }
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return new List<string>();
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

        public MentorInfo GetMentorInfo( string account )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "GetMentorInfo", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = command.ExecuteReader();
                    MentorInfo ret;
                    if ( reader.Read() )
                    {
                        //ret = new MentorInfo( Convert.ToInt32( reader[ "AccountId" ] ), reader[ "Name" ] as string, reader[ "Univ" ] as string, reader[ "Major" ] as string, Convert.ToInt32( reader[ "Promo" ] ), reader[ "Email" ] as string, reader[ "Comment" ] as string, reader[ "Image" ] as string, Convert.ToDateTime( reader[ "LastModifiedTime" ] ) );
                        ret = new MentorInfo( account, reader[ "Name" ] as string, reader[ "Univ" ] as string, reader[ "Major" ] as string, Convert.ToInt32( reader[ "Promo" ] ), reader[ "Email" ] as string, reader[ "Comment" ] as string, reader[ "Image" ] as string, Convert.ToDateTime( reader[ "LastModifiedTime" ] ) );
                    }
                    else
                    {
                        ret = null;
                    }
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return null;
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

        public MenteeInfo GetMenteeInfo( string account )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "GetMenteeInfo", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = command.ExecuteReader();
                    MenteeInfo ret;
                    if ( reader.Read() )
                    {
                        //ret = new MenteeInfo( Convert.ToInt32( reader[ "AccountId" ] ), reader[ "Name" ] as string, reader[ "School" ] as string, Convert.ToInt32( reader[ "Grade" ] ), reader[ "Email" ] as string, reader[ "Comment" ] as string, reader[ "Image" ] as string, Convert.ToDateTime( reader[ "LastModifiedTime" ] ) );
                        ret = new MenteeInfo(account, reader["Name"] as string, reader["School"] as string, Convert.ToInt32(reader["Grade"]), reader["Email"] as string, reader["Comment"] as string, reader["Image"] as string, Convert.ToDateTime(reader["LastModifiedTime"]));
                    }
                    else
                    {
                        ret = null;
                    }
                    connection.Close();
                    return ret;
                }
                catch ( Exception )
                {
                    return null;
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int ChangeMentorInfo( string account, string name, int gender, string email, string univ, string major, int promo, string comment, string image )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "ChangeMentorInfo", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Name", SqlDbType.NVarChar ).Value = name;
                    command.Parameters.Add( "@Univ", SqlDbType.NVarChar ).Value = univ;
                    command.Parameters.Add( "@Major", SqlDbType.NVarChar ).Value = major;
                    command.Parameters.Add( "@Promo", SqlDbType.Int ).Value = promo;
                    command.Parameters.Add( "@Email", SqlDbType.NVarChar ).Value = email;
                    command.Parameters.Add( "@Comment", SqlDbType.NVarChar ).Value = comment;
                    command.Parameters.Add( "@Image", SqlDbType.NVarChar ).Value = image;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int ChangeMenteeInfo( string account, string name, int gender, string email, string school, int grade, string comment, string image )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "ChangeMenteeInfo", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Name", SqlDbType.NVarChar ).Value = name;
                    command.Parameters.Add( "@School", SqlDbType.NVarChar ).Value = school;
                    command.Parameters.Add( "@Grade", SqlDbType.Int ).Value = grade;
                    command.Parameters.Add( "@Email", SqlDbType.NVarChar ).Value = email;
                    command.Parameters.Add( "@Comment", SqlDbType.NVarChar ).Value = comment;
                    command.Parameters.Add( "@Image", SqlDbType.NVarChar ).Value = image;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int ChangeName( string account, string name )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "ChangeName", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Name", SqlDbType.NVarChar ).Value = name;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int ChangeMajor( string account, string major )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "ChangeMajor", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Major", SqlDbType.NVarChar ).Value = major;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int ChangePromo( string account, int promo )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "ChangePromo", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Promo", SqlDbType.Int ).Value = promo;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int ChangeGrade( string account, int grade )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "ChangeGrade", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Grade", SqlDbType.Int ).Value = grade;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int ChangeComment( string account, string comment )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "ChangeComment", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Comment", SqlDbType.NVarChar ).Value = comment;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int ChangeImage( string account, string image )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "ChangeImage", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@Image", SqlDbType.NVarChar ).Value = image;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        // 성공하면 0을 리턴, 실패하면 -1을 리턴
        public int ChangeSchool( string account, string school )
        {
            lock ( connection )
            {
                try
                {
                    if ( connection.State == ConnectionState.Closed )
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand( "ChangeSchool", connection );
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add( "@Account", SqlDbType.NVarChar ).Value = account;
                    command.Parameters.Add( "@School", SqlDbType.NVarChar ).Value = school;
                    command.Parameters.Add( "return_value", SqlDbType.Int ).Direction = ParameterDirection.ReturnValue;
                    command.ExecuteNonQuery();
                    int ret = Convert.ToInt32( command.Parameters[ "return_value" ].Value );
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

        public bool ReportUser(string localAccount, string oppoAccount, string content)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("ReportUser", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@ReportId", SqlDbType.NVarChar).Value = localAccount;
                    command.Parameters.Add("@ProblemId", SqlDbType.NVarChar).Value = oppoAccount;
                    command.Parameters.Add("@Reason", SqlDbType.NText).Value = content;
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

        // 멘토의 활성화 상태를 알려준다.
        // 1,1 : 대화중-> return 3;
        // 1,0 : 멘토만수락-> return 2;
        // 0,0 : 잠수-> return 1;
        // 없음 -> retrun 0;
        public int GetMentorActiveStatus(string localAccount)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("GetMentorRecommendation", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@MentorAccount", SqlDbType.NVarChar).Value = localAccount;
                    SqlDataReader reader = command.ExecuteReader();
                    bool isMentorAccepted = false;
                    bool isMenteeAccepted = false;

                    if (!reader.HasRows)
                    {
                        return 0;
                    }

                    while (reader.Read())
                    {
                        isMentorAccepted = (bool)reader["MentorAccepted"];
                        isMenteeAccepted = (bool)reader["MenteeAccepted"];

                        if (isMenteeAccepted && isMentorAccepted)
                        {
                            return 3;
                        }

                        if (isMentorAccepted == true)
                        {
                            return 2;
                        }
                    }

                    connection.Close();
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

            return 1;
        }

        // 멘티의 활성화 상태를 알려준다.
        // 1,1 : 대화중-> return 3;
        // 1,0 : 멘토만수락-> return 2;
        // 0,0 : 잠수-> return 1;
        // 없음 -> retrun 0;
        public int GetMenteeActiveStatus(string localAccount)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("GetMenteeRecommendation", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@MenteeAccount", SqlDbType.NVarChar).Value = localAccount;
                    SqlDataReader reader = command.ExecuteReader();
                    bool isMentorAccepted = false;
                    bool isMenteeAccepted = false;


                    if (!reader.HasRows)
                    {
                        return 0;
                    }

                    while (reader.Read())
                    {
                        isMentorAccepted = (bool)reader["MentorAccepted"];
                        isMenteeAccepted = (bool)reader["MenteeAccepted"];

                        if (isMenteeAccepted && isMentorAccepted)
                        {
                            return 3;
                        }

                        if (isMentorAccepted == true)
                        {
                            return 2;
                        }
                    }

                    connection.Close();
                }
                catch (Exception)
                {
                    return 0;
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

            return 1;
        }
    }
    

}