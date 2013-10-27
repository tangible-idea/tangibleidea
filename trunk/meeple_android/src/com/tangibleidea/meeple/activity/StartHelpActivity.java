package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.util.SPUtil;

public class StartHelpActivity extends Activity implements android.view.View.OnClickListener
{
	ImageView img;
	Button btn;
	
	Display display;
	int nWid, nHei;

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.start_help);
		
		img= (ImageView) findViewById(R.id.img_start_help);
		btn= (Button) findViewById(R.id.btn_start_help_close);
		btn.setOnClickListener(this);
				
		display= ((WindowManager)this.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();
		nWid= display.getWidth();
		nHei= display.getHeight(); 
	  
		Log.d("display size","display width="+nWid+"  //  display height="+nHei );
	  
		if(nWid==800 && nHei==1280)
		{
			if(SPUtil.getBoolean(this, "isMentor"))
				img.setImageResource(R.drawable.meeple_tip_mentor_800);
			else
				img.setImageResource(R.drawable.meeple_tip_mentee_800);
		}
		else if(nWid==720 && nHei==1280)
		{
			if(SPUtil.getBoolean(this, "isMentor"))
				img.setImageResource(R.drawable.meeple_tip_mentor_720);
			else
				img.setImageResource(R.drawable.meeple_tip_mentee_720);
		}
		else
		{
			if(SPUtil.getBoolean(this, "isMentor"))
				img.setImageResource(R.drawable.meeple_tip_mentor);
			else
				img.setImageResource(R.drawable.meeple_tip_mentee);
		}
	}


	@Override
	public void onClick(View v)
	{
		SPUtil.putString(this, "start_help_off", "T");
		finish();
		
	}
	
}
