package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.server.RequestImageMethods;
import com.tangibleidea.meeple.server.RequestMethods;

public class SendMessageActivity extends Activity implements OnClickListener
{
	private ImageView IMG_OPPO;
	private TextView TXT_OPPO;
	private Button BTN_send;
	private EditText EDT_msg;
	private RequestMethods RM;
	private Context mContext;
	private String strMessage= "";
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		mContext= this;
		RM= new RequestMethods();
		
		setContentView(R.layout.send_message_layout);
		
		IMG_OPPO= (ImageView) findViewById(R.id.img_photo_oppo);
		TXT_OPPO= (TextView) findViewById(R.id.txt_name_oppo);
		BTN_send= (Button) findViewById(R.id.btn_message_send);
		EDT_msg= (EditText) findViewById(R.id.edt_message_content);
		
		EDT_msg.addTextChangedListener(new TextWatcher()
		{
			public void afterTextChanged(Editable arg0)
			{ }
			public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3)
			{ }
			public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3)
			{
				if(arg0.equals(""))
				{
					BTN_send.setEnabled(false);
				}else{
					BTN_send.setEnabled(true);
					strMessage= arg0.toString();
				}				
			}			
		});
		
	try
	{
      	  RequestImageMethods RIM= new RequestImageMethods();
    	  RIM.DownloadImage2( IMG_OPPO, getIntent().getStringExtra("id") );	// 이미지를 다운로드 받고
    	  IMG_OPPO.setBackgroundColor(Color.BLACK);
    }catch(Exception ex) {}
	
		TXT_OPPO.setText( getIntent().getStringExtra("name") );		
		BTN_send.setOnClickListener(this);
	}

	@Override
	public void onClick(View v)
	{
		if(v.getId()==R.id.btn_message_send)
		{
			if(!strMessage.equals(""))	// 내용이 있다면
			{
				if(	RM.SendMessage(mContext, getIntent().getStringExtra("id"), strMessage ) )
				{
					ShowAlertDialog("전송 결과", "쪽지 보내기 성공!", "확인");
					finish();
				}
				else
					ShowAlertDialog("전송 결과", "쪽지 보내기 실패", "확인");
					
			}
		}
	}
	
	private void ShowAlertDialog(String strTitle, String strContent, String strButton)
	{
		new AlertDialog.Builder(mContext)
		.setTitle( strTitle )
		.setMessage( strContent )
		.setPositiveButton( strButton , null)
		.setCancelable(false)
		.create()
		.show();
	}

}
