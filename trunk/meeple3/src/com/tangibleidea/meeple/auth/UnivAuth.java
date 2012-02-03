package com.tangibleidea.meeple.auth;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

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
			CBauth.OnAuthResult(true);
		} catch (Exception e)
		{
			e.printStackTrace();
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(false);
		}
	}
	
	public void KoreaUnivAuth(String URL, String ID, String PW)
	{
		try
		{
			HttpClient client = new DefaultHttpClient();
			HttpPost post = new HttpPost(URL);
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("viewType", "main"));
			params.add(new BasicNameValuePair("loginType", "1"));
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
		                Log.d("KOREA_HTTP_RES",line);
		            }          
		        } finally {
		            if(br != null) try { br.close(); } catch(Exception e) {}
		        }
		        
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(true);
		} catch (Exception e)
		{
			e.printStackTrace();
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(false);
		}
	}
	
	public void YonseiUnivAuth(String URL, String ID, String PW)
	{
		try
		{
			HttpClient client = new DefaultHttpClient();
			HttpPost post = new HttpPost(URL);
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("noticeBkey", "0"));
			params.add(new BasicNameValuePair("userid", ID));
			params.add(new BasicNameValuePair("passwd", PW));
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
		                Log.d("YONSEI_HTTP_RES",line);
		            }          
		        } finally {
		            if(br != null) try { br.close(); } catch(Exception e) {}
		        }
			
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(true);
		} catch (Exception e)
		{
			e.printStackTrace();
			CBauth.OnLoadCompelete(true);
			CBauth.OnAuthResult(false);
		}
	}
	
	public void SogangAuth(final WebView WV, final String URL1, final String URL2, final String ID, final String PW)
	{
		WV.getSettings().setJavaScriptEnabled(true);
		WV.addJavascriptInterface(new JavaScriptInterface(), "HTMLOUT");
		WV.setWebViewClient(new WebViewClient()
		{
			public void onPageFinished(WebView view, String url)
			{
				Log.d("URL1 load finished", url);
				if(url.equals( URL1 ))
				{
					WV.loadUrl( URL2 +"user_id="+ ID +"&user_passwd="+PW );
					return;
				}
				if(url.equals(URL2 +"user_id="+ ID +"&user_passwd="+PW))
				{
					WV.loadUrl( "javascript:window.HTMLOUT.showHTML('<head>'+document.getElementsByTagName('html')[0].innerHTML+'</head>');" );
					if( CBauth != null ) // 콜백 등록 되어있으면
						CBauth.OnLoadCompelete(true); // 로딩 끝
				}
			}
		});
		
		WV.loadUrl(URL1); // 처음은 URL1 로드
	}
	
	public boolean SonguneAuth()
	{
		return false;
	}
	
	
	
	
	
	class JavaScriptInterface
	{
		public void showHTML(String html)
		{
			String str=html.substring(14,15); // 성공= "h" , 실패= "m"
			
		
			if( CBauth != null ) // 콜백 등록 되어있으면
			{				
				if(str.equals("h"))
				{
					CBauth.OnAuthResult(true); // 인증 성공
				}
				else if(str.equals("m"))
				{
					CBauth.OnAuthResult(false);
				}
				else
				{
					CBauth.OnAuthResult(false);
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
