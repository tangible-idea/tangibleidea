package com.tangibleidea.meeple.layout;

public class InfoEntry
{
	public EnumMeepleStatus eSTAT;
	private String strID;
	private String strName;
    private String strSchool;
    private String strSub;
    private int photo;
    
    public InfoEntry(String _id, String _name, String _school,String _sub, int _photo, EnumMeepleStatus eStat)
    {
    	this.strID= _id;
        this.strName = _name;
        this.strSchool = _school;
        this.strSub= _sub;
        this.photo = _photo;
        this.eSTAT= eStat;
    }
    
    public String getID()
    {
    	return strID;
    }
    
    public String getName()
    {
        return strName;
    }

    public String getSchool()
    {
        return strSchool;
    }
    
    public String getSub()
    {
    	return strSub;
    }

    public int getPhotoId()
    {
        return photo;
    }
}
