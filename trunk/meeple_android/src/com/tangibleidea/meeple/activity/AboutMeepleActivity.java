package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;

import com.tangibleidea.meeple.R;

public class AboutMeepleActivity extends Activity
{
	ImageView IMG_tips_mentor, IMG_tips_mentee;

	/* (non-Javadoc)
	 * @see android.app.Activity#onCreate(android.os.Bundle)
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.about_meeple);
		
		IMG_tips_mentor= (ImageView) findViewById(R.id.img_tip_mentor);
		IMG_tips_mentee= (ImageView) findViewById(R.id.img_tip_mentee);
		
		IMG_tips_mentor.setOnClickListener(new OnClickListener()
		{
			
			@Override
			public void onClick(View v)
			{
				setContentView(R.layout.about_meeple_tip_mentor);
			}
		});
		
		IMG_tips_mentee.setOnClickListener(new OnClickListener()
		{
			
			@Override
			public void onClick(View v)
			{
				setContentView(R.layout.about_meeple_tip_mentee);
			}
		});
	}

}
