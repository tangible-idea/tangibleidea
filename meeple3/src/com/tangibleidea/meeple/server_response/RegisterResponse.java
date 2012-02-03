package com.tangibleidea.meeple.server_response;

public class RegisterResponse
{
	boolean bSuccess;
	String strSession;
	String strReason;
	/**
	 * @param bSuccess
	 * @param strSession
	 * @param strReason
	 */
	public RegisterResponse(boolean bSuccess, String strSession,
			String strReason)
	{
		super();
		this.bSuccess = bSuccess;
		this.strSession = strSession;
		this.strReason = strReason;
	}
	/**
	 * @return the bSuccess
	 */
	public boolean isSuccess()
	{
		return bSuccess;
	}
	/**
	 * @return the strSession
	 */
	public String getSession()
	{
		return strSession;
	}
	/**
	 * @return the strReason
	 */
	public String getReason()
	{
		return strReason;
	}
}
