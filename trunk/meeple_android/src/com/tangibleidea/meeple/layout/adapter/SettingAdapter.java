package com.tangibleidea.meeple.layout.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.entry.SettingEntry;
import com.tangibleidea.meeple.layout.enums.EnumSettingStatus;

public class SettingAdapter extends ArrayAdapter<SettingEntry>
{
	private ArrayList<SettingEntry> items;
	private int viewResource;
	private Context mContext;
	
	public SettingAdapter(Context context, int rsrcId, int txtId, ArrayList<SettingEntry> data)
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
   
        
        SettingEntry e = items.get(position); 	// 각 포지션에 맞는 Entry를 가져온다.
        
        
        if (e != null)	// null이 아니면 진행
        {
        	if( e.eSTAT == EnumSettingStatus.E_LABEL_PROFILE )
        	{
        		ImageView img= new ImageView(mContext);
            	img.setScaleType(ScaleType.FIT_XY);
            	img.setImageResource(R.drawable.label_setting_01);
            	return img;
        	}
        	else if( e.eSTAT == EnumSettingStatus.E_LABEL_INFO )
        	{
        		ImageView img= new ImageView(mContext);
            	img.setScaleType(ScaleType.FIT_XY);
            	img.setImageResource(R.drawable.label_setting_02);
            	return img;
        	}
        	else if( e.eSTAT == EnumSettingStatus.E_LABEL_REPORT )
        	{
        		ImageView img= new ImageView(mContext);
            	img.setScaleType(ScaleType.FIT_XY);
            	img.setImageResource(R.drawable.label_setting_03);
            	return img;
        	}
        	
          	LayoutInflater li = (LayoutInflater)mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            v = li.inflate(viewResource, null); 
            
            TextView TXT_content= (TextView) v.findViewById(R.id.e_txt_content);
            ImageView IMG_content= (ImageView) v.findViewById(R.id.e_img_content);
            
            
        	if( e.eSTAT == EnumSettingStatus.E_NOLABEL )
        	{
        		if(e.isTextView())	// 텍스트뷰로 출력할 경우...
        		{
        			TXT_content.setText(e.getStrText());
        		}
        		else	// 이미지뷰로 출력할 경우
        		{
        			TXT_content.setVisibility(View.GONE);
        			IMG_content.setImageResource(e.getImgID());
        		}
        	}
        }
        
        return v;
    }
}
