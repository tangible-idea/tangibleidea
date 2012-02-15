package com.tangibleidea.meeple.layout;

import java.util.ArrayList;

import com.tangibleidea.meeple.R;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

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
    	  
    	  
          View v = convertView;
          
          if (v == null)
          {
              LayoutInflater li = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
              v = li.inflate(viewResource, null);
          } 
          
          ChatEntry e = items.get(position); 
          
          if (e != null)
          {
        	  if(e.isMyChat())
        	  {
        		  ((TextView)v.findViewById(R.id.eMyChat)).setText(e.getContent());
                  ((TextView)v.findViewById(R.id.eMyTime)).setText(e.getTime());
                  ((TextView)v.findViewById(R.id.eOppoChat)).setVisibility(View.GONE);
                  ((TextView)v.findViewById(R.id.eOppoTime)).setVisibility(View.GONE);
                  (v.findViewById(R.id.eOppoPhoto)).setVisibility(View.GONE);
        	  }else{
        		  ((TextView)v.findViewById(R.id.eMyChat)).setVisibility(View.GONE);
                  ((TextView)v.findViewById(R.id.eMyTime)).setVisibility(View.GONE);
                  ((TextView)v.findViewById(R.id.eOppoChat)).setText(e.getContent());
                  ((TextView)v.findViewById(R.id.eOppoTime)).setText(e.getTime());
                  //(v.findViewById(R.id.eOppoPhoto)).set
        	  }
              
          }
          
          return v;
      }
}
