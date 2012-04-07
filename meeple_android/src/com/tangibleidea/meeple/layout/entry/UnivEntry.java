package com.tangibleidea.meeple.layout.entry;

public class UnivEntry
{
	/**
	 * @param strUnivName : 학교이름
	 * @param strLogoName : 로고명
	 */
	public UnivEntry(String strUnivName, String strLogoName)
	{
		super();
		this.strUnivName = strUnivName;
		this.strLogoName = strLogoName;
	}
	
	private String strUnivName;
	private String strLogoName;
	/**
	 * @return the strUnivName
	 */
	public String getUnivName()
	{
		return strUnivName;
	}
	/**
	 * @return the strLogoName
	 */
	public String getLogoName()
	{
		return strLogoName;
	}
	/**
	 * @param strUnivName the strUnivName to set
	 */
	public void setStrUnivName(String strUnivName)
	{
		this.strUnivName = strUnivName;
	}
	/**
	 * @param strLogoName the strLogoName to set
	 */
	public void setStrLogoName(String strLogoName)
	{
		this.strLogoName = strLogoName;
	}
}
