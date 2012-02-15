package com.tangibleidea.meeple.layout;

public class RecentTalkEntry
{
	private boolean bEndChat;
	private String strCount;
	private String strID;
	private String strOppoName;
	private String strContent;
	private String strChatID;
	private String strTime;
	
	/**
	 * 
	 * @param bEndChat
	 * @param nCount
	 * @param strContent
	 * @param strTime
	 */
	public RecentTalkEntry(boolean bEndChat, String strCount, String strOppoID, String strOppoName, String strContent, String strChatID, String strTime)
	{
		super();
		this.strCount= strCount;
		this.strID= strOppoID;
		this.bEndChat = bEndChat;
		this.strOppoName= strOppoName;
		this.strContent = strContent;
		this.strChatID= strChatID;
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
	
	public String getAccountID()
	{
		return strID;
	}
	
	public String getChatID()
	{
		return strChatID;
	}
}
