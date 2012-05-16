package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.server.RequestMethods;

public class ReportActivity extends Activity implements OnClickListener
{
	Context mContext;
	Button BTN_send;
	EditText EDT_target, EDT_content;
	
	String strOppoAccount, strContent;

	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.report);
		
		mContext= this;
		
		BTN_send= (Button) findViewById(R.id.btn_report);
		BTN_send.setOnClickListener(this);
		
		EDT_target= (EditText) findViewById(R.id.edt_report_target);
		EDT_content= (EditText) findViewById(R.id.edt_report_reason);
	}

	@Override
	public void onClick(View v)
	{
		strOppoAccount= EDT_target.getText().toString();
		strContent= EDT_content.getText().toString();
		
		RequestMethods RM= new RequestMethods();
		if( RM.ReportUser(mContext, strOppoAccount, strContent) )
		{
			ShowAlertDialog("[신고]","신고가 완료되었습니다.","확인");
			finish();
		}
		else
			ShowAlertDialog("[신고]","신고가 실패하였습니다.","확인");
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
