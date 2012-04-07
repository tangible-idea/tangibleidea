package com.tangibleidea.meeple.data;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import android.graphics.Bitmap;


//간단한 이미지 리스트를 제공합니다.
//직렬화를 선언하여서 파일캐쉬로 쓰기를 가능하게 한다. 
public class ImageCache implements Serializable
{
	
	private static final long serialVersionUID = 3490364931254392574L;
	
	private final Map<String , SynchronizedBitmap> synchronizedMap;
	
	public ImageCache()
	{
		synchronizedMap = new HashMap<String , SynchronizedBitmap>();
	}
	
	void addBitmapToCache(String url , Bitmap bitmap) {
		// 비트맵 추가
		synchronizedMap.put(url, new SynchronizedBitmap(bitmap));	
	}
	
	Bitmap getBitmapFromCache(String url) {
		// 비트맵 추출
		SynchronizedBitmap bitmap = synchronizedMap.get(url);
		if (bitmap != null)
			return bitmap.get();
		return null;
	}
	
	public void clearCache() {
		// 모든 캐시 삭제
		synchronizedMap.clear();
	}
		
	public static ImageCache toImageCache (String fileName)
	{
		ImageCache imageCache = null;
		try {
			imageCache = (ImageCache)ObjectRepository.readObject(fileName);
		} catch (Exception e) {
		}
		return imageCache;  
	}
	
	public static boolean fromImageCache (String fileName , ImageCache cache) {
		// 해당 객체를 파일로 저장
		try
		{
			ObjectRepository.saveObject(cache, fileName);
			return true;
		} catch (Exception e) {
		}
		return false;
	}
		
	// 직렬화된 비트맵 객체 선언 
	static final class SynchronizedBitmap implements Serializable
	{
		private static final long serialVersionUID = 1859678728937516189L;
		
		private final Bitmap bitmap;
		
		public SynchronizedBitmap(Bitmap bitmap) {
			this.bitmap = bitmap;
		}
		
		public Bitmap get() {
			return bitmap;
		}
	}
}
