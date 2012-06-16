package com.tangibleidea.meeple.layout.entry;

import com.tangibleidea.meeple.layout.enums.EnumRecentTalkStatus;

public class RecentTalkEntry
{
	public EnumRecentTalkStatus eSTAT= EnumRecentTalkStatus.E_NONE;
	private String strCount;
	private String strID;
	private String strOppoName;
	private String strEndDate;
	private String strContent;
	private String strChatID;
	private String strTime;
	
	/**
	 * 최근대화엔트리 설정
	 * @param bEndChat : 끝난 채팅인가요
	 * @param strEndDate : 끝난 시각 (끝난 대화 조회시 사용함)
	 * @param strCount : 새로운 채팅이 몇개인가?
	 * @param strOppoID : 상대방 ID
	 * @param strOppoName : 상대방 이름
	 * @param strContent : 최근 대화
	 * @param strChatID : 마지막 채팅 ID
	 * @param strTime : 마지막 채팅 시간
	 */
	
	public RecentTalkEntry(EnumRecentTalkStatus stat, String strEndDate, String strCount, String strOppoID, String strOppoName,  String strContent, String strChatID, String strTime)
	{
		super();
		this.eSTAT= stat;
		this.strEndDate= strEndDate;
		this.strCount= strCount;
		this.strID= strOppoID;
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
		if(eSTAT==EnumRecentTalkStatus.E_FINISHED_TALK)	// 끝난 채팅이면
			return true;
		return false;
	}

	/**
	 * @return the nCount
	 */
	public String getCount()
	{
		return strCount;
	}
	
	/**
	 * @return the strEndDate
	 */
	public String getStrEndDate()
	{
		return strEndDate;
	}

	/**
	 * @param strEndDate the strEndDate to set
	 */
	public void setStrEndDate(String strEndDate)
	{
		this.strEndDate = strEndDate;
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
