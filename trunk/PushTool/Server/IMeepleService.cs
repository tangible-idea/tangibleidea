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
        
        [OperationContract]
        [WebGet( ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare )]
        // password는 MD5 Hash로 인크립트해서 보낼 것. MD5 인크립트의 결과는 256bit(32byte이다)
        bool dummy();

    }

    // 아래 샘플에 나타낸 것처럼 데이터 계약을 사용하여 복합 형식을 서비스 작업에 추가합니다.

    [DataContract]
    public class IdAndPush
    {
        public IdAndPush(String userId, String push, bool isApple, String androidpush, bool isMentor)
        {
            this.userId = userId;
            this.push = push;
            this.isApple = isApple;
            this.isMentor = isMentor;
            this.androidpush = androidpush;
        }

        [DataMember]
        public String userId;

        [DataMember]
        public String push;

        [DataMember]
        public bool isApple;

        [DataMember]
        public bool isMentor;

        [DataMember]
        public String androidpush;
    }

}