package com.tangibleidea.meeple.activity;

import com.tangibleidea.meeple.util.Global;

import android.os.Bundle;
import android.preference.EditTextPreference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceScreen;

public class SettingActivity extends PreferenceActivity
{
	
	boolean isMentor=  Global.s_Info.isMentor();
	
    @Override 
    protected void onCreate(Bundle savedInstanceState)
    {
         super.onCreate(savedInstanceState);
        
        setPreferenceScreen(createPreferenceHierarchy());
    }
    
    private PreferenceScreen createPreferenceHierarchy()
    {
        // Root
        PreferenceScreen root = getPreferenceManager().createPreferenceScreen(this);

        	PreferenceCategory CAT_defaultInfo = new PreferenceCategory(this);
	        CAT_defaultInfo.setTitle("기본정보");	        
	        root.addPreference(CAT_defaultInfo);
	        
	        if( !isMentor )
	        {
	        	EditTextPreference EPT_name = new EditTextPreference(this);
		        EPT_name.setDialogTitle("[이름 입력]");
		        EPT_name.setKey("mentee_name");
		        EPT_name.setTitle("이름 변경");
		        EPT_name.setSummary( Global.s_Info.getMenteeInfo().getName() );
		        
		        EditTextPreference EPT_school = new EditTextPreference(this);
		        EPT_school.setDialogTitle("[학교 입력]");
		        EPT_school.setKey("mentee_school");
		        EPT_school.setTitle("학교 변경");
		        EPT_school.setSummary( Global.s_Info.getMenteeInfo().getSchool() );
		        
		        EditTextPreference EPT_grade = new EditTextPreference(this);
		        EPT_grade.setDialogTitle("[학년 입력]");
		        EPT_grade.setKey("mentee_grade");
		        EPT_grade.setTitle("학년 변경");
		        EPT_grade.setSummary( Global.s_Info.getMenteeInfo().getGrade() );
		        
		        CAT_defaultInfo.addPreference(EPT_name);
		        CAT_defaultInfo.addPreference(EPT_school);
		        CAT_defaultInfo.addPreference(EPT_grade);
		        
	        }else{
	        	EditTextPreference EPT_name = new EditTextPreference(this);
		        EPT_name.setDialogTitle("[이름 입력]");
		        EPT_name.setKey("mentor_name");
		        EPT_name.setTitle("이름 변경");
		        EPT_name.setSummary( Global.s_Info.getMentorInfo().getName() );
		        
		        EditTextPreference EPT_major = new EditTextPreference(this);
		        EPT_major.setDialogTitle("[전공 입력]");
		        EPT_major.setKey("mentor_major");
		        EPT_major.setTitle("전공 변경");
		        EPT_major.setSummary( Global.s_Info.getMentorInfo().getMajor() );
		        
		        EditTextPreference EPT_promo = new EditTextPreference(this);
		        EPT_promo.setDialogTitle("[학번 입력]");
		        EPT_promo.setKey("mentor_promo");
		        EPT_promo.setTitle("학번 변경");
		        EPT_promo.setSummary( Global.s_Info.getMentorInfo().getPromo() );
		        
		        CAT_defaultInfo.addPreference(EPT_name);
		        CAT_defaultInfo.addPreference(EPT_major);
		        CAT_defaultInfo.addPreference(EPT_promo);
	        }
		        
		        
	        
	        
	        PreferenceCategory CAT_AddtionInfo = new PreferenceCategory(this);
	        CAT_AddtionInfo.setTitle("부가정보");
	        root.addPreference(CAT_AddtionInfo);
	        
	        EditTextPreference EPT_comment;
	        
	        if( !isMentor )
	        {
		        EPT_comment = new EditTextPreference(this);
		        EPT_comment.setDialogTitle("[오늘의 한마디 입력]");
		        EPT_comment.setKey("mentee_comment");
		        EPT_comment.setTitle("오늘의 한마디");
		        EPT_comment.setSummary( Global.s_Info.getMenteeInfo().getComment() );
	        }else{
		        EPT_comment = new EditTextPreference(this);
		        EPT_comment.setDialogTitle("[오늘의 한마디 입력]");
		        EPT_comment.setKey("mentor_comment");
		        EPT_comment.setTitle("오늘의 한마디");
		        EPT_comment.setSummary( Global.s_Info.getMentorInfo().getComment() );
	        }
		        
		    CAT_AddtionInfo.addPreference(EPT_comment);
        
        
        
		return root;
    }
}
