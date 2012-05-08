package com.tangibleidea.meeple.layout.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.content.DialogInterface.OnClickListener;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.activity.PopupActivity;
import com.tangibleidea.meeple.activity.SendMessageActivity;
import com.tangibleidea.meeple.layout.entry.MessageEntry;
import com.tangibleidea.meeple.server.RequestImageMethods;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.util.SPUtil;

class ViewHolder_MessageList 
{
	TextView TXT_content, TXT_name, TXT_time;
	ImageView IMG_pos1, IMG_pos2, IMG_arrow, IMG_fromlabel;
	Button BTN_reply;
}

public class MessageListAdapter  extends ArrayAdapter<MessageEntry> implements android.view.View.OnClickListener// implements android.view.View.OnClickListener
{
	private RequestImageMethods RIM;
	private ArrayList<MessageEntry> items;
    private int viewResource;
	private Context mContext;
	private String strID= "", strName= "";

	public MessageListAdapter(Context context, int resource, int textViewResourceId, ArrayList<MessageEntry> data)
	{
		super(context, resource, textViewResourceId, data);
		RIM= new RequestImageMethods();
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
            VH.IMG_pos2= (ImageView)v.findViewById(R.id.eOppoPhoto);
            VH.IMG_arrow= (ImageView)v.findViewById(R.id.eFromArrow);
            VH.IMG_fromlabel= (ImageView)v.findViewById(R.id.eFromLabel);
            VH.BTN_reply.setOnClickListener(this);
            v.setTag(VH);
        }
        else
        {
        	VH=  (ViewHolder_MessageList) v.getTag();
        }
        
        
        
        MessageEntry e = items.get(position); 
        
        if (e != null)
        {
        	if(e.isMyChat())	// 내가 보낸 쪽지이면...
        	{
        		VH.BTN_reply.setVisibility(View.GONE);
        		VH.TXT_content.setText(e.getContent());
        		VH.TXT_name.setText(e.GetOppoID());
        		VH.TXT_time.setText(e.getTime());
        		VH.IMG_fromlabel.setVisibility(View.VISIBLE);
        		VH.IMG_arrow.setVisibility(View.VISIBLE);
        		VH.IMG_pos2.setVisibility(View.VISIBLE);
try{
        		RIM.DownloadImage2( VH.IMG_pos1, SPUtil.getString(mContext, "AccountID") );	// [내사진] ---전송---> 상대방사진
        		VH.IMG_pos1.setBackgroundColor(Color.BLACK);	// 배경은 까만색
        		
        		RIM.DownloadImage2( VH.IMG_pos2, e.GetOppoID() );	// 내사진 ---전송---> [상대방사진]
        		VH.IMG_pos2.setBackgroundColor(Color.BLACK);	// 배경은 까만색
}catch(Exception ex) {}
        	}
        	else
        	{
        		VH.BTN_reply.setVisibility(View.VISIBLE);
        		VH.TXT_content.setText(e.getContent());
        		VH.TXT_name.setText(e.GetOppoID());
        		VH.TXT_time.setText(e.getTime());
        		VH.IMG_fromlabel.setVisibility(View.INVISIBLE);
        		VH.IMG_arrow.setVisibility(View.INVISIBLE);
        		VH.IMG_pos2.setVisibility(View.INVISIBLE);  
try{
        		RIM.DownloadImage2( VH.IMG_pos1, e.GetOppoID() );	// [상대방사진]
        		VH.IMG_pos1.setBackgroundColor(Color.BLACK);	// 배경은 까만색
}catch(Exception ex) {}
        		strID= e.GetOppoID();
        	}
        }
        else
        {
        	
        }
        
        return v;
    }

	@Override
	public void onClick(View v)
	{
		Intent intent= new Intent(mContext, SendMessageActivity.class);
		intent.putExtra("id", strID);
		intent.putExtra("name", strID);
		mContext.startActivity(intent);
	}
    

}
