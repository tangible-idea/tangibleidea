package com.tangibleidea.meeple.server;

public class Notice
{
	int nNumber;
	String strTitle;
	String strContent;
	String strDate;
	boolean bExpand;
	/**
	 * @param nNumber
	 * @param strTitle
	 * @param strContent
	 * @param strDate
	 */
	public Notice(int nNumber, String strTitle, String strContent, String strDate, boolean _bExpand)
	{
		super();
		this.nNumber = nNumber;
		this.strTitle = strTitle;
		this.strContent = strContent;
		this.strDate = strDate;
		this.bExpand= _bExpand;
	}
	/**
	 * @return the bExpand
	 */
	public boolean isExpand()
	{
		return bExpand;
	}
	/**
	 * @param bExpand the bExpand to set
	 */
	public void setExpand(boolean bExpand)
	{
		this.bExpand = bExpand;
	}
	/**
	 * @return the nNumber
	 */
	public int getNumber()
	{
		return nNumber;
	}
	/**
	 * @return the strTitle
	 */
	public String getTitle()
	{
		return strTitle;
	}
	/**
	 * @return the strContent
	 */
	public String getContent()
	{
		return strContent;
	}
	/**
	 * @return the strDate
	 */
	public String getDate()
	{
		return strDate;
	}
}
