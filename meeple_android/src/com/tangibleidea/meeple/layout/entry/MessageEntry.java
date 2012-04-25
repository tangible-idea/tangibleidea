package com.tangibleidea.meeple.layout.entry;

public class MessageEntry extends ChatEntry
{
	String strOppoName= "";
	
	public MessageEntry(boolean bMyChat, String OppoName, String strContent, String strTime)
	{
		super(bMyChat, strContent, strTime);
		
		this.strOppoName= OppoName;
	}

	public String GetOppoName()
	{
		return this.strOppoName;
	}
}
