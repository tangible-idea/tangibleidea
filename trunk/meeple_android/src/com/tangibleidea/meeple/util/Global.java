package com.tangibleidea.meeple.util;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import com.tangibleidea.meeple.data.EnumError;

public class Global
{
	public final static String SERVER_IP= 	"http://tangibleidea.co.kr";//"http://tangibleidea.co.kr";//"http://64.23.67.167";	//1.234.2.227
	public final static String SERVER= 		SERVER_IP+ ":9091/MeepleService/";	// C#서버+메서드?+인자1=값1&인자2=값2 (HTTP GET 방식)
	public final static String SERVER_IMG= 	SERVER_IP+ "/userImage/";	// 이미지를 볼 수 있는 경로+유저이름+".jpg" (테스트는 userImage_test)
	//public final static String SERVER= "http://192.168.1.5:9091/MeepleService/";
	//112.168.48.138
	
	public static final int s_nRequest_Fail= -100;	// 
	public static final int s_nRequest_MentorJoin= 100;	// 멘티가입
	public static final int s_nRequest_MenteeJoin= 101;	// 멘토가입
	public static final int s_nRequest_Login= 200;	// 로그인했음
	public static final int s_nRequest_500= 500;		// 
	
	public static final int s_nIntent_Fail= -1;		// 
	public static final int s_nIntent_0	= 0;		// 
	public static final int s_nIntent_JoinSuccess= 1;	// 가입 성공
	public static final int s_nIntent_InChat= 2;		// 대화 상태 
	
	public static boolean s_HasNewChat= false;	// C2DM으로 새로운 채팅이 도착했는가?
	public static int s_nLobbyToTap= -1;	// C2DM으로 해당 인덱스로 넘어가는가?
	
	
	public static String s_MyUniv="";

	
	public static final int DB_VERSION= 4;						//
	public static final String DB_NAME= "meeple_chat.db";			// DB 이름
	public static final String DB_TABLE_CHAT= "chat_info";			// 대화 DB 테이블 이름
	public static final String DB_TABLE_ENDCHAT= "endchat_info";			// 끝낸 대화 DB 정보 테이블 이름
	
	public static final String LOG_TAG="MEEPLE";
	public static final String DEV_EMAIL="junhyeok@tangibleidea.co.kr";
	//public static String REG_ID="0";
	
	public static EnumError s_Error= EnumError.E_NONE_ERROR;
	
	
	//public static final MyInfo s_Info= MyInfo.GetInstance();
	
    /**
     * @param context
     *            id 발급 메서드
     */
    public static void C2DM_ID_Register(Context context)
    {
    	SPUtil.putString(context, "reg_id", "0");	// Exception을 막기 위해 처음 0을 넣어주고 받아온다.
    		
      Intent registrationIntent = new Intent("com.google.android.c2dm.intent.REGISTER");
       
      registrationIntent.putExtra("app", PendingIntent.getBroadcast(context, 0, new Intent(), 0));
      registrationIntent.putExtra("sender", Global.DEV_EMAIL);
      
      context.startService(registrationIntent);
    }
}
