package com.tangibleidea.meeple.layout;

import java.util.ArrayList;

import com.tangibleidea.meeple.R;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class ChatListAdapter  extends ArrayAdapter<ChatEntry>
{
	TextView TXT_MYCHAT, TXT_MYTIME, TXT_OPPOCHAT, TXT_OPPOTIME;
	ImageView IMG_OPPO;

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
    	  
    	  
          View v = convertView;
          

          
          if (v == null)
          {
              LayoutInflater li = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
              v = li.inflate(viewResource, null);
          } 
          
          TXT_MYCHAT= (TextView)v.findViewById(R.id.eMyChat);
          TXT_MYTIME= (TextView)v.findViewById(R.id.eMyTime);
          TXT_OPPOCHAT= (TextView)v.findViewById(R.id.eOppoChat);
          TXT_OPPOTIME= (TextView)v.findViewById(R.id.eOppoTime);
          IMG_OPPO= (ImageView)v.findViewById(R.id.eOppoPhoto);
          
          ChatEntry e = items.get(position); 
          
          if (e != null)
          {
        	  if(e.isMyChat())
        	  {
      			TXT_MYCHAT.setText( e.getContent() );
    			TXT_MYCHAT.setBackgroundResource(R.drawable.my_message);
    			TXT_MYTIME.setText( e.getTime() );
    			TXT_OPPOCHAT.setText("");
    			TXT_OPPOCHAT.setBackgroundResource(R.drawable.transpercy_image);
    			TXT_OPPOTIME.setText("");
    			IMG_OPPO.setImageResource(R.drawable.transpercy_image);
        	  }else{
      			TXT_MYCHAT.setText( "" );
    			TXT_MYCHAT.setBackgroundResource(R.drawable.transpercy_image);
    			TXT_MYTIME.setText( "" );
    			TXT_OPPOCHAT.setText( e.getContent() );
    			TXT_OPPOCHAT.setBackgroundResource(R.drawable.oppo_message);
    			TXT_OPPOTIME.setText( e.getTime() );
    			IMG_OPPO.setImageResource(R.drawable.no_profileimage);
        	  }
              
          }
          
          return v;
      }
}
