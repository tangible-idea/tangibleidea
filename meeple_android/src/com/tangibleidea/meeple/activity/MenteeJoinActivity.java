package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.data.EnumError;
import com.tangibleidea.meeple.server.RequestMethods;
import com.tangibleidea.meeple.server_response.RegisterResponse;
import com.tangibleidea.meeple.util.Global;
import com.tangibleidea.meeple.util.SPUtil;

public class MenteeJoinActivity extends Activity implements OnClickListener, OnItemSelectedListener
{
	Button BTN_join;
	EditText EDT_ID, EDT_PW, EDT_email, EDT_name, EDT_school, EDT_grade;
	Spinner SPN_gender, SPN_category;
	String strGender="0", strCategory="0";
	
	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.join_mentee);
		
		EDT_ID= (EditText) findViewById(R.id.edt_id);
		EDT_PW= (EditText) findViewById(R.id.edt_pw);
		EDT_email= (EditText) findViewById(R.id.edt_email);
		EDT_name= (EditText) findViewById(R.id.edt_name);
		EDT_school= (EditText) findViewById(R.id.edt_school);
		EDT_grade= (EditText) findViewById(R.id.edt_grade);
		SPN_gender= (Spinner) findViewById(R.id.spn_gender);
		SPN_category= (Spinner) findViewById(R.id.spn_category);
		
		BTN_join= (Button) findViewById(R.id.btn_join);
		BTN_join.setOnClickListener(this);
		SPN_gender.setOnItemSelectedListener(this);
		SPN_category.setOnItemSelectedListener(this);
		
	}
	
	@Override
	public void onItemSelected(AdapterView<?> arg0, View v, int position, long id)
	{
		if(arg0==SPN_category)
		{
			strCategory= Integer.toString(position);
		}
		
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

	@Override
	public void onClick(View v)
	{
		if(v.getId()==R.id.btn_join)
		{
			if( !CheckNull() )
				return;
			
			if( SPUtil.getString(this, "reg_id").equals("0") )
			{
				this.ShowAlertDialog("회원가입", "세션 초기화중입니다.\n잠시 후 다시 시도해주세요.", "확인");
				return;
			}
			
			RegisterResponse res;
			
			RequestMethods RM= new RequestMethods();
			res= RM.RegisterMentee(this, EDT_ID.getText().toString(),
							  EDT_PW.getText().toString(),
							  EDT_email.getText().toString(),
							  EDT_name.getText().toString(),
							  strGender,
							  EDT_school.getText().toString(),
							  EDT_grade.getText().toString(),
							  strCategory);
			
			if(res==null)
			{
				if( Global.s_Error == EnumError.E_JOIN_WRONG_TEXT )
				{
					this.ShowAlertDialog("가입실패", "올바르지 않은 문자가 있습니다.", "확인");
					Global.s_Error= EnumError.E_NONE_ERROR;
					return;
				}
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
				this.ShowAlertDialog("가입 실패", res.getReason(), "확인");
			}
		} 
		
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
			this.ShowAlertDialog("가입", "이메일을 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_email.getText().toString().indexOf("@") == -1)	// 골뱅이가 없으면
		{
			this.ShowAlertDialog("가입", "이메일이 올바르지 않습니다.", "확인");
			return false;
		}
		else if(EDT_name.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입", "이름을 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_school.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입", "학교를 입력해주세요~", "확인");
			return false;
		}
		else if(EDT_grade.getText().toString().equals(""))
		{
			this.ShowAlertDialog("가입", "학년을 입력해주세요~", "확인");
			return false;
		}
		else if(strGender.equals("0"))
		{
			this.ShowAlertDialog("가입", "성별을 입력해주세요~", "확인");
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
