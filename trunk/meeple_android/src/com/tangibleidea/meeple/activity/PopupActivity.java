package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.server.RequestImageMethods;

public class PopupActivity extends Activity implements OnClickListener
{
	RelativeLayout RL_window;
	ImageView IMG_profile;
	Button BTN_close;
	TextView TXT_name, TXT_profile, TXT_info;

	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.popup_layout);
		
		TXT_name= (TextView) findViewById(R.id.txt_popup_name);
		TXT_profile= (TextView) findViewById(R.id.txt_popup_profile);
		TXT_info= (TextView) findViewById(R.id.txt_popup_info);
		IMG_profile= (ImageView) findViewById(R.id.img_popup_photo);
		BTN_close= (Button) findViewById(R.id.btn_popup_exit);
		BTN_close.setOnClickListener(this);
		
		RL_window= (RelativeLayout) findViewById(R.id.view_popupwindow_all);
		
		TXT_name.setText( this.getIntent().getStringExtra("name") );
		TXT_profile.setText( this.getIntent().getStringExtra("profile") );
		//TXT_name.setText( this.getIntent().getStringExtra("info") );
		
		RequestImageMethods RIM= new RequestImageMethods();
		RIM.DownloadImage2( IMG_profile, this.getIntent().getStringExtra("id") );	// 이미지를 다운로드 받고
		IMG_profile.setBackgroundColor(Color.BLACK);
	}

	/* (non-Javadoc)
	 * @see android.app.Activity#onTouchEvent(android.view.MotionEvent)
	 */
	@Override
	public boolean onTouchEvent(MotionEvent event)
	{
		Rect RL_rect= new Rect();
		RL_window.getGlobalVisibleRect(RL_rect);
		
		if(! RL_rect.contains((int)event.getX(), (int)event.getY()) )
		{
			finish();
		}
		
		
		return super.onTouchEvent(event);
	}

	@Override
	public void onClick(View v)
	{
		if(v.getId() == R.id.btn_popup_exit)
		{
			finish();
		}
		
	}
	
}
