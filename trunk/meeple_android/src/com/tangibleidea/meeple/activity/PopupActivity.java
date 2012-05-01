package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Paint;
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
import com.tangibleidea.meeple.server.RequestMethods;

public class PopupActivity extends Activity implements OnClickListener
{
	private Context mContext;
	
	private RelativeLayout RL_window;
	private ImageView IMG_profile;
	private Button BTN_close, BTN_interaction;
	private TextView TXT_name, TXT_profile, TXT_comment;
	
	private boolean bFriend= false;	// 즐겨찾기 맺은 상태인가?
	private RequestMethods RM;
	
	private String strID= "", strName= "";

	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		mContext= this;
		RM= new RequestMethods();
		
		setContentView(R.layout.popup_layout);
		
		TXT_name= (TextView) findViewById(R.id.txt_popup_name);
		TXT_profile= (TextView) findViewById(R.id.txt_popup_profile);
		TXT_comment= (TextView) findViewById(R.id.txt_popup_info);
		IMG_profile= (ImageView) findViewById(R.id.img_popup_photo);
		BTN_close= (Button) findViewById(R.id.btn_popup_exit);
		BTN_close.setOnClickListener(this);
		BTN_interaction= (Button) findViewById(R.id.btn_popup_interaction);
		
		if( this.getIntent().getStringExtra("recommandation").equals("T") )	// 추천상태이면
		{
			if( this.getIntent().getStringExtra("relation").equals("T") )	// 나와 친구이면
			{
				bFriend= true;
				BTN_interaction.setBackgroundResource(R.drawable.btn_popup_send_note);	// 상호작용이 쪽지보내기 버튼이고
			}
			else
				BTN_interaction.setBackgroundResource(R.drawable.btn_popup_add_favorite);	// 친구아니면 친구하기 버튼이다.
			BTN_interaction.setOnClickListener(this);
		}
		else
			BTN_interaction.setVisibility(View.INVISIBLE);	// 추천상태가 아니면 버튼을 안보이게 한다.
		
		
		
		RL_window= (RelativeLayout) findViewById(R.id.view_popupwindow_all);
		TXT_name.setPaintFlags(TXT_name.getPaintFlags() | Paint.FAKE_BOLD_TEXT_FLAG);
		
		strID= this.getIntent().getStringExtra("id");
		strName= this.getIntent().getStringExtra("name");
		
		TXT_name.setText( strName );
		TXT_profile.setText( this.getIntent().getStringExtra("profile") );
		TXT_comment.setText( this.getIntent().getStringExtra("comment") );
		//TXT_name.setText( this.getIntent().getStringExtra("info") );
		
try{
		RequestImageMethods RIM= new RequestImageMethods();
		RIM.DownloadImage2( IMG_profile, strID );	// 이미지를 다운로드 받고
		IMG_profile.setBackgroundColor(Color.BLACK);
}catch(Exception e)
{
	
}
		
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
		
		if(v.getId()==R.id.btn_popup_interaction)
		{
			if(bFriend)	// 친구상태이므로 -> 쪽지보내기 버튼 일 때
			{
				Intent intent= new Intent(PopupActivity.this, SendMessageActivity.class);
				intent.putExtra("id", strID);
				intent.putExtra("name", strName);
				startActivity(intent);
			}
			else
			{
				if( RM.AddRelation(mContext, strID) )	// 친구상태가 아니므로 -> 친구맺기 버튼 일 때
				{
					bFriend= true;
					BTN_interaction.setBackgroundResource(R.drawable.btn_popup_send_note);	// 상호작용이 쪽지보내기 버튼이고
				}
			}
		}
		
	}
	
}
