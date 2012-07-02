package com.tangibleidea.meeple.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.widget.ImageView;

import com.tangibleidea.meeple.R;
import com.tangibleidea.meeple.util.SPUtil;

public class SplashActivity extends Activity
{

	//private LinearLayout LYO_Splash;
	private ImageView IMG_splash;
	private final int FADE_TIME= 950;
	private final int SHOW_TIME= 1650;
	
	private Context mContext;

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.splash);
		mContext= this;
		
		final Animation ANI_on= new AlphaAnimation( 0.0f, 1.0f );
		final Animation ANI_off= new AlphaAnimation( 1.0f, 0.0f );
		
		ANI_on.setDuration(FADE_TIME);
		ANI_off.setDuration(FADE_TIME);
		
		IMG_splash= (ImageView) findViewById(R.id.img_splash);
		IMG_splash.startAnimation(ANI_on);
		
//		LYO_Splash= (LinearLayout) findViewById(R.id.start_linearlayout_root);
//		LYO_Splash.startAnimation(ANI_on);
		
		
		ANI_on.setAnimationListener(new AnimationListener()
		{
			public void onAnimationEnd(Animation arg0)
			{				
				Handler handler= new Handler();
				handler.postDelayed(new Runnable()
				{
					public void run()
					{
						//LYO_Splash.startAnimation(ANI_off);
						IMG_splash.startAnimation(ANI_off);
					}
				}, SHOW_TIME );
			}

			public void onAnimationRepeat(Animation arg0)
			{ }

			public void onAnimationStart(Animation arg0)
			{ }
		});
		
		
		
		ANI_off.setAnimationListener(new AnimationListener()
		{
			public void onAnimationEnd(Animation arg0)
			{
				IMG_splash.setVisibility(View.INVISIBLE);
				
				if( SPUtil.getString(mContext, "session")!=null )	// 한번이라도 로그인했으면?	
				{
					Intent intent= new Intent( SplashActivity.this, LobbyActivity.class);
					startActivity(intent);
				}
				else
				{
					Intent intent= new Intent( SplashActivity.this, LoginActivity.class);
					startActivity(intent);
				}

				
				finish();
			}

			public void onAnimationRepeat(Animation arg0)
			{ }

			public void onAnimationStart(Animation arg0)
			{ }
		});
		

		

	}

}
