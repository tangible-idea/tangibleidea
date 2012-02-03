package com.tangibleidea.meeple.activity;

import android.app.ListActivity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.server.RequestMethods;

public class InChatActivity extends ListActivity implements OnClickListener
{
	Button BTN_send;
	Handler handler;
	
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.inchat);
		
		BTN_send= (Button) findViewById(R.id.btn_send);
		BTN_send.setOnClickListener(this);
		
		this.GetChats();
	}
	
	private void GetChats()
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
    	RequestMethods RM= new RequestMethods();
    }
    
	public Handler LoadingHandler = new Handler()
	{
		public void handleMessage(Message msg)
		{
			if(msg.what==0)
			{
				
			}
		}
	};

	@Override
	public void onClick(View v)
	{
		
	}

}
