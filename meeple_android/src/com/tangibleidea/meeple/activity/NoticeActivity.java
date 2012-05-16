package com.tangibleidea.meeple.activity;

import com.tangibleidea.meeple.R;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;

public class NoticeActivity extends Activity
{
	WebView WEB_notice;
	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.notice);
		
		WEB_notice= (WebView) findViewById(R.id.web_notice);
		WEB_notice.loadUrl("http://tangibleidea.co.kr");
	}

}
