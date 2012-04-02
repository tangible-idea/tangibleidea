package com.tangibleidea.meeple.server;

public class Chat
{
    protected String senderAccount;
    protected String receiverAccount;
    protected String chat;
    protected String dateTime;
    protected String chatId;
    
    public Chat(String senderAccount, String receiverAccount, String chat, String dateTime, String chatId)
    {
        this.senderAccount = senderAccount;
        this.receiverAccount = receiverAccount;
        this.chat = chat;
        this.dateTime = dateTime;
        this.chatId = chatId;
    }

	/**
	 * @return the senderAccount
	 */
	public String getSenderAccount()
	{
		return senderAccount;
	}

	/**
	 * @return the receiverAccount
	 */
	public String getReceiverAccount()
	{
		return receiverAccount;
	}

	/**
	 * @return the chat
	 */
	public String getChat()
	{
		return chat;
	}

	/**
	 * @return the dateTime
	 */
	public String getDateTime()
	{
		return dateTime;
	}

	/**
	 * @return the chatId
	 */
	public String getChatId()
	{
		return chatId;
	}
}
