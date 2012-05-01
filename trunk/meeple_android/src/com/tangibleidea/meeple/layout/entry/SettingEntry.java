package com.tangibleidea.meeple.layout.entry;

import com.tangibleidea.meeple.layout.enums.EnumSettingStatus;

public class SettingEntry
{
	public EnumSettingStatus eSTAT;
	private int ImgID= 0;
	private boolean bText= false;
	private String strText= "";
	
	/**
	 * 텍스트뷰로 나타낼 때의 SettingEntry 생성자
	 * @param eSTAT
	 * @param imgID
	 * @param strText
	 */
	public SettingEntry(EnumSettingStatus eSTAT, String strText)
	{
		super();
		this.eSTAT = eSTAT;
		ImgID = 0;
		this.bText = true;
		this.strText = strText;
	}
	
	/**
	 * 이미지뷰로 나타낼때의 SettingEntry 생성자
	 * @param eSTAT
	 * @param imgID
	 */
	public SettingEntry(EnumSettingStatus eSTAT, int imgID)
	{
		super();
		this.eSTAT = eSTAT;
		ImgID = imgID;
		this.bText = false;
		this.strText = "";
	}


	public int getImgID()
	{
		return ImgID;
	}

	public void setImgID(int imgID) 
	{
		ImgID = imgID;
	}

	public boolean isTextView()
	{
		return bText;
	}
	public String getStrText()
	{
		return strText;
	}

}
