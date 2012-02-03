package com.tangibleidea.meeple.util;

import com.tangibleidea.meeple.data.EnumError;
import com.tangibleidea.meeple.server.MyInfo;

public class Global
{
	public final static String SERVER= "http://1.234.2.227:9090/MeepleService/";
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
	public static final int s_nIntent_2= 2;		// 
	
	public static String s_MyUniv="";
	
	public static final int DB_VERSION= 37;						// DB버전 (v1.2~1.3 = 37)
	public static final String DB_NAME= "biblequiz.db";			// DB 이름
	public static final String DB_TABLE_MYINFO= "myinfo";			// DB 이름
	
	public static final String LOG_TAG="MEEPLE";
	public static final String DEV_EMAIL="junhyeok@tangibleidea.co.kr";
	public static String REG_ID="0";
	
	public static EnumError s_Error= EnumError.E_NONE_ERROR;
	
	
	public static final MyInfo s_Info= MyInfo.GetInstance();
	 
}
