package com.tangibleidea.meeple.server;


public class MyInfo
{
	MenteeInfo m_Mentee;
	MentorInfo m_Mentor;
	String m_MySession;
	boolean m_bMentor;
	
	public static final MyInfo instance= new MyInfo(); 
	
	public static final MyInfo GetInstance()
	{
		return instance;
	}
	
	
	public void SetMyInfo(boolean isMentor, MenteeInfo mentee, MentorInfo mentor, String session)
	{
		m_bMentor= isMentor;
		m_Mentor= mentor;
		m_Mentee= mentee;
		m_MySession= session;
	}


	/**
	 * @return the m_Mentee
	 */
	public MenteeInfo getMenteeInfo()
	{
		return m_Mentee;
	}


	/**
	 * @return the m_Mentor
	 */
	public MentorInfo getMentorInfo()
	{
		return m_Mentor;
	}


	/**
	 * @return the m_MySession
	 */
	public String getMySession()
	{
		return m_MySession;
	}


	/**
	 * @return the m_bMentor
	 */
	public boolean isMentor()
	{
		return m_bMentor;
	}


	/**
	 * @param m_Mentee the m_Mentee to set
	 */
	public void setMenteeInfo(MenteeInfo m_Mentee)
	{
		this.m_Mentee = m_Mentee;
	}


	/**
	 * @param m_Mentor the m_Mentor to set
	 */
	public void setMentorInfo(MentorInfo m_Mentor)
	{
		this.m_Mentor = m_Mentor;
	}


	/**
	 * @param m_MySession the m_MySession to set
	 */
	public void setMySession(String m_MySession)
	{
		this.m_MySession = m_MySession;
	}


	/**
	 * @param m_bMentor the m_bMentor to set
	 */
	public void setbMentor(boolean m_bMentor)
	{
		this.m_bMentor = m_bMentor;
	}
}
