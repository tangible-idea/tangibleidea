package com.tangibleidea.meeple.layout.viewpage;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

// ������ ǥ�� ��Ʈ�� 
public class PageControl extends View implements IPageControl {
	private int mPageSize;
	private int mCurrentPage;
	
	private Paint mPaint;
	
	public PageControl(Context context) {
		super(context);
		initialization();
	}

	public PageControl(Context context, AttributeSet attrs) {
		super(context, attrs);
		initialization();
	}
		
	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
	    setMeasuredDimension(10 * (mPageSize + (mPageSize - 1)), 10);
	}
	
	@Override
	protected void onLayout(boolean changed, int left, int top, int right,
			int bottom) {
		super.onLayout(changed, left, top, right, bottom);
	}
	
	private Paint mPaint2;

	private final void initialization() {
		//�̼���
		mPaint = new Paint();
		mPaint.setAntiAlias(true);
		mPaint.setColor(Color.LTGRAY);
		
		//����
		mPaint2 = new Paint();
		mPaint2.setAntiAlias(true);
		mPaint2.setColor(Color.DKGRAY);
	}
			
	public int getCurrentPageIndex() {
		return mCurrentPage;
	}
	
	public void setPageSize (int size) {
		mPageSize = size;
		
		invalidate();
	}
	
	public int getPageSize() {
		return mPageSize;
	}
	
	public void setPageIndex(int index) {
		mCurrentPage = index;
		
		invalidate();
	}
		
	private static final float RADIUS = 5;
	private static final int PADDING = 10;
	
	
	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
			
		float x = RADIUS;
		float y = RADIUS;
				
		for (int i = 0; i < mPageSize; i++) {
			if (mCurrentPage == i) {
				canvas.drawCircle(x, 
						y, 
						RADIUS, 
						mPaint2);
			} else {
				canvas.drawCircle(x, 
						y, 
						RADIUS, 
						mPaint);
			}
			x += (RADIUS * 2) + PADDING;
		}
	}

}
