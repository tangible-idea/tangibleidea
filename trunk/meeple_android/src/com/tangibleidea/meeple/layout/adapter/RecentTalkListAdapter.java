package com.tangibleidea.meeple.layout.adapter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.entry.RecentTalkEntry;
import com.tangibleidea.meeple.layout.enums.EnumRecentTalkStatus;
import com.tangibleidea.meeple.server.RequestImageMethods;

public class RecentTalkListAdapter extends ArrayAdapter<RecentTalkEntry>
{
	private ArrayList<RecentTalkEntry> items;
	private int viewResource;
	private Context mContext;
	
	//private HashMap<Integer,Boolean> mapRecenttalkLabel= new HashMap<Integer,Boolean>();
	  
	public RecentTalkListAdapter(Context context, int rsrcId, int txtId, ArrayList<RecentTalkEntry> data)
	{
	    super(context, rsrcId, txtId, data);
	    this.mContext= context;
	    this.items = data;
	    this.viewResource = rsrcId;
	}
       
	@Override
	public int getCount()
	{
		return items.size();
	}

	@Override
    public View getView(int position, View convertView, ViewGroup parent)
    {
        View v = convertView;
        
        if (v == null)
        {
            LayoutInflater li = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            v = li.inflate(viewResource, null); 
        } 
   
        
        RecentTalkEntry e = items.get(position); 	// 각 포지션에 맞는 Entry를 가져온다.
        
        
        if (e != null)	// null이 아니면 진행
        {
        	if(e.eSTAT == EnumRecentTalkStatus.E_LABEL_INPROGRESS)
        	{
        		ImageView img= new ImageView(mContext);
            	img.setScaleType(ScaleType.FIT_XY);
            	img.setImageResource(R.drawable.talk_list_now_label);
            	return img;
        	}
        	if(e.eSTAT == EnumRecentTalkStatus.E_LABEL_FINISHED)
        	{
        		ImageView img= new ImageView(mContext);
            	img.setScaleType(ScaleType.FIT_XY);
            	img.setImageResource(R.drawable.talk_list_last_label);
            	return img;
        	}
        	
        	LayoutInflater li = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            v = li.inflate(viewResource, null); 
            
        	//ImageView IMG_label=(ImageView) v.findViewById(R.id.eRecentTalk_IMGLabel);
        	ImageView IMG_profile=(ImageView) v.findViewById(R.id.ePhoto);
        	TextView TXT_recentCount= (TextView) v.findViewById(R.id.eRecentTalkCount);        	
        	TextView TXT_Name= (TextView) v.findViewById(R.id.eRecentTalkName);
        	TextView TXT_Time= (TextView) v.findViewById(R.id.eRecentTalkTime);
        	TextView TXT_Content= (TextView) v.findViewById(R.id.eRecentTalkContent);
        	
        	
        	try
        	{
        		
        		SimpleDateFormat format= new SimpleDateFormat("yyyy.MM.dd a h:mm");
				Date talkTime= format.parse(e.getTime());
				Date nowTime= new Date();
				
	        	if( talkTime.getMonth()==nowTime.getMonth() && talkTime.getDate()==nowTime.getDate() )// 대화 날짜가 오늘이면
	        	{
	        		String timeMarker="";
	        		if(talkTime.getHours() > 12)
	        		{
	        			talkTime.setHours(talkTime.getHours()-12);
	        			timeMarker="오후";
	        		}
	        		else
	        			timeMarker="오전";
	        		
	        		TXT_Time.setText( String.format("%s %02d:%02d", timeMarker, talkTime.getHours(),talkTime.getMinutes() ) );
	        	}else{
	        		TXT_Time.setText( talkTime.getMonth()+"월 "+talkTime.getDate()+"일");
	        	}
			}
        	catch (ParseException e1)
			{
				e1.printStackTrace();
			}

try
{
      	  	RequestImageMethods RIM= new RequestImageMethods();
    		RIM.DownloadImage2( IMG_profile, e.getAccountID() );	// 이미지를 다운로드 받고
    		IMG_profile.setBackgroundColor(Color.BLACK);
}
catch(OutOfMemoryError ex)
{
	
}
    		
        	TXT_Name.setText( e.getOppoName() );
        	TXT_Content.setText( e.getContent() );
        	
        	
        	if( e.getCount().equals("0") )
        	{
        		TXT_recentCount.setVisibility(View.INVISIBLE);
        	}else{
        		TXT_recentCount.setVisibility(View.VISIBLE);
        		TXT_recentCount.setText( e.getCount() );
        	}
        	
        	if( e.isEndChat() )
        	{
        		TXT_recentCount.setVisibility(View.INVISIBLE);
        		//IMG_label.setImageResource(R.drawable.talk_list_last_label);
        	}
//        	else
//        	{
//        		IMG_label.setImageResource(R.drawable.talk_list_now_label);
//        	}
            
        }
        
        return v;
    }
}
