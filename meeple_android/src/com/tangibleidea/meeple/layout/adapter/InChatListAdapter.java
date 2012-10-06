package com.tangibleidea.meeple.layout.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.activity.PopupActivity;
import com.tangibleidea.meeple.data.EnumMeepleStatus;
import com.tangibleidea.meeple.layout.entry.ChatEntry;
import com.tangibleidea.meeple.layout.entry.InfoEntry;
import com.tangibleidea.meeple.server.RequestImageMethods;
import com.tangibleidea.meeple.util.ChatManager;
import com.tangibleidea.meeple.util.Global;

//class ViewHolder_InChatList
//{
//	TextView TXT_MYCHAT, TXT_MYTIME, TXT_OPPOCHAT, TXT_OPPOTIME;
//	ImageView IMG_OPPO;
//}

public class InChatListAdapter  extends ArrayAdapter<ChatEntry>
{
	TextView TXT_MYCHAT, TXT_MYTIME, TXT_OPPOCHAT, TXT_OPPOTIME;
	ImageView IMG_OPPO;
	
	  private ArrayList<ChatEntry> items;
      private int viewResource;
      private Context mContext;
      private ChatManager chatMgr= ChatManager.GetInstance();
      
      public InChatListAdapter(Context context, int rsrcId, int txtId, ArrayList<ChatEntry> data)
      {
          super(context, rsrcId, txtId, data);
          this.mContext= context;
          this.items = data;
          this.viewResource = rsrcId;
      }

      
      @Override
      public View getView(int position, View convertView, ViewGroup parent)
      {
    	  //ViewHolder_InChatList VH;    	  
          View v = convertView;
          
          if (v == null)
          {
              LayoutInflater li = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
              v = li.inflate(viewResource, null);
          }
          
          
          
          ChatEntry e = items.get(position); 
                    
          if (e != null)
          {
        	  if(e.getContent()==null)	// 채팅 내용이 없으면 라벨이다.
        	  {
        		  LayoutInflater li = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                  v = li.inflate(R.layout.listbody_timemarker, null);
                  TextView txt= (TextView) v.findViewById(R.id.txt_time);
                  txt.setText(e.getTime());
                  return v;
        	  }
        	  
              LayoutInflater li = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
              v = li.inflate(viewResource, null);
              
              TXT_MYCHAT= (TextView)v.findViewById(R.id.eMyChat);
              TXT_MYTIME= (TextView)v.findViewById(R.id.eMyTime);
              TXT_OPPOCHAT= (TextView)v.findViewById(R.id.eOppoChat);
              TXT_OPPOTIME= (TextView)v.findViewById(R.id.eOppoTime);
              IMG_OPPO= (ImageView)v.findViewById(R.id.eOppoPhoto);
              
              IMG_OPPO.setOnClickListener(new OnClickListener()
              {
				@Override
				public void onClick(View v)
				{
					Intent intent= new Intent(mContext, PopupActivity.class);
					intent.putExtra("position", 0);
					intent.putExtra("id", chatMgr.getCurrOppoAccount());
					intent.putExtra("name", chatMgr.getCurrOppoName());
					intent.putExtra("profile", "");
					intent.putExtra("comment", "");
					
					intent.putExtra("recommandation", "T");	// 인채팅 창에서 클릭하면 쪽지보내기를 띄워준다.
					
					if(Global.s_LIST_Relations.isEmpty())	// 친구가 아무도 없으면
						intent.putExtra("relation", "F");
					else
					{
						intent.putExtra("relation", "F");
						
						for(InfoEntry IE : Global.s_LIST_Relations)
							if( chatMgr.getCurrOppoAccount().equals( IE.getID() ) )
							{
								intent.putExtra("relation", "T");		// 나와 친구사이이면 T
								break;
							}
					}
					
					mContext.startActivity(intent);
				}
              });
        	  
        	  if(e.isMyChat())
        	  {
        		  TXT_MYCHAT.setText( e.getContent() );
        		  TXT_MYCHAT.setBackgroundResource(R.drawable.talk_my_message_balloon);
        		  TXT_MYTIME.setText( e.getTime().substring(11) );
        		  TXT_OPPOCHAT.setText("");
        		  TXT_OPPOCHAT.setBackgroundResource(R.drawable.transpercy_image);
        		  TXT_OPPOTIME.setText("");
        		  IMG_OPPO.setImageResource(R.drawable.transpercy_image);
        	  }else{
	    		  TXT_MYCHAT.setText( "" );
	    		  TXT_MYCHAT.setBackgroundResource(R.drawable.transpercy_image);
	    		  TXT_MYTIME.setText( "" );
	    		  TXT_OPPOCHAT.setText( e.getContent() );
	    		  TXT_OPPOCHAT.setBackgroundResource(R.drawable.talk_message_balloon);
	    		  TXT_OPPOTIME.setText( e.getTime().substring(11) );
	    		  RequestImageMethods RIM= new RequestImageMethods();
	    		  //RIM.DownloadImage2( IMG_OPPO, chatMgr.getCurrOppoAccount() );	// 이미지를 다운로드 받고
	    		 // RIM.DownloadImage( IMG_OPPO, chatMgr.getCurrOppoAccount() );	// 이미지를 다운로드 받고
	    		  IMG_OPPO.setBackgroundColor(Color.BLACK);
        	  }
          }
          
          return v;
      }
}
