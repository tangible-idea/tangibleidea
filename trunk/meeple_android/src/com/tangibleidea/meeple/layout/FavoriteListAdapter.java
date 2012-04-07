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
import com.tangibleidea.meeple.layout.entry.InfoEntry;

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
          View v = convertView;
          
          
          if (v == null)
          {
              LayoutInflater li = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
              v = li.inflate(rsrc, null);
          } 
          
          InfoEntry e = items.get(position); 
          
          if (e != null)
          {
              ((TextView)v.findViewById(R.id.eName)).setText(e.getName()+" ("+e.getID()+")");
              ((TextView)v.findViewById(R.id.eSchool)).setText(e.getSchool()+" "+e.getSub());
          
              if (e.getPhotoId() != -1)
              {
            	  ((ImageView)v.findViewById(R.id.ePhoto)).setImageResource(e.getPhotoId());                
              } else {
            	  ((ImageView)v.findViewById(R.id.ePhoto)).setImageResource(R.drawable.no_profileimage);  
              }
        	  TextView LBL= (TextView) v.findViewById(R.id.eLabel);
        	  LBL.setVisibility(View.GONE);
        	  
        	  ++nLoop;
          }
          return v;
      }

}
