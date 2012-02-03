package com.tangibleidea.meeple.server;

public class RecentChat extends Chat
{
	String strCount;
	boolean bEndChat;

	public RecentChat(String senderAccount, String receiverAccount, String chat, String dateTime, String chatId, String count)
	{
		super(senderAccount, receiverAccount, chat, dateTime, chatId);
	
		this.strCount= count;
	}

	public boolean isEndChat()
	{
		return bEndChat;
	}
	
	/**
	 * @return the strCount
	 */
	public String getCount()
	{
		return strCount;
	}

	/**
	 * @param strCount the strCount to set
	 */
	public void setCount(String strCount)
	{
		this.strCount = strCount;
	}

}
