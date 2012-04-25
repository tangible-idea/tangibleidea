package com.tangibleidea.meeple.layout.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.entry.MessageEntry;

class ViewHolder_MessageList
{
	TextView TXT_content, TXT_name, TXT_time;
	ImageView IMG_pos1, IMG_pos2, IMG_arrow;
	Button BTN_reply;
}

public class MessageListAdapter  extends ArrayAdapter<MessageEntry>
{
	private ArrayList<MessageEntry> items;
    private int viewResource;
	private Context mContext;

	public MessageListAdapter(Context context, int resource, int textViewResourceId, ArrayList<MessageEntry> data)
	{
		super(context, resource, textViewResourceId, data);
		this.mContext= context;
		this.items= data;
		this.viewResource= resource;
	}
	
    @Override
    public View getView(int position, View convertView, ViewGroup parent)
    {
  	  	ViewHolder_MessageList VH;    	  
        View v = convertView;
        
        if (v == null)
        {
            LayoutInflater li = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            v = li.inflate(viewResource, null);
            
            VH= new ViewHolder_MessageList();
            VH.BTN_reply= (Button) v.findViewById(R.id.e_btn_reply);
            VH.TXT_content= (TextView) v.findViewById(R.id.eContent);
            VH.TXT_name= (TextView) v.findViewById(R.id.eName);
            VH.TXT_time= (TextView) v.findViewById(R.id.eDate);
            VH.IMG_pos1= (ImageView)v.findViewById(R.id.ePhoto);
            v.setTag(VH);
        }
        else
        {
        	VH=  (ViewHolder_MessageList) v.getTag();
        }
        
        
        
        MessageEntry e = items.get(position); 
                  
        if (e != null)
        {
        	if(e.isMyChat())
        	{
        		VH.BTN_reply.setVisibility(View.GONE);
        		VH.TXT_content.setText(e.getContent());
        		VH.TXT_name.setText(e.GetOppoName());
        		VH.TXT_time.setText(e.getTime());
        	}
        	else
        	{
        		VH.BTN_reply.setVisibility(View.VISIBLE);
        		VH.TXT_content.setText(e.getContent());
        		VH.TXT_name.setText(e.GetOppoName());
        		VH.TXT_time.setText(e.getTime());
        	}
        }
        else
        {
        	
        }
        
        return v;
    }

}
