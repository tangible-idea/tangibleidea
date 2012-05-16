package com.tangibleidea.meeple.layout.viewpage;



import android.content.Context;
import android.graphics.Color;
import android.os.Parcelable;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageView;

import com.tangibleidea.meeple.R;

public class SampleAdapter extends PagerAdapter {
	private Context mContext;
	public SampleAdapter(Context context) {
		mContext = context;
	}
	
	@Override
	public void destroyItem(View arg0, int arg1, Object arg2) {
		((ViewPager)arg0).removeView((View) arg2);
	}

	@Override
	public void finishUpdate(View arg0) {
	}

	@Override
	public int getCount() {
		return 2;
	}

	@Override
	public Object instantiateItem(View v, int pos)
	{
		ImageView IMG_child= new ImageView(mContext);
		
		if(pos==0)			
		{
			IMG_child.setImageResource(R.drawable.img_inform_tangible_01);
			IMG_child.setBackgroundColor(Color.rgb(230, 230, 230));
		}
		else if(pos==1)
		{
			IMG_child.setImageResource(R.drawable.img_inform_tangible_02);
			IMG_child.setBackgroundColor(Color.rgb(230, 230, 230));
		}
		
		((ViewPager)v).addView(IMG_child);
		return IMG_child;
	}

	@Override
	public boolean isViewFromObject(View arg0, Object arg1) {
		return arg0 == ((View)arg1);
	}

	@Override
	public void restoreState(Parcelable arg0, ClassLoader arg1) {
		// TODO Auto-generated method stub

	}

	@Override
	public Parcelable saveState() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void startUpdate(View arg0) {
	}

}
