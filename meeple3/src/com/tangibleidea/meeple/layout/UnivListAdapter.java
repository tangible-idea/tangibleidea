package com.tangibleidea.meeple.layout;

import java.util.ArrayList;

import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.AssetManager.AssetInputStream;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;

public class UnivListAdapter extends ArrayAdapter<UnivEntry>
{
	private ArrayList<UnivEntry> items;
	private int viewResource;
	private Context mContext;

	public UnivListAdapter(Context context, int resource, int textViewResourceId, ArrayList<UnivEntry> data)
	{
		super(context, resource, textViewResourceId, data);
	
		this.viewResource= resource;
		this.mContext= context;
		this.items= data;
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
        
        UnivEntry e = items.get(position); 
        
        ImageView IMG_LOGO= (ImageView) v.findViewById(R.id.ePhoto);
        TextView TXT_UNIV= (TextView) v.findViewById(R.id.eUnivName);
        
        if (e != null)
        {
        	IMG_LOGO.setImageBitmap(this.loadBitmapFromAssets( e.getLogoName() ));
        	TXT_UNIV.setText( e.getUnivName() );
        }
        
        return v;
    }
    
    
    /**
     * Assets 경로에 있는 이미지를 불러온다.
     * @param _strIMGURL : 이미지 경로 (확장자 포함)
     * @return : Bitmap Instance
     */
    public Bitmap loadBitmapFromAssets(String _strIMGURL)
    {
        Bitmap bitmap = null;
        AssetManager AM = mContext.getResources().getAssets();
        
        try
        {
        	AssetInputStream AIS = (AssetInputStream) AM.open(_strIMGURL);
        	bitmap = BitmapFactory.decodeStream(AIS);         
        }
        catch(Exception e)
        {
        	Log.e("ERROR", "loadBitmap exception" + e.toString());
        }
        
        return bitmap;
    }

}
