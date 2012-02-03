package com.tangibleidea.meeple.server;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.tangibleidea.meeple.data.EnumError;
import com.tangibleidea.meeple.server_response.LoginResponse;
import com.tangibleidea.meeple.server_response.RegisterResponse;
import com.tangibleidea.meeple.util.C2DMAuth;
import com.tangibleidea.meeple.util.Encoder;
import com.tangibleidea.meeple.util.Global;

public class RequestMethods
{
	/**
	 * 서버에서 리턴값 가져오기
	 * @param _strURI : 서버에 보낼 URI
	 * @return : 서버에서 받은 JSONObject
	 */
	private String RequestStringToServer(String _strURI)
	{
		String res= null;
		HttpClient httpClient = new DefaultHttpClient();
		
		try
	    {
		    HttpGet request = new HttpGet( new URI(_strURI) );
		      
		    HttpResponse response = httpClient.execute(request); 
	        HttpEntity responseEntity = response.getEntity();
	        
	        char[] buffer = new char[(int)responseEntity.getContentLength()];
	        InputStream stream = responseEntity.getContent();
	        InputStreamReader reader = new InputStreamReader(stream);
	        reader.read(buffer);
	        stream.close();
	        
	         res= new String(buffer);
	    }
	    catch (IOException e)
	    {
	    	Log.e( "IOException", e.getMessage() );
	    }
	    catch (URISyntaxException e)
	    {
	    	Log.e( "URISyntaxException", e.getMessage() );
	    }
				
		return res;
	}
	
	/**
	 * 서버에서 리턴값 가져오기
	 * @param _strURI : 서버에 보낼 URI
	 * @return : 서버에서 받은 JSONObject
	 */
	private JSONObject RequestJSONObjectToServer(String _strURI)
	{
		JSONObject json = null;
		HttpClient httpClient = new DefaultHttpClient();
		
		try
	    {
		    HttpGet request = new HttpGet( new URI(_strURI) );
		      
		    HttpResponse response = httpClient.execute(request); 
	        HttpEntity responseEntity = response.getEntity();
	        
	        char[] buffer = new char[(int)responseEntity.getContentLength()];
	        InputStream stream = responseEntity.getContent();
	        InputStreamReader reader = new InputStreamReader(stream);
	        reader.read(buffer);
	        stream.close();
	        
	        json = new JSONObject(new String(buffer));
	    }
	    catch (IOException e)
	    {
	    	Log.e( "IOException", e.getMessage() );
	    }
	    catch (URISyntaxException e)
	    {
	    	Log.e( "URISyntaxException", e.getMessage() );
	    	Global.s_Error= EnumError.E_JOIN_WRONG_TEXT;
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
				
		return json;
	}
	
	/**
	 * 서버에서 Array 정보를 가져옴
	 * @param _strURI : 서버에 보낼 URI
	 * @return : 서버에서 받은 JSONObject
	 */
	private JSONArray RequestJSONArrayToServer(String _strURI)
	{
		JSONArray jarr= null;
		HttpClient httpClient = new DefaultHttpClient();
		
		try
	    {
		    HttpGet request = new HttpGet( new URI(_strURI) );
		      
		    HttpResponse response = httpClient.execute(request); 
	        HttpEntity responseEntity = response.getEntity();
	        
	        char[] buffer = new char[(int)responseEntity.getContentLength()];
	        InputStream stream = responseEntity.getContent();
	        InputStreamReader reader = new InputStreamReader(stream);
	        reader.read(buffer);
	        stream.close();
	        
	        jarr = new JSONArray(new String(buffer));
	    }
	    catch (IOException e)
	    {
	    	Log.e( "IOException", e.getMessage() );
	    }
	    catch (URISyntaxException e)
	    {
	    	Log.e( "URISyntaxException", e.getMessage() );
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
				
		return jarr;
	}

	/**
	 * 로그인
	 * @param _strID
	 * @param _strPW
	 * @return
	 */
	public LoginResponse Login(String _strID, String _strPW)
	{
		LoginResponse ResLogin= null;
		
		Encoder encoder= new Encoder(_strPW);
	    String URI = Global.SERVER + "Login?"
		      		+"account=" + _strID
		      		+"&password="+ encoder.Encode()
		      		+"&IsPush=false" // 안드로이드는 push 필요없다.
		      		+"&push=0";
	    
		try
	    {
		    JSONObject json= this.RequestJSONObjectToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    if(json==null)
		    	return null; // 서버 접속 오류 또는 인자 오류
		    
		    MentorInfo mentor=null;
		    MenteeInfo mentee=null;
		    String strSession= json.getString("session");
		    boolean bMentor  = json.getBoolean("isMentor");	    
		    boolean bSuccess = json.getBoolean("success");
		    
		    
		    if(bSuccess)	// 로그인 성공시
		    {
		    	JSONObject jMenteeInfo = null;
			    JSONObject jMentorInfo = null;
		    	
			    if(!bMentor) // 멘토가 아니면
			    {
			    	jMenteeInfo= json.getJSONObject("menteeInfo");
			    	String ID= jMenteeInfo.getString("AccountId");
			    	String comment= jMenteeInfo.getString("Comment");
			    	String email= jMenteeInfo.getString("Email");
			    	String grade= jMenteeInfo.getString("Grade");
			    	String image= jMenteeInfo.getString("Image");
			    	String time= jMenteeInfo.getString("LastModifiedTime");
			    	String name= jMenteeInfo.getString("Name");
			    	String school= jMenteeInfo.getString("School");
			    	
			    	mentee= new MenteeInfo(ID, name, school, grade, email, comment, image, time); // 멘티일 경우 멘티 정보 생성
			    	
			    }else{
			    	jMentorInfo= json.getJSONObject("mentorInfo");
			    	String ID = jMentorInfo.getString("AccountId");
			    	String comment= jMentorInfo.getString("Comment");
			    	String email= jMentorInfo.getString("Email");
			    	String image= jMentorInfo.getString("Image");
			    	String time= jMentorInfo.getString("LastModifiedTime");
			    	String major= jMentorInfo.getString("Major");
			    	String name= jMentorInfo.getString("Name");
			    	String promo= jMentorInfo.getString("Promo");
			    	String univ= jMentorInfo.getString("Univ");
			    	
			    	mentor= new MentorInfo(ID, name,univ, major, promo, comment, image, time);	// 멘토일 경우 멘토 정보 생성
			    }
		    }
		    else
		    {
		    	
		    }
		    ResLogin= new LoginResponse(bMentor ,mentee, mentor, strSession, bSuccess);
		        
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
		
		return ResLogin;
	}
	
	/**
	 * 멘티 회원가입
	 * @param _strID
	 * @param _strPW
	 * @param _strEmail
	 * @param _strName
	 * @param _strGender
	 * @param _strSchool
	 * @param _strGrade
	 * @return
	 */
	public RegisterResponse RegisterMentee(String _strID, String _strPW, String _strEmail, String _strName, String _strGender, String _strSchool, String _strGrade)
	{
		RegisterResponse res= null;
		String IsPush= "true";
		
		if( Global.REG_ID.equals("0") )
			IsPush="false";

		
		Encoder encoder= new Encoder(_strPW);
	    String URI = Global.SERVER + "RegisterMentee?"
		      		+"account=" + _strID
		      		+"&password="+ encoder.Encode()
		      		+"&IsPush="+ IsPush
		      		+"&push="+ Global.REG_ID
		      		+"&email="+ _strEmail
		      		+"&name="+ _strName
		      		+"&gender="+ _strGender
		      		+"&school="+ _strSchool
		      		+"&grade="+ _strGrade;
	   
	    try
	    {
		    JSONObject json= this.RequestJSONObjectToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    if(json==null)
		    	return null; // 서버 접속 오류 또는 인자 오류
		    
		    boolean bSuccess= json.getBoolean("success");
		    String session= json.getString("session");
		    String reason= json.getString("reason");
		    
		    res= new RegisterResponse(bSuccess, session, reason);
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    
	    
	    return res;
	}
	
	
	/**
	 * 멘토 회원가입
	 * @param _strID
	 * @param _strPW
	 * @param _strEmail
	 * @param _strGender
	 * @param _strName
	 * @param _strUniv
	 * @param _strMajor
	 * @param _strPromo
	 * @return
	 */
	public RegisterResponse RegisterMentor(String _strID, String _strPW, String _strEmail, String _strGender, String _strName, String _strUniv, String _strMajor, String _strPromo )
	{
		RegisterResponse res= null;
		String IsPush= "true";
		
		if( Global.REG_ID.equals("0") )
			IsPush="false";
		
		Encoder encoder= new Encoder(_strPW);
	    String URI = Global.SERVER + "RegisterMentor?"
		      		+"account=" + _strID
		      		+"&password="+ encoder.Encode()
		      		+"&IsPush="+ IsPush
		      		+"&push="+ Global.REG_ID
		      		+"&name="+ _strName
		      		+"&gender="+ _strGender
		      		+"&email="+ _strEmail
		      		+"&univ="+ _strUniv
	    			+"&promo="+_strPromo
	    			+"&major="+_strMajor;
	   
	    try
	    {
		    JSONObject json= this.RequestJSONObjectToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    boolean bSuccess= json.getBoolean("success");
		    String session= json.getString("session");
		    String reason= json.getString("reason");
		    
		    res= new RegisterResponse(bSuccess, session, reason);
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
		
		
		return res; 
	}
	
	
	/**
	 * 멘토의 정보(자신의 정보)를 가져옵니다.
	 * @return
	 */
	public List<MentorInfo> GetRelationsMentor()
	{
		List<MentorInfo> res= new ArrayList<MentorInfo>();
		
	    String URI = Global.SERVER + "GetRelationsMentor?"
	      		+"account=" + Global.s_Info.m_Mentee.getAccountId()
	      		+"&session=" + Global.s_Info.m_MySession;
	    try
	    {
		    JSONArray jarr= this.RequestJSONArrayToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    if(jarr == null)
		    	return null;
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	String id= jarr.getJSONObject(i).getString("AccountId");
		    	res.add( new MentorInfo(id,null,null,null,null,null,null,null) );
		    }
   
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    return res;
	}
	
	
	/**
	 * 멘티의 정보(자신의 정보)를 가져옵니다.
	 * @return
	 */
	public List<MenteeInfo> GetRelationsMentee()
	{
		List<MenteeInfo> res= new ArrayList<MenteeInfo>();
		
	    String URI = Global.SERVER + "GetRelationsMentor?"
	      		+"account=" + Global.s_Info.m_Mentor.getAccountId()
	      		+"&session=" + Global.s_Info.m_MySession;
	    try
	    {
		    JSONArray jarr= this.RequestJSONArrayToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    if(jarr == null)
		    	return null;
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	String id= jarr.getJSONObject(i).getString("AccountId");
		    	res.add( new MenteeInfo(id,null,null,null,null,null,null,null) );
		    }
   
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    return res;
	}
	

	/**
	 * 멘토(나)의 수락을 기다리고 있는 멘티
	 * @return
	 */
	public List<MenteeInfo> PendingMenteeRecommmendations()
	{
		List<MenteeInfo> res= new ArrayList<MenteeInfo>();
		
	    String URI = Global.SERVER + "MenteeRecommendations?"
	      		+"localAccount=" + Global.s_Info.m_Mentor.getAccountId()
	      		+"&session=" + Global.s_Info.m_MySession;
	    
	    try
	    {
		    JSONObject json= this.RequestJSONObjectToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    if(json == null)
		    	return null;
		    
		    JSONArray jarr= json.getJSONArray("pendingRecommmendations");
		    
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	String id= jarr.getJSONObject(i).getString("AccountId");
		    	String name= jarr.getJSONObject(i).getString("Name");
		    	String school= jarr.getJSONObject(i).getString("School");
		    	String grade= jarr.getJSONObject(i).getString("Grade");
		    	String email= jarr.getJSONObject(i).getString("Email");
		    	String comment= jarr.getJSONObject(i).getString("Comment");
		    	String image= jarr.getJSONObject(i).getString("Image");
		    	String time= jarr.getJSONObject(i).getString("LastModifiedTime");
		    	res.add( new MenteeInfo(id,name,school,grade,email,comment,image,time) );
		    }
   
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    return res;
	}
	
	/**
	 * 멘토(나)와 대화중인 멘티
	 * @return
	 */
	public List<MenteeInfo> InProgressMenteeRecommmendations()
	{
		List<MenteeInfo> res= new ArrayList<MenteeInfo>();
		
	    String URI = Global.SERVER + "MenteeRecommendations?"
	      		+"localAccount=" + Global.s_Info.m_Mentor.getAccountId()
	      		+"&session=" + Global.s_Info.m_MySession;
	    
	    try
	    {
		    JSONObject json= this.RequestJSONObjectToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    if(json == null)
		    	return null;
		    
		    JSONArray jarr= json.getJSONArray("inProgressRecommendations");
		    
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	String id= jarr.getJSONObject(i).getString("AccountId");
		    	String name= jarr.getJSONObject(i).getString("Name");
		    	String school= jarr.getJSONObject(i).getString("School");
		    	String grade= jarr.getJSONObject(i).getString("Grade");
		    	String email= jarr.getJSONObject(i).getString("Email");
		    	String comment= jarr.getJSONObject(i).getString("Comment");
		    	String image= jarr.getJSONObject(i).getString("Image");
		    	String time= jarr.getJSONObject(i).getString("LastModifiedTime");
		    	res.add( new MenteeInfo(id,name,school,grade,email,comment,image,time) );
		    }
   
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    return res;
	}
	
	/**
	 * 멘토가 수락을 하고 응답을 기다리는 중인 멘티
	 * @return
	 */
	public List<MenteeInfo> WaitingMenteeRecommmendations()
	{
		List<MenteeInfo> res= new ArrayList<MenteeInfo>();
		
	    String URI = Global.SERVER + "MenteeRecommendations?"
	      		+"localAccount=" + Global.s_Info.m_Mentor.getAccountId()
	      		+"&session=" + Global.s_Info.m_MySession;
	    
	    try
	    {
		    JSONObject json= this.RequestJSONObjectToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    if(json == null)
		    	return null;
		    
		    JSONArray jarr= json.getJSONArray("waitingRecommendations");
		    
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	String id= jarr.getJSONObject(i).getString("AccountId");
		    	String name= jarr.getJSONObject(i).getString("Name");
		    	String school= jarr.getJSONObject(i).getString("School");
		    	String grade= jarr.getJSONObject(i).getString("Grade");
		    	String email= jarr.getJSONObject(i).getString("Email");
		    	String comment= jarr.getJSONObject(i).getString("Comment");
		    	String image= jarr.getJSONObject(i).getString("Image");
		    	String time= jarr.getJSONObject(i).getString("LastModifiedTime");
		    	res.add( new MenteeInfo(id,name,school,grade,email,comment,image,time) );
		    }
   
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    return res;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 멘티(나)의 수락을 기다리고 있는 멘토 (멘티가 이미 수락한 상황만 나옴)
	 * @return
	 */
	public List<MentorInfo> PendingMentorRecommmendations()
	{
		List<MentorInfo> res= new ArrayList<MentorInfo>();
		
	    String URI = Global.SERVER + "MentorRecommendations?"
	      		+"localAccount=" + Global.s_Info.m_Mentee.getAccountId()
	      		+"&session=" + Global.s_Info.m_MySession;
	    
	    try
	    {
		    JSONObject json= this.RequestJSONObjectToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    if(json == null)
		    	return null;
		    
		    JSONArray jarr= json.getJSONArray("pendingRecommmendations");
		    
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	String id= jarr.getJSONObject(i).getString("AccountId");
		    	String name= jarr.getJSONObject(i).getString("Name");
		    	String comment= jarr.getJSONObject(i).getString("Comment");
		    	String email= jarr.getJSONObject(i).getString("Email");
		    	String image= jarr.getJSONObject(i).getString("Image");
		    	String time= jarr.getJSONObject(i).getString("LastModifiedTime");
		    	String major= jarr.getJSONObject(i).getString("Major");
		    	String promo= jarr.getJSONObject(i).getString("Promo");
		    	String univ= jarr.getJSONObject(i).getString("Univ");
		    	res.add( new MentorInfo(id,name, univ, major, promo, comment, image, time) );
		    }
   
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    return res;
	}
	
	/**
	 * 멘티(나)와 대화중인 멘토
	 * @return
	 */
	public List<MentorInfo> InProgressMentorRecommmendations()
	{
		List<MentorInfo> res= new ArrayList<MentorInfo>();
		
	    String URI = Global.SERVER + "MentorRecommendations?"
	      		+"localAccount=" + Global.s_Info.m_Mentee.getAccountId()
	      		+"&session=" + Global.s_Info.m_MySession;
	    
	    try
	    {
		    JSONObject json= this.RequestJSONObjectToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		    
		    if(json == null)
		    	return null;
		    
		    JSONArray jarr= json.getJSONArray("inProgressRecommendations");
		    
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	String id= jarr.getJSONObject(i).getString("AccountId");
		    	String name= jarr.getJSONObject(i).getString("Name");
		    	String comment= jarr.getJSONObject(i).getString("Comment");
		    	String email= jarr.getJSONObject(i).getString("Email");
		    	String image= jarr.getJSONObject(i).getString("Image");
		    	String time= jarr.getJSONObject(i).getString("LastModifiedTime");
		    	String major= jarr.getJSONObject(i).getString("Major");
		    	String promo= jarr.getJSONObject(i).getString("Promo");
		    	String univ= jarr.getJSONObject(i).getString("Univ");
		    	res.add( new MentorInfo(id,name, univ, major, promo, comment, image, time) );
		    }
   
	    }
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    return res;
	}
	
	
	/**
	 * 상대를 수락 또는 거절합니다.
	 * @param oppoAccount : 상대방 아이디
	 * @param bAccept : 수락 여부
	 * @return : 서버에서 쿼리 성공여부
	 */
	public boolean RespondRecommendation(String oppoAccount, boolean bMentor, boolean bAccept)
	{
		boolean res;
		String strAccept;
		String strID;
		
		if(bMentor)
			strID= Global.s_Info.m_Mentor.getAccountId();
		else
			strID= Global.s_Info.m_Mentee.getAccountId();
		
		if(bAccept)
			strAccept="true";
		else
			strAccept="false";
			
	    String URI = Global.SERVER + "RespondRecommendation?"
	      		+"localAccount=" + strID
	      		+"&oppoAccount=" + oppoAccount
	      		+"&session=" + Global.s_Info.m_MySession
	      		+"&accept=" + strAccept;
		    String strRes= this.RequestStringToServer(URI);	// 만들어진 URI를 WCF서비스에 요청한다.
		     
		    if(strRes == null)
		    	return false;
		    
		    if( strRes.equals("true") )
		    	res= true;
		    else
		    	res= false;
		    
		 return res;
	}
	
	/**
	 * 토크탭에서 최근 채팅을 가져올때 사용
	 * @param bMentor : 자신이 멘토인가?
	 * @return
	 */
	public List<RecentChat> GetRecentChatsNew(boolean bMentor)
	{
		List<RecentChat> res= new ArrayList<RecentChat>();
		String strID;
		
		if(bMentor)
			strID= Global.s_Info.m_Mentor.getAccountId();
		else
			strID= Global.s_Info.m_Mentee.getAccountId();
		
	    String URI = Global.SERVER + "GetRecentChatsNew?"
	      		+"localAccount=" + strID
	      		+"&session=" + Global.s_Info.m_MySession;
	    
	    try
	    {
		    JSONArray jarr= this.RequestJSONArrayToServer(URI);
		    
		    if(jarr == null)
		    	return null;
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	JSONObject json= jarr.getJSONObject(i);
		    	String _chat= json.getString("chat");
		    	String _chatId= json.getString("chatId");
		    	String _count= json.getString("count");
		    	String _dateTime= json.getString("dateTime");
		    	String _receiverAccount= json.getString("receiverAccount");
		    	String _senderAccount= json.getString("senderAccount");
		    	res.add( new RecentChat(_senderAccount, _receiverAccount, _chat, _dateTime, _chatId, _count) );
		    }
		}
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    
	    return res;
	}
	
	/**
	 * 인채팅에서 채팅 전달
	 * @param oppoAccount : 상대방ID
	 * @param chat : 내용
	 * @param bMentor : 멘토인가?
	 * @return : 채팅리스트
	 */
	public List<Chat> SendChatNew(String oppoAccount, String chat, boolean bMentor)
	{
		List<Chat> res= new ArrayList<Chat>();
		String strID;
		
		if(bMentor)
			strID= Global.s_Info.m_Mentor.getAccountId();
		else
			strID= Global.s_Info.m_Mentee.getAccountId();
		
	    String URI = Global.SERVER + "SendChatNew?"
	      		+"localAccount=" + strID
	      		+"&oppoAccount=" + oppoAccount
	      		+"&session=" + Global.s_Info.m_MySession
	      		+"&chat=" + chat;
	    
	    try
	    {
		    JSONArray jarr= this.RequestJSONArrayToServer(URI);
		    
		    if(jarr == null)
		    	return null;
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	JSONObject json= jarr.getJSONObject(i);
		    	String _chat= json.getString("chat");
		    	String _chatId= json.getString("chatId");
		    	String _dateTime= json.getString("dateTime");
		    	String _receiverAccount= json.getString("receiverAccount");
		    	String _senderAccount= json.getString("senderAccount");
		    	res.add( new Chat(_senderAccount, _receiverAccount, _chat, _dateTime, _chatId) );
		    }
		}
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    
	    return res;
	}
	
	
	/**
	 * 인채팅에서 최근 채팅가져옴
	 * @param oppoAccount
	 * @param chat
	 * @param bMentor
	 * @return
	 */
	public List<Chat> GetChatsNew(String oppoAccount, String chat, boolean bMentor)
	{
		List<Chat> res= new ArrayList<Chat>();
		String strID;
		
		if(bMentor)
			strID= Global.s_Info.m_Mentor.getAccountId();
		else
			strID= Global.s_Info.m_Mentee.getAccountId();
		
	    String URI = Global.SERVER + "GetChatsNew?"
	      		+"localAccount=" + strID
	      		+"&oppoAccount=" + oppoAccount
	      		+"&session=" + Global.s_Info.m_MySession
	      		+"&chat=" + chat;
	    
	    try
	    {
		    JSONArray jarr= this.RequestJSONArrayToServer(URI);
		    
		    if(jarr == null)
		    	return null;
		    
		    for(int i=0; i<jarr.length(); ++i)
		    {
		    	JSONObject json= jarr.getJSONObject(i);
		    	String _chat= json.getString("chat");
		    	String _chatId= json.getString("chatId");
		    	String _dateTime= json.getString("dateTime");
		    	String _receiverAccount= json.getString("receiverAccount");
		    	String _senderAccount= json.getString("senderAccount");
		    	res.add( new Chat(_senderAccount, _receiverAccount, _chat, _dateTime, _chatId) );
		    }
		}
	    catch (JSONException e)
	    {
	    	Log.e( "JSONException", e.getMessage() );
		}
	    
	    return res;
	}
}

