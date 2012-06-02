using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Server
{
    class DatabaseCoordinator
    {
        private SqlConnection connection = null;

        public DatabaseCoordinator()
        {
            connection = new SqlConnection("Password=sksmsrhksflwkek;Persist Security Info=True;User ID=DBAdmin;Initial Catalog=Meeple;Data Source=WINDOWS-2CFD36G\\SQLEXPRESS");
        }

        public List<IdAndPush> GetIdAndPush()
        {
            bool isApple, isMentor; // 얻어오는 ID가 아이폰or안드로이드 인지.. 멘티or멘토인지

            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("GetDeviceTokenAllUser", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    SqlDataReader reader = command.ExecuteReader();
                    List<IdAndPush> pushlist = new List<IdAndPush>();
                    while (reader.Read())
                    {
                        isApple= (bool)reader["isApple"];
                        isMentor= (bool)reader["isMentor"];

                        IdAndPush temp = new IdAndPush(reader["account"] as string, reader["push"] as string, isApple, reader["androidpush"] as string, isMentor);
                        pushlist.Add(temp);
                    }

                    connection.Close();
                    return pushlist;
                }
                catch (Exception)
                {
                    return new List<IdAndPush>();
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

        public List<string> PendingMenteeRecommendations(string menteeAccount)
        {
            lock (connection)
            {
                try
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        connection.Open();
                    }
                    SqlCommand command = new SqlCommand("PendingMenteeRecommendations", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@MenteeAccount", SqlDbType.NVarChar).Value = menteeAccount;
                    command.Parameters.Add("return_value", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
                    SqlDataReader reader = command.ExecuteReader();
                    List<string> ret = new List<string>();
                    while (reader.Read())
                    {
                        ret.Add(reader["MentorAccount"] as string);
                    }
                    connection.Close();
                    return ret;
                }
                catch (Exception)
                {
                    return new List<string>();
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
}