package com.tangibleidea.meeple.server;

public class MenteeInfo
{
	String strAccountId;
	String strName;
	String strSchool;
	String strGrade;
	String strEmail;
	String strComment;
	String strImage;
	String strLastModifiedTime;
	
	/**
	 * @param strAccountId
	 * @param strName
	 * @param strSchool
	 * @param strGrade
	 * @param strEmail
	 * @param strComment
	 * @param strImage
	 * @param strLastModifiedTime
	 */
	public MenteeInfo(String strAccountId, String strName, String strSchool,
			String strGrade, String strEmail, String strComment,
			String strImage, String strLastModifiedTime)
	{
		super();
		this.strAccountId = strAccountId;
		this.strName = strName;
		this.strSchool = strSchool;
		this.strGrade = strGrade;
		this.strEmail = strEmail;
		this.strComment = strComment;
		this.strImage = strImage;
		this.strLastModifiedTime = strLastModifiedTime;
	}

	/**
	 * @return the strAccountId
	 */
	public String getAccountId()
	{
		return strAccountId;
	}

	/**
	 * @return the strName
	 */
	public String getName()
	{
		return strName;
	}

	/**
	 * @return the strSchool
	 */
	public String getSchool()
	{
		return strSchool;
	}

	/**
	 * @return the strGrade
	 */
	public String getGrade()
	{
		return strGrade;
	}

	/**
	 * @return the strEmail
	 */
	public String getEmail()
	{
		return strEmail;
	}

	/**
	 * @return the strComment
	 */
	public String getComment()
	{
		return strComment;
	}

	/**
	 * @return the strImage
	 */
	public String getImage()
	{
		return strImage;
	}

	/**
	 * @return the strLastModifiedTime
	 */
//	public String getLastModifiedTime()
//	{
//		return strLastModifiedTime;
//	}

	/**
	 * @param strAccountId the strAccountId to set
	 */
//	public void setStrAccountId(String strAccountId) {
//		this.strAccountId = strAccountId;
//	}

	/**
	 * @param strName the strName to set
	 */
	public void setName(String strName)
	{
		this.strName = strName;
	}

	/**
	 * @param strSchool the strSchool to set
	 */
	public void setStrSchool(String strSchool)
	{
		this.strSchool = strSchool;
	}

	/**
	 * @param strGrade the strGrade to set
	 */
	public void setGrade(String strGrade)
	{
		this.strGrade = strGrade;
	}

	/**
	 * @param strEmail the strEmail to set
	 */
	public void setEmail(String strEmail)
	{
		this.strEmail = strEmail;
	}

	/**
	 * @param strComment the strComment to set
	 */
	public void setComment(String strComment)
	{
		this.strComment = strComment;
	}

	/**
	 * @param strImage the strImage to set
	 */
	public void setImage(String strImage)
	{
		this.strImage = strImage;
	}

	/**
	 * @param strLastModifiedTime the strLastModifiedTime to set
	 */
//	public void setLastModifiedTime(String strLastModifiedTime) {
//		this.strLastModifiedTime = strLastModifiedTime;
//	}
	
}
