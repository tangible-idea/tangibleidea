package com.tangibleidea.meeple.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Encoder
{
	private String strText;
	
	public Encoder(String strOriginalText)
	{	
		strText= strOriginalText;
	}
	
	public String Encode()
	{
		StringBuffer SB= new StringBuffer();
		
		try
		{
			MessageDigest MD= MessageDigest.getInstance("MD5");
			MD.update( strText.getBytes() );
			byte[] bMD5= MD.digest();
			
			for(int i=0; i<bMD5.length; ++i)
			{
				String strChar= String.format("%02x", 0xff&(char)bMD5[i] );
				SB.append(strChar);
			}			
		}
		catch (NoSuchAlgorithmException e)
		{
			e.printStackTrace();
		}
		
		return SB.toString();
	}
}
