package com.tangibleidea.meeple.layout.viewpage;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.tangibleidea.meeple.R;



public class NumberPageControl extends LinearLayout implements IPageControl  {
	private static final int PRE_BUTTON_RES_OFF = R.drawable.page_prev_off;
	private static final int PRE_BUTTON_RES = R.drawable.page_prev;
	private static final int NEXT_BUTTON_RES_OFF = R.drawable.page_next_off;
	private static final int NEXT_BUTTON_RES = R.drawable.page_next;
	
	private Drawable mPagePre;
	private Drawable mPagePreOff;
	private Drawable mPageNext;
	private Drawable mPageNextOff;
			
	private ImageView mPre;
	private ImageView mNext;
	private TextView mCurrentPage;
	private TextView mTotalPage;
	
	public NumberPageControl(Context context) {
		super(context);
		init(context);
	}

	public NumberPageControl(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}
	
	private final void init(Context c) {
		initDrawable();
		
		setOrientation(LinearLayout.VERTICAL);
		setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT , LayoutParams.WRAP_CONTENT));
		
		LayoutParams params;
		LinearLayout layout = new LinearLayout(c);
		params = newParams();
		params.gravity = Gravity.CENTER;
		layout.setLayoutParams(params);
		//pre
		mPre = new ImageView(c);
		mPre.setImageDrawable(mPagePreOff);
		//mPre.setImageResource(PRE_BUTTON_RES_OFF);
		mPre.setClickable(true);
		params = newParams();
		params.gravity = Gravity.CENTER_VERTICAL;
		mPre.setLayoutParams(params);
		layout.addView(mPre);
		//currentPage
		mCurrentPage = new TextView(c);
		mCurrentPage.setText("1");
		mCurrentPage.setTextColor(Color.WHITE);
		mCurrentPage.setTextSize(13);
		params = newParams();
		params.gravity = Gravity.CENTER_VERTICAL;
		params.leftMargin = 20;
		mCurrentPage.setLayoutParams(params);
		layout.addView(mCurrentPage);
		// total page
		mTotalPage = new TextView(c);
		mTotalPage.setTextColor(Color.GRAY);
		mTotalPage.setTextSize(13);
		params = newParams();
		params.gravity = Gravity.CENTER_VERTICAL;
		params.rightMargin = 20;
		mTotalPage.setLayoutParams(params);
		layout.addView(mTotalPage);
	//next button
		mNext = new ImageView(c);
		mNext.setClickable(true);
		mNext.setImageResource(R.drawable.page_next);
		params = newParams();
		params.gravity = Gravity.CENTER_VERTICAL;
		mNext.setLayoutParams(params);
		layout.addView(mNext);
		
		addView(layout);
	}
	
	private final void initDrawable() {
		Resources r = getResources();
		mPagePre = r.getDrawable(PRE_BUTTON_RES);
		mPagePreOff = r.getDrawable(PRE_BUTTON_RES_OFF);
		mPageNext = r.getDrawable(NEXT_BUTTON_RES);
		mPageNextOff = r.getDrawable(NEXT_BUTTON_RES_OFF);
	}
	
	public void setNextClickListener( View.OnClickListener listener) {
		mNext.setOnClickListener(listener);
	}
	
	public void setPreClickListener( View.OnClickListener listener) {
		mPre.setOnClickListener(listener);
	}
	
	static LayoutParams newParams() {
		return new LayoutParams(LayoutParams.WRAP_CONTENT ,
				LayoutParams.WRAP_CONTENT);
	}
	
	private int mCurrentIndex;
	private int mTotalPageSize;

	@Override
	public int getCurrentPageIndex() {
		return mCurrentIndex;
	}

	@Override
	public int getPageSize() {
		return mTotalPageSize;
	}

	@Override
	public void setPageIndex(int index) {
		mCurrentIndex = index;
		mCurrentPage.setText(String.valueOf((index + 1)));
		
		if (mCurrentIndex == 0) {
			mPre.setImageDrawable(mPagePreOff);
		} else {
			mPre.setImageDrawable(mPagePre);
			mNext.setImageDrawable((mCurrentIndex + 1) == mTotalPageSize ? mPageNextOff : mPageNext);
		}
	}

	@Override
	public void setPageSize(int size) {
		mTotalPageSize = size;
		mTotalPage.setText("/" + String.valueOf(size));
	}
}
