package com.tangibleidea.meeple.activity;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.server_response.RegisterResponse;
import com.tangibleidea.meeple.util.Global;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.AdapterView.OnItemSelectedListener;

public class MentorJoinActivity extends Activity implements OnClickListener, OnItemSelectedListener
{
	Button BTN_join;
	EditText EDT_ID, EDT_PW, EDT_email, EDT_name, EDT_major, EDT_promo;
	Spinner SPN_gender; String strGender="0";
	
	
	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.join_mentor);
		
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
			
			if( Global.REG_ID.equals("0") )
			{
				this.ShowAlertDialog("회원가입", "세션 초기화중입니다.\n잠시 후 다시 시도해주세요.", "확인");
				return;
			}
			
			RegisterResponse res;
			
			RequestMethods RM= new RequestMethods();
			res= RM.RegisterMentor(EDT_ID.getText().toString(),
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
				this.ShowAlertDialog("가입실패", "서버 접속 실패\n인터넷 연결을 확인해주세요~", "확인");
				return;
			}
			
			if( res.isSuccess() )
			{
				Intent intent= new Intent();
				Bundle result= new Bundle();
				
				result.putInt("result", 1); // 성공값 첨부 
				intent.putExtras(result);
				this.setResult(RESULT_OK, intent); // 결과값 보냄
				this.finish();
			}else{
				this.ShowAlertDialog("가입 오류 실패", res.getReason(), "확인");
			}
		}
		
	}
	
	@Override
	public void onItemSelected(AdapterView<?> arg0, View v, int position, long id)
	{
		strGender= Integer.toString(position);		
	}

	@Override
	public void onNothingSelected(AdapterView<?> arg0)
	{		
	}
	
	
	
	
	
	private boolean CheckNull()
	{
		if(EDT_ID.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입 오류", "아이디를 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_PW.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입 오류", "비밀번호를 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_email.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입 오류", "이메일을 입력해주세요~", "확인");
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
