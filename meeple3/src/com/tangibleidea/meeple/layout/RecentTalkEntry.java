package com.tangibleidea.meeple.layout;

public class RecentTalkEntry
{
	private boolean bEndChat;
	private String strCount;
	private String strOppoName;
	private String strContent;
	private String strTime;
	
	/**
	 * 
	 * @param bEndChat
	 * @param nCount
	 * @param strContent
	 * @param strTime
	 */
	public RecentTalkEntry(boolean bEndChat, String strCount, String strOppoName, String strContent, String strTime)
	{
		super();
		this.strCount= strCount;
		this.bEndChat = bEndChat;
		this.strOppoName= strOppoName;
		this.strContent = strContent;
		this.strTime = strTime;
	}

	/**
	 * @return the bEndChat
	 */
	public boolean isEndChat()
	{
		return bEndChat;
	}

	/**
	 * @return the nCount
	 */
	public String getCount()
	{
		return strCount;
	}
	
	public String getOppoName()
	{
		return strOppoName;
	}

	/**
	 * @return the strContent
	 */
	public String getContent()
	{
		return strContent;
	}

	/**
	 * @return the strTime
	 */
	public String getTime()
	{
		return strTime;
	}
}
