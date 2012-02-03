package com.tangibleidea.meeple.server;

public class MentorInfo
{
	String strAccountId;
	String strName;
	String strUniv;
	String strMajor;
	String strPromo;
	String strComment;
	String strImage;
	String strLastModifiedTime;
	
	/**
	 * @param strAccountId
	 * @param strName
	 * @param strUniv
	 * @param strMajor
	 * @param strPromo
	 * @param strComment
	 * @param strImage
	 * @param strLastModifiedTime
	 */
	public MentorInfo(String strAccountId, String strName, String strUniv,
			String strMajor, String strPromo, String strComment,
			String strImage, String strLastModifiedTime)
	{
		this.strAccountId = strAccountId;
		this.strName = strName;
		this.strUniv = strUniv;
		this.strMajor = strMajor;
		this.strPromo = strPromo;
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
	 * @return the strUniv
	 */
	public String getUniv()
	{
		return strUniv;
	}

	/**
	 * @return the strMajor
	 */
	public String getMajor()
	{
		return strMajor;
	}

	/**
	 * @return the strPromo
	 */
	public String getPromo()
	{
		return strPromo;
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
//	public String getStrLastModifiedTime() {
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
	 * @param strUniv the strUniv to set
	 */
	public void setUniv(String strUniv)
	{
		this.strUniv = strUniv;
	}

	/**
	 * @param strMajor the strMajor to set
	 */
	public void setMajor(String strMajor)
	{
		this.strMajor = strMajor;
	}

	/**
	 * @param strPromo the strPromo to set
	 */
	public void setPromo(String strPromo)
	{
		this.strPromo = strPromo;
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
//	public void setLastModifiedTime(String strLastModifiedTime)
//	{
//		this.strLastModifiedTime = strLastModifiedTime;
//	}
}
