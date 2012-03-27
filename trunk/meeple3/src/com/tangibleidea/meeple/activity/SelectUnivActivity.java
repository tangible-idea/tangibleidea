package com.tangibleidea.meeple.activity;

import java.util.ArrayList;
import java.util.List;

import android.app.AlertDialog;
import android.app.ListActivity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.UnivEntry;
import com.tangibleidea.meeple.layout.UnivListAdapter;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.HangulUtils;

public class SelectUnivActivity extends ListActivity
{
	private Context mContext;
	
	ArrayAdapter<UnivEntry> list1;
	final ArrayList<UnivEntry> arraylist= new ArrayList<UnivEntry>();
	final ArrayList<UnivEntry> arraylist_filt= new ArrayList<UnivEntry>();
	private String searchKeyword="";
	
	
	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		mContext= this;
		
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.univ_list);
		
		EditText searchBox = (EditText) findViewById(R.id.edt_univ_search);
		
		searchBox.addTextChangedListener(new TextWatcher()
		{
			public void afterTextChanged(Editable arg0)
			{
				// ignore
			}

			public void beforeTextChanged(CharSequence s, int start, int count, int after)
			{
				// ignore
			}

			public void onTextChanged(CharSequence s, int start, int before, int count)
			{
				try
				{
					searchKeyword = s.toString();
					DisplayUnivList();	// 글자가 변하면 그에 따른 리스트를 즉각 표시한다
				}
				catch (Exception e)
				{
					Log.e("", e.getMessage(), e);
				}
			}

		});
		
		arraylist.add( new UnivEntry("가천대학교","univ_0.png") );
		arraylist.add( new UnivEntry("가톨릭대학교","univ_1.png") );
		arraylist.add( new UnivEntry("건국대학교","univ_2.png") );
		arraylist.add( new UnivEntry("경기대학교","univ_3.png") );
		arraylist.add( new UnivEntry("경북대학교","univ_4.png") );
		arraylist.add( new UnivEntry("경희대학교","univ_5.png") );
		arraylist.add( new UnivEntry("고려대학교","univ_6.png") );
		arraylist.add( new UnivEntry("광운대학교","univ_7.png") );
		arraylist.add( new UnivEntry("국민대학교","univ_8.png") );
		arraylist.add( new UnivEntry("금강대학교","univ_9.png") );
		arraylist.add( new UnivEntry("단국대학교","univ_10.png") );
		arraylist.add( new UnivEntry("덕성여자대학교","univ_11.png") );
		arraylist.add( new UnivEntry("동국대학교","univ_12.png") );
		arraylist.add( new UnivEntry("동덕여자학교","univ_13.png") );
		arraylist.add( new UnivEntry("명지대학교","univ_14.png") );
		arraylist.add( new UnivEntry("부산대학교","univ_15.png") );
		arraylist.add( new UnivEntry("상명대학교","univ_16.png") );
		arraylist.add( new UnivEntry("서강대학교","univ_17.png") );
		arraylist.add( new UnivEntry("서울과학기술대학교","univ_18.png") );
		arraylist.add( new UnivEntry("서울대학교","univ_19.png") );
		arraylist.add( new UnivEntry("서울시립대학교","univ_20.png") );
		arraylist.add( new UnivEntry("서울여자대학교","univ_21.png") );
		arraylist.add( new UnivEntry("성균관대학교","univ_22.png") );
		arraylist.add( new UnivEntry("성신여자대학교","univ_23.png") );
		arraylist.add( new UnivEntry("세종대학교","univ_24.png") );
		arraylist.add( new UnivEntry("숙명여자대학교","univ_25.png") );
		arraylist.add( new UnivEntry("숭실대학교","univ_26.png") );
		arraylist.add( new UnivEntry("아주대학교","univ_27.png") );
		arraylist.add( new UnivEntry("연세대학교","univ_28.png") );
		arraylist.add( new UnivEntry("울산과학대학교","univ_29.png") );
		arraylist.add( new UnivEntry("이화여자대학교","univ_30.png") );
		arraylist.add( new UnivEntry("인천대학교","univ_31.png") );
		arraylist.add( new UnivEntry("인하대학교","univ_32.png") );
		arraylist.add( new UnivEntry("전남대학교","univ_33.png") );
		arraylist.add( new UnivEntry("전북대학교","univ_34.png") );
		arraylist.add( new UnivEntry("중앙대학교","univ_35.png") );
		arraylist.add( new UnivEntry("충남대학교","univ_36.png") );
		arraylist.add( new UnivEntry("충북대학교","univ_37.png") );
		arraylist.add( new UnivEntry("카이스트(한국과학기술원)","univ_38.png") );
		arraylist.add( new UnivEntry("포항공과대학교","univ_39.png") );
		arraylist.add( new UnivEntry("한국교원학교","univ_40.png") );
		arraylist.add( new UnivEntry("한국기술교육대학교","univ_41.png") );
		arraylist.add( new UnivEntry("한국예술종합학교","univ_42.png") );
		arraylist.add( new UnivEntry("한국외국어대학교","univ_43.png") );
		arraylist.add( new UnivEntry("한국체육대학교","univ_44.png") );
		arraylist.add( new UnivEntry("한국항공대학교","univ_45.png") );
		arraylist.add( new UnivEntry("한동대학교","univ_46.png") );
		arraylist.add( new UnivEntry("한양대학교","univ_47.png") );
		arraylist.add( new UnivEntry("홍익대학교","univ_48.png") );
		//arraylist.add( new UnivEntry("임시계정","univ_0.png") );
				
		this.DisplayUnivList();
	}
	
	private void DisplayUnivList()
	{
		this.ResetUnivArrayList(); 		// 한번 필터링 해주고
		
		if(searchKeyword.equals(""))	// 필터링목록이 없으면, 본목록을 띄워주고 있으면 필터링목록을 띄워줌			
			list1 =  new UnivListAdapter(mContext, R.layout.entry_univ, R.id.eUnivName, arraylist);
		else
			list1 =  new UnivListAdapter(mContext, R.layout.entry_univ, R.id.eUnivName, arraylist_filt);
		
		setListAdapter(list1);
	}
	
	private void ResetUnivArrayList()
	{
//		if(list1 != null)	// 이미 한번 세팅되었으면(보여줬으면)
//			list1.clear();	// 보여주는 리스트 어댑터 클리어
		
		arraylist_filt.clear();	// 필터링 목록 초기화
		
		for(UnivEntry e : arraylist)
		{
			boolean isAdd = false;

			if (searchKeyword != null && !searchKeyword.trim().equals("") )
			{
				String iniName = HangulUtils.getHangulInitialSound(e.getUnivName(), searchKeyword);

				if (iniName.indexOf(searchKeyword) >= 0)	// 검색어가 맞으면
					isAdd = true;
			}
			else
				isAdd = true;

			
			if (isAdd)
				arraylist_filt.add(new UnivEntry(e.getUnivName(), e.getLogoName()));
		}
	}
	
	

	public void onListItemClick(ListView l, View v, final int pos, long id)
	{
		new AlertDialog.Builder(this)
        .setTitle("대학교 선택 확인")
        .setMessage("["+arraylist.get(pos).getUnivName() + "]\n선택하신 학교가 맞나요?") 
        .setPositiveButton("확인", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int whichButton)
            {
            	Global.s_MyUniv= arraylist.get(pos).getUnivName();
            	
            	if(pos==6 || pos==17 || pos==19 || pos==28 )	 // 인증이 있는 학교면(서연고서)
            	{
            		Intent intent= new Intent(SelectUnivActivity.this, AuthActivity.class);
            		startActivity(intent);
            	}else{	
            		Intent intent= new Intent(SelectUnivActivity.this, MentorJoinActivity.class);
            		startActivity(intent);
            	}
            }
        })
        .setNegativeButton("취소", new DialogInterface.OnClickListener()
        {
        	public void onClick(DialogInterface dialog, int whichButton)
            {
            }
        })
        .show();
		
	}
}
