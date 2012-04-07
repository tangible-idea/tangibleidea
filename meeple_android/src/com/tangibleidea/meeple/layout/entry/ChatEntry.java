package com.tangibleidea.meeple.layout.entry;

public class ChatEntry
{
	private boolean bMyChat;
	private String strContent;
	private String strTime;
	
	/**
	 * @param bMyChat
	 * @param strContent
	 * @param strTime
	 * @param strImage
	 */
	public ChatEntry(boolean bMyChat, String strContent, String strTime)
	{
		super();
		this.bMyChat = bMyChat;
		this.strContent = strContent;
		this.strTime = strTime;
	}

	/**
	 * @return the bMyChat
	 */
	public boolean isMyChat()
	{
		return bMyChat;
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
