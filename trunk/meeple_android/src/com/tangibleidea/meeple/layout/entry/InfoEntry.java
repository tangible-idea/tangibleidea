package com.tangibleidea.meeple.layout.entry;

import com.tangibleidea.meeple.data.EnumMeepleStatus;


public class InfoEntry
{
	public EnumMeepleStatus eSTAT;
	private String strID;
	private String strName;
    private String strSchool;
    private String strSub;
    private String strComment;
    private int photo;
    
    public InfoEntry(String _id, String _name, String _school,String _sub, String _comment, int _photo, EnumMeepleStatus eStat)
    {
    	this.strID= _id;
        this.strName = _name;
        this.strSchool = _school;
        this.strSub= _sub;
        this.photo = _photo;
        this.strComment= _comment;
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
    
    public String getComment()
    {
    	return strComment;
    }
}
