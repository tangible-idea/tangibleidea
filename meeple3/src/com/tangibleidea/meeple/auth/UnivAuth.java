package com.tangibleidea.meeple.auth;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.Header;
import org.apache.http.HeaderElement;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;

import android.content.Context;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.tangibleidea.meeple.server.RequestMethods;



public class UnivAuth
{
	private Context mContext;
	private String strCurrUniv;
	private int nCurrUniv;
	
	private OnAuthListener CBauth;

	
	public UnivAuth(Context _context)
	{
		mContext= _context;
	}
	

	
	public void SNUAuth(String URL, String ID, String PW)
	{
		try
		{
			HttpClient client = new DefaultHttpClient();
			HttpPost post = new HttpPost(URL);
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("si_realm", "SnuUser1"));
			params.add(new BasicNameValuePair("si_id", ID));
			params.add(new BasicNameValuePair("si_pwd", PW));
			UrlEncodedFormEntity ent = new UrlEncodedFormEntity(params, HTTP.UTF_8);
			post.setEntity(ent);
			HttpResponse res = client.execute(post);
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(true, "포털 아이디 인증 성공!");
		} catch (Exception e)
		{
			e.printStackTrace();
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(false, "서울대 포털 아이디 인증 실패.");
		}
	}
	
	public void KoreaUnivAuth(String URL, String ID, String PW)
	{
		//junguni / shan0210
		
		RequestMethods RM= new RequestMethods();
		String msg= RM.GetKoreaUnivAuth(URL, ID, PW);
		
		if(msg==null)	// 제대로 못받아옴
		{
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(false, "고려대 포털 접속 실패.");
			return;
		}
		
		if(msg.equals(""))	// 아무 메세지도 없으면 성공
		{
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(true, "고려대 포털 아이디 인증 성공.");
		}else{
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(false, msg);
		}
	}
	
	public void YonseiUnivAuth(final WebView WV, String strURL, String ID, String PW)
	{
		//https://im.yonsei.ac.kr/sso/auth?ssousername=0667012&password=yj3624yj&v=v1.2&site2pstoretoken=v1.2~45EC5C94~58B458BFAFA12DD6720B502B3B6E3E4B9DD12E76AB68DB407C7841CF668C469421E9150E2F6D44339BA5332B4E7E82DE5EC1D05219D2FE42D9F36C6701DF82D58AEEA1A6CA306F96E67CC1C5339B6FB4100D54DF65E514F40B9B4C0CB250AE5F67997A3655B6F4F6B228C2C91204568883AAFD866348D16C35DF0D58CF8F50A9509FE3A44D645D5D07263CB0B55CE43050BAD963935D1AA76BDA33BF60118F610315C704E498DE77078540983AAD909D
		//https://im.yonsei.ac.kr/sso/auth
		//?ssousername=0667012&password=yj3624yj
		//&v=v1.2&site2pstoretoken=v1.2~45EC5C94~58B458BFAFA12DD6720B502B3B6E3E4B9DD12E76AB68DB407C7841CF668C469421E9150E2F6D44339BA5332B4E7E82DE5EC1D05219D2FE42D9F36C6701DF82D58AEEA1A6CA306F96E67CC1C5339B6FB4100D54DF65E514F40B9B4C0CB250AE5F67997A3655B6F4F6B228C2C91204568883AAFD866348D16C35DF0D58CF8F50A9509FE3A44D645D5D07263CB0B55CE43050BAD963935D1AA76BDA33BF60118F610315C704E498DE77078540983AAD909D
//		try
//		{
//			HttpClient client = new DefaultHttpClient();
//			HttpPost post = new HttpPost(URL);
//			List<NameValuePair> params = new ArrayList<NameValuePair>();
//			params.add(new BasicNameValuePair("ssousername", ID));
//			params.add(new BasicNameValuePair("password", PW));
//			params.add(new BasicNameValuePair("v", "v1.2"));
//			params.add(new BasicNameValuePair("site2pstoretoken", "v1.2~45EC5C94~58B458BFAFA12DD6720B502B3B6E3E4B9DD12E76AB68DB407C7841CF668C469421E9150E2F6D44339BA5332B4E7E82DE5EC1D05219D2FE42D9F36C6701DF82D58AEEA1A6CA306F96E67CC1C5339B6FB4100D54DF65E514F40B9B4C0CB250AE5F67997A3655B6F4F6B228C2C91204568883AAFD866348D16C35DF0D58CF8F50A9509FE3A44D645D5D07263CB0B55CE43050BAD963935D1AA76BDA33BF60118F610315C704E498DE77078540983AAD909D"));
//			UrlEncodedFormEntity ent = new UrlEncodedFormEntity(params, HTTP.UTF_8);
//			post.setEntity(ent);
//			HttpResponse res = client.execute(post);
//			HttpEntity resEntity = res.getEntity();
//			
//			 BufferedReader br = null;      
//		        String line = null;
//		        try
//		        {
//		            // 응답 페이지 읽기
//		            br = new BufferedReader( new InputStreamReader(resEntity.getContent() ));
//		            while((line = br.readLine()) != null)
//		            {
//		                Log.d("YONSEI_HTTP_RES",line);
//		            }          
//		        } finally {
//		            if(br != null) try { br.close(); } catch(Exception e) {}
//		        }
//			
//			CBauth.OnLoadCompelete(true);
//			CBauth.OnAuthResult(true);
//		} catch (Exception e)
//		{
//			e.printStackTrace();
//			CBauth.OnLoadCompelete(true);
//			CBauth.OnAuthResult(false);
//		}
		String URL= strURL+"?ssousername="+ID+"&password="+PW+"&v=v1.2&site2pstoretoken=v1.2~45EC5C94~58B458BFAFA12DD6720B502B3B6E3E4B9DD12E76AB68DB407C7841CF668C469421E9150E2F6D44339BA5332B4E7E82DE5EC1D05219D2FE42D9F36C6701DF82D58AEEA1A6CA306F96E67CC1C5339B6FB4100D54DF65E514F40B9B4C0CB250AE5F67997A3655B6F4F6B228C2C91204568883AAFD866348D16C35DF0D58CF8F50A9509FE3A44D645D5D07263CB0B55CE43050BAD963935D1AA76BDA33BF60118F610315C704E498DE77078540983AAD909D";
		
		WV.getSettings().setJavaScriptEnabled(true);
		WV.addJavascriptInterface(new JavaScriptInterface(), "HTMLOUT");
		WV.setWebViewClient(new WebViewClient()
		{
			public void onPageFinished(WebView view, String _url)
			{
				Log.d("URL load finished", _url);
				WV.loadUrl( "javascript:window.HTMLOUT.showYenseiHTML('<head>'+document.getElementsByTagName('html')[0].innerHTML+'</head>');" );
				if( CBauth != null ) // 콜백 등록 되어있으면
					CBauth.OnLoadCompelete(true); // 로딩 끝				
			}
		});
		
		WV.loadUrl(URL); // 처음은 URL1 로드
	}
	
	public void SogangAuth(final WebView WV, final String URL, final String ID, final String PW)
	{
//		WV.getSettings().setJavaScriptEnabled(true);
//		WV.addJavascriptInterface(new JavaScriptInterface(), "HTMLOUT");
//		WV.setWebViewClient(new WebViewClient()
//		{
//			public void onPageFinished(WebView view, String url)
//			{
//				Log.d("URL1 load finished", url);
//				if(url.equals( URL1 ))
//				{
//					WV.loadUrl( URL2 +"user_id="+ ID +"&user_passwd="+PW );
//					return;
//				}
//				if(url.equals(URL2 +"user_id="+ ID +"&user_passwd="+PW))
//				{
//					WV.loadUrl( "javascript:window.HTMLOUT.showSogangHTML('<head>'+document.getElementsByTagName('html')[0].innerHTML+'</head>');" );
//					if( CBauth != null ) // 콜백 등록 되어있으면
//						CBauth.OnLoadCompelete(true); // 로딩 끝
//				}
//			}
//		});
//		
//		WV.loadUrl(URL1); // 처음은 URL1 로드
		
		try
		{
			HttpClient client = new DefaultHttpClient();
			HttpPost post = new HttpPost(URL);
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			//params.add(new BasicNameValuePair("si_realm", "SnuUser1"));
			params.add(new BasicNameValuePair("id", ID));
			params.add(new BasicNameValuePair("password", PW));
			UrlEncodedFormEntity ent = new UrlEncodedFormEntity(params, HTTP.UTF_8);
			post.setEntity(ent);
			HttpResponse res = client.execute(post);
			HttpEntity resEntity = res.getEntity();
			
			
			BufferedReader br = null;
	        String line = null;
	        try
	        {
	            // 응답 페이지 읽기
	            br = new BufferedReader( new InputStreamReader(resEntity.getContent() ));
	            while((line = br.readLine()) != null)
	            {
	            	line= new String(line.getBytes(), "euc-kr");
	                Log.d("SOGANG_HTTP_RES",line);
	            }          
	        } finally {
	            if(br != null) try { br.close(); } catch(Exception e) {}
	        }
	        
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(true, "포털 아이디 인증 성공!");
		} catch (Exception e)
		{
			e.printStackTrace();
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(false, "서울대 포털 아이디 인증 실패.");
		}
	}
	
	
	
	
	
	class JavaScriptInterface
	{
		public void showSogangHTML(String html)
		{
			String str=html.substring(14,15); // 성공= "h" , 실패= "m"
			
		
			if( CBauth != null ) // 콜백 등록 되어있으면
			{				
				if(str.equals("h"))
				{
					CBauth.OnAuthResult(true, "서강대 포털 아이디 인증 성공!"); // 인증 성공
				}
				else if(str.equals("m"))
				{
					CBauth.OnAuthResult(false, "서강대 포털 아이디 인증 실패.");
				}
				else
				{
					CBauth.OnAuthResult(false, "서강대 포털 아이디 인증 실패.");
				}
			}
		}
		
		
		public void showYenseiHTML(String html)
		{ 
			String str=html.substring(20,22); // 성공= "학생" , 실패= "bo","40"
			
		
			if( CBauth != null ) // 콜백 등록 되어있으면
			{				
				if(str.equals("학생"))
				{
					CBauth.OnAuthResult(true, "연세대 포털 아이디 인증 성공."); // 인증 성공
				}
				else if(str.equals("bo") || str.equals("40"))
				{
					CBauth.OnAuthResult(false, "연세대 포털 아이디 인증 실패.");
				}
				else
				{
					CBauth.OnAuthResult(false, "연세대 포털 아이디 인증 실패.");
				}
			}
		}
	}

	// 콜백 등록 메서드
	public void SetOnAuthListener(OnAuthListener _CB)
	{
		this.CBauth= _CB;
	}

	
	
}
