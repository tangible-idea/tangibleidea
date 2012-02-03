package com.tangibleidea.meeple.server_response;

import com.tangibleidea.meeple.server.MenteeInfo;
import com.tangibleidea.meeple.server.MentorInfo;

public class LoginResponse
{
	boolean bMentor;
	MenteeInfo m_Mentee;
	MentorInfo m_Mentor;
	String strSession;
	boolean bSuccess;
	
	/**
	 * @param bMentor
	 * @param m_Mentee
	 * @param m_Mentor
	 * @param strSession
	 * @param bSuccess
	 */
	public LoginResponse(boolean bMentor, MenteeInfo m_Mentee,
			MentorInfo m_Mentor, String strSession, boolean bSuccess)
	{
		super();
		this.bMentor = bMentor;
		this.m_Mentee = m_Mentee;
		this.m_Mentor = m_Mentor;
		this.strSession = strSession;
		this.bSuccess = bSuccess;
	}

	/**
	 * @return the bMentor
	 */
	public boolean isMentor()
	{
		return bMentor;
	}

	/**
	 * @return the m_Mentee
	 */
	public MenteeInfo getMentee()
	{
		return m_Mentee;
	}

	/**
	 * @return the m_Mentor
	 */
	public MentorInfo getMentor()
	{
		return m_Mentor;
	}

	/**
	 * @return the strSession
	 */
	public String getSession()
	{
		return strSession;
	}

	/**
	 * @return the bSuccess
	 */
	public boolean isSuccess()
	{
		return bSuccess;
	}
	
}
