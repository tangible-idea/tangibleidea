package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.server_response.RegisterResponse;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.SPUtil;

public class MentorJoinActivity extends Activity implements OnClickListener, OnItemSelectedListener
{
	Context mContext;
	Button BTN_join;
	EditText EDT_ID, EDT_PW, EDT_email, EDT_name, EDT_major, EDT_promo;
	Spinner SPN_gender; String strGender="0";
	
	private ProgressDialog LoadingDL;	
	private String strJoinFailReason="";
	
	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		mContext= this;
		
		setContentView(R.layout.join_mentor);
		
		LoadingDL = new ProgressDialog(mContext);
		
		EDT_ID= (EditText) findViewById(R.id.edt_id);
		EDT_PW= (EditText) findViewById(R.id.edt_pw);
		EDT_email= (EditText) findViewById(R.id.edt_email);
		EDT_name= (EditText) findViewById(R.id.edt_name);
		EDT_major= (EditText) findViewById(R.id.edt_major);
		EDT_promo= (EditText) findViewById(R.id.edt_promo);
		SPN_gender= (Spinner) findViewById(R.id.spn_gender);
		
		BTN_join= (Button) findViewById(R.id.btn_join);
		BTN_join.setOnClickListener(this);
		SPN_gender.setOnItemSelectedListener(this);
	}
	
	@Override
	public void onClick(View v)
	{
		if(v.getId() == R.id.btn_join)
		{
			if( !CheckNull() )
				return;
			
			if( SPUtil.getString(this, "reg_id") == null )	// 초기화된 것이 없으면 초기화해줌
				SPUtil.putString(this, "reg_id", "0");
			if( SPUtil.getString(this, "reg_id").equals("0") )
			{
				this.ShowAlertDialog("회원가입", "세션 초기화중입니다.\n잠시 후 다시 시도해주세요.", "확인");
				return;
			}
			
			this.MentorJoin();
		}
//		else if(v.getId()==R.id.spn_gender)
//		{
//			try
//			{
//				if( SPUtil.getString(this, "reg_id").equals("0") )
//					Global.C2DM_ID_Register(this);
//			}catch(Exception e)
//			{
//				Global.C2DM_ID_Register(this);
//			}
//		}
		
	}
	public void MentorJoin()
	{
		Thread thread = new Thread(null, BackgroundThread, "Background");
    	thread.start();
	}
	
    
    private Runnable BackgroundThread = new Runnable()
    {
    	public void run()
    	{	
    		LoadingHandler.sendEmptyMessage(0);
    		
    		RegisterResponse res;
			
			RequestMethods RM= new RequestMethods();
			res= RM.RegisterMentor(mContext, EDT_ID.getText().toString(),
							  EDT_PW.getText().toString(),
							  EDT_email.getText().toString(),
							  strGender,
							  EDT_name.getText().toString(),
							  Global.s_MyUniv,
							  EDT_major.getText().toString(),
							  EDT_promo.getText().toString()							  
							  );
			
			if(res==null)
			{
				LoadingHandler.sendEmptyMessage(1);
				return;
			}
    		
			if( res.isSuccess() )
			{
				LoadingHandler.sendEmptyMessage(2);
			}else{
				strJoinFailReason= res.getReason();
				LoadingHandler.sendEmptyMessage(3);
			}
    	}
    };
	
	public Handler LoadingHandler = new Handler()
	{
		public void handleMessage(Message msg)
		{
			if(msg.what==0)
			{
		        LoadingDL.setMessage("멘토가입정보를 전송하는 중");
		        LoadingDL.setIndeterminate(true);
				LoadingDL.show();
			}
			if(msg.what==1)
			{
				LoadingDL.hide();
				ShowAlertDialog("가입실패", "서버 접속 실패\n인터넷 연결을 확인해주세요~", "확인");
				return;
			}
			
			if(msg.what==2)
			{
				LoadingDL.hide();
//				Intent intent= new Intent();
//				Bundle result= new Bundle();
//				
//				result.putInt("result", 1); // 성공값 첨부 
//				intent.putExtras(result);
//				setResult(RESULT_OK, intent); // 결과값 보냄
//				finish();
				Intent intent= new Intent(MentorJoinActivity.this, LoginActivity.class);
				intent.putExtra("reg_mentor", true);
				startActivityForResult(intent, Global.s_nRequest_MentorJoin);
			}
			if(msg.what==3)
			{
				LoadingDL.hide();
				ShowAlertDialog("가입 실패", strJoinFailReason, "확인");
			}
		}
	};
	
	@Override
	public void onItemSelected(AdapterView<?> arg0, View v, int position, long id)
	{
		if(arg0==SPN_gender)
		{
			try
			{
				if( SPUtil.getString(this, "reg_id").equals("0") )
					Global.C2DM_ID_Register(this);
			}catch(Exception e)
			{
				Global.C2DM_ID_Register(this);
			}
				
			strGender= Integer.toString(position);	
		}
		
	}

	@Override
	public void onNothingSelected(AdapterView<?> arg0)
	{		
	}
	
	
	
	
	
	private boolean CheckNull()
	{
		if(EDT_ID.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입", "아이디를 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_ID.getText().toString().length() < 4)
		{
			this.ShowAlertDialog("가입", "아이디는 4글자 이상 입력해주세요.", "확인");
			return false;
		}
		else if(EDT_PW.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입", "비밀번호를 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_PW.getText().toString().length() < 4)
		{
			this.ShowAlertDialog("가입", "비밀번호는 4글자 이상 입력해주세요.", "확인");
			return false;
		}
		else if(EDT_email.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입 오류", "이메일을 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_email.getText().toString().indexOf("@") == -1)	// 골뱅이가 없으면
		{
			this.ShowAlertDialog("가입", "이메일이 올바르지 않습니다.", "확인");
			return false;
		}
		else if(EDT_name.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입 오류", "이름을 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_major.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입 오류", "전공을 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_promo.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입 오류", "학번을 입력해주세요~", "확인");
			return false;
		}
		else if(strGender.equals("0"))
		{
			this.ShowAlertDialog("가입 오류", "성별을 입력해주세요~", "확인");
			return false;
		}
		return true;
	}
	
	
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
	


	
}
