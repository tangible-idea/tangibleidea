package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.layout.viewpage.BaseViewPager;
import com.tangibleidea.meeple.layout.viewpage.PageControl;
import com.tangibleidea.meeple.layout.viewpage.SampleAdapter;

public class AboutCompanyActivity extends Activity
{
	Context mContext;
	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.about_company);
		
		mContext= this;
		
		BaseViewPager pager = new BaseViewPager(mContext);
		pager.setPageControl(new PageControl(mContext));
		pager.setAdapter(new SampleAdapter(mContext));
		pager.setBackgroundColor(Color.rgb(230, 230, 230));
		setContentView(pager);
	}

}
