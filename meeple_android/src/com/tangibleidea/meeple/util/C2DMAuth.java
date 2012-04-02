package com.tangibleidea.meeple.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import android.util.Log;

public class C2DMAuth
{
private static String HOST = "https://www.google.com/accounts/ClientLogin";
private static String EMAIL = Global.DEV_EMAIL;      //사용자 아이디
private static String PASS = "apsxhfld";                 //비밀번호
private static String SOURCE = "android_push_meeple";   //어플리케이션에 대한 간단한 설명

	public static String SetupC2DMAndroid() throws Exception
	{
		String AUTH= null;
		
		try
		{
			StringBuffer postDataBuilder = new StringBuffer();
			
			postDataBuilder.append("Email=" + EMAIL);
			postDataBuilder.append("&Passwd=" + PASS);
			postDataBuilder.append("&accountType=GOOGLE");
			postDataBuilder.append("&source=" + SOURCE);
			postDataBuilder.append("&service=ac2dm");
			
			byte[] postData = postDataBuilder.toString().getBytes("UTF8");
			URL url = new URL(HOST);
			
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
			conn.setRequestProperty("Content-Length",Integer.toString(postData.length));
			
			OutputStream out = conn.getOutputStream();
			out.write(postData);
			out.close();
			
			BufferedReader in = new BufferedReader( new InputStreamReader(conn.getInputStream()));
			String inputLine;
			
			while ((inputLine = in.readLine()) != null)
			{
				if( inputLine.startsWith("Auth=") )
					AUTH= inputLine.substring(5);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		Log.d(Global.LOG_TAG, Integer.toString( AUTH.length()) );
		
		return AUTH;
	}
}