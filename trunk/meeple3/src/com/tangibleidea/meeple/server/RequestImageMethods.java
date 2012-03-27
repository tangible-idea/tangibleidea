package com.tangibleidea.meeple.server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.impl.client.DefaultHttpClient;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.widget.ImageView;

import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.ImageDownloader2;
import com.tangibleidea.meeple.util.SPUtil;

public class RequestImageMethods extends RequestMethods
{
	public boolean UploadImage(Context context, byte[] byteImage)
	{
		String res;
		
		String URL= Global.SERVER+ "SaveImage?"
				+"account="+ SPUtil.getString(context, "AccountID")
				+"&session="+ SPUtil.getString(context, "session")
				+"&file="+ byteImage;	
		
		HttpClient httpClient = new DefaultHttpClient();
		HttpPost postRequest = new HttpPost(URL);
		
		try
		{
			ByteArrayBody BAB = new ByteArrayBody(byteImage, SPUtil.getString(context, "AccountID")+".jpg");
			MultipartEntity reqEntity = new MultipartEntity( HttpMultipartMode.BROWSER_COMPATIBLE);

			reqEntity.addPart("file", BAB);
			
			postRequest.setEntity(reqEntity);
		   
			HttpResponse response = httpClient.execute(postRequest);
			BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"));
		   
			String sResponse;
			StringBuilder SB = new StringBuilder();
	
			while ((sResponse = reader.readLine()) != null)
			{
				SB = SB.append(sResponse);
			}
		   
			res= SB.toString();
			Log.i("SendImage::파일업로드요청", res);
			
		   	}
		catch (ClientProtocolException e)
		{
			Log.e("SendImage::ClientProtocolException::파일업로드 실패",e.getMessage());
			return false;
		}
		catch (IOException e)
		{
			Log.e("SendImage::IOException::파일업로드 실패", e.getMessage());
			return false;
        }
		catch (Exception e)
		{
			Log.e("SendImage::Exception::파일업로드 실패", e.getMessage());
			return false;
		}
		
		if(res.equals("true"))	// 서버에서 넘어온 값으로 판단한다.
		{
			return true;
		}else{
			return false;
		}
	}
	
	public void DownloadImage(ImageView IV, String AccountID) 
	{
		String URL= Global.SERVER_IMG+ AccountID+".jpg";
		
		Log.d("RIM::DownloadImage", URL);
		
		ImageDownloader2 downloader= new ImageDownloader2();
		downloader.download(URL, IV);
	}
	
	public Bitmap DownloadImageToThread(String AccountID)
	{
		Bitmap res;
		
		String URL= Global.SERVER_IMG+ AccountID+".jpg";	// 계정ID에 맞는 URL 생성
		
		Log.d("RIM::DownloadImage", URL);
		
		ImageDownloader2 downloader= new ImageDownloader2();
		res= downloader.downloadBitmap(URL);
		
		return res;
	}
}
