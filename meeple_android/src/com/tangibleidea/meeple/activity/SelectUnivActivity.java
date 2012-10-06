package com.tangibleidea.meeple.activity;

import java.util.ArrayList;

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
import com.tangibleidea.meeple.layout.adapter.UnivListAdapter;
import com.tangibleidea.meeple.layout.entry.UnivEntry;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.HangulUtils;

public class SelectUnivActivity extends ListActivity
{
	private Context mContext;
	
	ArrayAdapter<UnivEntry> list1;
	final ArrayList<UnivEntry> arraylist= new ArrayList<UnivEntry>();
	final ArrayList<UnivEntry> arraylist_filt= new ArrayList<UnivEntry>();
	private String searchKeyword="";
	private boolean bFiltered= false;
	
	
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
		
//		arraylist.add( new UnivEntry("CHA의과대","univ_1.png") );
//		arraylist.add( new UnivEntry("가야대학교","univ_2.png") );
//		arraylist.add( new UnivEntry("감리신학대학교","univ_3.png") );
//		arraylist.add( new UnivEntry("강남대학교","univ_4.png") );
//		arraylist.add( new UnivEntry("강릉대학교","univ_5.png") );
//		arraylist.add( new UnivEntry("강원대학교","univ_6.png") );
//		arraylist.add( new UnivEntry("건양대학교","univ_7.png") );
//		arraylist.add( new UnivEntry("경남대학교","univ_8.png") );
//		arraylist.add( new UnivEntry("경동대학교","univ_9.png") );
//		arraylist.add( new UnivEntry("경상대학교","univ_10.png") );
//		arraylist.add( new UnivEntry("경성대학교","univ_11.png") );
//		arraylist.add( new UnivEntry("경운대학교","univ_12.png") );
//		arraylist.add( new UnivEntry("경일대학교","univ_13.png") );
//		arraylist.add( new UnivEntry("경주대학교","univ_14.png") );
//		arraylist.add( new UnivEntry("경찰대학교","univ_15.png") );
//		arraylist.add( new UnivEntry("계명대학교","univ_16.png") );
//		arraylist.add( new UnivEntry("고신대학교","univ_17.png") );
//		arraylist.add( new UnivEntry("공주대학교","univ_18.png") );
//		arraylist.add( new UnivEntry("관동대학교","univ_19.png") );
//		arraylist.add( new UnivEntry("광신대학교","univ_20.png") );
//		arraylist.add( new UnivEntry("광주대학교","univ_21.png") );
//		arraylist.add( new UnivEntry("광주여자대학교","univ_22.png") );
//		arraylist.add( new UnivEntry("광주카톨릭대학교","univ_23.png") );
//		arraylist.add( new UnivEntry("군산대학교","univ_24.png") );
//		arraylist.add( new UnivEntry("그리스도신학대학교","univ_25.png") );
//		arraylist.add( new UnivEntry("극동대학교","univ_26.png") );
//		arraylist.add( new UnivEntry("금오공과대학교","univ_27.png") );
//		arraylist.add( new UnivEntry("꽃동네현도사회복지대학교","univ_28.png") );
//		arraylist.add( new UnivEntry("나사렛대학교","univ_29.png") );
//		arraylist.add( new UnivEntry("남부대학교","univ_30.png") );
//		arraylist.add( new UnivEntry("남서울대학교","univ_31.png") );
//		arraylist.add( new UnivEntry("대구대학교","univ_32.png") );
//		arraylist.add( new UnivEntry("대구예술대학교","univ_33.png") );
//		arraylist.add( new UnivEntry("대구외국어대학교","univ_34.png") );
//		arraylist.add( new UnivEntry("대구카톨릭대학교","univ_35.png") );
//		arraylist.add( new UnivEntry("대구한의대학교","univ_36.png") );
//		arraylist.add( new UnivEntry("대불대학교","univ_37.png") );
//		arraylist.add( new UnivEntry("대신대학교","univ_38.png") );
//		arraylist.add( new UnivEntry("대전대학교","univ_39.png") );
//		arraylist.add( new UnivEntry("대전카톨릭대학교","univ_40.png") );
//		arraylist.add( new UnivEntry("대진대학교","univ_41.png") );
//		arraylist.add( new UnivEntry("동명대학교","univ_42.png") );
//		arraylist.add( new UnivEntry("동서대학교","univ_43.png") );
//		arraylist.add( new UnivEntry("동신대학교","univ_44.png") );
//		arraylist.add( new UnivEntry("동아대학교","univ_45.png") );
//		arraylist.add( new UnivEntry("동양대학교","univ_46.png") );
//		arraylist.add( new UnivEntry("동의대학교","univ_47.png") );
//		arraylist.add( new UnivEntry("동해대학교","univ_48.png") );
//		arraylist.add( new UnivEntry("루터대학교","univ_49.png") );
//		arraylist.add( new UnivEntry("명신대학교","univ_50.png") );
//		arraylist.add( new UnivEntry("목원대학교","univ_51.png") );
//		arraylist.add( new UnivEntry("목포대학교","univ_52.png") );
//		arraylist.add( new UnivEntry("목포카톨릭대학교","univ_53.png") );
//		arraylist.add( new UnivEntry("목포해양대학교","univ_54.png") );
//		arraylist.add( new UnivEntry("배재대학교","univ_55.png") );
//		arraylist.add( new UnivEntry("부경대학교","univ_56.png") );
//		arraylist.add( new UnivEntry("부산외국어대학교","univ_57.png") );
//		arraylist.add( new UnivEntry("부산카톨릭학교","univ_58.png") );
//		arraylist.add( new UnivEntry("삼육대학교","univ_59.png") );
//		arraylist.add( new UnivEntry("삼척대학교","univ_60.png") );
//		arraylist.add( new UnivEntry("상명대학교","univ_61.png") );
//		arraylist.add( new UnivEntry("상지대학교","univ_63.png") );
//		arraylist.add( new UnivEntry("서경대학교","univ_62.png") );
//		arraylist.add( new UnivEntry("서남대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("서울교육대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("서울기독대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("서울신학대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("서울장신대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("서원대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("선문대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("성결대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("성공회대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("성민대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("세명대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("수원대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("수원카톨릭대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("순천대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("순천향대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("신라대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("아세아연합신학대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("안동대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("안양대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("영남대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("영남신학대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("영동대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("영산대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("영산원불교대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("예원예술대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("용인대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("우석대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("우송대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("울산대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("원광대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("위덕대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("인제대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("인천카톨릭대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("전남대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("전주대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("제주대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("조선대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("중부대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("중앙숭가대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("중원대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("진주산업대학교","univ_0.png") );		
//		arraylist.add( new UnivEntry("창원대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("천안대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("청운대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("청주대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("초당대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("총신대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("추계예술대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("충주대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("침례신학대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("칼빈대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("탐라대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("평택대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한경대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한국국제대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한국산업기술대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한국성서대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한국전통문화학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한국해양대학교","univ_0.png") );		
//		arraylist.add( new UnivEntry("한남대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한라대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한려대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한림대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한밭대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한북대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한서대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한성대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한세대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한신대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("한영신학대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("협성대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("호남대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("호남신학대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("호서대학교","univ_0.png") );
//		arraylist.add( new UnivEntry("호원대학교","univ_0.png") );
		
		
		
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
		arraylist.add( new UnivEntry("임시계정","univ_0.png") );
				
		this.DisplayUnivList();
	}
	
	private void DisplayUnivList()
	{
		this.ResetUnivArrayList(); 		// 한번 필터링 해주고
		
		if(searchKeyword.equals(""))	// 필터링목록이 없으면, 본목록을 띄워주고 있으면 필터링목록을 띄워줌	
		{
			list1 =  new UnivListAdapter(mContext, R.layout.entry_univ, R.id.eUnivName, arraylist);
			bFiltered= false;
		}
		else
		{
			list1 =  new UnivListAdapter(mContext, R.layout.entry_univ, R.id.eUnivName, arraylist_filt);
			bFiltered= true;
		}
		
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
		if(bFiltered)
			Global.s_MyUniv= arraylist_filt.get(pos).getUnivName();
		else
			Global.s_MyUniv= arraylist.get(pos).getUnivName();
		
		new AlertDialog.Builder(this)
        .setTitle("대학교 선택 확인")
        .setMessage("["+ Global.s_MyUniv + "]\n선택하신 학교가 맞나요?") 
        .setPositiveButton("확인", new DialogInterface.OnClickListener()
        {
            public void onClick(DialogInterface dialog, int whichButton)
            {
            	 
            	
            	if(pos==6 || pos==19 || pos==28 )	 // 인증이 있는 학교면(서연고)
            	{
            		Intent intent= new Intent(SelectUnivActivity.this, AuthActivity.class);
            		startActivity(intent);
            		finish();
            	}else{	
            		Intent intent= new Intent(SelectUnivActivity.this, MentorJoinActivity.class);
            		startActivity(intent);
            		finish();
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
