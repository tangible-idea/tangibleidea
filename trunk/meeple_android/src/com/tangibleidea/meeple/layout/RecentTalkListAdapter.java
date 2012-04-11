package com.tangibleidea.meeple.layout;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.entry.RecentTalkEntry;

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
        
        
        if (e == null)	// null이면 구분자를 넣어준다. (임시)
        {
        	ImageView img= new ImageView(mContext);
        	img.setScaleType(ScaleType.FIT_XY);
        	img.setImageResource(R.drawable.talk_list_now_label);
        	//img.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
        	v=img;
        }
        else
        {
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
        		Calendar rightNow = Calendar.getInstance();        	
            	SimpleDateFormat format= new SimpleDateFormat("yyyy.MM.dd a h:mm");
				Date talkTime= format.parse(e.getTime());
				
	        	if( talkTime.getDate() == rightNow.get(Calendar.DATE) ) // 대화 날짜가 오늘이면
	        	{
	        		TXT_Time.setText( talkTime.getHours()+":"+talkTime.getMinutes() );
	        	}else{
	        		TXT_Time.setText( talkTime.getMonth()+"월 "+talkTime.getDate()+"일");
	        	}
			}
        	catch (ParseException e1)
			{
				e1.printStackTrace();
			}

        	
        	IMG_profile.setImageResource(R.drawable.no_profileimage);
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
