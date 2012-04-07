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
import com.tangibleidea.meeple.layout.entry.ChatEntry;

class ViewHolder_InChatList
{
	TextView TXT_MYCHAT, TXT_MYTIME, TXT_OPPOCHAT, TXT_OPPOTIME;
	ImageView IMG_OPPO;
}

public class ChatListAdapter  extends ArrayAdapter<ChatEntry>
{
	  private ArrayList<ChatEntry> items;
      private int viewResource;
      private Context context;
      
      public ChatListAdapter(Context context, int rsrcId, int txtId, ArrayList<ChatEntry> data)
      {
          super(context, rsrcId, txtId, data);
          this.context= context;
          this.items = data;
          this.viewResource = rsrcId;
      }

      
      @Override
      public View getView(int position, View convertView, ViewGroup parent)
      {
    	  ViewHolder_InChatList VH;    	  
    	  
          View v = convertView;
          

          
          if (v == null)
          {
              LayoutInflater li = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
              v = li.inflate(viewResource, null);
              
              VH= new ViewHolder_InChatList();
              VH.TXT_MYCHAT= (TextView)v.findViewById(R.id.eMyChat);
              VH.TXT_MYTIME= (TextView)v.findViewById(R.id.eMyTime);
              VH.TXT_OPPOCHAT= (TextView)v.findViewById(R.id.eOppoChat);
              VH.TXT_OPPOTIME= (TextView)v.findViewById(R.id.eOppoTime);
              VH.IMG_OPPO= (ImageView)v.findViewById(R.id.eOppoPhoto);
              
              v.setTag(VH);
          }
          else
          {
        	  VH= (ViewHolder_InChatList) v.getTag();
          }
          
          
          
          ChatEntry e = items.get(position); 
          
          if (e != null)
          {
        	  if(e.isMyChat())
        	  {
        		  VH.TXT_MYCHAT.setText( e.getContent() );
        		  VH.TXT_MYCHAT.setBackgroundResource(R.drawable.talk_my_message_balloon);
        		  VH.TXT_MYTIME.setText( e.getTime() );
        		  VH.TXT_OPPOCHAT.setText("");
        		  VH.TXT_OPPOCHAT.setBackgroundResource(R.drawable.transpercy_image);
        		  VH.TXT_OPPOTIME.setText("");
        		  VH.IMG_OPPO.setImageResource(R.drawable.transpercy_image);
        	  }else{
	    		  VH.TXT_MYCHAT.setText( "" );
	    		  VH.TXT_MYCHAT.setBackgroundResource(R.drawable.transpercy_image);
	    		  VH.TXT_MYTIME.setText( "" );
	    		  VH.TXT_OPPOCHAT.setText( e.getContent() );
	    		  VH.TXT_OPPOCHAT.setBackgroundResource(R.drawable.talk_message_balloon);
	    		  VH.TXT_OPPOTIME.setText( e.getTime() );
	    		  VH.IMG_OPPO.setImageResource(R.drawable.no_profileimage);
        	  }
        	  
//        	  if(e.isMyChat())
//        	  {
//        		  VH.TXT_MYCHAT.setText( e.getContent() );
//        		  VH.TXT_MYCHAT.setBackgroundResource(R.drawable.my_message);
//        		  VH.TXT_MYTIME.setText( e.getTime() );
//        		  //VH.TXT_OPPOCHAT.setText("");
//        		  VH.TXT_OPPOCHAT.setVisibility(View.INVISIBLE);
//        		  //VH.TXT_OPPOTIME.setText("");
//        		  VH.IMG_OPPO.setVisibility(View.INVISIBLE);
//        	  }else{
//	    		  //VH.TXT_MYCHAT.setText( "" );
//	    		  VH.TXT_MYCHAT.setVisibility(View.INVISIBLE);
//	    		  //VH.TXT_MYTIME.setText( "" );
//	    		  VH.TXT_OPPOCHAT.setText( e.getContent() );
//	    		  VH.TXT_OPPOCHAT.setBackgroundResource(R.drawable.oppo_message);
//	    		  VH.TXT_OPPOTIME.setText( e.getTime() );
//	    		  VH.IMG_OPPO.setImageResource(R.drawable.no_profileimage);
//        	  }
              
          }
          
          return v;
      }
}
