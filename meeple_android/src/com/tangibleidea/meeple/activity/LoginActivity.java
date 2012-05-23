package com.tangibleidea.meeple.activity;

import org.apache.http.HttpEntity;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.server.MenteeInfo;
import com.tangibleidea.meeple.server.MentorInfo;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.server_response.LoginResponse;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.SPUtil;

public class LoginActivity extends Activity implements OnClickListener
{
	private TextView TXT_ID, TXT_PW;
	private Button BTN_Login, BTN_join_mentor, BTN_join_mentee;
	private ProgressDialog LoadingDL;
	Context mContext;
	LoginResponse login;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.login);
		
		mContext= this;
		
		LoadingDL = new ProgressDialog(this);
		
		TXT_ID= (TextView) findViewById(R.id.edt_id);
		TXT_PW= (TextView) findViewById(R.id.edt_pw);
		
		BTN_Login= (Button) findViewById(R.id.btn_login);
		BTN_join_mentor= (Button) findViewById(R.id.btn_join_mentor);
		BTN_join_mentee= (Button) findViewById(R.id.btn_join_mentee);
		
		BTN_Login.setOnClickListener(this);
		BTN_join_mentee.setOnClickListener(this);
		BTN_join_mentor.setOnClickListener(this);
		
		if( getIntent().getBooleanExtra("logout_session", false) )	// 세션아웃으로 로그아웃되었으면
		{
			ShowAlertDialog("[셰션 종료]", "세션이 종료되었습니다.\n다시 로그인해주세요~", "확인");
			return;
		}
		
		
		if( SPUtil.getString(mContext, "password")!=null )	// 한번이라도 로그인했으면?	
		{
			this.Login();
		}
		

	}

	@Override
	public void onClick(View v)
	{
		if (v.getId() == R.id.btn_login)
		{
			this.Login(); 
		}
		else if (v.getId() == R.id.btn_join_mentor)
		{
			Intent intent= new Intent(LoginActivity.this, SelectUnivActivity.class);
			startActivityForResult(intent, Global.s_nRequest_MentorJoin);
		}
		else if (v.getId() == R.id.btn_join_mentee)
		{
			Intent intent= new Intent(LoginActivity.this, MenteeJoinActivity.class);
			startActivityForResult(intent, Global.s_nRequest_MenteeJoin);
		}
	}
	
	/* (non-Javadoc)
	 * @see android.app.Activity#onActivityResult(int, int, android.content.Intent)
	 */
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		 
		int nRes= -1;
		
		if(resultCode == RESULT_OK && data != null)
			nRes= data.getExtras().getInt("result"); // 중간평가 또는 해설의 결과값 (0:끝내기, 1:계속진행, -1:오류)
		else
			return;
		
		if(requestCode == Global.s_nRequest_MenteeJoin)  // 멘티 가입
		{
			if (nRes==1)	// 성공
			{
				this.ShowAlertDialog("멘티가입", "멘티가 되셨습니다. 로그인해주세용~", "확인");
			}
		}
		else if(requestCode == Global.s_nRequest_MentorJoin)  // 멘토 가입
		{
			if (nRes==1)	// 성공
			{
				this.ShowAlertDialog("멘티가입", "멘토가 되셨습니다. 로그인해주세용~", "확인");
			}
		}
		
		
	}

	private void Login()
	{
    	Thread thread = new Thread(null, BackgroundThread, "Background");
    	thread.start();
	}
	
    
    private Runnable BackgroundThread = new Runnable()
    {
    	public void run()
    	{	
    		backgroundThreadProcessing();
    	}
    };

    // 백그라운드에서 몇 가지 처리를 수행하는 메서드.
    private void backgroundThreadProcessing()
    {
    	try 
    	{
    		LoadingHandler.sendEmptyMessage(0);
   		
    		if( SPUtil.getString(mContext, "password")!=null )	// 한번이라도 로그인했으면?	
    		{
    			RequestMethods RM= new RequestMethods();
        		login= RM.Login( this, SPUtil.getString(mContext, "AccountID") , SPUtil.getString(mContext, "password") );
        		Log.d("Auto Login", "ID="+ SPUtil.getString(mContext, "AccountID")+ "PW"+ SPUtil.getString(mContext, "password") );
    		}
    		else
    		{
	    		RequestMethods RM= new RequestMethods();
	    		login= RM.Login( this, TXT_ID.getText().toString() , TXT_PW.getText().toString() );			
    		}
    		
    		SPUtil.putString(mContext, "AccountID", TXT_ID.getText().toString() );
    		SPUtil.putString(mContext, "password", TXT_PW.getText().toString() );
    		
    		LoadingHandler.sendEmptyMessage(1);
    		

    	}
    	catch (Exception ex)
    	{
    		Global.C2DM_ID_Register(this);	// c2dm 다시 할당
    		
    		
    		LoadingHandler.sendEmptyMessage(-1);
    		
    		ex.toString();
    	}
    }
    
	public Handler LoadingHandler = new Handler()
	{
		public void handleMessage(Message msg)
		{
			if(msg.what==-1)
			{
				LoadingDL.hide();
    			ShowAlertDialog("로그인", "정보 초기화 중입니다.\n잠시 후 다시 실행해주세요~", "확인");
    			return;
			}
			
			if(msg.what==0)
			{
		        LoadingDL.setMessage("로그인 중");
		        LoadingDL.show();
			}
			else if(msg.what==1)
			{
				LoadingDL.hide();
				
	    		if(login==null)
	    		{
	    			ShowAlertDialog("로그인", "서버 접속 실패\n인터넷 연결을 확인해주세요~", "확인");
	    			return;
	    		}
	    		
	    		if (login.isSuccess())
	    		{
	    			SPUtil.putBoolean(mContext, "isMentor", login.isMentor());
	    			SPUtil.putString(mContext, "session", login.getSession());
	    			
	    			
	    			if(login.isMentor())
	    			{
	    				MentorInfo tor= login.getMentor();
	    				SPUtil.putString(mContext, "AccountID" ,tor.getAccountId());
	    				SPUtil.putString(mContext, "Comment" ,tor.getComment());
	    				SPUtil.putString(mContext, "Email" ,tor.getEmail());
	    				SPUtil.putString(mContext, "Image" ,tor.getImage());
	    				SPUtil.putString(mContext, "Major" ,tor.getMajor());
	    				SPUtil.putString(mContext, "Name" ,tor.getName());
	    				SPUtil.putString(mContext, "Promo" ,tor.getPromo());
	    				SPUtil.putString(mContext, "Univ" ,tor.getUniv());
	    				
	    			}else{
	    				
	    				MenteeInfo tee= login.getMentee();
	    				SPUtil.putString(mContext, "AccountID" ,tee.getAccountId());
	    				SPUtil.putString(mContext, "Comment" ,tee.getComment());
	    				SPUtil.putString(mContext, "Email" ,tee.getEmail());
	    				SPUtil.putString(mContext, "Image" ,tee.getImage());
	    				SPUtil.putString(mContext, "Name" ,tee.getName());
	    				SPUtil.putString(mContext, "Grade" ,tee.getGrade());
	    				SPUtil.putString(mContext, "School" ,tee.getSchool());
	    			}
	    			
	    			Intent intent= new Intent(LoginActivity.this, LobbyActivity.class);
	    			startActivityForResult(intent, Global.s_nRequest_Login);
	    			finish();
	    			
	    		}else{
	    			ShowAlertDialog("로그인", "아이디 또는 패스워드가 올바르지 않습니다.", "확인");
	    		}
			}
		}
	};
	
	
	
	

	
	
	
	
	private void ShowAlertDialog(String strTitle, String strContent, String strButton)
	{
		new AlertDialog.Builder(this)
		.setTitle( strTitle )
		.setMessage( strContent )
		.setPositiveButton( strButton , null)
		.setCancelable(false)
		.create()
		.show();
	}

	private String getResponse(HttpEntity entity)
	{
		// TODO Auto-generated method stub
		return null;
	}

}
