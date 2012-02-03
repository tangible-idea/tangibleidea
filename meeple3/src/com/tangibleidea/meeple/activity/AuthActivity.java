package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.auth.Authenticator;
import com.tangibleidea.meeple.auth.OnAuthListener;
import com.tangibleidea.meeple.auth.UnivAuth;
import com.tangibleidea.meeple.util.Global;

public class AuthActivity extends Activity implements OnItemSelectedListener, Authenticator, OnClickListener
{
	final Context context= this;
	private ProgressDialog LoadingDL;
	
	private WebView WV;
	private TextView TXT_ID, TXT_PW;
	private Spinner SPN_sel_univ;
	private Button BTN_auth;
	
	private int nSelUnivID;
	
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





	private UnivAuth auth= new UnivAuth(context);
	private boolean bAuthRes= false;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.univ_auth);
		
		TXT_ID= (TextView) findViewById(R.id.edt_id);
		TXT_PW= (TextView) findViewById(R.id.edt_pw);
		
		BTN_auth= (Button) findViewById(R.id.btn_auth);
		WV= (WebView) findViewById(R.id.web);
		SPN_sel_univ= (Spinner) findViewById(R.id.spinner);

		BTN_auth.setOnClickListener(this);
		SPN_sel_univ.setOnItemSelectedListener(this);
		LoadingDL = new ProgressDialog(this);
		
		
		OnAuthListener callback= new OnAuthListener()
		{
			
			@Override
			public void OnLoadCompelete(boolean bCompleted)
			{
				if(bCompleted)
				{
					LoadingDL.hide();
					BTN_auth.setEnabled(true);			
				}
			}

			@Override
			public void OnAuthResult(boolean bSuccess)
			{
				if(bSuccess)
				{
					C2DM_ID_Register();
					
					Global.s_MyUniv= SPN_sel_univ.getSelectedItem().toString();
					Intent intent= new Intent(AuthActivity.this, MentorJoinActivity.class);
					startActivityForResult(intent, Global.s_nRequest_MentorJoin);
				}
				else
					ShowAlertDialog("인증결과", "인증실패", "확인");
			}
		};
		
		auth.SetOnAuthListener(callback);
	}
	
	
	


	@Override
	public void onItemSelected(AdapterView<?> arg0, View v, int position, long id)
	{
		nSelUnivID= position;
		
		switch(position)
		{
		case 0:
			TXT_ID.setEnabled(false);
			TXT_PW.setEnabled(false);
			break;
		case 1:
			TXT_ID.setEnabled(true);
			TXT_PW.setEnabled(true);
			break;
		case 2:
			TXT_ID.setEnabled(true);
			TXT_PW.setEnabled(true);
			break;
		case 3:
			TXT_ID.setEnabled(true);
			TXT_PW.setEnabled(true);
			break;
		case 4:
			TXT_ID.setEnabled(false);
			TXT_PW.setEnabled(false);
			break;
		case 5:
			TXT_ID.setEnabled(true);
			TXT_PW.setEnabled(true);
			break;
		}
	}

	@Override
	public void onNothingSelected(AdapterView<?> arg0)
	{
		// TODO Auto-generated method stub
		
	}

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
			auth.YonseiUnivAuth( getString(R.string.ys_auth_address), strID, strPW);
			break;
		case 3:
			auth.KoreaUnivAuth( getString(R.string.korea_auth_address), strID, strPW);
			break;
		case 4:
			if(auth.SonguneAuth())
			{
				
			}
			break;
		case 5:
			auth.SogangAuth(WV, getString(R.string.sogang_auth_address1), getString(R.string.sogang_auth_address2) , strID, strPW);
			
			break;
		}
	}
	
	private void ShowAlertDialog(String strTitle, String strContent, String strButton)
	{
		new AlertDialog.Builder(context)
		.setTitle( strTitle )
		.setMessage( strContent )
		.setPositiveButton( strButton , null)
		.setCancelable(false)
		.create()
		.show();
	}
	

    /**
     * @param context
     *            id 발급 메서드
     */
    public void C2DM_ID_Register()
    {
      Intent registrationIntent = new Intent("com.google.android.c2dm.intent.REGISTER");
       
      registrationIntent.putExtra("app", PendingIntent.getBroadcast(this, 0, new Intent(), 0));
      registrationIntent.putExtra("sender", Global.DEV_EMAIL);
       
      startService(registrationIntent);
    }


	@Override
	public void onClick(View v)
	{
		if(v.getId()==R.id.btn_auth)
		{
			
            //dialog.setTitle("인증중...");
            LoadingDL.setMessage("대학교 인증 중입니다.");
            LoadingDL.setIndeterminate(true);
            LoadingDL.setCancelable(true);
            LoadingDL.show();
            
			BTN_auth.setEnabled(false);
            
            this.UnivAuth(nSelUnivID, TXT_ID.getText().toString(), TXT_PW.getText().toString());
		}
		
	}

}
