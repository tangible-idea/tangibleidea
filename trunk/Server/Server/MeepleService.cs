using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using AntsCode.Util;
using System.Drawing;
using System.Runtime.Serialization;

namespace Server
{
    public class MeepleService : IMeepleService
    {
        
        public bool SaveImage(string account, string session, Stream file)
        {
            /*
            if (Program.onlineCoord.GetSession(account) != session.Substring(0, Program.onlineCoord.GetSession(account).Length))
            {
                Program.logCoord.WriteLog(account + "\tsession이 틀렸음\t" + DateTime.Now);
                return false;
            }
            */
            MultipartParser parser = new MultipartParser(file);

            if (parser.Success)
            {
                // Save the file
                //SaveFile(parser.Filename, parser.ContentType, parser.FileContents);
                try
                {
                    // Open file for reading
                    System.IO.FileStream _FileStream = new System.IO.FileStream(@"E:\UserImage\" +account+ ".jpg", System.IO.FileMode.Create, System.IO.FileAccess.Write);

                    // Writes a block of bytes to this stream using data from a byte array.
                    _FileStream.Write(parser.FileContents, 0, parser.FileContents.Length);

                    // close file stream
                    _FileStream.Close();
                }
                catch
                {
                    // Error
                    Program.logCoord.WriteLog("file 쓰는 중 에러");
                    return false;
                }
            }
            else
            {
                Program.logCoord.WriteLog("parser error");
                return false;
            }

            Program.logCoord.WriteLog("upload Image id :" + account );
            return true;
        }

        
        public RegisterResponse RegisterMentor(string account, string password, bool isPush, string push, string name, int gender, string email, string univ, string major, int promo)
        {
            UTF8Encoding encoding = new UTF8Encoding();
            if (account.Length > 30
                || encoding.GetBytes(password).Length != 32
                || (gender != 1 && gender != 2)
                || name.Length > 10
                || email.Length > 100
                || univ.Length > 30
                || major.Length > 30
                || promo < 1900
                )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog(account + "라는 놈이 RegisterMentor를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now);
                return new RegisterResponse(false, "", "폼에 들어가야할 길이를 확인하세요");
            }
            else if (!isPush)
            {
                push = "0000000000000000000000000000000000000000000000000000000000000000";
            }

            bool isApple = true;      //
            string androidpush="0"; // 애플용 Mentor 가입이므로 이렇게 처리

            int accountId = Program.dbCoord.AddAccount(account, password, gender, isApple, push, true, email, androidpush);
            if (accountId > 0)
            {
                if (Program.dbCoord.AddMentorInfo(accountId, name, univ, major, promo, email, "", "") == 0)
                {
                    Program.dbCoord.UpdatePush(account, push);  // 푸시를 새로 업데이트함

                    Program.onlineCoord.Login(account);
                    Program.logCoord.WriteLog(account + "\tRegisterMentor 성공했음\tSession : " + Program.onlineCoord.GetSession(account) + "\t" + DateTime.Now);
                    return new RegisterResponse(true, Program.onlineCoord.GetSession(account), "");
                }
                else
                {
                    // 이 경우는 없어야 한다. AddMentorInfo의 경우 이미 값이 있는 경우는 update, 없는 경우는 insert를 하기 때문이다.
                    Program.logCoord.WriteLog(account + "\tDb에서 AddAccount는 됬는데 AddMentorInfo가 실행이 잘 안되서 망함\t" + DateTime.Now);
                    return new RegisterResponse(false, "", "없어야한다");
                }
            }
            else if (accountId == -1)
            {
                // 이미 아이디가 있는 경우 -1 혹은 Stored Procedure를 실행하면서 문제가 생겨 Accounts table에 등록되지 않은 경우
                Program.logCoord.WriteLog(account + "\tDb에서 AddAccount가 실행이 잘 안되서 망함\t" + DateTime.Now);
                return new RegisterResponse(false, "", "아이디가 중복되었습니다. 아이디를 변경해주세요.");
            }
            else if (accountId == -2)
            {
                Program.logCoord.WriteLog(account + "\t이메일이 중복되어 AddAcount 실행이 안됨\t" + DateTime.Now);
                return new RegisterResponse(false, "", "이메일이 중복되었습니다.이메일을 변경해주세요.");
            }
            else
            {
                Program.logCoord.WriteLog(account + "\tDb에서 AddAccount가 실행이 잘 안되서 망함\t" + DateTime.Now);
                return new RegisterResponse(false, "", " 시스템 오류입니다. 관리자에게 문의하세요. ");
            }

        }

        
        // 안드로이드용 Mentor가입 메서드
        public RegisterResponse RegisterMentorAndroid( string account, string password, bool isPush, string androidpush, string name, int gender, string email, string univ, string major, int promo )
        {

            UTF8Encoding encoding = new UTF8Encoding();
            if ( account.Length > 30
                || encoding.GetBytes( password ).Length != 32
                || ( gender != 1 && gender != 2 )
                || name.Length > 10
                || email.Length > 100
                || univ.Length > 30
                || major.Length > 30
                || promo < 1900
                )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 RegisterMentor를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return new RegisterResponse( false, "", "폼에 들어가야할 길이를 확인하세요" );
            }
            else if  ( !isPush )
            {
                androidpush = "0";
            }

            bool isApple = false;       //
            string push = "0000000000000000000000000000000000000000000000000000000000000000";          // 안드로이드용 설정

            int accountId = Program.dbCoord.AddAccount(account, password, gender, isApple, push, true, email, androidpush);
            if ( accountId > 0 )
            {
                if ( Program.dbCoord.AddMentorInfo( accountId, name, univ, major, promo, email, "", "" ) == 0 )
                {
                    Program.dbCoord.UpdateAndroidPush(account, androidpush);    // 안드로이드 푸시 정보 업데이트

                    Program.onlineCoord.Login( account );
                    Program.logCoord.WriteLog( account + "\tRegisterMentor 성공했음\tSession : " + Program.onlineCoord.GetSession( account ) + "\t" + DateTime.Now );
                    return new RegisterResponse( true, Program.onlineCoord.GetSession( account ),"" );
                }
                else
                {
                    // 이 경우는 없어야 한다. AddMentorInfo의 경우 이미 값이 있는 경우는 update, 없는 경우는 insert를 하기 때문이다.
                    Program.logCoord.WriteLog( account + "\tDb에서 AddAccount는 됬는데 AddMentorInfo가 실행이 잘 안되서 망함\t" + DateTime.Now );
                    return new RegisterResponse( false, "" ,"없어야한다");
                }
            }
            else if (accountId == -1)
            {
                // 이미 아이디가 있는 경우 -1 혹은 Stored Procedure를 실행하면서 문제가 생겨 Accounts table에 등록되지 않은 경우
                Program.logCoord.WriteLog(account + "\tDb에서 AddAccount가 실행이 잘 안되서 망함\t" + DateTime.Now);
                return new RegisterResponse(false, "", "아이디가 중복되었습니다. 아이디를 변경해주세요.");
            }
            else if (accountId == -2)
            {
                Program.logCoord.WriteLog(account + "\t이메일이 중복되어 AddAcount 실행이 안됨\t" + DateTime.Now);
                return new RegisterResponse(false, "", "이메일이 중복되었습니다.이메일을 변경해주세요.");
            }
            else
            {
                Program.logCoord.WriteLog(account + "\tDb에서 AddAccount가 실행이 잘 안되서 망함\t" + DateTime.Now);
                return new RegisterResponse(false, "", " 시스템 오류입니다. 관리자에게 문의하세요. ");
            }
            
        }



        // 애플용 mentee 가입 메서드
        public RegisterResponse RegisterMentee(string account, string password, bool isPush, string push, string name, int gender, string email, string school, int grade)
        {
            UTF8Encoding encoding = new UTF8Encoding();


            if (account.Length > 30                // 아이디 길이는 30자 미만
                || encoding.GetBytes(password).Length != 32   // MD5 암호화 길이가 32자이여야 한다.
                || (gender != 1 && gender != 2)   // 성별은 1(남자) 2(여자) 이여야함
                || name.Length > 10                 // 이름의 길이는 10자 미만
                || email.Length > 100               // 이메일 길이는 100자 미만
                || school.Length > 30               // 학교 길이는 30자 미만
               )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog(account + "라는 놈이 RegisterMentee를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now);
                return new RegisterResponse(false, "", "인자잘못");
            }
            else if (!isPush)
            {
                push = "0000000000000000000000000000000000000000000000000000000000000000";
            }

            bool isApple = true;
            string androidpush = "0";
            

            int accountId = Program.dbCoord.AddAccount(account, password, gender, isApple, push, false, email, androidpush);
            if (accountId > 0)
            {
                if (Program.dbCoord.AddMenteeInfo(accountId, name, school, grade, email, "", "") == 0)
                {
                    Program.dbCoord.UpdatePush(account, push);  // 푸시 새로고침

                    Program.onlineCoord.Login(account);
                    Program.logCoord.WriteLog(account + "\tRegisterMentee 성공했음\tSession : " + Program.onlineCoord.GetSession(account) + "\t" + DateTime.Now);
                    return new RegisterResponse(true, Program.onlineCoord.GetSession(account), "");
                }
                else
                {
                    // 이 경우는 없어야 한다. AddMentorInfo의 경우 이미 값이 있는 경우는 update, 없는 경우는 insert를 하기 때문이다.
                    Program.logCoord.WriteLog(account + "\tDb에서 AddAccount는 됬는데 AddMenteeInfo가 실행이 잘 안되서 망함\t" + DateTime.Now);
                    return new RegisterResponse(false, "", "시스템 오류");
                }
            }
            else if (accountId == -1)
            {
                // 이미 아이디가 있는 경우 -1 혹은 Stored Procedure를 실행하면서 문제가 생겨 Accounts table에 등록되지 않은 경우
                Program.logCoord.WriteLog(account + "\tDb에서 AddAccount가 실행이 잘 안되서 망함\t" + DateTime.Now);
                return new RegisterResponse(false, "", "아이디가 중복되었습니다. 아이디를 변경해주세요.");
            }
            else if (accountId == -2)
            {
                Program.logCoord.WriteLog(account + "\t이메일이 중복되어 AddAcount 실행이 안됨\t" + DateTime.Now);
                return new RegisterResponse(false, "", "이메일이 중복되었습니다.이메일을 변경해주세요.");
            }
            else
            {
                Program.logCoord.WriteLog(account + "\tDb에서 AddAccount가 실행이 잘 안되서 망함\t" + DateTime.Now);
                return new RegisterResponse(false, "", " 시스템 오류입니다. 관리자에게 문의하세요. ");
            }
        }



        // 안드로이드용 mentee 가입 메서드
        public RegisterResponse RegisterMenteeAndroid( string account, string password, bool isPush, string androidpush, string name, int gender, string email, string school, int grade )
        {
            UTF8Encoding encoding = new UTF8Encoding();


            if ( account.Length > 30                // 아이디 길이는 30자 미만
                || encoding.GetBytes( password ).Length != 32   // MD5 암호화 길이가 32자이여야 한다.
                || ( gender != 1 && gender != 2 )   // 성별은 1(남자) 2(여자) 이여야함
                || name.Length > 10                 // 이름의 길이는 10자 미만
                || email.Length > 100               // 이메일 길이는 100자 미만
                || school.Length > 30               // 학교 길이는 30자 미만
               )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 RegisterMentee를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return new RegisterResponse( false, "","인자잘못" );
            }
            else if  ( !isPush )
            {
                androidpush = "0";
            }

            bool isApple = false;
            string push = "0000000000000000000000000000000000000000000000000000000000000000";



            int accountId = Program.dbCoord.AddAccount(account, password, gender, isApple, push, false, email, androidpush);
            if ( accountId > 0 )
            {
                if ( Program.dbCoord.AddMenteeInfo( accountId, name, school, grade, email, "", "" ) == 0 )
                {
                    Program.dbCoord.UpdateAndroidPush(account, androidpush);    // 안드로이드 푸시 정보 업데이트

                    Program.onlineCoord.Login( account );
                    Program.logCoord.WriteLog( account + "\tRegisterMentee 성공했음\tSession : " + Program.onlineCoord.GetSession( account ) + "\t" + DateTime.Now );
                    return new RegisterResponse( true, Program.onlineCoord.GetSession( account ),"");
                }
                else
                {
                    // 이 경우는 없어야 한다. AddMentorInfo의 경우 이미 값이 있는 경우는 update, 없는 경우는 insert를 하기 때문이다.
                    Program.logCoord.WriteLog( account + "\tDb에서 AddAccount는 됬는데 AddMenteeInfo가 실행이 잘 안되서 망함\t" + DateTime.Now );
                    return new RegisterResponse( false, "" ,"시스템 오류");
                }
            }
            else if( accountId == -1)
            {
                // 이미 아이디가 있는 경우 -1 혹은 Stored Procedure를 실행하면서 문제가 생겨 Accounts table에 등록되지 않은 경우
                Program.logCoord.WriteLog( account + "\tDb에서 AddAccount가 실행이 잘 안되서 망함\t" + DateTime.Now );
                return new RegisterResponse( false, "","아이디가 중복되었습니다. 아이디를 변경해주세요.");
            }
            else if (accountId == -2)
            {
                Program.logCoord.WriteLog(account + "\t이메일이 중복되어 AddAcount 실행이 안됨\t" + DateTime.Now);
                return new RegisterResponse(false, "", "이메일이 중복되었습니다.이메일을 변경해주세요.");
            }
            else
            {
                Program.logCoord.WriteLog(account + "\tDb에서 AddAccount가 실행이 잘 안되서 망함\t" + DateTime.Now);
                return new RegisterResponse(false, "", " 시스템 오류입니다. 관리자에게 문의하세요. ");
            }
        }

        public bool CheckLogin(string localAccount, string session)
        {
            //if (Program.onlineCoord.GetSession(localAccount) != session.Substring(0, Program.onlineCoord.GetSession(localAccount).Length))
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t(check login)" + DateTime.Now);
                return false;
            }
            return true;
        }

        public LoginResponse Login(string account, string password, bool isPush, string push)
        {
            UTF8Encoding encoding = new UTF8Encoding();
            if (account.Length > 30 || encoding.GetBytes(password).Length != 32 ) // 아이디가 30자가 넘거나 MD5로 제대로 인코딩 안됬으면
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog(account + "라는 놈이 Login를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now);
                return new LoginResponse();
            }
            else if (!isPush)
            {
                push = "0000000000000000000000000000000000000000000000000000000000000000";
            }

            if (Program.dbCoord.CheckAccount(account, password) > 0)
            {
                if (Program.dbCoord.UpdateAccount(account, password, push) == 0)
                {
                    // update를 통해 account의 push를 바꿔준다.
                    Program.dbCoord.UpdatePush(account, push);

                    Program.onlineCoord.Login(account);
                    Program.logCoord.WriteLog(account + "\tLogin 성공했음\tSession : " + Program.onlineCoord.GetSession(account) + "\t" + DateTime.Now);
                    if (Program.dbCoord.IsMentor(account))
                    {
                        return new LoginResponse(true, Program.onlineCoord.GetSession(account), Program.dbCoord.GetMentorInfo(account));
                    }
                    else
                    {
                        return new LoginResponse(true, Program.onlineCoord.GetSession(account), Program.dbCoord.GetMenteeInfo(account));
                    }
                }
                else
                {
                    Program.logCoord.WriteLog(account + "\tDb에서 UpdateAccount가 실행이 잘 안되서 망함\t" + DateTime.Now);
                    // 이 경우는 없어야 한다. 이미 account와 password가 있는 경우를 확인했고 UpdateAccount에서는 update만 하기 때문이다.
                    return new LoginResponse();
                }
            }
            else
            {
                Program.logCoord.WriteLog(account + "라는 놈은 없거나 패스워드가 틀림\t" + DateTime.Now);
                return new LoginResponse();
            }
        }

        // 안드로이드용 로그인
        public LoginResponse LoginAndroid( string account, string password, bool isPush, string androidpush)
        {
            UTF8Encoding encoding = new UTF8Encoding();
            if ( account.Length > 30
                || encoding.GetBytes( password ).Length != 32
               )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 Login를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return new LoginResponse();
            }
            else if ( !isPush )
            {
                androidpush = "0";
            }

            if ( Program.dbCoord.CheckAccount( account, password ) > 0 )
            {
                if (Program.dbCoord.UpdateAndroidAccount(account, password, androidpush) == 0)
                {
                    // update를 통해 account의 push를 바꿔준다.
                    Program.dbCoord.UpdateAndroidPush(account, androidpush);

                    Program.onlineCoord.Login( account );
                    Program.logCoord.WriteLog( account + "\tLogin 성공했음\tSession : " + Program.onlineCoord.GetSession( account ) + "\t" + DateTime.Now );
                    if ( Program.dbCoord.IsMentor( account ) )
                    {
                        return new LoginResponse( true, Program.onlineCoord.GetSession( account ), Program.dbCoord.GetMentorInfo( account ) );
                    }
                    else
                    {
                        return new LoginResponse( true, Program.onlineCoord.GetSession( account ), Program.dbCoord.GetMenteeInfo( account ) );
                    }
                }
                else
                {
                    Program.logCoord.WriteLog( account + "\tDb에서 UpdateAccount가 실행이 잘 안되서 망함\t" + DateTime.Now );
                    // 이 경우는 없어야 한다. 이미 account와 password가 있는 경우를 확인했고 UpdateAccount에서는 update만 하기 때문이다.
                    return new LoginResponse();
                }
            }
            else
            {
                Program.logCoord.WriteLog( account + "라는 놈은 없거나 패스워드가 틀림\t" + DateTime.Now );
                return new LoginResponse();
            }
        }

        public bool Logout( string account )
        {
            Program.onlineCoord.Logout( account );
            Program.logCoord.WriteLog( account + "\tLogout\t" + DateTime.Now );
            return true;
        }

        public MentorInfo GetMentorInfo( string localAccount, string oppoAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session )
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return null;
            }

            MentorInfo mentorInfo = Program.dbCoord.GetMentorInfo( oppoAccount );
            if ( mentorInfo == null )
            {
                Program.logCoord.WriteLog( localAccount + "\tDb에서 GetMentorInfo이 망함\t" + DateTime.Now );
                return null;
            }
            else
            {
                Program.logCoord.WriteLog( localAccount + "가 " + oppoAccount + "의 GetMentorInfo를 가져갔음\t" + DateTime.Now );
                return mentorInfo;
            }
        }

        public MenteeInfo GetMenteeInfo( string localAccount, string oppoAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return null;
            }

            MenteeInfo menteeInfo = Program.dbCoord.GetMenteeInfo( oppoAccount );
            if ( menteeInfo == null )
            {
                Program.logCoord.WriteLog( localAccount + "\tDb에서 GetMenteeInfo이 망함\t" + DateTime.Now );
                return null;
            }
            else
            {
                Program.logCoord.WriteLog( localAccount + "가 " + oppoAccount + "의 GetMenteeInfo를 가져갔음\t" + DateTime.Now );
                return menteeInfo;
            }
        }

        public bool ChangeMentorInfo( string account, string session, string name, int gender, string email, string univ, string major, int promo, string comment, string image )
        {
            if ( Program.onlineCoord.GetSession( account ) != session)
            {
                Program.logCoord.WriteLog( account + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( account.Length > 30
                || ( gender != 1 && gender != 2 )
                || name.Length > 10
                || email.Length > 100
                || univ.Length > 30
                || major.Length > 30
                || promo < 1900 )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 ChangeMentorInfo를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.ChangeMentorInfo( account, name, gender, email, univ, major, promo, comment, image ) == 0 )
            {
                Program.logCoord.WriteLog( account + "\tChangeMentorInfo\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( account + "\tDb에서 ChangeMentorInfo이 망함\t" + DateTime.Now );
                return false;
            }
        }

        public bool ChangeMenteeInfo( string account, string session, string name, int gender, string email, string school, int grade, string comment, string image )
        {
            if ( Program.onlineCoord.GetSession( account ) != session)
            {
                Program.logCoord.WriteLog( account + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( account.Length > 30
                || ( gender != 1 && gender != 2 )
                || name.Length > 10
                || email.Length > 100
                || school.Length > 30 )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 ChangeMenteeInfo를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.ChangeMenteeInfo( account, name, gender, email, school, grade, comment, image ) == 0 )
            {
                Program.logCoord.WriteLog( account + "\tChangeMenteeInfo\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( account + "\tDb에서 ChangeMenteeInfo이 망함\t" + DateTime.Now );
                return false;
            }
        }

        public bool ChangeName( string account, string session, string name )
        {
            if ( Program.onlineCoord.GetSession( account ) != session)
            {
                Program.logCoord.WriteLog( account + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( account.Length > 30 )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 ChangeName를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.ChangeName( account, name ) == 0 )
            {
                Program.logCoord.WriteLog( account + "\tChangeName\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( account + "\tDb에서 ChangeName이 망함\t" + DateTime.Now );
                return false;
            }
        }

        public bool ChangeComment( string account, string session, string comment )
        {
            if ( Program.onlineCoord.GetSession( account ) != session)
            {
                Program.logCoord.WriteLog( account + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( account.Length > 30 )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 ChangeComment를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.ChangeComment( account, comment ) == 0 )
            {
                Program.logCoord.WriteLog( account + "\tChangeComment\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( account + "\tDb에서 ChangeComment이 망함\t" + DateTime.Now );
                return false;
            }
        }

        public bool ChangeImage( string account, string session, string image )
        {
            if ( Program.onlineCoord.GetSession( account ) != session)
            {
                Program.logCoord.WriteLog( account + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( account.Length > 30 )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 ChangeImage를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.ChangeImage( account, image ) == 0 )
            {
                Program.logCoord.WriteLog( account + "\tChangeImage\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( account + "\tDb에서 ChangeImage이 망함\t" + DateTime.Now );
                return false;
            }
        }

        public bool ChangeMajor( string account, string session, string major )
        {
            if ( Program.onlineCoord.GetSession( account ) != session)
            {
                Program.logCoord.WriteLog( account + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( account.Length > 30 )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 ChangeMajor를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.ChangeMajor( account, major ) == 0 )
            {
                Program.logCoord.WriteLog( account + "\tChangeMajor\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( account + "\tDb에서 ChangeMajor이 망함\t" + DateTime.Now );
                return false;
            }
        }

        public bool ChangeGrade( string account, string session, int grade )
        {
            if ( Program.onlineCoord.GetSession( account ) != session)
            {
                Program.logCoord.WriteLog( account + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( account.Length > 30 )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 ChangeGrade를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.ChangeGrade( account, grade ) == 0 )
            {
                Program.logCoord.WriteLog( account + "\tChangeGrade\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( account + "\tDb에서 ChangeGrade이 망함\t" + DateTime.Now );
                return false;
            }
        }

        public bool ChangeSchool( string account, string session, string school )
        {
            if ( Program.onlineCoord.GetSession( account ) != session)
            {
                Program.logCoord.WriteLog( account + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( account.Length > 30 )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 ChangeSchool를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.ChangeSchool( account, school ) == 0 )
            {
                Program.logCoord.WriteLog( account + "\tChangeSchool\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( account + "\tDb에서 ChangeSchool이 망함\t" + DateTime.Now );
                return false;
            }
        }

        public bool ChangePromo( string account, string session, int promo )
        {
            if ( Program.onlineCoord.GetSession( account ) != session)
            {
                Program.logCoord.WriteLog( account + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( account.Length > 30 )
            {
                // 인자가 이상합니다.
                Program.logCoord.WriteLog( account + "라는 놈이 ChangePromo를 하려고 했는데 넘어온 인자가 병맛이라 처리 안됨\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.ChangePromo( account, promo ) == 0 )
            {
                Program.logCoord.WriteLog( account + "\tChangePromo\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( account + "\tDb에서 ChangePromo이 망함\t" + DateTime.Now );
                return false;
            }
        }


        public List<MentorInfo> PendingMentorRecommendations(string localAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return new List<MentorInfo>();
            }

            Program.logCoord.WriteLog(localAccount + "\tPendingMenteeRecommendations\t" + DateTime.Now);
            List<MentorInfo> ret = new List<MentorInfo>();
            foreach (string mentorAccount in Program.dbCoord.PendingMenteeRecommendations(localAccount))
            {
                ret.Add(Program.dbCoord.GetMentorInfo(mentorAccount));
            }
            return ret;
            
        }
        public List<MenteeInfo> PendingMenteeRecommendations(string localAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return new List<MenteeInfo>();
            }

            Program.logCoord.WriteLog(localAccount + "\tPendingMentorRecommendations\t" + DateTime.Now);
            List<MenteeInfo> ret = new List<MenteeInfo>();
            foreach (string menteeAccount in Program.dbCoord.PendingMentorRecommendations(localAccount))
            {
                ret.Add(Program.dbCoord.GetMenteeInfo(menteeAccount));
            }
            return ret;
               
        }
  
        public List<MeepleInfo> PendingRecommendations(string localAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return new List<MeepleInfo>();
            }

            if (Program.dbCoord.IsMentor(localAccount))
            {
                Program.logCoord.WriteLog(localAccount + "\tPendingMentorRecommendations\t" + DateTime.Now);
                List<MeepleInfo> ret = new List<MeepleInfo>();
                foreach (string menteeAccount in Program.dbCoord.PendingMentorRecommendations(localAccount))
                {
                    ret.Add(new MeepleInfo(Program.dbCoord.GetMenteeInfo(menteeAccount)));
                }
                return ret;
            }
            else
            {
                Program.logCoord.WriteLog(localAccount + "\tPendingMenteeRecommendations\t" + DateTime.Now);
                List<MeepleInfo> ret = new List<MeepleInfo>();
                foreach (string mentorAccount in Program.dbCoord.PendingMenteeRecommendations(localAccount))
                {
                    ret.Add(new MeepleInfo(Program.dbCoord.GetMentorInfo(mentorAccount)));
                }
                return ret;
            }
        }

        public List<MenteeInfo> WaitingMenteeRecommendations(string localAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return new List<MenteeInfo>();
            }

            if (Program.dbCoord.IsMentor(localAccount))
            {
                Program.logCoord.WriteLog(localAccount + "\tWaitingMenteeRecommendations\t" + DateTime.Now);
                List<MenteeInfo> ret = new List<MenteeInfo>();
                foreach (string menteeAccount in Program.dbCoord.WaitingMenteeRecommendations(localAccount))
                {
                    ret.Add(Program.dbCoord.GetMenteeInfo(menteeAccount));
                }
                return ret;
            }
            else
            {
                return new List<MenteeInfo>();
            }
        }

        public List<MeepleInfo> WaitingRecommendations(string localAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session.Substring(0, Program.onlineCoord.GetSession(localAccount).Length))
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return new List<MeepleInfo>();
            }

            if (Program.dbCoord.IsMentor(localAccount))
            {
                Program.logCoord.WriteLog(localAccount + "\tWaitingMentorRecommendations\t" + DateTime.Now);
                List<MeepleInfo> ret = new List<MeepleInfo>();
                foreach (string menteeAccount in Program.dbCoord.WaitingMenteeRecommendations(localAccount))
                {
                    ret.Add(new MeepleInfo(Program.dbCoord.GetMenteeInfo(menteeAccount)));
                }
                return ret;
            }
            else
            {
                return new List<MeepleInfo>();
            }
        }
        public List<MentorInfo> InProgressMentorRecommendations(string localAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return new List<MentorInfo>();
            }

            Program.logCoord.WriteLog(localAccount + "\tInProgressMentorRecommendations\t" + DateTime.Now);
            List<MentorInfo> ret = new List<MentorInfo>();
            foreach (string mentorAccount in Program.dbCoord.InProgressMentorRecommendations(localAccount))
            {
                ret.Add(Program.dbCoord.GetMentorInfo(mentorAccount));
            }
            return ret;  
            
        }
        public List<MenteeInfo> InProgressMenteeRecommendations(string localAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return new List<MenteeInfo>();
            }

            Program.logCoord.WriteLog(localAccount + "\tInProgressMenteeRecommendations\t" + DateTime.Now);
            List<MenteeInfo> ret = new List<MenteeInfo>();
            foreach (string menteeAccount in Program.dbCoord.InProgressMenteeRecommendations(localAccount))
            {
                ret.Add(Program.dbCoord.GetMenteeInfo(menteeAccount));
            }
            return ret;

        }


        public List<MeepleInfo> InProgressRecommendations( string localAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session.Substring( 0, Program.onlineCoord.GetSession( localAccount ).Length ) )
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return new List<MeepleInfo>();
            }

            if ( Program.dbCoord.IsMentor( localAccount ) )
            {
                Program.logCoord.WriteLog( localAccount + "\tInProgressMentorRecommendations\t" + DateTime.Now );
                List<MeepleInfo> ret = new List<MeepleInfo>();
                foreach ( string menteeAccount in Program.dbCoord.InProgressMentorRecommendations( localAccount ) )
                {
                    ret.Add( new MeepleInfo( Program.dbCoord.GetMenteeInfo( menteeAccount ) ) );
                }
                return ret;
            }
            else
            {
                Program.logCoord.WriteLog( localAccount + "\tInProgressMenteeRecommendations\t" + DateTime.Now );
                List<MeepleInfo> ret = new List<MeepleInfo>();
                foreach ( string mentorAccount in Program.dbCoord.InProgressMenteeRecommendations( localAccount ) )
                {
                    ret.Add( new MeepleInfo( Program.dbCoord.GetMentorInfo( mentorAccount ) ) );
                }
                return ret;
            }
        }

        public Recommendations Recommendations( string localAccount, string session )
        {
            return new Recommendations( PendingRecommendations( localAccount, session ), InProgressRecommendations( localAccount, session ), WaitingRecommendations( localAccount, session ) );
        }

        public MentorRecommendations MentorRecommendations(string localAccount, string session)
        {
            return new MentorRecommendations(PendingMentorRecommendations(localAccount, session), InProgressMentorRecommendations(localAccount, session));
        }

        public MenteeRecommendations MenteeRecommendations(string localAccount, string session)
        {
            return new MenteeRecommendations(PendingMenteeRecommendations(localAccount, session), InProgressMenteeRecommendations(localAccount, session), WaitingMenteeRecommendations(localAccount, session));
        }

        public bool RespondRecommendation( string localAccount, string oppoAccount, string session, bool accept )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }
            if ( accept )
            {
                if ( Program.dbCoord.IsMentor( localAccount ) )
                {
                    if ( Program.dbCoord.AcceptMentorRecommendation( localAccount, oppoAccount ) == 0 )
                    {
                        Program.logCoord.WriteLog( localAccount + "\tAcceptMentorRecommendation\t" + oppoAccount + "\t" + DateTime.Now );
                        Program.onlineCoord.OnlineMentor.Remove(localAccount);
                        Program.onlineCoord.OnlineMentor.Add(localAccount);

                        bool isApple = Program.dbCoord.IsApple(oppoAccount);                        
                        string nick = Program.dbCoord.GetMentorInfo(localAccount).Name;
                        int count = GetMenteeBadgeCount(oppoAccount);

                        if (isApple)
                        {
                            string pushToken = Program.dbCoord.GetDeviceToken(oppoAccount);
                            Program.pushProvider.SendPushMessage(pushToken, nick + "님이 Mentor로 추천되었습니다.", count, "default", "3");
                        }
                        else
                        {
                            string pushAndroid = Program.dbCoord.GetDeviceToken(oppoAccount);
                            Program.AndroidPushProvider.sendMessage(pushAndroid, nick + "님이 Mentor로 추천되었습니다.", "recommend");
                        }

                        return true;
                    }
                    else
                    {
                        Program.logCoord.WriteLog( localAccount + "\tDb에서 AcceptMentorRecommendation 실행이 망함\t" + oppoAccount + "\t" + DateTime.Now );
                        return false;
                    }
                }
                else // mentee
                {
                    if ( Program.dbCoord.AcceptMenteeRecommendation( localAccount, oppoAccount ) == 0 )
                    {
                        Program.logCoord.WriteLog( localAccount + "\tAcceptMenteeRecommendation\t" + oppoAccount + "\t" + DateTime.Now );
                        Program.onlineCoord.OnlineMentee.Remove(localAccount);
                        Program.onlineCoord.OnlineMentee.Add(localAccount);
                        
                        string nick = Program.dbCoord.GetMenteeInfo(localAccount).Name;
                        
                        int count = GetMentorBadgeCount(oppoAccount);

                        if (Program.dbCoord.IsApple(oppoAccount)) // 아이폰이면
                        {
                            string pushToken = Program.dbCoord.GetDeviceToken(oppoAccount);
                            Program.pushProvider.SendPushMessage(pushToken, nick + " Mentee님이 수락하셨습니다. 대화를 시작합니다.", count, "default", "3");
                        }
                        else
                        {
                            string pushAndroid = Program.dbCoord.GetAndroidDeviceToken(oppoAccount);
                            Program.AndroidPushProvider.sendMessage(pushAndroid, nick + "Mentee님이 수락하셨습니다. 대화를 시작합니다.", "recommend");
                        }

                        return true;
                    }
                    else
                    {
                        Program.logCoord.WriteLog( localAccount + "\tDb에서 tAcceptMenteeRecommendation 실행이 망함\t" + oppoAccount + "\t" + DateTime.Now );
                        return false;
                    }
                }
            }
            else
            {
                return RejectChatting( localAccount, oppoAccount, session );
            }
        }
        public List<Chat> SendChatNew(string localAccount, string oppoAccount, string session, string chat)
        {
            string session1 = Program.onlineCoord.GetSession(localAccount);
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now + " " + session1 + " " + session);
                return null;
            }

            if (Program.dbCoord.IsMentor(localAccount))
            {
                if (Program.dbCoord.CheckRecommendation(localAccount, oppoAccount) > 0)
                {
                    Program.logCoord.WriteLog(localAccount + "\tSendChat\t" + oppoAccount + "\t" + chat + "\t" + DateTime.Now);
                    //int lastChatId = Program.sqliteCoord.WriteChatNew(localAccount, oppoAccount, chat);

                    if (Program.sqliteCoord.WriteChatNew(localAccount, oppoAccount, chat))
                    {
                        int lastChatId = Program.sqliteCoord.LastRequestedChatNew(localAccount, oppoAccount);
                        string nick = Program.dbCoord.GetMentorInfo(localAccount).Name;
           
                        List<Chat> ret = Program.sqliteCoord.GetChatsNew(localAccount, oppoAccount, lastChatId);
                        int count = GetMenteeBadgeCount(oppoAccount);

                        if (Program.dbCoord.IsApple(oppoAccount)) // 아이폰이면
                        {
                            string pushToken = Program.dbCoord.GetDeviceToken(oppoAccount);
                            Program.pushProvider.SendPushMessage(pushToken, nick + ": " + chat, count, "default", "2");
                        }
                        else
                        {
                            string pushAndroid = Program.dbCoord.GetAndroidDeviceToken(oppoAccount);
                            Program.AndroidPushProvider.sendMessage(pushAndroid, nick + ":" + chat, "chat", localAccount);
                        }
                        
                        return ret;
                    }
                    else
                    {
                        return null;
                    }
                }
                else
                {
                    Program.logCoord.WriteLog(localAccount + "\tDb에서 CheckRecommendation 실행이 망함. 대화중이 아닌듯\t" + oppoAccount + "\t" + DateTime.Now);
                    return null;
                }
            }
            else
            {
                if (Program.dbCoord.CheckRecommendation(oppoAccount, localAccount) > 0)
                {
                    Program.logCoord.WriteLog(localAccount + "\tSendChat\t" + oppoAccount + "\t" + chat + "\t" + DateTime.Now);
                    if (Program.sqliteCoord.WriteChatNew(localAccount, oppoAccount, chat))
                    {
                        int lastChatId = Program.sqliteCoord.LastRequestedChatNew(localAccount, oppoAccount);
                        string nick = Program.dbCoord.GetMenteeInfo(localAccount).Name;

                        List<Chat> ret = Program.sqliteCoord.GetChatsNew(localAccount, oppoAccount, lastChatId);
                        int count = GetMentorBadgeCount(oppoAccount);

                        if (Program.dbCoord.IsApple(oppoAccount)) // 아이폰이면
                        {
                            string pushToken = Program.dbCoord.GetDeviceToken(oppoAccount);
                            Program.pushProvider.SendPushMessage(pushToken, nick + ": " + chat, count, "default", "2");
                        }
                        else
                        {
                            string pushAndroid = Program.dbCoord.GetAndroidDeviceToken(oppoAccount);
                            Program.AndroidPushProvider.sendMessage(pushAndroid, nick + ":" + chat, "chat", localAccount);
                        }
                        return ret;
                    }
                    else
                    {
                        return null;
                    }
                }
                else
                {
                    Program.logCoord.WriteLog(localAccount + "\tDb에서 CheckRecommendation 실행이 망함. 대화중이 아닌듯\t" + oppoAccount + "\t" + DateTime.Now);
                    return null;
                }
            }
        }
 
        public List<Chat> GetChatsNew(string localAccount, string oppoAccount, string session, int chatId)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return null;
            }

            Program.logCoord.WriteLog(localAccount + "가 GetChats 수행\t" + DateTime.Now);
            return Program.sqliteCoord.GetChatsNew(localAccount, oppoAccount, chatId);
        }

        public List<RecentChat> GetRecentChatsNew(string localAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return null;
            }

            if (Program.dbCoord.IsMentor(localAccount))
            {
                List<string> mentees = Program.dbCoord.InProgressMenteeRecommendations(localAccount);
                Program.logCoord.WriteLog(localAccount + "가 GetRecentChats 수행\t" + DateTime.Now);
                return Program.sqliteCoord.GetRecentChatsNew(localAccount, mentees);
            }
            else
            {
                List<string> mentors = Program.dbCoord.InProgressMentorRecommendations(localAccount);
                Program.logCoord.WriteLog(localAccount + "가 GetRecentChats 수행\t" + DateTime.Now);
                return Program.sqliteCoord.GetRecentChatsNew(localAccount, mentors);
            }
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

        public bool CheckChats( string localAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            Program.logCoord.WriteLog( localAccount + "가 CheckChats 수행\t" + DateTime.Now );
            return Program.sqliteCoord.CheckChats( localAccount );
        }

        public bool CheckChatsNew(string localAccount, string oppoAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return false;
            }

            Program.logCoord.WriteLog(localAccount + "가 CheckChats 수행\t" + DateTime.Now);
            return Program.sqliteCoord.CheckChatsNew(localAccount,oppoAccount);
        }

        public int LastChatId( string localAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return 0;
            }

            int lastChatId = Program.sqliteCoord.LastRequestedChat( localAccount );
            if ( lastChatId < 0 )
            {
                Program.logCoord.WriteLog( localAccount + "가 Db에서 LastRequestedChat 망함\t" + DateTime.Now );
                return 0;
            }
            else
            {
                Program.logCoord.WriteLog( localAccount + "가 LastChatId 수행\t" + DateTime.Now );
                return lastChatId;
            }
        }

        public int LastChatIdNew(string localAccount, string oppoAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return 0;
            }

            int lastChatId = Program.sqliteCoord.LastRequestedChatNew(localAccount,oppoAccount);
            if (lastChatId < 0)
            {
                Program.logCoord.WriteLog(localAccount + "가 Db에서 LastRequestedChat 망함\t" + DateTime.Now);
                return 0;
            }
            else
            {
                Program.logCoord.WriteLog(localAccount + "가 LastChatId 수행\t" + DateTime.Now);
                return lastChatId;
            }
        }

        public bool RejectChatting( string localAccount, string oppoAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.IsMentor( localAccount ) )
            {
                if ( Program.dbCoord.DeleteRecommendation( localAccount, oppoAccount ) == 0 )
                {
                    Program.logCoord.WriteLog( localAccount + "\t mentor가 추천을 거절했습니다.\t" + oppoAccount );
                    Program.sqliteCoord.EndChatNew(localAccount, oppoAccount);
                    
                    Program.onlineCoord.OnlineMentor.Remove(localAccount);
                    Program.onlineCoord.OnlineMentor.Add(localAccount);                        
                    return true;
                }
                else
                {
                    Program.logCoord.WriteLog( localAccount + "\tDb에서 CloseChatting 실행이 망함\t" + oppoAccount );
                    // 이런 경우가 있으면 안되는데...
                    return false;
                }
            }
            else // mentee
            {
                if ( Program.dbCoord.DeleteRecommendation( oppoAccount, localAccount ) == 0 )
                {
                    Program.logCoord.WriteLog(localAccount + "\t mentee가 추천을 거절했습니다.\t" + oppoAccount);
                    Program.sqliteCoord.EndChatNew(localAccount, oppoAccount);
                    Program.pushProvider.SendPushMessage();

                    string nick = Program.dbCoord.GetMenteeInfo(localAccount).Name;
                    int count = GetMentorBadgeCount(oppoAccount);

                    if ( Program.dbCoord.IsApple(oppoAccount) ) // 아이폰이면
                    {
                        string pushToken = Program.dbCoord.GetDeviceToken(oppoAccount);
                        Program.pushProvider.SendPushMessage(pushToken, nick + " Mentee님이 대화를 수락하지 않으셨습니다. 다른 추천을 기다려주세요~", count, "default", "3");
                    }
                    else
                    {
                        string pushAndroid = Program.dbCoord.GetAndroidDeviceToken(oppoAccount);
                        Program.AndroidPushProvider.sendMessage(pushAndroid, nick + " Mentee님이 대화를 수락하지 않으셨습니다. 다른 추천을 기다려주세요~", "recommend");
                    }
                    
                    Program.onlineCoord.OnlineMentee.Remove(localAccount);
                    Program.onlineCoord.OnlineMentee.Add(localAccount);                            
                    return true;
                }
                else
                {
                    Program.logCoord.WriteLog( localAccount + "\tDb에서 CloseChatting 실행이 망함\t" + oppoAccount );
                    // 이런 경우가 있으면 안되는데...
                    return false;
                }
            }
        }

        public bool CloseChatting(string localAccount, string oppoAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return false;
            }

            if (Program.dbCoord.IsMentor(localAccount))
            {
                if (Program.dbCoord.DeleteRecommendation(localAccount, oppoAccount) == 0)
                {
                    Program.logCoord.WriteLog(localAccount + "\tCloseChatting\t" + oppoAccount);
                    Program.sqliteCoord.EndChatNew(localAccount, oppoAccount);
                    
                    string nick = Program.dbCoord.GetMentorInfo(localAccount).Name;
                    int count = GetMenteeBadgeCount(oppoAccount);

                    if (Program.dbCoord.IsApple(oppoAccount)) // 아이폰이면
                    {
                        string pushToken = Program.dbCoord.GetDeviceToken(oppoAccount);
                        Program.pushProvider.SendPushMessage(pushToken, nick + " Mentor님과의 대화가 종료되었습니다.", count, "default", "3");
                    }
                    else
                    {
                        string pushAndroid = Program.dbCoord.GetAndroidDeviceToken(oppoAccount);
                        Program.AndroidPushProvider.sendMessage(pushAndroid, nick + " Mentor님과의 대화가 종료되었습니다.", "end");
                    }

                    Program.onlineCoord.OnlineMentor.Remove(localAccount);
                    Program.onlineCoord.OnlineMentor.Add(localAccount);
                    return true;
                }
                else
                {
                    Program.logCoord.WriteLog(localAccount + "\tDb에서 CloseChatting 실행이 망함\t" + oppoAccount);
                    // 이런 경우가 있으면 안되는데...
                    return false;
                }
            }
            else
            {
                if (Program.dbCoord.DeleteRecommendation(oppoAccount, localAccount) == 0)
                {
                    Program.logCoord.WriteLog(oppoAccount + "\tCloseChatting\t" + localAccount);
                    Program.sqliteCoord.EndChatNew(localAccount, oppoAccount);
                    Program.pushProvider.SendPushMessage();

                    string nick = Program.dbCoord.GetMenteeInfo(localAccount).Name;
                    int count = GetMentorBadgeCount(oppoAccount);

                    if (Program.dbCoord.IsApple(oppoAccount)) // 아이폰이면
                    {
                        string pushToken = Program.dbCoord.GetDeviceToken(oppoAccount);
                        Program.pushProvider.SendPushMessage(pushToken, nick + " Mentee님과의 대화가 종료되었습니다.", count, "default", "3");
                    }
                    else
                    {
                        string pushAndroid = Program.dbCoord.GetAndroidDeviceToken(oppoAccount);
                        Program.AndroidPushProvider.sendMessage(pushAndroid, nick + " Mentee님과의 대화가 종료되었습니다.", "end");
                    }
                    
 
                    Program.onlineCoord.OnlineMentee.Remove(localAccount);
                    Program.onlineCoord.OnlineMentee.Add(localAccount);
                    return true;
                }
                else
                {
                    Program.logCoord.WriteLog(localAccount + "\tDb에서 CloseChatting 실행이 망함\t" + oppoAccount);
                    // 이런 경우가 있으면 안되는데...
                    return false;
                }
            }
        }

        public bool AddRelation( string localAccount, string oppoAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.AddRelation( localAccount, oppoAccount ) == 0 )
            {
                Program.logCoord.WriteLog( localAccount + "\tAddRelation\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( localAccount + "\tDb AddRelation 망함\t" + DateTime.Now );
                return false;
            }
        }
        public MenteeInfo AddRelationAndGetMenteeInfo(string localAccount, string oppoAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return new MenteeInfo();
            }

            if (Program.dbCoord.AddRelation(localAccount, oppoAccount) == 0)
            {
                Program.logCoord.WriteLog(localAccount + "\tAddRelation\t" + DateTime.Now);
                return Program.dbCoord.GetMenteeInfo(oppoAccount);
            }
            else
            {
                Program.logCoord.WriteLog(localAccount + "\tDb AddRelation 망함\t" + DateTime.Now);
                return new MenteeInfo();
            }
        }

        public MentorInfo AddRelationAndGetMentorInfo(string localAccount, string oppoAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return new MentorInfo();
            }

            if (Program.dbCoord.AddRelation(localAccount, oppoAccount) == 0)
            {
                Program.logCoord.WriteLog(localAccount + "\tAddRelation\t" + DateTime.Now);
                return Program.dbCoord.GetMentorInfo(oppoAccount);
            }
            else
            {
                Program.logCoord.WriteLog(localAccount + "\tDb AddRelation 망함\t" + DateTime.Now);
                return new MentorInfo();
            }
        }

        public bool DeleteRelation( string localAccount, string oppoAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            if ( Program.dbCoord.DeleteRelation( localAccount, oppoAccount ) == 0 )
            {
                Program.logCoord.WriteLog( localAccount + "\tDeleteRelation\t" + DateTime.Now );
                return true;
            }
            else
            {
                Program.logCoord.WriteLog( localAccount + "\tDb DeleteRelation 망함\t" + DateTime.Now );
                return false;
            }
        }

        public List<MenteeInfo> GetRelationsMentee(string localAccount, string session)
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return null;
            }

            Program.logCoord.WriteLog( localAccount + "\tGetRelations\t" + DateTime.Now );
            List<string> relationAccounts = Program.dbCoord.GetRelations( localAccount );
            int count = relationAccounts.Count;
            //MeepleInfo[] ret = new MeepleInfo[count];

            List<MenteeInfo> ret = new List<MenteeInfo>();
            foreach ( string relationAccount in relationAccounts )
            {
                
                    //ret[i] = new MeepleInfo(Program.dbCoord.GetMenteeInfo(relationAccount));
                ret.Add(Program.dbCoord.GetMenteeInfo( relationAccount ));
                
            }
          
            return ret;
        }
        public List<MentorInfo> GetRelationsMentor(string localAccount, string session)
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return null;
            }

            Program.logCoord.WriteLog( localAccount + "\tGetRelations\t" + DateTime.Now );
            List<string> relationAccounts = Program.dbCoord.GetRelations( localAccount );
            int count = relationAccounts.Count;
        
            List<MentorInfo> ret = new List<MentorInfo>();
            foreach ( string relationAccount in relationAccounts )
            {
                
                ret.Add(Program.dbCoord.GetMentorInfo( relationAccount ));
         
            }
          
            return ret;
        }

        public bool SendMessage( string localAccount, string oppoAccount, string session, string message )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            Program.logCoord.WriteLog( localAccount + "\tSendChat\t" + oppoAccount + "\t" + message + "\t" + DateTime.Now );
            
            bool ret = Program.sqliteCoord.WriteMessage( localAccount, oppoAccount, message );
            int count = 0;
            if (Program.dbCoord.IsMentor(localAccount))
            {
                count = GetMenteeBadgeCount(oppoAccount);
            }
            else
            {
                count = GetMentorBadgeCount(oppoAccount);
            }

            if (Program.dbCoord.IsApple(oppoAccount)) // 아이폰이면
            {
                string pushToken = Program.dbCoord.GetDeviceToken(oppoAccount);
                Program.pushProvider.SendPushMessage(pushToken, localAccount + "님으로 부터 메세지가 도착했습니다.", count, "default", "1");
            }
            else
            {
                string pushAndroid = Program.dbCoord.GetAndroidDeviceToken(oppoAccount);
                Program.AndroidPushProvider.sendMessage(pushAndroid, localAccount + "님으로 부터 메세지가 도착했습니다.", "message"); 
            }

            return ret;
        }
        public List<MessageWithId> GetMessagesFirst(string localAccount, string session)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return null;
            }

            Program.logCoord.WriteLog(localAccount + "가 GetMessages 수행\t" + DateTime.Now);
            return Program.sqliteCoord.GetMessagesFirst(localAccount);
        }

        public List<Message> GetMessages( string localAccount, string session, int messageId )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return null;
            }

            Program.logCoord.WriteLog( localAccount + "가 GetMessages 수행\t" + DateTime.Now );
            return Program.sqliteCoord.GetMessages( localAccount, messageId );
        }

        public bool CheckMessages( string localAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return false;
            }

            Program.logCoord.WriteLog( localAccount + "가 CheckMessages 수행\t" + DateTime.Now );
            return Program.sqliteCoord.CheckMessages( localAccount );
        }

        public int LastMessageId( string localAccount, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return 0;
            }

            int lastMessageId = Program.sqliteCoord.LastRequestedMessage( localAccount );
            if ( lastMessageId < 0 )
            {
                Program.logCoord.WriteLog( localAccount + "가 Db에서 LastRequestedMessage 망함\t" + DateTime.Now );
                return 0;
            }
            else
            {
                Program.logCoord.WriteLog( localAccount + "가 LastMessageId 수행\t" + DateTime.Now );
                return lastMessageId;
            }
        }

        public int GetWaitingLines( string localAccount /* mentee account */, string session )
        {
            if ( Program.onlineCoord.GetSession( localAccount ) != session)
            {
                Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
                return -1;
            }

            return Program.onlineCoord.OnlineMentee.FindIndex( i => i == localAccount );
        }

        public bool ReportUser(string localAccount, string oppoAccount, string session, string content)
        {
            if (Program.onlineCoord.GetSession(localAccount) != session)
            {
                Program.logCoord.WriteLog(localAccount + "\tsession이 틀렸음\t" + DateTime.Now);
                return false;
            }

            return Program.dbCoord.ReportUser(localAccount, oppoAccount, content);
        }
    }
}



/*
public bool SendChat( string localAccount, string oppoAccount, string session, string chat )
{
    if ( Program.onlineCoord.GetSession( localAccount ) != session.Substring( 0, Program.onlineCoord.GetSession( localAccount ).Length ) )
    {
        Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
        return false;
    }

    if ( Program.dbCoord.IsMentor( localAccount ) )
    {
        if ( Program.dbCoord.CheckRecommendation( localAccount, oppoAccount ) > 0 )
        {
            Program.logCoord.WriteLog( localAccount + "\tSendChat\t" + oppoAccount + "\t" + chat + "\t" + DateTime.Now );
            return Program.sqliteCoord.WriteChat( localAccount, oppoAccount, chat );
        }
        else
        {
            Program.logCoord.WriteLog( localAccount + "\tDb에서 CheckRecommendation 실행이 망함. 대화중이 아닌듯\t" + oppoAccount + "\t" + DateTime.Now );
            return false;
        }
    }
    else
    {
        if ( Program.dbCoord.CheckRecommendation( oppoAccount, localAccount ) > 0 )
        {
            Program.logCoord.WriteLog( localAccount + "\tSendChat\t" + oppoAccount + "\t" + chat + "\t" + DateTime.Now );
            return Program.sqliteCoord.WriteChat( localAccount, oppoAccount, chat );
        }
        else
        {
            Program.logCoord.WriteLog( localAccount + "\tDb에서 CheckRecommendation 실행이 망함. 대화중이 아닌듯\t" + oppoAccount + "\t" + DateTime.Now );
            return false;
        }
    }
}
*/

/*
public List<MeepleInfo> GetRelations(string localAccount, string session)
{
    if ( Program.onlineCoord.GetSession( localAccount ) != session.Substring( 0, Program.onlineCoord.GetSession( localAccount ).Length ) )
    {
        Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
        return null;
    }

    Program.logCoord.WriteLog( localAccount + "\tGetRelations\t" + DateTime.Now );
    List<string> relationAccounts = Program.dbCoord.GetRelations( localAccount );
    int count = relationAccounts.Count;
    //MeepleInfo[] ret = new MeepleInfo[count];

    List<MeepleInfo> ret = new List<MeepleInfo>();
    int i = 0;
    foreach ( string relationAccount in relationAccounts )
    {
        if ( Program.dbCoord.IsMentor( relationAccount ) )
        {
            //ret[i] = new MeepleInfo(Program.dbCoord.GetMentorInfo(relationAccount));
            ret.Add( new MeepleInfo( Program.dbCoord.GetMentorInfo( relationAccount ) ) );
        }
        else
        {
            //ret[i] = new MeepleInfo(Program.dbCoord.GetMenteeInfo(relationAccount));
            ret.Add( new MeepleInfo( Program.dbCoord.GetMenteeInfo( relationAccount ) ) );
        }
        i++;
    }
          
    return ret;
}
 */
/*
 public List<Chat> GetChats( string localAccount, string session, int chatId )
 {
     if ( Program.onlineCoord.GetSession( localAccount ) != session.Substring( 0, Program.onlineCoord.GetSession( localAccount ).Length ) )
     {
         Program.logCoord.WriteLog( localAccount + "\tsession이 틀렸음\t" + DateTime.Now );
         return null;
     }

     Program.logCoord.WriteLog( localAccount + "가 GetChats 수행\t" + DateTime.Now );
     return Program.sqliteCoord.GetChats( localAccount, chatId );
 }
 */