package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

import com.tangibleidea.meeple.R;

public class ChatEvalActivity extends Activity implements OnClickListener
{
	Button BTN_eval_awesome, BTN_eval_good, BTN_eval_bad, BTN_continue;
	Intent intent;
	Bundle result;

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.chat_eval);
		
		BTN_continue= (Button) findViewById(R.id.btn_chat_eval_close);
		BTN_eval_awesome= (Button) findViewById(R.id.btn_chat_eval_awesome);
		BTN_eval_good= (Button) findViewById(R.id.btn_chat_eval_good);
		BTN_eval_bad= (Button) findViewById(R.id.btn_chat_eval_bad);
		
		BTN_continue.setOnClickListener(this);
		BTN_eval_awesome.setOnClickListener(this);
		BTN_eval_good.setOnClickListener(this);
		BTN_eval_bad.setOnClickListener(this);
		
		intent= new Intent();
		result= new Bundle();
	}

	@Override
	public void onClick(View v)
	{
		if(v.getId()== R.id.btn_chat_eval_close)
		{	
			result.putInt("result", 0); 
			intent.putExtras(result);
			this.setResult(RESULT_OK, intent); // 결과값 보냄
			this.finish();
		}
		else if(v.getId()== R.id.btn_chat_eval_awesome)
		{
			result.putInt("result", 3); 
			intent.putExtras(result);
			this.setResult(RESULT_OK, intent); // 결과값 보냄
			this.finish();
		}
		else if(v.getId()== R.id.btn_chat_eval_good)
		{
			result.putInt("result", 2); 
			intent.putExtras(result);
			this.setResult(RESULT_OK, intent); // 결과값 보냄
			this.finish();
		}
		else if(v.getId()== R.id.btn_chat_eval_bad)
		{
			result.putInt("result", 1); 
			intent.putExtras(result);
			this.setResult(RESULT_OK, intent); // 결과값 보냄
			this.finish();
		}
		else
		{
			result.putInt("result", -1); 
			intent.putExtras(result);
			this.setResult(RESULT_OK, intent); // 결과값 보냄
			this.finish();
		}
		
		
	}

}
