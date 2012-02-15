package com.tangibleidea.meeple.util;


public class ChatManager
{
	private String C2DMoppoAccount="";	// C2DM으로 왔음. pending된 intent로 갈때 채팅할 상대방ID
	private String CurrOppoAccount="";	// 현재 나와 대화하고 있는 사람
	private String CurrChatID="";		// 현재 대화하고 있는 채팅방 ID
	
	private final static ChatManager instance= new ChatManager();
	
	private ChatManager()
	{
		
	}
	
	public static final ChatManager GetInstance()
	{
		return instance;
	}
	
	public void AcceptC2DMuser()
	{
		if(!C2DMoppoAccount.equals(""))	 // C2DM이 왔으면
			CurrOppoAccount= C2DMoppoAccount;	// 현재 채팅상대를 C2DM에서 온 상대방ID로 변경.
		
		C2DMoppoAccount="";
	}

	/**
	 * @return the c2DMoppoAccount
	 */
	public String getC2DMoppoAccount()
	{
		return C2DMoppoAccount;
	}

	/**
	 * @return the currOppoAccount
	 */
	public String getCurrOppoAccount()
	{
		return CurrOppoAccount;
	}

	/**
	 * @return the currChatID
	 */
	public String getCurrChatID()
	{
		return CurrChatID;
	}

	/**
	 * @param c2dMoppoAccount the c2DMoppoAccount to set
	 */
	public void setC2DMoppoAccount(String c2dMoppoAccount)
	{
		C2DMoppoAccount = c2dMoppoAccount;
	}

	/**
	 * @param currOppoAccount the currOppoAccount to set
	 */
	public void setCurrOppoAccount(String currOppoAccount)
	{
		CurrOppoAccount = currOppoAccount;
	}

	/**
	 * @param currChatID the currChatID to set
	 */
	public void setCurrChatID(String currChatID)
	{
		CurrChatID = currChatID;
	}
	
}
