package com.tangibleidea.meeple.layout.entry;


public class MessageEntry extends ChatEntry
{
	String strOppoID= "";
	
	public MessageEntry(boolean bMyChat, String OppoID, String strContent, String strTime)
	{
		super(bMyChat, strContent, strTime);
		
		this.strOppoID= OppoID;
	}
	
	public String GetOppoID()
	{
		return this.strOppoID;
	}

}
