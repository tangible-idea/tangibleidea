package com.tangibleidea.meeple.layout;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;

public class RecentTalkListAdapter extends ArrayAdapter<RecentTalkEntry>
{
	private ArrayList<RecentTalkEntry> items;
	private int viewResource;
	private Context context;
	  
	public RecentTalkListAdapter(Context context, int rsrcId, int txtId, ArrayList<RecentTalkEntry> data)
	{
	    super(context, rsrcId, txtId, data);
	    this.context= context;
	    this.items = data;
	    this.viewResource = rsrcId;
	}
          
    @Override
    public View getView(int position, View convertView, ViewGroup parent)
    {
        View v = convertView;
        
        if (v == null)
        {
            LayoutInflater li = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            v = li.inflate(viewResource, null);
        } 
        
        RecentTalkEntry e = items.get(position); 
        
        if (e != null)
        {
        	ImageView IMG_label=(ImageView) v.findViewById(R.id.eRecentTalk_IMGLabel);
        	ImageView IMG_profile=(ImageView) v.findViewById(R.id.ePhoto);
        	TextView TXT_recentCount= (TextView) v.findViewById(R.id.eRecentTalkCount);        	
        	TextView TXT_Name= (TextView) v.findViewById(R.id.eRecentTalkName);
        	TextView TXT_Time= (TextView) v.findViewById(R.id.eRecentTalkTime);
        	TextView TXT_Content= (TextView) v.findViewById(R.id.eRecentTalkContent);
        	
        	IMG_profile.setImageResource(R.drawable.no_profileimage);
        	TXT_Name.setText( e.getOppoName() );
        	TXT_Content.setText( e.getContent() );
        	TXT_Time.setText( e.getTime() );
        	
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
        		IMG_label.setImageResource(R.drawable.label_lasttalk);
        	}else{
        		IMG_label.setImageResource(R.drawable.label_nowtalk);
        	}
            
        }
        
        return v;
    }
}
