using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using System.ServiceModel.Web;

using System.Runtime.Serialization;
using System.IO;
namespace Server
{
    [ServiceContract]
    public interface IMeepleService
    {
        // TODO: 여기에 서비스 작업을 추가합니다.

        // 멘토를 등록한다. (아이폰)
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        // password는 MD5 Hash로 인크립트해서 보낼 것. MD5 인크립트의 결과는 256bit(32byte이다)
        RegisterResponse RegisterMentor(string account, string password, bool isPush, string push, string name, int gender, string email, string univ, string major, int promo);

        // 멘토를 등록한다. (안드로이드)
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        // password는 MD5 Hash로 인크립트해서 보낼 것. MD5 인크립트의 결과는 256bit(32byte이다)
        RegisterResponse RegisterMentorAndroid( string account, string password, bool isPush, string androidpush, string name, int gender, string email, string univ, string major, int promo );

        // 멘티를 등록한다. (아이폰)
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        // password는 MD5 Hash로 인크립트해서 보낼 것. MD5 인크립트의 결과는 256bit(32byte이다)
        RegisterResponse RegisterMentee(string account, string password, bool isPush, string push, string name, int gender, string email, string school, int grade);

        // 멘티를 등록한다. (안드로이드)
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        // password는 MD5 Hash로 인크립트해서 보낼 것. MD5 인크립트의 결과는 256bit(32byte이다)
        RegisterResponse RegisterMenteeAndroid( string account, string password, bool isPush, string androidpush, string name, int gender, string email, string school, int grade );

        // 로그인 (아이폰)
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        // password는 MD5 Hash로 인크립트해서 보낼 것. MD5 인크립트의 결과는 256bit(32byte이다)
        LoginResponse Login(string account, string password, bool isPush, string push);

        // 로그인 (안드로이드)
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        // password는 MD5 Hash로 인크립트해서 보낼 것. MD5 인크립트의 결과는 256bit(32byte이다)
        LoginResponse LoginAndroid(string account, string password, bool isPush, string androidpush );

        // 로그아웃 (deprecated)
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool Logout( string account );

        // 멘토 정보를 가져온다.
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        MentorInfo GetMentorInfo( string localAccount, string oppoAccount, string session );

        // 멘티정보를 가져온다.
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        MenteeInfo GetMenteeInfo( string localAccount, string oppoAccount, string session );

        // 멘토 정보를 바꾼다.
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool ChangeMentorInfo( string account, string session, string name, int gender, string email, string univ, string major, int promo, string comment, string image );

        // 멘티 정보를 바꾼다.
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool ChangeMenteeInfo( string account, string session, string name, int gender, string email, string school, int grade, string comment, string image );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool ChangeName( string account, string session, string name );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool ChangeComment( string account, string session, string comment );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool ChangeImage( string account, string session, string image );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool ChangeSchool( string account, string session, string school );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool ChangeGrade( string account, string session, int grade );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool ChangeMajor( string account, string session, string major );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool ChangePromo( string account, string session, int promo );

        // 서버에서 추천해준 상대방 미플의 수락 여부를 결정한다.
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool RespondRecommendation( string localAccount, string oppoAccount, string session, bool accept );

        // 나를 기다리고 있는 상대방을 불러온다.
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        List<MeepleInfo> PendingRecommendations( string localAccount, string session );

        // 나와 대화중인 상대방을 불러온다.
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        List<MeepleInfo> InProgressRecommendations( string localAccount, string session );

        // 내가 기다리고 있는 상대방을 불러온다.
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        List<MeepleInfo> WaitingRecommendations( string localAccount, string session );


        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        Recommendations Recommendations( string localAccount, string session );

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        MenteeRecommendations MenteeRecommendations(string localAccount, string session);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        MentorRecommendations MentorRecommendations(string localAccount, string session);

        /*
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool SendChat( string localAccount, string oppoAccount, string session, string chat );
        */
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        List<Chat> SendChatNew(string localAccount, string oppoAccount, string session, string chat);

        /*
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        List<Chat> GetChats( string localAccount, string session, int chatId );
        */

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        List<Chat> GetChatsNew(string localAccount, string oppoAccount, string session, int chatId);

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool CheckChats( string localAccount, string session );

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        bool CheckChatsNew(string localAccount, string oppoAccount, string session);

        //[OperationContract]
        //[WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        //int LastChatId( string localAccount, string session );

        // 클라이언트에서 마지막으로 요청한 ChatID
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        int LastChatIdNew(string localAccount, string oppoAccount, string session);

        // 실제 서버상 채팅DB의 마지막 ChatID
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        int LastRealChatIdNew(string localAccount, string oppoAccount, string session);

        // 채팅 끝내기 (아이폰용)
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool CloseChatting( string localAccount, string oppoAccount, string session );

        // 채팅 끝내기 (안드로이드용) 끝난 sqlite파일명을 가져오기 위해서 string return 한다.
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        string CloseChattingAndroid(string localAccount, string oppoAccount, string session);

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool AddRelation( string localAccount, string oppoAccount, string session );

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        MenteeInfo AddRelationAndGetMenteeInfo(string localAccount, string oppoAccount, string session);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        MentorInfo AddRelationAndGetMentorInfo(string localAccount, string oppoAccount, string session);


        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool DeleteRelation( string localAccount, string oppoAccount, string session );

        /*
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json)]
        List<MeepleInfo> GetRelations( string account, string session );
        */
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json)]
        //List<MeepleInfo> GetRelations( string account, string session );
        List<MentorInfo> GetRelationsMentor(string account, string session);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json)]
        //List<MeepleInfo> GetRelations( string account, string session );
        List<MenteeInfo> GetRelationsMentee(string account, string session);

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool SendMessage( string localAccount, string oppoAccount, string session, string message );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        List<Message> GetMessages( string localAccount, string session, int messageId );

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        List<MessageWithId> GetMessagesFirst(string localAccount, string session);

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        bool CheckMessages( string localAccount, string session );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        int LastMessageId( string localAccount, string session );

        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        int GetWaitingLines( string localAccount /* mentor account */, string session );
       
        [OperationContract]
        [WebInvoke(
            Method = "POST",
            UriTemplate = "/SaveImage?account={account}&session={session}",
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            BodyStyle = WebMessageBodyStyle.Bare
            )]
        bool SaveImage(string account, string session, Stream file);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        List<RecentChat> GetRecentChatsNew(string localAccount, string session);


        // 로그인 상태를 확인한다. (현재 세션이 맞는지 확인)
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        bool CheckLogin(string account, string session);

        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare)]
        bool ReportUser(string localAccount, string oppoAccount, string session, string content);

    }

    // 아래 샘플에 나타낸 것처럼 데이터 계약을 사용하여 복합 형식을 서비스 작업에 추가합니다.

    [DataContract]
    public class MenteeRecommendations
    {
        public MenteeRecommendations(List<MenteeInfo> pendingRecommmendations, List<MenteeInfo> inProgressRecommendations, List<MenteeInfo> waitingRecommendations)
        {
            this.pendingRecommmendations = pendingRecommmendations;
            this.inProgressRecommendations = inProgressRecommendations;
            this.waitingRecommendations = waitingRecommendations;
        }

        [DataMember]
        private List<MenteeInfo> pendingRecommmendations;

        [DataMember]
        private List<MenteeInfo> inProgressRecommendations;

        [DataMember]
        private List<MenteeInfo> waitingRecommendations;
    }

    [DataContract]
    public class MentorRecommendations
    {
        public MentorRecommendations(List<MentorInfo> pendingRecommmendations, List<MentorInfo> inProgressRecommendations)
        {
            this.pendingRecommmendations = pendingRecommmendations;
            this.inProgressRecommendations = inProgressRecommendations;
        }

        [DataMember]
        private List<MentorInfo> pendingRecommmendations;

        [DataMember]
        private List<MentorInfo> inProgressRecommendations;
    }

    [DataContract]
    public class Recommendations
    {
        public Recommendations( List<MeepleInfo> pendingRecommmendations, List<MeepleInfo> inProgressRecommendations, List<MeepleInfo> waitingRecommendations )
        {
            this.pendingRecommmendations = pendingRecommmendations;
            this.inProgressRecommendations = inProgressRecommendations;
            this.waitingRecommendations = waitingRecommendations;
        }

        [DataMember]
        private List<MeepleInfo> pendingRecommmendations;

        [DataMember]
        private List<MeepleInfo> inProgressRecommendations;

        [DataMember]
        private List<MeepleInfo> waitingRecommendations;
    }

    // 아래 샘플에 나타낸 것처럼 데이터 계약을 사용하여 복합 형식을 서비스 작업에 추가합니다.
    [DataContract]
    public class RegisterResponse
    {
        public RegisterResponse( bool success, string session, string reason)
        {
            this.success = success;
            this.session = session;
            this.reason = reason;
        }

        [DataMember]
        private bool success;

        [DataMember]
        //Login 시에 지급 받는 Session ID. 자신의 ID + Session ID를 이용해서 Request를 보내고, Session ID 오류이면 App에서 Logout 시켜버린다.
        private string session;

        [DataMember]
        private string reason;
    }

    [DataContract]
    public class LoginResponse
    {
        public LoginResponse()
        {
            this.success = false;
            this.isMentor = false;
        }

        public LoginResponse( bool success, string session, MentorInfo mentorInfo )
        {
            this.success = success;
            this.session = session;
            this.isMentor = true;
            this.mentorInfo = mentorInfo;
        }

        public LoginResponse( bool success, string session, MenteeInfo menteeInfo )
        {
            this.success = success;
            this.session = session;
            this.isMentor = false;
            this.menteeInfo = menteeInfo;
        }

        [DataMember]
        private bool success;

        [DataMember]
        //Login 시에 지급 받는 Session ID.자신의 ID + Session ID를 이용해서 Request를 보내고, Session ID 오류이면 App에서 Logout 시켜버린다.
        private string session;

        [DataMember]
        private bool isMentor;

        [DataMember]
        private MentorInfo mentorInfo;

        [DataMember]
        private MenteeInfo menteeInfo;
    }

    [DataContract]
    public class MeepleInfo
    {
        public MeepleInfo( MentorInfo mentorInfo )
        {
            this.isMentor = true;
            this.mentorInfo = mentorInfo;
            this.menteeInfo = new MenteeInfo();
        }

        public MeepleInfo( MenteeInfo menteeInfo )
        {
            this.isMentor = false;
            this.mentorInfo = new MentorInfo();
            this.menteeInfo = menteeInfo;
        }

        [DataMember]
        private bool isMentor;

        [DataMember]
        private MentorInfo mentorInfo;

        [DataMember]
        private MenteeInfo menteeInfo;
    }

    [DataContract]
    public class MentorInfo
    {
        [DataMember]
        public string AccountId
        {
            get;
            set;
        }

        [DataMember]
        public string Name
        {
            get;
            set;
        }

        [DataMember]
        public string Univ
        {
            get;
            set;
        }

        [DataMember]
        public string Major
        {
            get;
            set;
        }

        [DataMember]
        public int Promo
        {
            get;
            set;
        }

        [DataMember]
        public string Email
        {
            get;
            set;
        }

        [DataMember]
        public string Comment
        {
            get;
            set;
        }

        [DataMember]
        public string Image
        {
            get;
            set;
        }

        [DataMember]
        public DateTime LastModifiedTime
        {
            get;
            set;
        }

        public MentorInfo()
        {
        }

        public MentorInfo( string accountId, string name, string univ, string major, int promo, string email, string comment, string image, DateTime lastModifiedTime )
        {
            this.AccountId = accountId;
            this.Name = name;
            this.Univ = univ;
            this.Major = major;
            this.Promo = promo;
            this.Email = email;
            this.Comment = comment;
            this.Image = image;
            this.LastModifiedTime = lastModifiedTime;
        }
    }

    [DataContract]
    public class MenteeInfo
    {
        [DataMember]
        public string AccountId
        {
            get;
            set;
        }

        [DataMember]
        public string Name
        {
            get;
            set;
        }

        [DataMember]
        public string School
        {
            get;
            set;
        }

        [DataMember]
        public int Grade
        {
            get;
            set;
        }

        [DataMember]
        public string Email
        {
            get;
            set;
        }

        [DataMember]
        public string Comment
        {
            get;
            set;
        }

        [DataMember]
        public string Image
        {
            get;
            set;
        }

        [DataMember]
        public DateTime LastModifiedTime
        {
            get;
            set;
        }

        public MenteeInfo()
        {
        }

        public MenteeInfo( string accountId, string name, string school, int grade, string email, string comment, string image, DateTime lastModifiedTime )
        {
            this.AccountId = accountId;
            this.Name = name;
            this.School = school;
            this.Grade = grade;
            this.Email = email;
            this.Comment = comment;
            this.Image = image;
            this.LastModifiedTime = lastModifiedTime;
        }
    }

    [DataContract]
    public class Chat
    {
        
        public Chat( string senderAccount, string receiverAccount, string chat, string dateTime )
        {
            this.senderAccount = senderAccount;
            this.receiverAccount = receiverAccount;
            this.chat = chat;
            this.dateTime = dateTime;
        }
     
        public Chat(string senderAccount, string receiverAccount, string chat, string dateTime, string chatId)
        {
            this.senderAccount = senderAccount;
            this.receiverAccount = receiverAccount;
            this.chat = chat;
            this.dateTime = dateTime;
            this.chatId = chatId;
        }

        [DataMember]
        private string senderAccount;

        [DataMember]
        private string receiverAccount;

        [DataMember]
        private string chat;

        [DataMember]
        private string dateTime;

        [DataMember]
        private string chatId;
    }
    [DataContract]
    public class RecentChat
    {
        public RecentChat(string senderAccount, string receiverAccount, string chat, string dateTime, string chatId, string count)
        {
            this.senderAccount = senderAccount;
            this.receiverAccount = receiverAccount;
            this.chat = chat;
            this.dateTime = dateTime;
            this.chatId = chatId;
            this.count = count;
        }

        [DataMember]
        private string senderAccount;

        [DataMember]
        private string receiverAccount;

        [DataMember]
        private string chat;

        [DataMember]
        private string dateTime;

        [DataMember]
        private string chatId;

        [DataMember]
        private string count;
    }

    [DataContract]
    public class Message
    {
        public Message( string senderAccount, string receiverAccount, string message, string dateTime )
        {
            this.senderAccount = senderAccount;
            this.receiverAccount = receiverAccount;
            this.message = message;
            this.dateTime = dateTime;
        }

        [DataMember]
        private string senderAccount;

        [DataMember]
        private string receiverAccount;

        [DataMember]
        private string message;

        [DataMember]
        private string dateTime;
    }

    [DataContract]
    public class MessageWithId
    {
         public MessageWithId(string localNo, string senderAccount, string receiverAccount, string message, string dateTime )
        {
            this.localNo = localNo;
            this.senderAccount = senderAccount;
            this.receiverAccount = receiverAccount;
            this.message = message;
            this.dateTime = dateTime;
        }
         [DataMember]
         private string localNo;
        [DataMember]
        private string senderAccount;

        [DataMember]
        private string receiverAccount;

        [DataMember]
        private string message;

        [DataMember]
        private string dateTime;
    }

}