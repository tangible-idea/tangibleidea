package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.EditText;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.callback.auth.Authenticator;
import com.tangibleidea.meeple.callback.auth.OnAuthListener;
import com.tangibleidea.meeple.callback.auth.UnivAuth;
import com.tangibleidea.meeple.util.Global;

public class AuthActivity extends Activity implements Authenticator, OnClickListener
{
	final Context mContext= this;
	private ProgressDialog LoadingDL;
	
	private WebView WV;
	private EditText EDT_ID, EDT_PW;
	private Button BTN_auth;
	
	private int nSelUnivID;
	private String strUnivMsg= "";
	
	/* (non-Javadoc)
	 * @see android.app.Activity#onActivityResult(int, int, android.content.Intent)
	 */
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		
		this.setResult(RESULT_OK, data); // 결과값 보냄
		this.finish();
	}


	private UnivAuth auth= new UnivAuth(mContext);
	private boolean bAuthRes= false;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.univ_auth);
		
		if(Global.s_MyUniv.equals("서울대학교"))
		{
			nSelUnivID= 1;
		}
		else if(Global.s_MyUniv.equals("연세대학교"))
		{
			nSelUnivID= 2;
		}
		else if(Global.s_MyUniv.equals("고려대학교"))
		{
			nSelUnivID= 3;
		}
		else if(Global.s_MyUniv.equals("서강대학교"))
		{
			nSelUnivID= 4;
		}
		else{
			nSelUnivID= 0;
		}
		
		this.setTitle(Global.s_MyUniv + " 학생인증 (학사포털 계정로그인)");
		
		EDT_ID= (EditText) findViewById(R.id.edt_id);
		EDT_PW= (EditText) findViewById(R.id.edt_pw);
		
		BTN_auth= (Button) findViewById(R.id.btn_auth);
		WV= (WebView) findViewById(R.id.web);

		BTN_auth.setOnClickListener(this);
		LoadingDL = new ProgressDialog(this);
		
		EDT_ID.addTextChangedListener(new TextWatcher()
		{
			public void afterTextChanged(Editable arg0)
			{ }
			public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3)
			{ }
			public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3)
			{
				if(!arg0.equals("") && !EDT_PW.getText().toString().equals("") )
				{
					BTN_auth.setEnabled(true);
				}else{
					BTN_auth.setEnabled(false);
				}				
			}			
		});
		
		EDT_PW.addTextChangedListener(new TextWatcher()
		{
			public void afterTextChanged(Editable arg0)
			{ }
			public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3)
			{ }
			public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3)
			{
				if(!arg0.equals("") && !EDT_ID.getText().toString().equals(""))
				{
					BTN_auth.setEnabled(true);
				}else{
					BTN_auth.setEnabled(false);					
				}				
			}			
		});
		
		
		OnAuthListener callback= new OnAuthListener()
		{
			
			@Override
			public void OnLoadCompelete(boolean bCompleted)
			{
				if(bCompleted)
				{
					LoadingHandler.sendEmptyMessage(10);
				}
			}

			@Override
			public void OnAuthResult(boolean bSuccess, String msg)	// 인증결과 콜백함수
			{
				strUnivMsg= msg;
				
				if(bSuccess)
					LoadingHandler.sendEmptyMessage(1);
				else
					LoadingHandler.sendEmptyMessage(2);
					
			}
		};
		
		auth.SetOnAuthListener(callback);
	}
	
	// 대학 인증으로 가는 스레드
	public void UnivAuthThread()
	{
		Thread thread = new Thread(null, BackgroundThread, "Background");
    	thread.start();
	}
	
    
    private Runnable BackgroundThread = new Runnable()
    {
    	public void run()
    	{	
    		LoadingHandler.sendEmptyMessage(0);
    		UnivAuth(nSelUnivID, EDT_ID.getText().toString(), EDT_PW.getText().toString());
    	}
    };
	
	public Handler LoadingHandler = new Handler()
	{
		public void handleMessage(Message msg)
		{
			if(msg.what==0)
			{
		        LoadingDL.setMessage("대학교 포털 인증 처리 중");
		        LoadingDL.setIndeterminate(true);
				LoadingDL.show();
			}
			if(msg.what==1)
			{
				Global.C2DM_ID_Register(mContext);
				
				Intent intent= new Intent(AuthActivity.this, MentorJoinActivity.class);
				startActivityForResult(intent, Global.s_nRequest_MentorJoin);
				finish();
			}
			if(msg.what==2)
			{
				ShowAlertDialog("인증결과", strUnivMsg, "확인");
			}
			if(msg.what==10)
			{
				LoadingDL.hide();
				BTN_auth.setEnabled(true);
			}
			
		}
	};

//
//	@Override
//	public void onItemSelected(AdapterView<?> arg0, View v, int position, long id)
//	{
//		nSelUnivID= position;
//		
//		switch(position)
//		{
//		case 0:
//			TXT_ID.setEnabled(false);
//			TXT_PW.setEnabled(false);
//			BTN_auth.setEnabled(false);
//			break;
//		case 1:
//			TXT_ID.setEnabled(true);
//			TXT_PW.setEnabled(true);
//			BTN_auth.setEnabled(true);
//			break;
//		case 2:
//			TXT_ID.setEnabled(true);
//			TXT_PW.setEnabled(true);
//			BTN_auth.setEnabled(true);
//			break;
//		case 3:
//			TXT_ID.setEnabled(true);
//			TXT_PW.setEnabled(true);
//			BTN_auth.setEnabled(true);
//			break;
//		case 4:
//			TXT_ID.setEnabled(false);
//			TXT_PW.setEnabled(false);
//			BTN_auth.setEnabled(false);
//			break;
//		case 5:
//			TXT_ID.setEnabled(true);
//			TXT_PW.setEnabled(true);
//			BTN_auth.setEnabled(true);
//			break;
//		}
//	}


	@Override
	public void UnivAuth(int nUnivID, String strID, String strPW)
	{
		
		switch(nSelUnivID)
		{
		case 0:
			ShowAlertDialog("대학교 선택", "학교를 선택해주세요~", "네~");
			break;
			
		case 1:
			auth.SNUAuth( getString(R.string.snu_auth_address)  ,strID, strPW);
			
			break;
		case 2:
			auth.YonseiUnivAuth(WV, getString(R.string.ys_auth_address), strID, strPW);
			break;
		case 3:
			auth.KoreaUnivAuth( getString(R.string.korea_auth_address), strID, strPW);
			break;
		case 4:
			auth.SogangAuth(WV, getString(R.string.sogang_auth_address), strID, strPW);
			
			break;
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
	


	@Override
	public void onClick(View v)
	{
		if(v.getId()==R.id.btn_auth)
		{
			

			BTN_auth.setEnabled(false);
            
            this.UnivAuthThread();
		}
		
	}

}
