package com.tangibleidea.meeple.layout.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.entry.InfoEntry;
import com.tangibleidea.meeple.server.RequestImageMethods;


class ViewHolder_FriendsList
{
	ImageView IMG_ProfilePic;
	TextView TXT_Name, TXT_Info;
}

public class FavoriteListAdapter extends ArrayAdapter<InfoEntry>
{
	  private ArrayList<InfoEntry> items;
      private int rsrc;
      private Context context;
      
      int nLoop= 0;
      
      public FavoriteListAdapter(Context context, int rsrcId, int txtId, ArrayList<InfoEntry> data)
      {
          super(context, rsrcId, txtId, data);
          this.context= context;
          this.items = data;
          this.rsrc = rsrcId;
      }
      
      @Override
      public View getView(int position, View convertView, ViewGroup parent)
      {
    	  ViewHolder_FriendsList VH;
          View v = convertView;         
          
          if (v == null)
          {
              LayoutInflater li = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
              v = li.inflate(rsrc, null);
              
              VH = new ViewHolder_FriendsList();
    		  VH.IMG_ProfilePic = (ImageView)v.findViewById(R.id.ePhoto);    		  
    		  VH.TXT_Name= (TextView)v.findViewById(R.id.eFriendName);
    		  VH.TXT_Info= (TextView)v.findViewById(R.id.eFriendInfo);
    		  
    		  v.setTag(VH);
          }else{
        	  VH = (ViewHolder_FriendsList)v.getTag();
          }
          
          InfoEntry e = items.get(position); 
          
          if (e != null)
          {
        	  RequestImageMethods RIM= new RequestImageMethods();
      		  RIM.DownloadImage2( VH.IMG_ProfilePic, e.getID() );	// 이미지를 다운로드 받고
      		  VH.IMG_ProfilePic.setBackgroundColor(Color.BLACK);	// 배경은 까만색
      		  
        	  VH.TXT_Name.setText(e.getName());
        	  VH.TXT_Info.setText(e.getComment());
        	  
        	  
          }
          return v;
      }

}
